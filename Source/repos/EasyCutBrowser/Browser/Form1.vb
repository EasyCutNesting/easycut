Imports System.Windows.Forms
Imports System.Security.Permissions
Imports System.Web
Imports System.Net
Imports System.IO

Public Class Form1

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

        Dim userAgent As HttpWebRequest
        userAgent = myHttpWebRequest.UserAgent
        If userAgent.IndexOf("MSIE 6.0") > -1 Then
            ' The browser is Microsoft Internet Explorer 6.0.
        End If


        ' Create a new 'HttpWebRequest' object to the mentioned URL.
        Dim myHttpWebRequest As HttpWebRequest = CType(WebRequest.Create("http://www.google.com"), HttpWebRequest)
        myHttpWebRequest.UserAgent = ".NET Framework Test Client"
        ' The response object of 'HttpWebRequest' is assigned to a 'HttpWebResponse' variable.
        Dim myHttpWebResponse As HttpWebResponse = CType(myHttpWebRequest.GetResponse(), HttpWebResponse)
        ' Display the contents of the page to the console.
        Dim streamResponse As Stream = myHttpWebResponse.GetResponseStream()
        Dim streamRead As New StreamReader(streamResponse)
        Dim readBuff(256) As [Char]
        Dim count As Integer = streamRead.Read(readBuff, 0, 256)
        Console.WriteLine(ControlChars.Cr + "The contents of HTML Page are :" + ControlChars.Cr)
        While count > 0
            Dim outputData As New [String](readBuff, 0, count)
            Console.Write(outputData)
            count = streamRead.Read(readBuff, 0, 256)
        End While
        streamRead.Close()
        streamResponse.Close()
        ' Release the response object resources.
        myHttpWebResponse.Close()

    End Sub

    Private Sub ChkVer()

        Dim AppName As String = My.Application.Info.AssemblyName
        Dim VersionCode As Integer
        Dim Version As String = ""
        Dim ieVersion As Object = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\Microsoft\Internet Explorer").GetValue("svcUpdateVersion")
        If ieVersion Is Nothing Then
            ieVersion = Microsoft.Win32.Registry.LocalMachine.OpenSubKey("Software\Microsoft\Internet Explorer").GetValue("Version")
        End If
        If ieVersion IsNot Nothing Then
            Version = ieVersion.ToString.Substring(0, ieVersion.ToString.IndexOf("."c))
            Select Case Version
                Case "7"
                    VersionCode = 7000
                Case "8"
                    VersionCode = 8888
                Case "9"
                    VersionCode = 9999
                Case "10"
                    VersionCode = 10001
                Case Else
                    If CInt(Version) >= 11 Then
                        VersionCode = 11001
                    Else
                        Throw New Exception("IE Version not supported")
                    End If
            End Select
        Else
            Throw New Exception("Registry error")
        End If
        'Check if the right emulation is set
        'if not, Set Emulation to highest level possible on the user machine
        Dim Root As String = "HKEY_CURRENT_USER\"
        Dim Key As String = "Software\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION"
        Dim CurrentSetting As String = CStr(Microsoft.Win32.Registry.CurrentUser.OpenSubKey(Key).GetValue(AppName & ".exe"))
        If CurrentSetting Is Nothing OrElse CInt(CurrentSetting) <> VersionCode Then
            Microsoft.Win32.Registry.SetValue(Root & Key, AppName & ".exe", VersionCode)
            Microsoft.Win32.Registry.SetValue(Root & Key, AppName & ".vshost.exe", VersionCode)
        End If

    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        WebBrowser1.Navigate("file:///C:/Users/User/EasyCut/Output/Docs/01Sheet/Sheet_02144.html")
    End Sub

    Private Sub WebBrowser1_DocumentCompleted(sender As Object, e As WebBrowserDocumentCompletedEventArgs) Handles WebBrowser1.DocumentCompleted
        WebBrowser1.ScriptErrorsSuppressed() = True
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs)

    End Sub






End Class
