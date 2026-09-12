# pyinstaller --clean --noconsole --name=RectPack02 RectPack02.py   (crea il file Exe con librerie sorgenti)
# pyinstaller RectPack02.py                                         (crea exe con librerie compresse)
# python RectPack02.py                                              (esegue il file da terminale senza compilarlo)
# =====================================================================
# 1 PARTE - Importazioni e Utility Geometriche (Incapsulata)
# =====================================================================
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.widgets import Button
from rectpack import newPacker, SORT_AREA
from rectpack.guillotine import GuillotineBssfSas
import ezdxf
import xml.etree.ElementTree as ET
from pathlib import Path
import tkinter as tk                 
from tkinter import messagebox
import winreg  # Libreria nativa Windows per accedere ai registri
import sys


def inizializza_utility_geometriche():
    """
    Raggruppa le funzioni di utilità per la gestione dei popup 
    e l'analisi/trasformazione geometrica dei file DXF.
    """
    def mostra_popup_fatto(testo, titolo, tipo="info"):
        root = tk.Tk()
        root.withdraw()
        root.attributes("-topmost", True)
        if tipo == "errore":
            messagebox.showerror(title=titolo, message=testo)
        else:
            messagebox.showinfo(title=titolo, message=testo)
        root.destroy()

    def ricava_dimensioni_e_limiti_dxf(percorso_dxf):
        try:
            p = Path(percorso_dxf)
            if not p.exists():
                return None, None, 0, 0
            doc = ezdxf.readfile(p)
            msp = doc.modelspace()
            from ezdxf.bbox import extents
            box = extents(msp)
            if box.has_data:
                min_x, min_y, _ = box.extmin
                max_x, max_y, _ = box.extmax
                return int(max_x - min_x), int(max_y - min_y), min_x, min_y
            return None, None, 0, 0
        except Exception:
            return None, None, 0, 0

    def copia_geometria_dxf(percorso_sorg, msp_dest, x_dest, y_dest, min_x, min_y, ruotato=False, h_reale=0):
        try:
            doc_sorg = ezdxf.readfile(percorso_sorg)
            msp_sorg = doc_sorg.modelspace()
            entita = msp_sorg.query("LINE CIRCLE ARC LWPOLYLINE POLYLINE SPLINE ELLIPSE TEXT MTEXT")
            from ezdxf.math import Matrix44
            m_centra = Matrix44.translate(-min_x, -min_y, 0)
            if ruotato:
                m_ruota = Matrix44([0.0, 1.0, 0.0, 0.0, -1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0])
                m_riallinea = Matrix44.translate(h_reale, 0, 0)
                m_locale = m_centra @ m_ruota @ m_riallinea
            else:
                m_locale = m_centra
            m_posizione = Matrix44.translate(x_dest, y_dest, 0)
            for ent in entita:
                nuova_ent = ent.copy()
                nuova_ent.transform(m_locale @ m_posizione)
                msp_dest.add_entity(nuova_ent)
        except Exception:
            pass

    return mostra_popup_fatto, ricava_dimensioni_e_limiti_dxf, copia_geometria_dxf

# Estrazione delle funzioni per l'utilizzo globale nelle parti successive
mostra_popup_fatto, ricava_dimensioni_e_limiti_dxf, copia_geometria_dxf = inizializza_utility_geometriche()

# =====================================================================
# 2 PARTE - Configurazione e caricamento file XML (Ottimizzata EXE)
# =====================================================================
def carica_configurazioni_e_dati():
    """
    Recupera il file di configurazione principale RectPackSetup.xml tramite 2 livelli di sicurezza:
    1. Registro di Windows (Valore: SettingRectPack)
    2. Cartella locale da dove è stato lanciato l'eseguibile (.exe) o lo script (.py)
    Successivamente estrae i dati geometrici dai file XML indicati nel Setup.
    """
    FILE_CONFIG = None

    # LIVELLO 1: Tentativo da Registro di Sistema (Con maschera per architetture 32/64 bit)
    try:
        access_mask = winreg.KEY_READ | winreg.KEY_WOW64_64KEY
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"SOFTWARE\EasyCut", 0, access_mask) as chiave:
            valore, _ = winreg.QueryValueEx(chiave, "SettingRectPack")
            percorso_registro = Path(valore.strip())
            if percorso_registro.exists():
                FILE_CONFIG = percorso_registro
    except Exception:
        pass

    # LIVELLO 2: Tentativo dalla cartella di lancio dell'eseguibile (Massima compatibilità PyInstaller)
    if FILE_CONFIG is None:
        try:
            if getattr(sys, 'frozen', False):
                # Se è un .exe compilato, sys.executable restituisce il percorso dell'exe stesso
                cartella_lancio = Path(sys.executable).resolve().parent
            else:
                # Se è lo script .py originale in fase di test
                cartella_lancio = Path(__file__).resolve().parent
                
            percorso_locale = cartella_lancio / "RectPackSetup.xml"
            if percorso_locale.exists():
                FILE_CONFIG = percorso_locale
        except Exception:
            pass

    # Stampa di controllo visibile in fase di sviluppo/debug console
    print(f"[INFO] File di configurazione caricato da: {FILE_CONFIG}")

    # Valori di default iniziali (verranno sovrascritti se presenti nell'XML)
    SPESSORE_LAMA = 4    
    MARGINI_RIFILO = 0  
    CARTELLA_DXF_OUTPUT = Path(".")  
    PREFISSO_FILE = "schema"  
    MOSTRA_GRAFICA = True     
    TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA = 10, 10, 2

    # Inizializzazione contenitori dati
    percorsi_fogli = {}
    nomi_fogli = {}
    pannelli_magazzino = []
    pezzi_da_tagliare = []
    nomi_pezzi = {}
    percorsi_pezzi = {}
    limiti_min_pezzi = {}
    dimensioni_orig_pezzi = {}

    try:
        if FILE_CONFIG is None or not FILE_CONFIG.exists():
            raise FileNotFoundError("Impossibile trovare RectPackSetup.xml né nel Registro né nella cartella dell'eseguibile.")
        
        # 1. LETTURA DEL FILE DI CONFIGURAZIONE PRINCIPALE
        root_config = ET.parse(FILE_CONFIG).getroot()
        
        # Estrazione dei percorsi dinamici dei file XML dal tuo nuovo schema
        shape_path_node = root_config.find("DxfSourceShape")
        sheet_path_node = root_config.find("DxfSourceSheet")
        
        thcut_node = root_config.find("thcut")
        trim_node = root_config.find("trim")
        prefixfile_node = root_config.find("prefixfile")
        show_node = root_config.find("show")
        tox_node = root_config.find("txtoffset_x")
        toy_node = root_config.find("txtoffset_y")
        htxt_node = root_config.find("htxt")
        outputfile_node = root_config.find("outputfile")

        # Assegnazione parametri di configurazione
        if thcut_node is not None and thcut_node.text: SPESSORE_LAMA = int(thcut_node.text)
        if trim_node is not None and trim_node.text: MARGINI_RIFILO = int(trim_node.text)
        if prefixfile_node is not None and prefixfile_node.text: PREFISSO_FILE = prefixfile_node.text.strip()
        if show_node is not None and show_node.text: MOSTRA_GRAFICA = show_node.text.strip().lower() in ("true", "1", "yes")
        if tox_node is not None and tox_node.text: TESTO_OFFSET_X = float(tox_node.text)
        if toy_node is not None and toy_node.text: TESTO_OFFSET_Y = float(toy_node.text)
        if htxt_node is not None and htxt_node.text: TESTO_ALTEZZA = float(htxt_node.text)
        if outputfile_node is not None and outputfile_node.text:
            CARTELLA_DXF_OUTPUT = Path(outputfile_node.text.strip())
            CARTELLA_DXF_OUTPUT.mkdir(parents=True, exist_ok=True)

        # Controllo sui nodi dei file dati
        if shape_path_node is None or not shape_path_node.text:
            raise ValueError("Nodo <DxfSourceShape> vuoto o mancante in RectPackSetup.xml")
        if sheet_path_node is None or not sheet_path_node.text:
            raise ValueError("Nodo <DxfSourceSheet> vuoto o mancante in RectPackSetup.xml")

        DxfSourceShape = Path(shape_path_node.text.strip())
        DxfSourceSheet = Path(sheet_path_node.text.strip())

        if not DxfSourceShape.exists() or not DxfSourceSheet.exists():
            raise FileNotFoundError("Uno o più file XML dei dati sorgente (<DxfSourceShape> o <DxfSourceSheet>) non esistono.")

        # 2. LETTURA SHEET CON GESTIONE QUANTITÀ FINITE
        for s in ET.parse(DxfSourceSheet).getroot().findall(".//sheet"):
            dxf_path = s.get("path")
            if dxf_path:
                w, h, mx, my = ricava_dimensioni_e_limiti_dxf(dxf_path.strip())
                if w and h:
                    nome_sheet = s.get("name", f"Pannello_{len(pannelli_magazzino)}")
                    qta_sheet = int(s.get("quantity", 1))
                    
                    percorsi_fogli[nome_sheet] = (dxf_path.strip(), mx, my)
                    nomi_fogli[nome_sheet] = nome_sheet
                    pannelli_magazzino.append((w, h, qta_sheet, nome_sheet))

        # 3. LETTURA PEZZI DA TAGLIARE
        for p in ET.parse(DxfSourceShape).getroot().findall(".//shape"):
            dxf_path = p.get("path")
            if dxf_path:
                w, h, mx, my = ricava_dimensioni_e_limiti_dxf(dxf_path.strip())
                if w and h:
                    for _ in range(int(p.get("quantity", 1))):
                        id_p = len(pezzi_da_tagliare)
                        nomi_pezzi[id_p] = p.get("name", f"Pezzo_{id_p}")
                        percorsi_pezzi[id_p] = dxf_path.strip()
                        limiti_min_pezzi[id_p] = (mx, my)
                        dimensioni_orig_pezzi[id_p] = (w, h)
                        pezzi_da_tagliare.append((w, h, id_p))
                        
    except Exception as e:
        mostra_popup_fatto(f"Errore caricamento XML:\n{e}", "Errore", "errore")
        raise SystemExit

    return (
        SPESSORE_LAMA, MARGINI_RIFILO, CARTELLA_DXF_OUTPUT, PREFISSO_FILE, MOSTRA_GRAFICA,
        TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA, percorsi_fogli, nomi_fogli,
        pannelli_magazzino, pezzi_da_tagliare, nomi_pezzi, percorsi_pezzi,
        limiti_min_pezzi, dimensioni_orig_pezzi
    )

# Unpacking delle variabili per l'utilizzo globale nello script
(
    SPESSORE_LAMA, MARGINI_RIFILO, CARTELLA_DXF_OUTPUT, PREFISSO_FILE, MOSTRA_GRAFICA,
    TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA, percorsi_fogli, nomi_fogli,
    pannelli_magazzino, pezzi_da_tagliare, nomi_pezzi, percorsi_pezzi,
    limiti_min_pezzi, dimensioni_orig_pezzi
) = carica_configurazioni_e_dati()

# =====================================================================
# 3 PARTE - Esecuzione Nesting e Scrittura DXF
# =====================================================================
# packer = newPacker(pack_algo=GuillotineBssfSas, rotation=True)
packer = newPacker(
    pack_algo=GuillotineBssfSas, 
    sort_algo=SORT_AREA,          # <--- Questa riga ottimizza la disposizione a ghigliottina
    rotation=True
)

# Configurazione dei contenitori (bin) in base al magazzino disponibile
for w, h, qta, nome in pannelli_magazzino:
    if w - (2*MARGINI_RIFILO) > 0 and h - (2*MARGINI_RIFILO) > 0:
        packer.add_bin(w - (2*MARGINI_RIFILO), h - (2*MARGINI_RIFILO), count=qta, bid=nome)

# Aggiunta dei rettangoli da tagliare compensando lo spessore della lama
for w, h, id_p in pezzi_da_tagliare:
    packer.add_rect(w + SPESSORE_LAMA, h + SPESSORE_LAMA, rid=id_p)
    
# Avvio dell'ottimizzazione
packer.pack()

# Controllo se l'algoritmo è riuscito a posizionare almeno un pezzo
if not packer.bin_list():
    mostra_popup_fatto("Nessun pezzo posizionato. Controlla dimensioni o quantità dei fogli.", "Errore", "errore")
    raise SystemExit

# Calcolo ed eventuale avviso per i pezzi rimasti esclusi dal nesting
pezzi_inseriti = sum(len(b) for b in packer)
if pezzi_inseriti < len(pezzi_da_tagliare):
    pezzi_esclusi = len(pezzi_da_tagliare) - pezzi_inseriti
    mostra_popup_fatto(f"Attenzione: Fogli insufficienti a magazzino.\n{pezzi_esclusi} pezzi non sono stati inseriti.", "Avviso Magazzino Finite")

tutti_i_fogli = []

# Ciclo sui fogli generati dal packer per la scrittura geometrica dei file DXF
for indice_foglio, bin_istanza in enumerate(packer):
    W_orig = bin_istanza.width + (2 * MARGINI_RIFILO)
    H_orig = bin_istanza.height + (2 * MARGINI_RIFILO)
    
    doc = ezdxf.new("R2007")
    msp = doc.modelspace()
    
    # Recupero e inserimento della geometria originale dello sheet sorgente
    nome_sheet_corrente = bin_istanza.bid
    if nome_sheet_corrente in percorsi_fogli:
        path_sheet, s_mx, s_my = percorsi_fogli[nome_sheet_corrente]
        copia_geometria_dxf(path_sheet, msp, 0, 0, s_mx, s_my, ruotato=False, h_reale=0)
    else:
        # Fallback se non trova il foglio originale: disegna il rettangolo d'ingombro
        msp.add_lwpolyline([(0, 0), (W_orig, 0), (W_orig, H_orig), (0, H_orig), (0, 0)], close=True)

    rettangoli_foglio = []

    # Ciclo sui singoli pezzi inseriti all'interno dello sheet corrente
    for rect in bin_istanza:
        x, y = rect.x + MARGINI_RIFILO, rect.y + MARGINI_RIFILO
        w, h = rect.width - SPESSORE_LAMA, rect.height - SPESSORE_LAMA
        id_p = rect.rid
        rettangoli_foglio.append((x, y, w, h, id_p))
        
        # Controllo tolleranza per verificare se il pezzo è stato ruotato dall'algoritmo
        ruotato = False
        w_o, h_o = dimensioni_orig_pezzi[id_p]
        if abs(w - h_o) < 2 and abs(h - w_o) < 2: ruotato = True
        
        # Trasferimento geometrico delle entità interne del pezzo DXF sul foglio finale
        mx, my = limiti_min_pezzi[id_p]
        copia_geometria_dxf(percorsi_pezzi[id_p], msp, x, y, mx, my, ruotato, h_o)
        
    tutti_i_fogli.append({'W_orig': W_orig, 'H_orig': H_orig, 'rettangoli': rettangoli_foglio})
    
    # Salvataggio effettivo del file DXF finale
    doc.saveas(CARTELLA_DXF_OUTPUT / f"{PREFISSO_FILE}_{indice_foglio}.dxf")

# -----------------------------------------------------------
# 4 parte - Interfaccia Grafica Interattiva (Matplotlib)
# -----------------------------------------------------------
indice_corrente = 0
if MOSTRA_GRAFICA and tutti_i_fogli:
    
    # Configura uno stile pulito per lo sfondo della finestra
    plt.rcParams['figure.facecolor'] = '#f8f9fa'
    fig, ax = plt.subplots(figsize=(11, 7))
    plt.subplots_adjust(bottom=0.22, top=0.90, left=0.08, right=0.95)

    def aggiorna_grafico():
        ax.clear()
        f = tutti_i_fogli[indice_corrente]
        W_orig = f['W_orig']
        H_orig = f['H_orig']
        
        ax.set_xlim(-15, W_orig + 15)
        ax.set_ylim(-15, H_orig + 15)
        ax.set_aspect('equal')
        
        # --- AGGIUNTA GRIGLIA E ASSI ---
        ax.grid(True, which='both', color='#e0e0e0', linestyle='--', linewidth=0.5, zorder=0)
        ax.set_axisbelow(True) # Mette la griglia sotto i pannelli
        ax.set_xlabel("Larghezza (mm)", fontsize=9, color='#555555')
        ax.set_ylabel("Altezza (mm)", fontsize=9, color='#555555')
        ax.tick_params(colors='#555555', labelsize=8)
        
        # Disegna il foglio di magazzino (sfondo grigio chiaro con bordo deciso)
        ax.add_patch(patches.Rectangle((0, 0), W_orig, H_orig, linewidth=2, edgecolor='#2c3e50', facecolor='#fdfefe', zorder=1))
        
        for x, y, w, h, id_p in f['rettangoli']:
            # Rileva se il pezzo è stato ruotato
            w_o, h_o = dimensioni_orig_pezzi[id_p]
            ruotato = abs(w - h_o) < 2 and abs(h - w_o) < 2
            notazione_rotazione = " ↻" if ruotato else ""
            
            # Colore pezzo: Arancione soft pastello per non affaticare la vista
            colore_faccia = '#ffcc80' if ruotato else '#ffe082'
            colore_bordo = '#e65100' if ruotato else '#f57f17'
            
            # Disegna il pezzo nidificato
            ax.add_patch(patches.Rectangle((x, y), w, h, linewidth=1.2, edgecolor=colore_bordo, facecolor=colore_faccia, alpha=0.85, zorder=2))
            
            # Testo etichetta multilinea più ordinato
            nome = nomi_pezzi.get(id_p, "Pezzo")
            testo_etichetta = f"{nome}{notazione_rotazione}\n{int(w)}x{int(h)}"
            
            # Il testo viene stampato solo se entra visivamente nel rettangolo
            ax.text(x + w/2, y + h/2, testo_etichetta, fontsize=TESTO_ALTEZZA, color='#1a1a1a', 
                    ha='center', va='center', weight='bold', clip_on=True, zorder=3)
            
        # Titolo moderno e informativo
        ax.set_title(f"SCHEMA NESTING  |  Foglio {indice_corrente + 1} di {len(tutti_i_fogli)}\nDimensione Pannello: {int(W_orig)} x {int(H_orig)} mm", 
                     fontsize=11, color='#2c3e50', weight='bold', pad=15)
        plt.draw()

    def avanti(event):
        global indice_corrente
        if indice_corrente < len(tutti_i_fogli) - 1:
            indice_corrente += 1
            aggiorna_grafico()

    def indietro(event):
        global indice_corrente
        if indice_corrente > 0:
            indice_corrente -= 1
            aggiorna_grafico()

    # Pulsanti dal look minimale e moderno
    ax_indietro = plt.axes([0.38, 0.05, 0.11, 0.055])
    ax_avanti = plt.axes([0.51, 0.05, 0.11, 0.055])

    btn_indietro = Button(ax_indietro, '← Indietro', color='#e0e0e0', hovercolor='#b0bec5')
    btn_avanti = Button(ax_avanti, 'Avanti →', color='#e0e0e0', hovercolor='#b0bec5')
    
    # Cambia font e colore del testo dei pulsanti
    btn_indietro.label.set_fontsize(9)
    btn_indietro.label.set_weight('bold')
    btn_avanti.label.set_fontsize(9)
    btn_avanti.label.set_weight('bold')

    btn_indietro.on_clicked(indietro)
    btn_avanti.on_clicked(avanti)
    
    aggiorna_grafico()
    plt.show()

# Popup di completamento corretto
mostra_popup_fatto(f"Nesting completato con successo!\nGenerati {len(tutti_i_fogli)} file DXF.", "EasyCut")


