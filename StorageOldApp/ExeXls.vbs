Set objExcel = CreateObject("Excel.Application")
objExcel.Visible = True
Set objWorkbook = objExcel.Workbooks.Open("C:\EasyCutNesting Beta\Test\Xls\TuoFile.xlsx")

' Riduce il menu (Ribbon)
objExcel.ExecuteExcel4Macro "SHOW.TOOLBAR(""Ribbon"",False)"

' Opzionale: Schermo intero (nasconde anche i titoli delle finestre)
objExcel.DisplayFullScreen = True 