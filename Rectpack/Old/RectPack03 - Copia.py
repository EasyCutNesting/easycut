# pyinstaller --clean --noconsole --name=RectPack02 RectPack02.py   (crea il file Exe con librerie sorgenti)
# pyinstaller RectPack02.py                                         (crea exe con librerie compresse)
# python RectPack02.py                                              (esegue il file da terminale senza compilarlo)
# =====================================================================
# 1 PARTE - Importazioni e Utility Geometriche (Ottimizzata con Cache RAM)
# =====================================================================
import sys
import xml.etree.ElementTree as ET
import winreg  # Libreria nativa Windows per accedere ai registri
from pathlib import Path
import tkinter as tk                 
from tkinter import messagebox
import matplotlib.pyplot as plt
import matplotlib.patches as patches
from matplotlib.widgets import Button
from rectpack import newPacker, SORT_AREA
from rectpack.guillotine import GuillotineBssfSas
import ezdxf

def inizializza_utility_geometriche():
    """
    Raggruppa le funzioni di utilità per la gestione dei popup,
    l'analisi geometrica e la copia rapida tramite Cache RAM dei file DXF.
    """
    # Dizionario in RAM per salvare i file DXF già letti ed evitare accessi al disco ripetuti
    cache_dxf = {}

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
            
            # Sfruttiamo la cache anche in fase di caricamento iniziale se il file è già noto
            if str(p) in cache_dxf:
                doc = cache_dxf[str(p)]
            else:
                doc = ezdxf.readfile(p)
                cache_dxf[str(p)] = doc
                
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
            p_str = str(Path(percorso_sorg))
            
            # GESTIONE CACHE: Se il file è già in RAM lo usiamo, altrimenti lo leggiamo una sola volta
            if p_str in cache_dxf:
                doc_sorg = cache_dxf[p_str]
            else:
                doc_sorg = ezdxf.readfile(p_str)
                cache_dxf[p_str] = doc_sorg
                
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

# Estrazione delle funzioni per l'utilizzo globale
mostra_popup_fatto, ricava_dimensioni_e_limiti_dxf, copia_geometria_dxf = inizializza_utility_geometriche()

# =====================================================================
# 2 PARTE - Configurazione e caricamento file XML (Ottimizzata EXE)
# =====================================================================
def carica_configurazioni_e_dati():
    """
    Recupera il file di configurazione principale RectPackSetup.xml tramite 2 livelli di sicurezza.
    Successivamente estrae i dati geometrici e i vincoli di rotazione (venatura) dai file XML.
    """
    
    # <shape name="Test ant  1pz sp4" path="C:\Users\adl20\EasyCut\Output\Nesting\Test ant  1pz sp4.dxf" quantity="48" rotation="0" />
    # rotation="0" Questo pezzo NON ruoterà (rispetta la vena) -->
    # rotation="1" il pezzo può ruotare
    
    FILE_CONFIG = None

    # LIVELLO 1: Registro di Sistema
    try:
        access_mask = winreg.KEY_READ | winreg.KEY_WOW64_64KEY
        with winreg.OpenKey(winreg.HKEY_CURRENT_USER, r"SOFTWARE\EasyCut", 0, access_mask) as chiave:
            valore, _ = winreg.QueryValueEx(chiave, "SettingRectPack")
            percorso_registro = Path(valore.strip())
            if percorso_registro.exists():
                FILE_CONFIG = percorso_registro
    except Exception:
        pass

    # LIVELLO 2: Cartella di lancio locale
    if FILE_CONFIG is None:
        try:
            if getattr(sys, 'frozen', False):
                cartella_lancio = Path(sys.executable).resolve().parent
            else:
                cartella_lancio = Path(__file__).resolve().parent
                
            percorso_locale = cartella_lancio / "RectPackSetup.xml"
            if percorso_locale.exists():
                FILE_CONFIG = percorso_locale
        except Exception:
            pass

    print(f"[INFO] File di configurazione caricato da: {FILE_CONFIG}")

    # Valori di default
    SPESSORE_LAMA = 4    
    MARGINI_RIFILO = 0  
    CARTELLA_DXF_OUTPUT = Path(".")  
    PREFISSO_FILE = "schema"  
    MOSTRA_GRAFICA = True     
    TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA = 10, 10, 2

    percorsi_fogli = {}
    nomi_fogli = {}
    pannelli_magazzino = []
    pezzi_da_tagliare = []  # Struttura: (w, h, id_p, consenti_rotazione)
    nomi_pezzi = {}
    percorsi_pezzi = {}
    limiti_min_pezzi = {}
    dimensioni_orig_pezzi = {}

    try:
        if FILE_CONFIG is None or not FILE_CONFIG.exists():
            raise FileNotFoundError("Impossibile trovare RectPackSetup.xml né nel Registro né nella cartella dell'eseguibile.")
        
        root_config = ET.parse(FILE_CONFIG).getroot()
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

        if shape_path_node is None or not shape_path_node.text:
            raise ValueError("Nodo <DxfSourceShape> vuoto o mancante in RectPackSetup.xml")
        if sheet_path_node is None or not sheet_path_node.text:
            raise ValueError("Nodo <DxfSourceSheet> vuoto o mancante in RectPackSetup.xml")

        DxfSourceShape = Path(shape_path_node.text.strip())
        DxfSourceSheet = Path(sheet_path_node.text.strip())

        if not DxfSourceShape.exists() or not DxfSourceSheet.exists():
            raise FileNotFoundError("Uno o più file XML dei dati sorgente non esistono.")

        # Lettera Fogli
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

        # Lettura Pezzi con controllo Venatura (rotation="0" blocca la rotazione)
        for p in ET.parse(DxfSourceShape).getroot().findall(".//shape"):
            dxf_path = p.get("path")
            if dxf_path:
                w, h, mx, my = ricava_dimensioni_e_limiti_dxf(dxf_path.strip())
                if w and h:
                    rot_attr = p.get("rotation", "1").strip().lower()
                    consenti_rotazione = rot_attr not in ("0", "false", "no")
                    
                    for _ in range(int(p.get("quantity", 1))):
                        id_p = len(pezzi_da_tagliare)
                        nomi_pezzi[id_p] = p.get("name", f"Pezzo_{id_p}")
                        percorsi_pezzi[id_p] = dxf_path.strip()
                        limiti_min_pezzi[id_p] = (mx, my)
                        dimensioni_orig_pezzi[id_p] = (w, h)
                        pezzi_da_tagliare.append((w, h, id_p, consenti_rotazione))
                        
    except Exception as e:
        mostra_popup_fatto(f"Errore caricamento XML:\n{e}", "Errore", "errore")
        raise SystemExit

    return (
        SPESSORE_LAMA, MARGINI_RIFILO, CARTELLA_DXF_OUTPUT, PREFISSO_FILE, MOSTRA_GRAFICA,
        TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA, percorsi_fogli, nomi_fogli,
        pannelli_magazzino, pezzi_da_tagliare, nomi_pezzi, percorsi_pezzi,
        limiti_min_pezzi, dimensioni_orig_pezzi
    )

(
    SPESSORE_LAMA, MARGINI_RIFILO, CARTELLA_DXF_OUTPUT, PREFISSO_FILE, MOSTRA_GRAFICA,
    TESTO_OFFSET_X, TESTO_OFFSET_Y, TESTO_ALTEZZA, percorsi_fogli, nomi_fogli,
    pannelli_magazzino, pezzi_da_tagliare, nomi_pezzi, percorsi_pezzi,
    limiti_min_pezzi, dimensioni_orig_pezzi
) = carica_configurazioni_e_dati()

# =====================================================================
# 3 PARTE - Anteprima Dati, Esecuzione Nesting e Scrittura DXF (Con Popup Finale)
# =====================================================================

def mostra_anteprima_dati():
    """
    Crea una finestra Tkinter a due colonne per mostrare il riepilogo
    dei pezzi (colonna SX) e delle lamiere/fogli (colonna DX) prima del calcolo.
    """
    finestra = tk.Tk()
    finestra.title("EasyCut - Anteprima Dati di Taglio")
    finestra.geometry("950x450")
    finestra.configure(bg="#f8f9fa")
    finestra.attributes("-topmost", True)

    stato = {"procedi": False}

    def on_procedi():
        stato["procedi"] = True
        finestra.destroy()

    def on_annulla():
        finestra.destroy()

    # --- TITOLO PRINCIPALE ---
    lbl_titolo = tk.Label(finestra, text="RIEPILOGO MATERIALE PRIMA DEL NESTING", font=("Arial", 12, "bold"), bg="#f8f9fa", fg="#2c3e50")
    lbl_titolo.pack(pady=10)

    # --- CONTENITORE DELLE DUE COLONNE ---
    frame_colonne = tk.Frame(finestra, bg="#f8f9fa")
    frame_colonne.pack(fill=tk.BOTH, expand=True, padx=15, pady=5)

    # --- COLONNA SINISTRA: PEZZI DA TAGLIARE ---
    col_sinistra = tk.LabelFrame(frame_colonne, text=" Lista Pezzi da Tagliare ", font=("Arial", 10, "bold"), bg="#ffffff", fg="#e65100")
    col_sinistra.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

    txt_pezzi = tk.Text(col_sinistra, font=("Consolas", 9), bg="#ffffff", bd=0, wrap=tk.NONE)
    scroll_s = tk.Scrollbar(col_sinistra, command=txt_pezzi.yview)
    txt_pezzi.configure(yscrollcommand=scroll_s.set)
    scroll_s.pack(side=tk.RIGHT, fill=tk.Y)
    txt_pezzi.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

    conteggio_pezzi = {}
    for w, h, id_p, consenti_rotazione in pezzi_da_tagliare:
        nome = nomi_pezzi.get(id_p, f"Pezzo_{id_p}")
        rot_str = "Libera" if consenti_rotazione else "BLOCCATA"
        chiave = (nome, w, h, rot_str)
        conteggio_pezzi[chiave] = conteggio_pezzi.get(chiave, 0) + 1

    txt_pezzi.insert(tk.END, f"{'NOME PEZZO':<38} {'DIM. (mm)':<12} {'Q.TÀ':<5} {'ROTAZIONE':<9}\n")
    txt_pezzi.insert(tk.END, "-" * 69 + "\n")
    for (nome, w, h, rot_str), qta in conteggio_pezzi.items():
        dim_str = f"{w}x{h}"
        nome_corto = nome[:36] + ".." if len(nome) > 36 else nome
        txt_pezzi.insert(tk.END, f"{nome_corto:<38} {dim_str:<12} {qta:<5} {rot_str:<9}\n")
    txt_pezzi.configure(state=tk.DISABLED)

    # --- COLONNA DESTRA: LAMIERE IN MAGAZZINO ---
    col_destra = tk.LabelFrame(frame_colonne, text=" Lista Lamiere / Fogli Disponibili ", font=("Arial", 10, "bold"), bg="#ffffff", fg="#2c3e50")
    col_destra.pack(side=tk.RIGHT, fill=tk.BOTH, expand=True, padx=5, pady=5)

    txt_lamiere = tk.Text(col_destra, font=("Consolas", 9), bg="#ffffff", bd=0, wrap=tk.NONE)
    scroll_d = tk.Scrollbar(col_destra, command=txt_lamiere.yview)
    txt_lamiere.configure(yscrollcommand=scroll_d.set)
    scroll_d.pack(side=tk.RIGHT, fill=tk.Y)
    txt_lamiere.pack(side=tk.LEFT, fill=tk.BOTH, expand=True, padx=5, pady=5)

    txt_lamiere.insert(tk.END, f"{'ID PANNELLO / SHEET':<38} {'DIM. (mm)':<12} {'Q.TÀ DISP.':<10}\n")
    txt_lamiere.insert(tk.END, "-" * 64 + "\n")
    for w, h, qta, nome in pannelli_magazzino:
        dim_str = f"{w}x{h}"
        nome_corto = nome[:36] + ".." if len(nome) > 36 else nome
        txt_lamiere.insert(tk.END, f"{nome_corto:<38} {dim_str:<12} {qta:<10}\n")
    txt_lamiere.configure(state=tk.DISABLED)

    # --- PULSANTI DI AZIONE ---
    frame_pulsanti = tk.Frame(finestra, bg="#f8f9fa")
    frame_pulsanti.pack(fill=tk.X, pady=15)

    btn_annulla = tk.Button(frame_pulsanti, text="Annulla Taglio", font=("Arial", 9, "bold"), fg="#ffffff", bg="#c62828", activebackground="#b71c1c", width=15, command=on_annulla)
    btn_annulla.pack(side=tk.LEFT, padx=40)

    btn_procedi = tk.Button(frame_pulsanti, text="Avvia Nesting →", font=("Arial", 9, "bold"), fg="#ffffff", bg="#2e7d32", activebackground="#1b5e20", width=15, command=on_procedi)
    btn_procedi.pack(side=tk.RIGHT, padx=40)

    finestra.mainloop()
    return stato["procedi"]


# Controllo avvio anteprima dati
if not mostra_anteprima_dati():
    print("[INFO] Operazione annullata dall'utente.")
    sys.exit()


# Creiamo due packer distinti per separare la logica delle rotazioni
packer_libero = newPacker(pack_algo=GuillotineBssfSas, sort_algo=SORT_AREA, rotation=True)
packer_fisso = newPacker(pack_algo=GuillotineBssfSas, sort_algo=SORT_AREA, rotation=False)

# Configurazione dei contenitori (bin) per entrambi i packer
for w, h, qta, nome in pannelli_magazzino:
    if w - (2*MARGINI_RIFILO) > 0 and h - (2*MARGINI_RIFILO) > 0:
        w_disponibile = w - (2*MARGINI_RIFILO)
        h_disponibile = h - (2*MARGINI_RIFILO)
        packer_libero.add_bin(w_disponibile, h_disponibile, count=qta, bid=nome)
        packer_fisso.add_bin(w_disponibile, h_disponibile, count=qta, bid=nome)

# Smistamento dei pezzi in base al vincolo XML della venatura
for w, h, id_p, consenti_rotazione in pezzi_da_tagliare:
    w_lama = w + SPESSORE_LAMA
    h_lama = h + SPESSORE_LAMA
    if consenti_rotazione:
        packer_libero.add_rect(w_lama, h_lama, rid=id_p)
    else:
        packer_fisso.add_rect(w_lama, h_lama, rid=id_p)
    
# Avvio dell'ottimizzazione su entrambi i fronti
packer_libero.pack()
packer_fisso.pack()

# Controllo se almeno un algoritmo ha posizionato qualcosa
if not packer_libero.bin_list() and not packer_fisso.bin_list():
    mostra_popup_fatto("Nessun pezzo posizionato. Controlla dimensioni o quantità dei fogli.", "Errore", "errore")
    raise SystemExit

# Calcolo dei pezzi rimasti esclusi
pezzi_inseriti_liberi = sum(len(b) for b in packer_libero)
pezzi_inseriti_fissi = sum(len(b) for b in packer_fisso)
totale_inseriti = pezzi_inseriti_liberi + pezzi_inseriti_fissi

if totale_inseriti < len(pezzi_da_tagliare):
    pezzi_esclusi = len(pezzi_da_tagliare) - totale_inseriti
    mostra_popup_fatto(
        f"Attenzione: Fogli insufficienti a magazzino.\n\n"
        f"Pezzi totali richiesti: {len(pezzi_da_tagliare)}\n"
        f"Pezzi posizionati con successo: {totale_inseriti}\n"
        f"Pezzi RIMASTI ESCLUSI: {pezzi_esclusi}", 
        "Avviso Magazzino Fogli"
    )

# Unifichiamo i risultati combinando i fogli generati da entrambi i packer
mappa_fogli_generati = {}

def elabora_istanza_packer(packer_selezionato):
    for bin_istanza in packer_selezionato:
        if len(bin_istanza) == 0:
            continue
            
        nome_foglio = bin_istanza.bid
        if nome_foglio not in mappa_fogli_generati:
            mappa_fogli_generati[nome_foglio] = {
                'W_orig': bin_istanza.width + (2 * MARGINI_RIFILO),
                'H_orig': bin_istanza.height + (2 * MARGINI_RIFILO),
                'rettangoli': []
            }
        
        for rect in bin_istanza:
            x, y = rect.x + MARGINI_RIFILO, rect.y + MARGINI_RIFILO
            w, h = rect.width - SPESSORE_LAMA, rect.height - SPESSORE_LAMA
            id_p = rect.rid
            mappa_fogli_generati[nome_foglio]['rettangoli'].append((x, y, w, h, id_p))

elabora_istanza_packer(packer_fisso)
elabora_istanza_packer(packer_libero)

# Creiamo la lista per l'interfaccia grafica
tutti_i_fogli = list(mappa_fogli_generati.values())

# Scrittura geometrica dei file DXF finali combinati
print("\n[INFO] Avvio generazione file DXF di output...")
for indice_foglio, (nome_sheet_corrente, dati_foglio) in enumerate(mappa_fogli_generati.items()):
    W_orig = dati_foglio['W_orig']
    H_orig = dati_foglio['H_orig']
    
    doc = ezdxf.new("R2007")
    msp = doc.modelspace()
    
    if nome_sheet_corrente in percorsi_fogli:
        path_sheet, s_mx, s_my = percorsi_fogli[nome_sheet_corrente]
        copia_geometria_dxf(path_sheet, msp, 0, 0, s_mx, s_my, ruotato=False, h_reale=0)
    else:
        msp.add_lwpolyline([(0, 0), (W_orig, 0), (W_orig, H_orig), (0, H_orig), (0, 0)], close=True)

    for x, y, w, h, id_p in dati_foglio['rettangoli']:
        ruotato = False
        w_o, h_o = dimensioni_orig_pezzi[id_p]
        if abs(w - h_o) < 2 and abs(h - w_o) < 2: ruotato = True
        
        mx, my = limiti_min_pezzi[id_p]
        copia_geometria_dxf(percorsi_pezzi[id_p], msp, x, y, mx, my, ruotato, h_o)
        
    percorso_salvataggio = CARTELLA_DXF_OUTPUT / f"{PREFISSO_FILE}_{indice_foglio}.dxf"
    doc.saveas(percorso_salvataggio)
    print(f" -> Scritto file: {percorso_salvataggio.name} (Pezzi inseriti: {len(dati_foglio['rettangoli'])})")
print("[INFO] Generazione DXF completata.\n")

# --- POPUP FINALE DI COMPLETAMENTO REINSERITO ---
mostra_popup_fatto(f"Nesting completato con successo!\nGenerati {len(tutti_i_fogli)} file DXF.", "EasyCut")

# -----------------------------------------------------------
# 4 parte - Interfaccia Grafica Interattiva (Matplotlib)
# -----------------------------------------------------------
indice_corrente = 0
if MOSTRA_GRAFICA and tutti_i_fogli:
    
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
        
        ax.grid(True, which='both', color='#e0e0e0', linestyle='--', linewidth=0.5, zorder=0)
        ax.set_axisbelow(True)
        ax.set_xlabel("Larghezza (mm)", fontsize=9, color='#555555')
        ax.set_ylabel("Altezza (mm)", fontsize=9, color='#555555')
        ax.tick_params(colors='#555555', labelsize=8)
        
        ax.add_patch(patches.Rectangle((0, 0), W_orig, H_orig, linewidth=2, edgecolor='#2c3e50', facecolor='#fdfefe', zorder=1))
        
        for x, y, w, h, id_p in f['rettangoli']:
            # Verifica se il pezzo originario nel database pezzi_da_tagliare ha la rotazione disabilitata
            info_pezzo = next((p for p in pezzi_da_tagliare if p[2] == id_p), None)
            vena_bloccata = not info_pezzo[3] if info_pezzo else False
            
            w_o, h_o = dimensioni_orig_pezzi[id_p]
            ruotato = abs(w - h_o) < 2 and abs(h - w_o) < 2
            
            if ruotato:
                notazione_rotazione = " ↻"
                colore_faccia = '#ffcc80'  # Arancione pastello
                colore_bordo = '#e65100'
            elif vena_bloccata:
                notazione_rotazione = "\n[Vena Bloccata]"
                colore_faccia = '#c8e6c9'  # Verde pastello per la venatura garantita
                colore_bordo = '#2e7d32'
            else:
                notazione_rotazione = ""
                colore_faccia = '#ffe082'  # Giallo standard
                colore_bordo = '#f57f17'
            
            ax.add_patch(patches.Rectangle((x, y), w, h, linewidth=1.2, edgecolor=colore_bordo, facecolor=colore_faccia, alpha=0.85, zorder=2))
            
            nome = nomi_pezzi.get(id_p, "Pezzo")
            testo_etichetta = f"{nome}{notazione_rotazione}\n{int(w)}x{int(h)}"
            
            ax.text(x + w/2, y + h/2, testo_etichetta, fontsize=TESTO_ALTEZZA, color='#1a1a1a', 
                    ha='center', va='center', weight='bold', clip_on=True, zorder=3)
            
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

    ax_indietro = plt.axes([0.38, 0.05, 0.11, 0.055])
    ax_avanti = plt.axes([0.51, 0.05, 0.11, 0.055])

    btn_indietro = Button(ax_indietro, '← Indietro', color='#e0e0e0', hovercolor='#b0bec5')
    btn_avanti = Button(ax_avanti, 'Avanti →', color='#e0e0e0', hovercolor='#b0bec5')
    
    btn_indietro.label.set_fontsize(9)
    btn_indietro.label.set_weight('bold')
    btn_avanti.label.set_fontsize(9)
    btn_avanti.label.set_weight('bold')

    btn_indietro.on_clicked(indietro)
    btn_avanti.on_clicked(avanti)
    
    aggiorna_grafico()
    plt.show()

# mostra_popup_fatto(f"Nesting completato con successo!\nGenerati {len(tutti_i_fogli)} file DXF.", "EasyCut")
