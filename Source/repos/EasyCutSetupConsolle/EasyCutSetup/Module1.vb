Imports System
Imports Microsoft.Win32
Imports System.Environment
Imports System.IO
Imports System.Collections


Module Module1

    Function FileExists(FilePath As String) As Boolean

        Dim TestStr As String
        Dim bRet As Boolean = False

        TestStr = Dir(FilePath)
        If TestStr <> "" Then
            bRet = True
        End If
        Return bRet
    End Function

    Sub Main()
        '
        ' defaut data
        '

        'My.Computer.FileSystem.CopyFile("C:\Program Files\Application Verifier\vrfauto - Copia.idl", "C:\Program Files\Application VerifiervrfautoCopia.idl", True)

        'If FileExists("c:\Users\Utente\Documents\Scan.pdf") Then
        '    MsgBox("file Exist")
        'Else
        'MsgBox("file not exist")
        'End If
        Dim namefile As String = "C:\Program Files\Application Verifier\vrfauto - Copia.idl"
        Dim af As StreamWriter = Nothing
        GetFileInfo(namefile)

        Try
            'af = New StreamWriter(namefile, True)
            My.Computer.FileSystem.CopyFile("C:\Program Files\Application Verifier\vrfauto - Copia.idl", "C:\Program Files\Application VerifiervrfautoCopia.idl", True)
        Catch e As UnauthorizedAccessException
            Dim attr As FileAttributes = (New FileInfo(namefile)).Attributes
            MsgBox("Utente non autorizzato alla scrittura del file " & namefile)
            If (attr And FileAttributes.ReadOnly) > 0 Then
                MsgBox("Il file " & namefile & " è read-only")
            End If
            'Finally
            '    If af IsNot Nothing Then af.Close()
        End Try
    End Sub
    Sub GetFileInfo(sFile As String)
        Dim sFileAttrib As Long
        Dim sFileInfo As String
        sFileAttrib = GetAttr(sFile)
        ' Get Attibutes and fill attribute string
        If (sFileAttrib And vbReadOnly) = vbReadOnly Then
            sFileInfo = sFileInfo & "Read Only"
        End If
        If (sFileAttrib And vbArchive) = vbArchive Then
            sFileInfo = sFileInfo & " Archive"
        End If
        If (sFileAttrib And vbNormal) = vbNormal Then
            sFileInfo = sFileInfo & " Normal"
        End If
        If (sFileAttrib And vbSystem) = vbSystem Then
            sFileInfo = sFileInfo & " System"
        End If
        If (sFileAttrib And vbHidden) = vbHidden Then
            sFileInfo = sFileInfo & " Hidden"
        End If
        If (sFileAttrib And vbDirectory) = vbDirectory Then
            sFileInfo = sFileInfo & " Directory"
        End If
        MsgBox(sFile & " has the following properties: " & sFileInfo)
    End Sub
End Module

