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

' --- ESEMPIO DI UTILIZZO ---
Dim FileXls
FileXls = "C:\EasyCutNesting Beta\Test\Xls\ExportArray.xlsx"

If IsFileOpen(FileXls) Then
    MsgBox "Attenzione: Chiudi il file Excel prima di continuare!", 48
	Else
    MsgBox "Il file è libero. Posso procedere al salvataggio.", 64
End If