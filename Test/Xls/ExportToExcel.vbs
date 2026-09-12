Function IsFileOpen(strPath)
    Dim fso, fileObj
    On Error Resume Next ' Ignora l'errore se il file è bloccato
    
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Tentativo di aprire il file in modalità Append (8)
    ' Se è aperto da Excel, questa operazione fallirà
    Set fileObj = fso.OpenTextFile(strPath, 8, False)
    
    If Err.Number <> 0 Then
        IsFileOpen = True ' Errore presente: il file è occupato
    Else
        IsFileOpen = False ' Nessun errore: il file è libero
        fileObj.Close ' Ricordati di chiuderlo subito!
    End If
    
    Set fso = Nothing
    On Error GoTo 0 ' Ripristina la gestione errori normale
End Function


' 1. Definiamo i dati in un Array (Esempio: Nome, Cognome, Età)
' Usiamo un array multidimensionale (3 righe x 3 colonne)
' Crea l'oggetto per la gestione dei file

Dim objExcel, objWorkbook, objWorksheet
Dim dati(2, 2)
Dim riga, colonna
Dim larghezze
Dim i
Dim FileXls

FileXls = "C:\EasyCutNesting Beta\Test\Xls\ExportArray.xlsx"

	If IsFileOpen(FileXls) Then
		MsgBox "Attenzione: Chiudi il file Excel prima di continuare!", 48
	Else


	dati(0, 0) = "Nome"
	dati(0, 1) = "Città"
	dati(0, 2) = "Punteggio"

	dati(1, 0) = "Mario"
	dati(1, 1) = "Roma"
	dati(1, 2) = 8.5

	dati(2, 0) = "Luigi"
	dati(2, 1) = "Milano"
	dati(2, 2) = "'092"

	larghezze = Array(10, 30, 15)

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set objExcel = CreateObject("Excel.Application")

	' Avvio Excel
	objExcel.Visible = False ' Imposta a False se vuoi che avvenga in background

	' Creo	un nuovo file
	Set objWorkbook = objExcel.Workbooks.Add()
	Set objWorksheet = objWorkbook.Worksheets(1)

	' Riduce la barra multifunzione (Ribbon)
	objExcel.ExecuteExcel4Macro "SHOW.TOOLBAR(""Ribbon"",False)"

	' Nasconde la barra delle formule
	objExcel.DisplayFormulaBar = False

	' Nasconde la barra di stato (in basso)
	objExcel.DisplayStatusBar = False

	' Nasconde le intestazioni di riga e colonna (A, B, C... 1, 2, 3)
	'objExcel.ActiveWindow.DisplayHeadings = False

	' Nasconde la griglia delle celle	
	'objExcel.ActiveWindow.DisplayGridlines = False

	' Nasconde le schede dei fogli in basso
	objExcel.ActiveWindow.DisplayWorkbookTabs = False

	' Formattazione rapida (opzionale)
	' objWorksheet.Columns("A:C").AutoFit

	' Set larghezza e allineamento colonna
	For i = 0 To UBound(larghezze)
		' le colonne di Excel partono da 1, l'array da 0
		objWorksheet.Columns(i + 1).ColumnWidth = larghezze(i)
		objWorksheet.Columns(i + 1).HorizontalAlignment = -4108
	Next

	' Set titoli colore interno e bordo cella
	For i = 1 To 3
		objWorksheet.Cells(1, i).Interior.ColorIndex = 15
		objWorksheet.Cells(1, i).Borders.LineStyle = 1
	Next

	objWorksheet.Rows(1).Font.Bold = True

	' Ciclo per esportare l'Array nelle celle
	' Le celle di Excel partono da 1, gli Array da 0
	For riga = 0 To 2
		For colonna = 0 To 2
			' Cells(riga, colonna) -> aggiungiamo 1 perché Excel non ha riga 0
			objWorksheet.Cells(riga + 1, colonna + 1).Value = dati(riga, colonna)
		Next
	Next


	If fso.FileExists(FileXls) Then
		fso.DeleteFile FileXls, True
	End If

	'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	objExcel.Visible = True ' Imposta a False se vuoi che avvenga in background

	' Crea l'oggetto Shell per gestire le finestre di Windows
	Set WshShell = CreateObject("WScript.Shell")
	
	' Porta Excel in primo piano
	' AppActivate cerca il titolo della finestra (che di solito contiene "Excel")
	WshShell.AppActivate objExcel.Caption

	' Opzionale: un piccolo trucco per forzare il focus se AppActivate fallisce
	' Invia una combinazione di tasti nulla (Alt) per risvegliare la finestra
	WshShell.SendKeys "%"

	' Salva (il numero 51 indica il formato standard .xlsx)
	objWorkbook.SaveAs FileXls, 51 

	' Messaggio di conferma
	' MsgBox "Esportazione completata!", 64, "VBScript to Excel"
	'++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	' Rilascio degli oggetti (come discusso prima)
	Set WshShell     = Nothing
	Set objWorksheet = Nothing
	Set objWorkbook  = Nothing
	Set objExcel     = Nothing
	Set fso          = Nothing

    'MsgBox "Il file è libero. Posso procedere al salvataggio.", 64
End If

