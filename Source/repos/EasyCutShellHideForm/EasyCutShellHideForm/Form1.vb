Imports Microsoft.Win32
Public Class Form1

    Dim FileApplication As String
    Private Sub Form1_Load(sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.Opacity = 0
        Me.Visible = False
        Me.Hide()

        Dim trd As Threading.Thread
        Dim args() As String = System.Environment.GetCommandLineArgs()


        Me.Text = String.Join(" ", args)
        FileApplication = args(1)
        'args(1) = "C:\Users\delucaa\AppData\Local\Temp\EasyCutQrcode.bat"

        trd = New Threading.Thread(AddressOf ShellHide)
        trd.IsBackground = True
        trd.Start()

    End Sub
    Public Sub ShellHide()

        Dim procID As Integer
        'Dim Application As String
        'Dim CurrentUser As String = "HKEY_CURRENT_USER\"
        ' Dim EasyCutRegistry As String = "Software\EasyCut\Imaging"
        ' Dim SubKey As String = "Key1"

        'Application = My.Computer.Registry.GetValue(CurrentUser & EasyCutRegistry, SubKey, Nothing)
        procID = Shell(FileApplication, vbHide)
        TerminateSelf()

    End Sub
    Private Sub TerminateSelf()
        Dim pid As Integer
        pid = System.Diagnostics.Process.GetCurrentProcess().Id
        System.Diagnostics.Process.GetProcessById(pid).Kill()
    End Sub
End Class
