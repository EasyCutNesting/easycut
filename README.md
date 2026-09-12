# EasyCut Nesting

**Software gratuito per l'ottimizzazione del taglio di lamiere e barre**

EasyCut Nesting è un software per la gestione e l'ottimizzazione del taglio di materiali, sviluppato per lavorare all'interno di AutoCAD.

Il programma consente di organizzare le sagome da tagliare, ridurre gli sprechi di materiale e preparare i dati necessari alla lavorazione industriale.

🌐 Sito ufficiale: https://www.easycutnesting.it/

---

## Indice

* [Descrizione](#descrizione)
* [Caratteristiche principali](#caratteristiche-principali)
* [Compatibilità e tecnologia](#compatibilità-e-tecnologia)
* [EasyCut Nesting](#easycut-nesting)
* [EasyCut NestingBars](#easycut-nestingbars)
* [Funzionalità](#funzionalità)
* [Installazione](#installazione)
* [Utilizzo](#utilizzo)
* [Sviluppo](#sviluppo)
* [Licenza](#licenza)
* [Contatti](#contatti)

---

## Descrizione

EasyCut nasce dall'esperienza nel settore del taglio industriale e dalla volontà di mettere a disposizione uno strumento semplice, efficace e gratuito per l'ottimizzazione del materiale.

Il software utilizza il motore grafico di AutoCAD per la gestione dei disegni e delle sagome, producendo file DWG nativi.

L'obiettivo principale è migliorare l'efficienza del processo di taglio attraverso:

* Ottimizzazione della disposizione delle sagome.
* Riduzione degli scarti di materiale.
* Gestione dei contorni e delle relative caratteristiche.
* Preparazione dei dati per la produzione.

## Caratteristiche principali

### Ottimizzazione del taglio

L'algoritmo di nesting permette di disporre automaticamente le sagome all'interno della lamiera, cercando di ridurre gli sprechi e sfruttare al meglio il materiale disponibile.

### Integrazione con AutoCAD

EasyCut è basato su AutoCAD e lavora con disegni DWG nativi.

L'integrazione con l'ambiente CAD permette di utilizzare gli strumenti grafici e le funzionalità di modifica del disegno.

### Riconoscimento dei contorni

Il programma dispone di una procedura per il riconoscimento dei contorni delle sagome.

Durante questa fase possono essere definiti attributi e caratteristiche utili alla lavorazione, tra cui:

* Spessore.
* Senso di percorrenza.
* Compensazione di taglio.
* Commessa.
* Fase.
* Nome della sagoma.

### Editing dinamico

Le caratteristiche e gli attributi delle sagome possono essere modificati anche dopo la loro creazione.

Il software comprende inoltre funzionalità di verifica della sovrapposizione degli spigoli delle sagome.

### Reportistica e produzione

EasyCut dispone di moduli per la reportistica e la schedulazione del lavoro.

È prevista anche una gestione con codice a barre sviluppata in HTML, pensata per l'utilizzo a bordo macchina durante le operazioni di carico e scarico del lavoro.

---

## Compatibilità e tecnologia

EasyCut è sviluppato in linguaggio **AutoLISP** e utilizza AutoCAD come ambiente grafico.

### Tecnologia

| Caratteristica    | Descrizione                                     |
| ----------------- | ----------------------------------------------- |
| Linguaggio        | AutoLISP                                        |
| Ambiente grafico  | AutoCAD                                         |
| Formato disegni   | DWG nativo                                      |
| Sistema operativo | Windows                                         |
| Distribuzione     | Software gratuito                               |
| Codice sorgente   | Disponibile secondo la documentazione ufficiale |

### Versioni testate

La documentazione ufficiale riporta test su:

* AutoCAD 2007, versione inglese, 32/64 bit ad 
* Autocad 2021, versione italiana/inglese, 64 bit.
* Autocad 2024, versione italiana/inglese, 64 bit.
* Autocad 2026, versione italiana/inglese, 64 bit.

Sistema operativo supportato:
* Windows XP.
* Windows Vista.
* Windows 7.
* Windows 8.
* Windows 10.
* Windows 11.

La compatibilità con altre versioni di AutoCAD e Windows deve essere verificata in base all'ambiente di installazione.

---

## EasyCut Nesting

Il modulo EasyCut Nesting è dedicato all'ottimizzazione del taglio delle lamiere.

### Processo di lavoro

1. Preparazione delle sagome da tagliare.
2. Importazione o riconoscimento dei contorni.
3. Definizione delle caratteristiche delle parti.
4. Inserimento delle sagome nella lamiera.
5. Ottimizzazione della disposizione.
6. Verifica del risultato.
7. Preparazione dei dati per la produzione.

### Gestione delle sagome

Le sagome possono essere gestite attraverso gli strumenti di AutoCAD e le funzionalità dedicate di EasyCut.

Il programma permette di lavorare sui contorni e di modificarne le caratteristiche durante il processo di nesting.

---

## EasyCut NestingBars

EasyCut comprende anche il modulo **NestingBars**, dedicato all'ottimizzazione del taglio delle barre.

Questa estensione consente la creazione e la gestione automatica dell'ottimizzazione di barre, ampliando l'utilizzo del programma oltre il solo taglio delle lamiere.

### Caratteristiche

* Gestione dei dati delle parti.
* Importazione dei dati da file XLS, XLSX e CSV.
* Caricamento di dati di esempio.
* Ottimizzazione delle barre.
* Gestione delle lavorazioni.

---

## Funzionalità

### Gestione delle lamiere

* Definizione della lamiera di lavoro.
* Inserimento e gestione delle sagome.
* Ottimizzazione del materiale.
* Gestione degli attributi dei contorni.

### Modifica delle sagome

* Inserimento manuale di un contorno nella lamiera.
* Spostamento dei contorni.
* Rotazione.
* Specchiatura.
* Copia.
* Gestione di serie di contorni.
* Definizione di deformazioni del contorno.

### Importazione DXF

Il programma dispone di un modulo per l'importazione di file DXF, utile per acquisire le sagome da utilizzare nel nesting.

### Programmazione macchina

EasyCut supporta la creazione di PartProgram per lamiere e contorni in formato ISO / ESSI.

La documentazione ufficiale cita il supporto per postprocessori ESAB, FRO, KOIKE e SOITAAB.

---

## Installazione

### Requisiti

Prima dell'installazione verificare:

* Sistema operativo Windows.
* Presenza di una versione compatibile di AutoCAD.
* Permessi necessari per l'installazione.
* Spazio disponibile sul disco.

### Procedura

1. Visitare il sito ufficiale di EasyCut.
2. Scaricare il programma.
3. Eseguire l'installazione.
4. Avviare AutoCAD.
5. Caricare il programma secondo le istruzioni fornite.
6. Verificare il corretto funzionamento del modulo di nesting.

Per le istruzioni aggiornate fare riferimento alla documentazione ufficiale.

---

## Utilizzo

EasyCut è pensato per essere utilizzato da operatori e tecnici che lavorano con disegni CAD e processi di taglio industriale.

### Flusso operativo consigliato

```text
Disegno CAD
    |
    v
Importazione delle sagome
    |
    v
Riconoscimento dei contorni
    |
    v
Definizione delle caratteristiche
    |
    v
Nesting della lamiera
    |
    v
Ottimizzazione del materiale
    |
    v
Verifica del risultato
    |
    v
Preparazione del programma macchina
```

---

## Sviluppo

EasyCut è un progetto software sviluppato in AutoLISP, con l'obiettivo di fornire strumenti dedicati al settore del nesting e del taglio industriale.

Il progetto comprende funzionalità di gestione CAD, ottimizzazione, importazione dei dati e preparazione alla produzione.

Per informazioni sullo sviluppo, sulle versioni disponibili e sulle modifiche introdotte, consultare il changelog ufficiale.

---

## Licenza

EasyCut è distribuito gratuitamente.

Per informazioni dettagliate sulla licenza, sull'utilizzo del codice sorgente e sulle condizioni di distribuzione, consultare la documentazione ufficiale del progetto.

---

## Contatti

**EasyCut Nesting**

Sito web: https://www.easycutnesting.it/

Email: [info@easycutnesting.it](mailto:info@easycutnesting.it)

---

## Documentazione

* Sito ufficiale: https://www.easycutnesting.it/
* Presentazione EasyCut Nesting: https://www.easycutnesting.it/wp-content/uploads/2020/06/EasyCutNesting-200609.pdf
* Presentazione EasyCut NestingBars: https://www.easycutnesting.it/guida/Presentazione%20NestingBar.pdf

---

*EasyCut Nesting — Ottimizzazione del taglio, semplicità e integrazione con AutoCAD.*
