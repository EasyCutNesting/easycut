Set objExcel = CreateObject("Excel.Application")
Set objShell = CreateObject("WScript.Shell")

' Rende l'applicazione visibile
objExcel.Visible = True

' Aggiunge un nuovo documento (o usa .Open "C:\percorso\file.xlsx")
' objExcel.Workbooks.Add
Set objWorkbook = objExcel.Workbooks.Open("C:\EasyCutNesting Beta\Test\Xls\TuoFile.xlsx")

' Riduce l'interfaccia: Modalità Schermo Intero
' Nasconde Ribbon, Barra di stato e Barra della formula
objExcel.ExecuteExcel4Macro "SHOW.TOOLBAR(""Ribbon"",False)"
'objExcel.DisplayFullScreen = True
objExcel.WindowState = -4143

' Porta la finestra in primo piano (Focus)
' AppActivate utilizza il titolo della finestra
objShell.AppActivate objExcel.Caption

Set objExcel = Nothing
Set objShell = Nothing

