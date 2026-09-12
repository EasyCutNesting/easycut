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

    Private Sub ErrorCode(ErrorNumber As Integer)

        Select Case ErrorNumber
            Case 1
                MsgBox("Autocad non installato [ il programma non funzionera' ]")
            Case 2
                MsgBox("Chiudere Autocad ed eseguire nuovamente l'installazione")
            Case 3
                MsgBox("Errore configurazione Suite Autocad non eseguita")
            Case 4
                MsgBox("complimenti EasyCut installato e configurato")
        End Select

    End Sub

    Function LoadAppAutocad(FileUpLoad As String, StringWrite As String, Append As Boolean) as Integer

        Dim sLine As String = ""
        Dim ControlStartStr As String = "; Start EasyCut Load Application "
        Dim ControlEndStr As String = "; End EasyCut Load Application "
        Dim Find As Boolean
        Dim NewStringWrite as String = StringWrite.Replace("\", "\\")
        Dim Rtn as Integer = -1

        If Append Then
            Dim rf As New StreamReader(FileUpLoad)
            Do
                sLine = rf.ReadLine()
                If Not sLine Is Nothing Then

                    sLine=sLine.Replace(" ", "")
                    NewStringWrite=NewStringWrite.Replace(" ", "")
                    sLine=UCase(sLine.replace(Chr(34),"*"))
                    NewStringWrite=UCase(NewStringWrite.replace(Chr(34),"*"))
                    
                    Dim foo() As Byte = System.Text.Encoding.ASCII.GetBytes(sLine)
                    Dim bar() As Byte = System.Text.Encoding.ASCII.GetBytes(NewStringWrite)

                    If foo.SequenceEqual(bar) Then
                        Find = True
                        Rtn = 1
                    End If

                End If
            Loop Until sLine Is Nothing
            rf.Close()

            If Not Find Then
                Dim af As New StreamWriter(FileUpLoad, True)
                af.WriteLine(ControlStartStr & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"))
                af.WriteLine(StringWrite.Replace("\", "\\"))
                af.WriteLine(ControlEndStr & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"))
                af.Close()
                Rtn = 2
            End If
        Else
            Dim af As New StreamWriter(FileUpLoad, True)
            af.WriteLine(ControlStartStr & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"))
            af.WriteLine(StringWrite.Replace("\", "\\"))
            af.WriteLine(ControlEndStr & System.DateTime.Now.ToString("yyyy/MM/dd HH:mm:ss"))
            af.Close()
            Rtn= 3
        End If
        Return Rtn
    End Function

    Sub Main()
        '
        ' defaut data
        '
        Dim CurrentUser As String = "HKEY_CURRENT_USER\"
        Dim FolderApp as String = "EasyCut"
        Dim StartupFileEasyCut As String = "StartEasyCut.lsp"
        Dim EasyCutRegistry As String = "Software\EasyCut"
        Dim FolderExample As String ="Example"
        Dim EasyCutFileCfg As String = "setup.cfg"
        Dim EasyCutArrayColumn As String = "1"
        Dim EasyCutArrayRow As String = "2"
        Dim EasyCutSymula As String = "0"
        Dim EasyCutSymulaChoiseShape As String = "10"
        Dim EasyCutDisplayVersion As String = "1.0"
        Dim AutoCadRegistry As String = "Software\Autodesk\AutoCAD"

        Dim EasyCutPathInstaller As String = My.Application.Info.DirectoryPath
        Dim EasyCutPathInfo As String = My.Application.Info.DirectoryPath
        Dim EasyCutPathNc As String = My.Application.Info.DirectoryPath & "\" & FolderExample
        Dim EasyCutPathCfg As String = Environment.GetEnvironmentVariable("LOCALAPPDATA") & "\" & FolderApp
        Dim AutoCadKey As RegistryKey = Registry.CurrentUser.OpenSubKey(AutoCadRegistry, False)

        Dim Version As String
        Dim SubVersion As String
        Dim Profile As String

        Dim StartupEasyCut As String = EasyCutPathInstaller & "\" & StartupFileEasyCut
        Dim ErrorNumber As Integer = 0

        Dim AcadPath As String
        Dim AcadDrv As String

        Dim Rtn as Integer
        
        If AutoCadKey Is Nothing Then
            ErrorNumber = 1
        Else

           ' Set default registry Easy Cut +++++++++++++++++++++++++++++++++++++++++++++++++++++++++

            My.Computer.Registry.CurrentUser.CreateSubKey(EasyCutRegistry)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "Version", EasyCutDisplayVersion)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "PathInstaller", EasyCutPathInstaller)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "PathNc", EasyCutPathNc)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "PathInfo", EasyCutPathInfo)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "ArrayColumn", EasyCutArrayColumn)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "ArrayRow", EasyCutArrayRow)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "Symula", EasyCutSymula)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "SymulaChoiseShape", EasyCutSymulaChoiseShape)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "EasyCutPathCfg", EasyCutPathCfg)
                My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "EasyCutFileCfg", EasyCutFileCfg)

                ' Read Registry Autocad +++++++++++++++++++++++++++++++++++++++++++++++++++++++

                Version = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry, "CurVer", Nothing)
                SubVersion = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & Version, "CurVer", Nothing)
                Profile = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & Version & "\" & SubVersion & "\Profiles", "", Nothing)
                AcadPath = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & Version & "\" _
                                                                     & SubVersion & "\Profiles" & "\" _
                                                                     & Profile & "\General", "ACAD", Nothing)
                AcadDrv = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry & "\" & Version & "\" _
                                                                    & SubVersion & "\Profiles" & "\" _
                                                                    & Profile & "\General", "ACADDRV", Nothing)

                If (Version IsNot Nothing And SubVersion IsNot Nothing And Profile IsNot Nothing And
                    AcadPath IsNot Nothing And AcadDrv IsNot Nothing) Then
                    Dim TotPath As String = AcadPath & AcadDrv
                    Dim Words As String() = TotPath.Split(New Char() {";"c})
                    Dim Path As String 
                    Dim PathAcadDoc As String = ""
                    Dim Trovato As Boolean = False
                    Dim Conta As Integer = 1

                    Console.WriteLine("Autocad Version    " & Version)
                    Console.WriteLine("Autocad SubVersion " & SubVersion)
                    Console.WriteLine("Profile            " & Profile)

                    Console.WriteLine("Search AcadDoc.lsp in ... ")

                    For Each Path In Words
                        If Path <> "" Then
                            If FileExists(Path & "\" & "AcadDoc.lsp") Then
                                Trovato = True
                                Rtn = LoadAppAutocad(Path & "\" & "AcadDoc.lsp", "(load " & Chr(34) & StartupEasyCut & Chr(34) & ")", True)

                                Select Case Rtn
                                    Case 1
                                        Console.WriteLine("[FIND    AcadDoc.lsp] --> " & Path & " [EasyCut alredy Write]")
                                    Case 2
                                        Console.WriteLine("[FIND    AcadDoc.lsp] --> " & Path & " [Write Load EasyCut]")
                                End Select
                            Else
                                Console.WriteLine("[NOTHING AcadDoc.lsp] --> " & Path)
                            End If

                            If Conta = 1 Then
                                PathAcadDoc = Path
                            End If
                            Conta = Conta + 1
                        End If
                    Next

                    If Not Trovato Then
                        Rtn = LoadAppAutocad(PathAcadDoc & "\" & "AcadDoc.lsp", "(load " & Chr(34) & StartupEasyCut & Chr(34) & ")", False)
                        Console.WriteLine("[AcadDoc.lsp create ] --> " & PathAcadDoc)
                    End If

                    ErrorNumber = 4
                Else
                    ErrorNumber = 3
                End If
        End If

        If ErrorNumber > 0 Then
            ErrorCode(ErrorNumber)
        End If

    End Sub

End Module

