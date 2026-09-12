Imports Microsoft.Win32
Public Class Form1

    Private Declare Function InternetGetConnectedState Lib "wininet" (ByRef flags As UInt32, ByVal reserved As UInt32) As Boolean

    'Local system uses a modem to connect to the Internet.
    Private Const INTERNET_CONNECTION_MODEM As Long = &H1
    'Local system uses a LAN to connect to the Internet.
    Private Const INTERNET_CONNECTION_LAN As Long = &H2
    'Local system uses a proxy server to connect to the Internet.
    Private Const INTERNET_CONNECTION_PROXY As Long = &H4
    'No longer used.
    Private Const INTERNET_CONNECTION_MODEM_BUSY As Long = &H8
    Private Const INTERNET_RAS_INSTALLED As Long = &H10
    Private Const INTERNET_CONNECTION_OFFLINE As Long = &H20
    Private Const INTERNET_CONNECTION_CONFIGURED As Long = &H40


    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        Dim trd As Threading.Thread
        Me.Opacity = 0
        Me.Visible = False
        Me.Hide()

        trd = New Threading.Thread(AddressOf CheckInternetStatus)
        trd.IsBackground = True
        trd.Start()
    End Sub
    Private Sub CheckInternetStatus()

        Dim CurrentUser As String = "HKEY_CURRENT_USER\"
        Dim EasyCutRegistry As String = "Software\EasyCut"
        Dim Rtn As String = ""
        Dim Status As String

        If IsNetConnectViaLAN() Then
            'Console.WriteLine("Lan    -> OK")
            Rtn = Rtn + "Lan OK|"
        Else
            'Console.WriteLine("Lan    -> NO")
            Rtn = Rtn + "Lan NO|"
        End If
        If IsNetConnectViaModem() Then
            'Console.WriteLine("Modem  -> OK")
            Rtn = Rtn + "Modem OK|"
        Else
            'Console.WriteLine("Modem  -> NO")
            Rtn = Rtn + "Modem NO|"
        End If
        If IsNetConnectViaProxy() Then
            'Console.WriteLine("Proxy  -> OK")
            Rtn = Rtn + "Proxy OK|"
        Else
            'Console.WriteLine("Proxy  -> NO")
            Rtn = Rtn + "Proxy NO|"
        End If
        If IsNetConnectOnline() Then
            'Console.WriteLine("OnLine -> OK")
            Rtn = Rtn + "OnLine OK|"
        Else
            'Console.WriteLine("OnLine -> NO")
            Rtn = Rtn + "OnLine NO|"
        End If
        If IsNetRASInstalled() Then
            'Console.WriteLine("RAS    -> OK Remote Access Services")
            Rtn = Rtn + "RAS OK|"
        Else
            'Console.WriteLine("RAS    -> NO Remote Access Services")
            Rtn = Rtn + "RAS NO|"
        End If
        Status = GetNetConnectString()
        Rtn = Rtn + Status
        My.Computer.Registry.SetValue(CurrentUser & EasyCutRegistry, "Internet", Rtn)
        TerminateSelf()
    End Sub

    Private Function IsNetConnectViaLAN() As Boolean

        Dim dwflags As Long

        'pass an empty variable into which the API will
        'return the flags associated with the connection
        Call InternetGetConnectedState(dwflags, 0&)

        'return True if the flags indicate a LAN connection
        IsNetConnectViaLAN = dwflags And INTERNET_CONNECTION_LAN

    End Function

    Private Function IsNetConnectViaModem() As Boolean

        Dim dwflags As Long

        'pass an empty variable into which the API will
        'return the flags associated with the connection
        Call InternetGetConnectedState(dwflags, 0&)

        'return True if the flags indicate a modem connection
        IsNetConnectViaModem = dwflags And INTERNET_CONNECTION_MODEM

    End Function

    Private Function IsNetConnectViaProxy() As Boolean

        Dim dwflags As Long

        'pass an empty variable into which the API will
        'return the flags associated with the connection
        Call InternetGetConnectedState(dwflags, 0&)

        'return True if the flags indicate a proxy connection
        IsNetConnectViaProxy = dwflags And INTERNET_CONNECTION_PROXY

    End Function

    Private Function IsNetConnectOnline() As Boolean

        'no flags needed here - the API returns True 
        'if there is a connection of any type
        IsNetConnectOnline = InternetGetConnectedState(0&, 0&)

    End Function

    Private Function IsNetRASInstalled() As Boolean

        Dim dwflags As Long

        'pass an empty variable into which the API will
        'return the flags associated with the connection
        Call InternetGetConnectedState(dwflags, 0&)

        'return True if the flags include RAS installed
        IsNetRASInstalled = dwflags And INTERNET_RAS_INSTALLED

    End Function

    Private Function GetNetConnectString() As String

        Dim dwflags As Long
        Dim msg As String
        msg = ""

        'build a string for display
        If InternetGetConnectedState(dwflags, 0&) Then

            If dwflags And INTERNET_CONNECTION_CONFIGURED Then
                msg = msg & "You have a network connection configured."
            End If

            If dwflags And INTERNET_CONNECTION_LAN Then
                msg = msg & "The local system connects to the Internet via a LAN"
            End If

            If dwflags And INTERNET_CONNECTION_PROXY Then
                msg = msg & ", and uses a proxy server. "
            Else
                msg = msg & "."
            End If

            If dwflags And INTERNET_CONNECTION_MODEM Then
                msg = msg & "The local system uses a modem to connect to the Internet. "
            End If

            If dwflags And INTERNET_CONNECTION_OFFLINE Then
                msg = msg & "The connection is currently offline[NoInt]."
            End If

            If dwflags And INTERNET_CONNECTION_MODEM_BUSY Then
                msg = msg & "The local system's modem is busy with a non-Internet connection.[NoInt]"
            End If

            If dwflags And INTERNET_RAS_INSTALLED Then
                msg = msg & "Remote Access Services are installed on this system."
            End If
        Else
            msg = "Not connected to the internet[NoInt]"

        End If

        GetNetConnectString = msg

    End Function
    Private Sub TerminateSelf()
        ' I know now why you cry, but it is something I can never do.
        Dim pid As Integer
        pid = System.Diagnostics.Process.GetCurrentProcess().Id
        System.Diagnostics.Process.GetProcessById(pid).Kill()
        'My.Computer.Registry.SetValue(CurrentUser & EasyPacManRegistry, SubKey, "0")


    End Sub
End Class
