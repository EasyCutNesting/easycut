Imports Microsoft.Win32
Imports System
Imports System.Collections.Generic
Imports System.Diagnostics
Imports System.Linq
Imports System.Text
Imports System.Threading.Tasks

Module Module1

    Sub Main()

        GetBrowsers()

        'For Each browser As Browser In GetAllInstalledBrowsers.GetBrowsers
        'Console.WriteLine(String.Format("{0}: " & vbLf& vbTab&"Path: {1} "& vbLf& vbTab&"Version: {2} "& vbLf& vbTab&"Icon: {3}", browser.Name, browser.Path, browser.Version, browser.IconPath))
        'Next
        'Console.ReadKey()
    End Sub

    Public Function GetBrowsers() As New ArrayList

        Dim browserKeys As RegistryKey
        'on 64bit the browsers are in a different location
        browserKeys = Registry.LocalMachine.OpenSubKey("SOFTWARE\WOW6432Node\Clients\StartMenuInternet")
        If (browserKeys Is Nothing) Then
            browserKeys = Registry.LocalMachine.OpenSubKey("SOFTWARE\Clients\StartMenuInternet")
        End If

        Dim browserNames() As String = browserKeys.GetSubKeyNames
        Dim browsers As New ArrayList()
        Dim i As Integer = 0

        Do While (i < browserNames.Length)
            browserNames = CType(browserKey.GetValue(Nothing), String)
            'Dim browser As Browser = New Browser
            'Dim browserKey As RegistryKey = browserKeys.OpenSubKey(browserNames(i))
            'browser.Name = CType(browserKey.GetValue(Nothing), String)
            'Dim browserKeyPath As RegistryKey = browserKey.OpenSubKey("shell\open\command")
            'browser.Path = CType(browserKeyPath.GetValue(Nothing).ToString.StripQuotes, String)
            'Dim browserIconPath As RegistryKey = browserKey.OpenSubKey("DefaultIcon")
            'browser.IconPath = CType(browserIconPath.GetValue(Nothing).ToString.StripQuotes, String)
            'browsers.Add(browser)
            'If (Not (browser.Path) Is Nothing) Then
            'browser.Version = FileVersionInfo.GetVersionInfo(browser.Path).FileVersion
            'Else
            'browser.Version = "unknown"
            'End If
            '
            'i = (i + 1)
        Loop

        Return browsers
    End Function



End Module
