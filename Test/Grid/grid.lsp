(defun c:TestGrid ()
  (setq cmdecho (getvar "CMDECHO"))
  (setvar "CMDECHO" 0)
  (command "_OPENDCL")
  (setvar "CMDECHO" cmdecho)

  ; Carica il file di progetto (assicurati che il nome coincida)
  (dcl-Project-Load "C:\\EasyCutNesting Beta\\Test\\Grid\\Grid.odcl" T)
  ;; Show the main form
  (dcl-Form-Show Grid/Dcl-1)


  ;(dcl-Project-Load "MioProgetto" T)
  ;(dcl-Form-Show MioProgetto/Form_Esempio)
  (princ)
)

(defun c:Project1_Dcl-1_TB-Close_OnClicked () 
	(alert "chiudi")
	(dcl-Form-Close Grid/Dcl-1)
)
; Evento che scatta all'apertura del Form
(defun c:Project1_Dcl-1_OnInitialize (/)
  ; Inizializziamo la griglia con una colonna base
	(dcl-Grid-AddColumns Grid/Dcl-1/Grid1 
							(list 
								(list "Nome" 0 150)       ; Sinistra, 150px
								(list "Quantità" 1 80)    ; Centro, 80px
								(list "Prezzo" 2 80)      ; Destra, 80px
							)
	)
 
	(dcl-Grid-AddRow Grid/Dcl-1/Grid1 "Riga 1")
	(dcl-Grid-AddRow Grid/Dcl-1/Grid1 "Riga 2")
)
; Evento collegato a un pulsante "Inserisci Colonna"
(defun c:Grid/Dcl-1/TB-AddCol#OnClicked (/)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:Grid/Dcl-1/TB-AddCol#OnClicked" "To do")
)
(defun c:Grid/Dcl-1/AddRow#OnClicked (/)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:Grid/Dcl-1/AddRow#OnClicked" "To do")
)
(defun c:Grid/Dcl-1#OnInitialize (/)
  (dcl-MessageBox "To Do: code must be added to event handler\r\nc:Grid/Dcl-1#OnInitialize" "To do")
)

