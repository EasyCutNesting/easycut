'' --- Configurazione Percorsi ---
Dim percorsoExcel, percorsoTesto
percorsoExcel = "C:\EasyCutNesting Beta\Test\Xls\TuoFile.xlsx"
percorsoTesto = "C:\EasyCutNesting Beta\Test\Xls\ReadExcel.txt"
'
' --- Apertura Excel ---
Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(percorsoExcel)
Set objSheet = objWorkbook.Sheets(1)
'
' --- Creazione File di Testo ---
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile(percorsoTesto, True)
'
' 1. Identifica l'area utilizzata
Set objRange = objSheet.UsedRange
maxRighe = objRange.Rows.Count
maxColonne = objRange.Columns.Count

' 2. Carica tutti i dati in un array con un unico comando
' Questo è il modo più veloce in VBScript
arrDati = objRange.Value

' 3. Cicla l'array per leggere i valori
' Gli array da Excel partono sempre da indice 1
For r = 1 To maxRighe
    'rigaTesto = "Riga " & r & ": "
    rigaTesto = ""
    For c = 1 To maxColonne
        ' Legge il valore dall'array (molto più rapido che da objSheet.Cells)
        rigaTesto = rigaTesto & arrDati(r, c) & ";"
    Next
    ' Qui puoi elaborare la riga o scriverla su file
	objFile.WriteLine(rigaTesto)
    'WScript.Echo rigaTesto 
Next
'
' --- Chiusura e Pulizia ---
objFile.Close
objWorkbook.Close False
objExcel.Quit
'
Set objFile = Nothing
Set objFSO = Nothing
Set objSheet = Nothing
Set objWorkbook = Nothing
Set objExcel = Nothing
'
'MsgBox "Esportazione completata in: " & percorsoTesto
