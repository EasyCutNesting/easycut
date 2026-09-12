Imports System
Imports Microsoft.Win32
Imports System.Environment
Imports System.IO
Imports System.Collections



Public Class Form1
    Dim VersionAcad As String
    Dim SubVersionAcad As String
    Dim ProfileAcad As String
    Dim AcadPath As String
    Dim AcadDrv As String
    Dim Chk1 As Boolean = False 'Autocad not installed
    Dim Chk2 As Boolean = False 'Autocad installede with problems
    Dim Chk3 As Boolean = False 'AcadDoc Exist with restiction
    Dim Chk4 As Boolean = False 'AcadDoc CREATED
    Dim Chk5 As Boolean = False 'AcadDoc NOT CREATED
    Dim ChK6 As Boolean = False 'AcadDoc modified


    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

        'RichTextBox2.TabStop = False
        RichTextBox2.Font = New Font("Tahoma", 9)

        'TextBox2.TabStop = False

        'RichTextBox1.TabStop = False
        RichTextBox1.Font = New Font("Tahoma", 9)

        Setup()
    End Sub
    Private Sub Setup()
        '
        ' defaut data
        '
        Dim CurrentUser As String = "HKEY_CURRENT_USER\"
        Dim FolderApp As String = "EasyCut"
        Dim StartupFileEasyCut As String = "StartEasyCut.lsp"
        Dim EasyCutRegistry As String = "Software\EasyCut"
        Dim AutoCadRegistry As String = "Software\Autodesk\AutoCAD"
        Dim ReleaseFileName As String = My.Application.Info.DirectoryPath & "\Dbase\Release.lsp"

        Dim EasyCutPathInstaller As String = My.Application.Info.DirectoryPath
        Dim AutoCadKey As RegistryKey = Registry.CurrentUser.OpenSubKey(AutoCadRegistry, False)
        Dim VersionEasyCut As String = ReadRelease(ReleaseFileName)
        Dim StartupEasyCut As String = EasyCutPathInstaller & "\" & StartupFileEasyCut
        Dim Rtn As Boolean = False


        If AutoCadKey Is Nothing Then
            Chk1 = True
        Else

            ' Set default registry Easy Cut +++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            My.Computer.Registry.CurrentUser.CreateSubKey(EasyCutRegistry)
            My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "PathInstaller", EasyCutPathInstaller)
            My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "FirstInstaller", "1")
            My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "Version", ReadRelease(ReleaseFileName))

            ' Read Registry Autocad +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            VersionAcad = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry, "CurVer", Nothing)
            SubVersionAcad = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & VersionAcad, "CurVer", Nothing)
            ProfileAcad = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & VersionAcad & "\" _
                                                                    & SubVersionAcad & "\Profiles", "", Nothing)
            AcadPath = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & VersionAcad & "\" _
                                                                 & SubVersionAcad & "\Profiles" & "\" _
                                                                 & ProfileAcad & "\General", "ACAD", Nothing)
            AcadDrv = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & VersionAcad & "\" _
                                                                & SubVersionAcad & "\Profiles" & "\" _
                                                                & ProfileAcad & "\General", "ACADDRV", Nothing)

            If (VersionAcad IsNot Nothing And SubVersionAcad IsNot Nothing And ProfileAcad IsNot Nothing And
                AcadPath IsNot Nothing And AcadDrv IsNot Nothing) Then

                Dim TotPath As String = AcadPath & ";" & AcadDrv '& "; C: \Program Files\Application Verifier"
                'Dim TotPath As String = "C:\Program Files\Application Verifier"
                Dim Words As String() = TotPath.Split(New Char() {";"c})
                Dim Path As String
                Dim PathAcadDoc As String = ""
                Dim Trovato As Boolean = False
                Dim Conta As Integer = 1

                RichTextBox2.Text &= "Run application    " & EasyCutPathInstaller
                RichTextBox2.Text &= vbCrLf & "Autocad Version    " & VersionAcad
                RichTextBox2.Text &= vbCrLf & "Autocad SubVersion " & SubVersionAcad
                RichTextBox2.Text &= vbCrLf & "Profile            " & ProfileAcad
                RichTextBox2.Text &= vbCrLf & "Search AcadDoc.lsp in ......"

                For Each Path In Words
                    Path = Path.TrimStart(" ")
                    Path = Path.TrimEnd(" ")
                    If Path <> "" Then
                        If FileExists(Path & "\" & "AcadDoc.lsp") Then

                            If SaveFile(Path, "AcadDoc.lsp") Then
                                ClearLoadAppAutocad(Path & "\" & "AcadDoc.lsp")
                                LoadAppAutocad(Path & "\AcadDoc.lsp", EasyCutPathInstaller & "\Load\" & StartupFileEasyCut, EasyCutPathInstaller, VersionEasyCut)
                                RichTextBox2.Text &= vbCrLf & "[FIND        AcadDoc.lsp] --> " & Path '& "   -->   [EasyCut Write]"
                                Trovato = True
                                ChK6 = True
                            Else
                                RichTextBox2.Text &= vbCrLf & "[FIND NO ADMIN AcadDoc.lsp] --> " & Path '& "   -->   [EasyCut Write]"
                                Trovato = True
                                Chk3 = True
                            End If
                        Else
                            RichTextBox2.Text &= vbCrLf & "[NOTHING AcadDoc.lsp] --> " & Path
                        End If

                        If Conta = 1 Then
                            PathAcadDoc = Path
                        End If
                        Conta = Conta + 1
                    End If
                Next

                If Not Trovato Then

                    Rtn = LoadAppAutocad(PathAcadDoc & "\AcadDoc.lsp", EasyCutPathInstaller & "\Load\" & StartupFileEasyCut, EasyCutPathInstaller, VersionEasyCut)

                    If Rtn Then
                        RichTextBox2.Text &= vbCrLf & "[   AcadDoc.lsp CREATED    ] --> " & PathAcadDoc
                        Chk4 = True
                    Else
                        RichTextBox2.Text &= vbCrLf & "[ AcadDoc.lsp NOT CREATED ] --> " & PathAcadDoc
                        Chk5 = True
                    End If

                End If
            Else
                Chk2 = True
            End If
        End If

        ResultInstallation(ReadRelease(ReleaseFileName))
    End Sub

    Function ReadRelease(FileRelease As String) As String

        Dim fileReader As String
        If FileExists(FileRelease) Then
            fileReader = My.Computer.FileSystem.ReadAllText(FileRelease)
        Else
            fileReader = "Nothing"
        End If
        Return fileReader
    End Function

    Function FileExists(FilePath As String) As Boolean

        Dim TestStr As String
        Dim bRet As Boolean = False

        TestStr = Dir(FilePath)
        If TestStr <> "" Then
            bRet = True
        End If
        Return bRet
    End Function

    Private Sub ResultInstallation(Version As String)

        TextBox2.Font = New Font(TextBox2.Font.FontFamily, 9, FontStyle.Bold)

        If Chk1 Then
            TextBox2.ForeColor = Color.Red
            TextBox2.Text = "Autocad non installato [ il programma non funzionera' ]"
        ElseIf Chk2 Then
            TextBox2.ForeColor = Color.Red
            TextBox2.Text = "Errore configurazione AcadDoc.lsp"
        ElseIf Chk3 Then
            TextBox2.ForeColor = Color.Red
            TextBox2.Text = "Utente non autorizzato alla modifica del file AcadDoc.lsp"
        ElseIf Chk4 Then
            TextBox2.ForeColor = Color.DarkGreen
            TextBox2.Text = "AcadDoc.lsp creato | EasyCut " & Version & " installato e configurato correttamente"
        ElseIf Chk5 Then
            TextBox2.ForeColor = Color.DarkGreen
            TextBox2.Text = "Utente non autorizzato alla creazione del file AcadDoc.lsp"
        ElseIf ChK6 Then
            TextBox2.ForeColor = Color.Green
            TextBox2.Text = "AcadDoc.lsp modificato | EasyCut " & Version & " installato e configurato correttamente"
        End If
        ResolutionProblem()
    End Sub

    Sub ResolutionProblem()

        RichTextBox1.DetectUrls = True

        If Chk1 Then
            RichTextBox1.Text &= "Mi dispiace ma non hai Autocad installato" & vbCrLf
            RichTextBox1.Text &= "EasyCut funziona con tutte le release di Autocad" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Controlla le specifiche contenute in questo link " & vbCrLf
            RichTextBox1.Text &= "https://www.easycutnesting.it/guida/Requisitisistema.html" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "oppure, se hai una connessione internet attiva e un browser, attendi un istante ...."
            NavigateWebURL("https://www.easycutnesting.it/guida/Requisitisistema.html")

        ElseIf Chk2 Then
            RichTextBox1.Text &= "Sembra esserci qualche problema con l'installazione di Autocad." & vbCrLf
            RichTextBox1.Text &= "Se hai dimestichezza controlla i registri." & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Ho riscontrato i seguenti valori:" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Versione Autocad =" & VersionAcad & vbCrLf
            RichTextBox1.Text &= "Release Autocad  =" & SubVersionAcad & vbCrLf
            RichTextBox1.Text &= "Profilo utente   =" & ProfileAcad & vbCrLf
            RichTextBox1.Text &= "Percorsi Autocad =" & AcadPath & vbCrLf
            RichTextBox1.Text &= "Percorsi Driver  =" & AcadDrv

        ElseIf Chk3 Then
            RichTextBox1.Text &= "E' probabile che il tuo account è di tipo standard." & vbCrLf
            RichTextBox1.Text &= "Tuttavia ci sono alcune restrizioni che dovi affrontare quando si tratta " &
                                 "di apportare modifiche ai file di sistema o scaricare nuovi programmi o app." & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Per eseguire queste modifiche sono necessari i privilegi forniti con un account amministratore." & vbCrLf
            RichTextBox1.Text &= "Puoi caricare EasyCut manualmente seguendo la procedura descritta nel link:" & vbCrLf
            RichTextBox1.Text &= "https://www.easycutnesting.it/Video/ManualLoading.pdf" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "oppure, se hai una connessione internet attiva e un browser, attendi un istante ...." & vbCrLf
            NavigateWebURL("https://www.easycutnesting.it/Video/ManualLoading.pdf", "default")

        ElseIf Chk4 Then
            RichTextBox1.Text &= "Congratulazioni l'installazione è andata a buon fine." & vbCrLf
            RichTextBox1.Text &= "Ho creato il file di configurazione AcadDoc.lsp." & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Tuttavia possono esserci degli impedimenti per caricare in maniera " &
                                 "automatica EasyCut." & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Qualora, all'interno di Autocad, il comando LOADEC non funzioni, " &
                                 "puoi seguire la procedura descritta nel link:" & vbCrLf
            RichTextBox1.Text &= "https://www.easycutnesting.it/Video/ManualLoading.pdf" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "oppure, se hai una connessione internet attiva e un browser, attendi un istante ...."
            NavigateWebURL("https://www.easycutnesting.it/Video/ManualLoading.pdf", "default")

        ElseIf Chk5 Then
            RichTextBox1.Text &= "Congratulazioni l'installazione è andata a buon fine." & vbCrLf
            RichTextBox1.Text &= "E' probabile che il tuo account è di tipo standard." & vbCrLf
            RichTextBox1.Text &= "Non sono riuscito a creare il file di configurazione AcadDoc.lsp" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Puoi tuttavia eseguire il caricamento del programma manualmente " &
                                 "descritto nel link:" & vbCrLf
            RichTextBox1.Text &= "https://www.easycutnesting.it/Video/ManualLoading.pdf" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "oppure, se hai una connessione internet attiva e un browser, attendi un istante ...."
            NavigateWebURL("https://www.easycutnesting.it/Video/ManualLoading.pdf", "default")

        ElseIf ChK6 Then
            RichTextBox1.Text &= "Congratulazioni l'installazione è andata a buon fine." & vbCrLf
            RichTextBox1.Text &= "Ho modificato il file di configurazione AcadDoc.lsp" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Tuttavia possono esserci degli impedimenti per caricare in maniera " &
                                 "automatica EasyCut." & vbCrLf & vbCrLf
            RichTextBox1.Text &= "Qualora, all'interno di Autocad, il comando LOADEC non funzioni, " &
                                 "puoi seguire la procedura descritta nel link" & vbCrLf
            RichTextBox1.Text &= "https://www.easycutnesting.it/Video/ManualLoading.pdf" & vbCrLf & vbCrLf
            RichTextBox1.Text &= "oppure, se hai una connessione internet attiva e un browser, attendi un istante ...."
            NavigateWebURL("https://www.easycutnesting.it/Video/ManualLoading.pdf", "default")
        End If
    End Sub

    Private Sub RichTextBox1_LinkClicked(ByVal sender As Object, ByVal e As System.Windows.Forms.LinkClickedEventArgs) _
                                        Handles RichTextBox1.LinkClicked
        ' Call Process.Start method to open a browser
        ' with link text as URL.
        System.Diagnostics.Process.Start(e.LinkText)
    End Sub

    Function SaveFile(PathFile As String, FileName As String) As Boolean

        Dim bRet As Boolean = False
        Try
            My.Computer.FileSystem.CopyFile(PathFile & "\" & FileName,
                                            PathFile & "\" & System.DateTime.Now.ToString("yyyyMMdd_HHmmss") & "_" & FileName, True)
            bRet = True
        Catch e As UnauthorizedAccessException
            bRet = False
        End Try
        Return bRet
    End Function

    Function LoadAppAutocad(FileAcadDoc As String, FileStartUp As String, TrustedPath As String, Version As String) As Boolean

        ' https://docs.microsoft.com/it-it/dotnet/api/system.unauthorizedaccessexception?view=net-5.0
        ' Dim af As New StreamWriter(FileAcadDoc, True)

        Dim bRet As Boolean = False
        Dim af As StreamWriter = Nothing

        Try
            af = New StreamWriter(FileAcadDoc, True)

            af.WriteLine("; Start Load Application                                                     ; EasyCut")
            af.WriteLine("; Build " & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss") & "                                                  ; EasyCut")
            af.WriteLine("; Version " & Version & "                                                 ; EasyCut")
            af.WriteLine("(defun Search&AddTrsPth (AddPath / TrsPth)                                           ; EasyCut")
            af.WriteLine("    (if AddPath                                                                      ; EasyCut")
            af.WriteLine("        (if (findfile AddPath)                                                       ; EasyCut")
            af.WriteLine("            (progn                                                                   ; EasyCut")
            af.WriteLine("                (if (setq TrsPth (getvar 'trustedpaths))                             ; EasyCut")
            af.WriteLine("                    (if (not (vl-string-search (strcase AddPath) (strcase TrsPth)))  ; EasyCut")
            af.WriteLine("                        (progn                                                       ; EasyCut")
            af.WriteLine("                            (setq TrsPth (vl-string-left-trim " & Chr(34) & " " & Chr(34) & " TrsPth))           ; EasyCut")
            af.WriteLine("                            (setq TrsPth (vl-string-right-trim  " & Chr(34) & " " & Chr(34) & " TrsPth))         ; EasyCut")
            af.WriteLine("                            (cond                                                    ; EasyCut")
            af.WriteLine("                                ((or (= TrsPth " & Chr(34) & "." & Chr(34) & ") (= TrsPth " & Chr(34) & Chr(34) & "))                   ; EasyCut")
            af.WriteLine("                                  (setq TrsPth AddPath)                              ; EasyCut")
            af.WriteLine("                                )                                                    ; EasyCut")
            af.WriteLine("                                (t                                                   ; EasyCut")
            af.WriteLine("                                  (setq TrsPth (strcat TrsPth " & Chr(34) & ";" & Chr(34) & " AddPath))          ; EasyCut")
            af.WriteLine("                                )                                                    ; EasyCut")
            af.WriteLine("                            )                                                        ; EasyCut")
            af.WriteLine("                            (setvar 'trustedpaths TrsPth)                            ; EasyCut")
            af.WriteLine("                        )                                                            ; EasyCut")
            af.WriteLine("                    )                                                                ; EasyCut")
            af.WriteLine("                )                                                                    ; EasyCut")
            af.WriteLine("            )                                                                        ; EasyCut")
            af.WriteLine("        )                                                                            ; EasyCut")
            af.WriteLine("    )                                                                                ; EasyCut")
            af.WriteLine(")                                                                                    ; EasyCut")
            af.WriteLine("(Search&AddTrsPth " & Chr(34) & TrustedPath.Replace("\", "\\") & "\\..." & Chr(34) & ")  ; EasyCut")
            af.WriteLine("(load " & Chr(34) & FileStartUp.Replace("\", "\\") & Chr(34) & " " & Chr(34) & Chr(34) & ") ; EasyCut")
            af.WriteLine("; End Load Application                                                               ; EasyCut")
            bRet = True
        Catch e As UnauthorizedAccessException
            bRet = False
        Finally
            If af IsNot Nothing Then af.Close()
        End Try
        Return bRet
    End Function

    Private Sub ClearLoadAppAutocad(FileUpLoad As String)

        Dim CheckString As String = "EasyCut"
        Dim NewLine(1000) As String
        Dim Conta As Integer = 0

        If System.IO.File.Exists(FileUpLoad) Then
            Dim lines() As String = IO.File.ReadAllLines(FileUpLoad)
            For i As Integer = 0 To lines.Length - 1

                If Not lines(i).Contains(CheckString) Then
                    NewLine(Conta) = lines(i)
                    Conta = Conta + 1

                End If

            Next
            Dim NNewLine(Conta - 1) As String
            For i As Integer = 0 To Conta - 1
                NNewLine(i) = NewLine(i)
            Next
            IO.File.WriteAllLines(FileUpLoad, NNewLine)
        End If
    End Sub

    Private Sub NavigateWebURL(ByVal URL As String, Optional browser As String = "default")

        If Not (browser = "default") Then
            Try
                '// try set browser if there was an error (browser not installed)
                Process.Start(browser, URL)
            Catch ex As Exception
                '// use default browser
                Process.Start(URL)
            End Try

        Else
            '// use default browser
            Process.Start(URL)

        End If

    End Sub

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        'Dim frm As New Form1
        'frm.Show()
        Me.Close()
    End Sub

End Class