import matplotlib.pyplot as plt
import matplotlib.patches as patches
from rectpack import newPacker
from rectpack.guillotine import GuillotineBssfSas
import ezdxf
import xml.etree.ElementTree as ET
from pathlib import Path
import tkinter as tk                 # <-- AGGIUNTO: Importato tkinter
from tkinter import messagebox       # <-- AGGIUNTO: Importato messagebox

def mostra_popup_fatto(testo, titolo, tipo="info"):
    root = tk.Tk()
    root.withdraw()
    root.attributes("-topmost", True)
    if tipo == "errore":
        messagebox.showerror(title=titolo, message=testo)
    else:
        messagebox.showinfo(title=titolo, message=testo)
    root.destroy()

# --- CONFIGURAZIONE PERCORSO FILE DATI ---
NOME_FILE_XML = Path.home() / "EasyCut" / "Output" / "Nesting" / "RectPack.xml"

# Parametri di default
SPESSORE_LAMA = 4    
MARGINI_RIFILO = 0  
CARTELLA_DXF = Path(".")  
PREFISSO_FILE = "schema"  
MOSTRA_GRAFICA = True     

TESTO_OFFSET_X = 10
TESTO_OFFSET_Y = 10
TESTO_ALTEZZA = 2

pannelli_magazzino = []
pezzi_da_tagliare = []
nomi_pezzi = {}  

# --- PARSING DEL FILE XML ---
try:
    tree = ET.parse(NOME_FILE_XML)
    root = tree.getroot()
    
    config = root.find("configurazione")
    if config is not None:
        lama_node = config.find("lama")
        rifilo_node = config.find("rifilo")
        output_node = config.find("cartella_output")
        prefisso_node = config.find("prefisso_file")
        grafica_node = config.find("mostra_grafica")
        
        tox_node = config.find("testo_offset_x")
        toy_node = config.find("testo_offset_y")
        th_node = config.find("testo_altezza")

        if lama_node is not None and lama_node.text:
            SPESSORE_LAMA = int(lama_node.text)
        if rifilo_node is not None and rifilo_node.text:
            MARGINI_RIFILO = int(rifilo_node.text)
        if prefisso_node is not None and prefisso_node.text:
            PREFISSO_FILE = prefisso_node.text.strip()     
        if grafica_node is not None and grafica_node.text:
            MOSTRA_GRAFICA = grafica_node.text.strip().lower() == "true"
        if tox_node is not None and tox_node.text:
            TESTO_OFFSET_X = float(tox_node.text)
        if toy_node is not None and toy_node.text:
            TESTO_OFFSET_Y = float(toy_node.text)
        if th_node is not None and th_node.text:
            TESTO_ALTEZZA = float(th_node.text)
        if output_node is not None and output_node.text:
            CARTELLA_DXF = Path(output_node.text.strip())
            CARTELLA_DXF.mkdir(parents=True, exist_ok=True)
            
    magazzino = root.find("magazzino")
    if magazzino is not None:
        for p in magazzino.findall("pannello"):
            w = int(p.get("larghezza"))
            h = int(p.get("altezza"))
            pannelli_magazzino.append((w, h))
            
    prodotti = root.find("prodotti")
    if prodotti is not None:
        for id_pezzo, p in enumerate(prodotti.findall("pezzo")):
            w = int(p.get("larghezza"))
            h = int(p.get("altezza"))
            nome = p.get("nome", f"Pezzo_{id_pezzo}")
            
            pezzi_da_tagliare.append((w, h))
            nomi_pezzi[id_pezzo] = nome

except FileNotFoundError:
    print(f"Errore: Il file '{NOME_FILE_XML}' non esiste!")
    exit()
except ET.ParseError:
    print(f"Errore: Il file '{NOME_FILE_XML}' contiene errori di sintassi XML!")
    exit()

# --- ALGORITMO DI NESTING ---
packer = newPacker(pack_algo=GuillotineBssfSas, rotation=True)

for p in pannelli_magazzino:
    w_mag, h_mag = p
    w_utile = w_mag - (MARGINI_RIFILO * 2)
    h_utile = h_mag - (MARGINI_RIFILO * 2)
    packer.add_bin(w_utile, h_utile, count=1)

for i, pezzo in enumerate(pezzi_da_tagliare):
    w_pezzo, h_pezzo = pezzo
    w_con_lama = w_pezzo + SPESSORE_LAMA
    h_con_lama = h_pezzo + SPESSORE_LAMA
    packer.add_rect(w_con_lama, h_con_lama, rid=i)

packer.pack()

all_rects = packer.rect_list()
pannelli_usati = sorted(list(set(r[0] for r in all_rects)))

# --- CONTROLLO PEZZI ESCLUSI (Ottimizzazione) ---
rimasti_fuori = len(pezzi_da_tagliare) - len(all_rects)
if rimasti_fuori > 0:
    print(f"\n⚠️ ATTENZIONE: {rimasti_fuori} pezzi non hanno trovato spazio nei pannelli!")

# --- ELABORAZIONE E OUTPUT SEPARATO ---
for bin_idx in pannelli_usati:
    doc = ezdxf.new('R2010')
    msp = doc.modelspace()
    
    layer_legno = doc.layers.new(name='PANNELLO_LEGNO')
    layer_legno.color = 7
    layer_rifilo = doc.layers.new(name='LINEE_RIFILO')
    layer_rifilo.color = 1  
    layer_pezzi = doc.layers.new(name='PANNELLI_TAGLIATI')
    layer_pezzi.color = 2
    layer_testo = doc.layers.new(name='TESTO_MISURE')
    layer_testo.color = 3

    if MOSTRA_GRAFICA:
        fig, ax = plt.subplots(figsize=(10, 7))
    
    l_totale, h_totale = pannelli_magazzino[bin_idx]
    
    if MOSTRA_GRAFICA:
        ax.add_patch(patches.Rectangle((0, 0), l_totale, h_totale, facecolor='#f5f5f5', edgecolor='#7f8c8d', lw=1, linestyle='--'))
        ax.add_patch(patches.Rectangle((MARGINI_RIFILO, MARGINI_RIFILO), l_totale - (MARGINI_RIFILO*2), h_totale - (MARGINI_RIFILO*2), facecolor='#e0e0e0', edgecolor='#c0392b', lw=2))
    
    msp.add_lwpolyline([(0, 0), (l_totale, 0), (l_totale, h_totale), (0, h_totale)], dxfattribs={'layer': 'PANNELLO_LEGNO', 'closed': True})
    msp.add_lwpolyline(
        [(MARGINI_RIFILO, MARGINI_RIFILO), 
         (l_totale - MARGINI_RIFILO, MARGINI_RIFILO), 
         (l_totale - MARGINI_RIFILO, h_totale - MARGINI_RIFILO), 
         (MARGINI_RIFILO, h_totale - MARGINI_RIFILO)],
        dxfattribs={'layer': 'LINEE_RIFILO', 'closed': True}
    )
    msp.add_text(f"PANNELLO {bin_idx + 1} (Lama {SPESSORE_LAMA}mm - Rifilo {MARGINI_RIFILO}mm)", dxfattribs={'layer': 'PANNELLO_LEGNO', 'height': 80}).set_placement((0, h_totale + 50))

    print(f"\n=======================================================")
    print(f"--- LISTA POSIZIONI PANNELLO {bin_idx + 1} ({l_totale}x{h_totale} mm) ---")
    print(f"Lama: {SPESSORE_LAMA} mm | Rifilo: {MARGINI_RIFILO} mm per lato.")
    print(f"=======================================================")
    
    for rettangolo in all_rects:
        b, x, y, w, h, rid = rettangolo
        if b == bin_idx:
            w_reale = w - SPESSORE_LAMA
            h_reale = h - SPESSORE_LAMA
            nome_reale = nomi_pezzi[rid]
            
            x_reale_pannello = x + MARGINI_RIFILO
            y_reale_pannello = y + MARGINI_RIFILO
            
            print(f"NOME: {nome_reale:<20} | Inizio Taglio -> X: {x_reale_pannello:<5} Y: {y_reale_pannello:<5} | Misure: {w_reale}x{h_reale} mm")
            
            if MOSTRA_GRAFICA:
                ax.add_patch(patches.Rectangle((x_reale_pannello, y_reale_pannello), w_reale, h_reale, facecolor='#f39c12', edgecolor='#d35400', alpha=0.7))
                testo_grafico = f"{nome_reale}\n{w_reale}x{h_reale}"
                ax.text(x_reale_pannello + w_reale/2, y_reale_pannello + h_reale/2, testo_grafico, color='black', weight='bold', ha='center', va='center', fontsize=7)
            
            x1_cad = x_reale_pannello
            y1_cad = y_reale_pannello
            x2_cad = x1_cad + w_reale
            y2_cad = y1_cad + h_reale
            
            msp.add_lwpolyline([(x1_cad, y1_cad), (x2_cad, y1_cad), (x2_cad, y2_cad), (x1_cad, y2_cad)], dxfattribs={'layer': 'PANNELLI_TAGLIATI', 'closed': True})
            
            centro_x = x1_cad + (w_reale / 2)
            centro_y = y1_cad + (h_reale / 2)
            
            t_nome = msp.add_text(nome_reale, dxfattribs={'layer': 'TESTO_MISURE', 'height': 35})
            t_nome.set_placement((centro_x, centro_y + 20), align=ezdxf.enums.TextEntityAlignment.CENTER)
            t_misure = msp.add_text(f"{w_reale}x{h_reale}", dxfattribs={'layer': 'TESTO_MISURE', 'height': 30})
            t_misure.set_placement((centro_x, centro_y - 20), align=ezdxf.enums.TextEntityAlignment.CENTER)

    # --- CODICE RIPRISTINATO E COMPLETATO ---
    nome_file_singolo = f"{PREFISSO_FILE}_pannello_{bin_idx + 1}.dxf"
    percorso_salvataggio_dxf = CARTELLA_DXF / nome_file_singolo
    
    doc.saveas(percorso_salvataggio_dxf)
    print(f"--> Generato file CAD in: '{percorso_salvataggio_dxf}'")
    
    if MOSTRA_GRAFICA:
        ax.set_xlim(-50, l_totale + 50)
        ax.set_ylim(-50, h_totale + 50)
        ax.set_aspect('equal')
        plt.title(f"Schema di Taglio - Pannello {bin_idx + 1}")

# Mostra i grafici solo alla fine di tutta l'elaborazione dei file
if MOSTRA_GRAFICA and pannelli_usati:
    plt.show()

# Esempio di utilizzo del popup a fine processo
mostra_popup_fatto(f"Nesting completato con successo!\nGenerati {len(pannelli_usati)} file DXF.", "EasyCut")



