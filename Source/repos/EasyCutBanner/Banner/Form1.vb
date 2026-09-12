Imports System
Imports Microsoft.Win32
Imports System.Environment
Imports System.IO
Imports System.Collections

Public Class Form1

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load

        Dim CurrentUser As String = "HKEY_CURRENT_USER\"
        Dim AutoCadRegistry As String = "Software\EasyCut"
        Dim Version As String = My.Computer.Registry.GetValue(CurrentUser & AutoCadRegistry, "Version", Nothing)

        LinkLabel1.Text = "www.easycutnesting.it"
        LinkLabel1.Links.Add(0, 21, "www.easycutnesting.it")
        Label1.Text = Version
    End Sub
    Private Sub LinkLabel1_LinkClicked(sender As Object, e As LinkLabelLinkClickedEventArgs) Handles LinkLabel1.LinkClicked
        System.Diagnostics.Process.Start(e.Link.LinkData.ToString())
    End Sub
    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        Me.Close()
    End Sub



End Class