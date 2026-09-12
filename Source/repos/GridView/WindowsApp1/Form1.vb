Imports System.IO

Public Class Form1

    Dim dt As New DataTable()
    Dim CloseForm As Boolean = False
    Dim RowPreLoad As Integer = 10
    Dim ActiveFile As String = ""
    Dim RowIndexSelect As New ArrayList()
    Dim CurrentUserKey As String = "HKEY_CURRENT_USER\Software\EasyCut"
    Dim CurrentUserRegistry As String = "PathDxfJob"
    Dim CurrentSentinelRegistry As String = "Sentinel"

    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load


        If My.Computer.Registry.GetValue(CurrentUserKey, CurrentSentinelRegistry, Nothing) = 0 Then
            MakeTable()
            LoadDataGridView(My.Computer.Registry.GetValue(CurrentUserKey, CurrentUserRegistry, Nothing))
            AddEmptyRow()
            ResizeDataGrid()
        End If

    End Sub

    Private Sub MakeTable()

        Dim WidthTable As Integer = 800
        Dim HeigthTable As Integer = 287

        Dim MarginXTable As Integer = 3
        Dim MarginYTable As Integer = 0

        Dim MarginXForm As Integer = 30
        Dim MarginYForm As Integer = 150
        Dim RowPreLoad As Integer = 10

        dt.Columns.Add("Carica", GetType(Boolean))
        dt.Columns.Add("File Dxf", GetType(String))
        dt.Columns.Add("Commessa", GetType(String))
        dt.Columns.Add("Fase", GetType(String))
        dt.Columns.Add("Marca/Pos", GetType(String))
        dt.Columns.Add("Quantità", GetType(String))
        dt.Columns.Add("Spessore", GetType(String))
        dt.Columns.Add("Qualita'", GetType(String))

        DataGridView1.DataSource = dt
        DataGridView1.RowHeadersWidth = 50
        DataGridView1.Columns(0).Width = WidthTable * 5 / 100
        DataGridView1.Columns(1).Width = WidthTable * 30 / 100
        DataGridView1.Columns(2).Width = WidthTable * 10 / 100
        DataGridView1.Columns(3).Width = WidthTable * 10 / 100
        DataGridView1.Columns(4).Width = WidthTable * 10 / 100
        DataGridView1.Columns(5).Width = WidthTable * 10 / 100
        DataGridView1.Columns(6).Width = WidthTable * 10 / 100
        DataGridView1.Columns(7).Width = WidthTable * 10 / 100


        DataGridView1.Size = New Size(WidthTable + MarginXTable, HeigthTable + MarginYTable)
        Me.Size = New Size(WidthTable + MarginXForm, HeigthTable + MarginYForm)

        With DataGridView1.ColumnHeadersDefaultCellStyle
            .Alignment = DataGridViewContentAlignment.MiddleCenter
        End With

        DataGridView1.AllowUserToAddRows = True
        'DataGridView1.EditMode = DataGridView1.EditMode.EditOnEnter

    End Sub

    Private Sub LoadDataGridView(FileName As String)

        If System.IO.File.Exists(FileName) Then
            Dim lines() As String = IO.File.ReadAllLines(FileName)

            For i As Integer = 0 To lines.Length - 1
                Dim SplitWord As String() = lines(i).Split(New Char() {";"c})
                dt.Rows.Add(SplitWord(0), SplitWord(1), SplitWord(2), SplitWord(3), SplitWord(4), SplitWord(5), SplitWord(6), SplitWord(7))
            Next

            DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells
            DataGridView1.AutoResizeColumns()

            If lines.Length - 1 < RowPreLoad Then
                Dim row As DataRow
                For i As Integer = 0 To RowPreLoad - lines.Length - 1
                    row = dt.NewRow
                    dt.Rows.Add()
                Next
            End If
            Label2.Text = FileName
            ActiveFile = FileName
        Else
            DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.None
            Label2.Text = ""
            ActiveFile = FileName
        End If
    End Sub

    Private Sub AddEmptyRow()

        If (DataGridView1.Rows.Count - 1) < RowPreLoad Then
            Dim row As DataRow
            For i As Integer = 1 To RowPreLoad - (DataGridView1.Rows.Count - 1)
                row = dt.NewRow
                dt.Rows.Add()
            Next
        End If
    End Sub

    Private Sub IndexDataGrid()
        ' Renumber all rows
        For Each row As DataGridViewRow In Me.DataGridView1.Rows
            Me.SetRowHeaderNumber(row)
        Next row
    End Sub

    Private Sub SetRowHeaderNumber(ByRef row As DataGridViewRow)
        row.HeaderCell.Value = String.Format("{0}", row.Index + 1)
    End Sub

    Private Sub ResizeDataGrid()

        Dim iWidth As Integer = 0
        Dim iHeigth As Integer = 0
        Dim MarginX As Integer = 53
        Dim MarginY As Integer = 40
        Dim MarginXForm As Integer = MarginX + 200 '28
        Dim MarginYForm As Integer = MarginY + 120
        Dim ScrolBarHeigth As Integer = 18

        Dim maxWidth As Integer = 1024
        Dim maxHeigth As Integer = 450

        For i As Integer = 0 To DataGridView1.Columns.Count - 1
            iWidth += DataGridView1.Columns(i).Width
        Next
        For i As Integer = 0 To DataGridView1.Rows.Count - 1
            iHeigth += DataGridView1.Rows(i).Height
        Next

        DataGridView1.ScrollBars = ScrollBars.Both

        'MsgBox("Larghezza " & iWidth)

        If iWidth >= maxWidth Then
            iWidth = maxWidth
            MarginY = MarginY + ScrolBarHeigth
            MarginYForm = MarginY + 110
        End If

        If iHeigth >= maxHeigth Then
            iHeigth = maxHeigth
            MarginX = MarginX + ScrolBarHeigth
            MarginXForm = MarginX + 200 '50

        End If

        DataGridView1.Size = New Size(iWidth + MarginX, iHeigth + MarginY)
        Me.Size = New Size(iWidth + MarginXForm, iHeigth + MarginYForm)

    End Sub

    Private Function CheckEmptyCell() As Boolean

        Dim Check As Boolean = False

        For i As Integer = 1 To DataGridView1.Rows.Count - 1
            For ii As Integer = 2 To DataGridView1.Columns.Count - 1
                DataGridView1.Rows(i).Cells(ii).Style.BackColor = Color.White
            Next
        Next

        For i As Integer = DataGridView1.Rows.Count - 2 To 0 Step -1
            For ii As Integer = 1 To DataGridView1.Columns.Count - 1
                If IsDBNull(DataGridView1(ii, i).Value) Then
                    Check = True
                    DataGridView1(ii, i).Style.BackColor = Color.Yellow
                ElseIf DataGridView1(ii, i).Value.trim = "" Then
                    Check = True
                    DataGridView1(ii, i).Style.BackColor = Color.Yellow
                End If
            Next
        Next
        DataGridView1.ClearSelection()
        Return Check
    End Function

    Private Function CheckDuplicateFile() As Boolean

        Dim Check As Boolean = False
        Dim ListFile As New ArrayList()
        For i As Integer = 0 To DataGridView1.Rows.Count - 2
            ListFile.Add(DataGridView1.Rows(i).Cells(1).Value)
            DataGridView1.Rows(i).Cells(1).Style.BackColor = Color.White
        Next

        For i = 0 To ListFile.Count - 2
            If Not IsDBNull(ListFile.Item(i)) Then
                For j = i + 1 To ListFile.Count - 1
                    If Not IsDBNull(ListFile.Item(j)) Then
                        If ListFile.Item(i) = ListFile.Item(j) Then
                            DataGridView1(1, i).Style.BackColor = Color.Yellow
                            DataGridView1(1, j).Style.BackColor = Color.Yellow
                            Check = True
                        End If
                    End If
                Next
            End If
        Next

        DataGridView1.ClearSelection()
        Return Check

    End Function

    Private Sub DeleteAllRow()

        dt.Rows.Clear()
        'For i As Integer = DataGridView1.Rows.Count - 2 To 0 Step -1
        'DataGridView1.Rows.RemoveAt(i)
        'Next

    End Sub

    Private Sub DeleteEmptyRow()

        Dim Check As Boolean

        ' cancello le righe vuote

        For i As Integer = DataGridView1.Rows.Count - 2 To 0 Step -1
            Check = True
            For ii As Integer = 1 To DataGridView1.Columns.Count - 1
                If Not IsDBNull(DataGridView1(ii, i).Value) Then
                    Check = False
                End If
                'Exit For
            Next
            If Check Then
                DataGridView1.Rows.RemoveAt(i)
                'AlternateColorRow()
            End If
        Next

    End Sub

    Private Sub SaveGridData(FileName As String)
        Dim CatString(DataGridView1.Rows.Count - 2) As String
        For i As Integer = 0 To DataGridView1.Rows.Count - 2
            Dim Count As Integer = 0
            For Each cell As DataGridViewCell In DataGridView1.Rows(i).Cells
                If Count = 0 And IsDBNull(cell.Value) Then
                    cell.Value = "False"
                End If
                CatString(i) = CatString(i) & cell.Value & ";"
                Count = Count + 1
            Next
        Next
        IO.File.WriteAllLines(FileName, CatString)
    End Sub

    Private Sub SaveActualJob()

        Dim OpenFileDialog1 As New OpenFileDialog
        OpenFileDialog1.Filter = "Text Files(*.csv)|*.csv|All files (*.*)|*.*"
        OpenFileDialog1.Title = "Seleziona csv"

        Dim result As Integer = MessageBox.Show("Vuoi salvare l'archivio attuale ?", "", MessageBoxButtons.YesNo)
        OpenFileDialog1.FileName = Path.GetFileName(ActiveFile)
        Select Case result
            Case MsgBoxResult.Yes
                If System.IO.File.Exists(ActiveFile) Then
                    DeleteEmptyRow()
                    SaveGridData(ActiveFile)
                Else
                    OpenFileDialog1.CheckFileExists = False
                    If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then
                        DeleteEmptyRow()
                        SaveGridData(OpenFileDialog1.FileName)
                    End If
                End If
        End Select
    End Sub

    Private Function CheckEmptyDataGrid() As Boolean

        Dim Check As Boolean
        Dim RowCheck As Integer

        If DataGridView1.Rows.Count - 1 > 0 Then

            RowCheck = DataGridView1.Rows.Count - 1
            For i As Integer = DataGridView1.Rows.Count - 2 To 0 Step -1
                Check = True
                For ii As Integer = 1 To DataGridView1.Columns.Count - 1
                    If Not IsDBNull(DataGridView1(ii, i).Value) Then
                        Check = False
                    End If
                    'Exit For
                Next
                If Check Then
                    RowCheck = RowCheck - 1
                End If
            Next

        Else
            RowCheck = 0
        End If

        If RowCheck = 0 Then
            Check = True
        Else
            Check = False
        End If

        Return Check

    End Function

    '++++++++++++++++++++++
    '       Button
    '++++++++++++++++++++++
    Private Sub Show_Click(sender As Object, e As EventArgs) Handles Show.Click

        DeleteEmptyRow()
        If CheckEmptyCell() Then
            MsgBox("cella vuota inserire valore")
            Exit Sub
        End If
        If CheckDuplicateFile() Then
            MsgBox("nome file duplicato")
            Exit Sub
        End If

        'AlternateColorRow()

        If System.IO.File.Exists(ActiveFile) Then
            SaveGridData(ActiveFile)
            My.Computer.Registry.SetValue(CurrentUserKey, CurrentUserRegistry, ActiveFile)
            My.Computer.Registry.SetValue(CurrentUserKey, CurrentSentinelRegistry, "2")
            CloseForm = True
            Close()
        Else
            Dim OpenFileDialog1 As New OpenFileDialog
            OpenFileDialog1.Filter = "Text Files(*.csv)|*.csv|All files (*.*)|*.*"
            OpenFileDialog1.Multiselect = False
            OpenFileDialog1.CheckFileExists = False
            OpenFileDialog1.Title = "Seleziona Csv"
            If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then
                SaveGridData(OpenFileDialog1.FileName)
                My.Computer.Registry.SetValue(CurrentUserKey, CurrentUserRegistry, OpenFileDialog1.FileName)
                My.Computer.Registry.SetValue(CurrentUserKey, CurrentSentinelRegistry, "2")
                Label2.Text = OpenFileDialog1.FileName
                ActiveFile = OpenFileDialog1.FileName
                CloseForm = True
                Close()
            End If
        End If
    End Sub

    Private Sub NewJob_Click(sender As Object, e As EventArgs) Handles NewJob.Click

        If Not CheckEmptyDataGrid() Then
            SaveActualJob()
        End If

        DeleteAllRow()
        LoadDataGridView("")
        AddEmptyRow()
        'IndexDataGrid()
        ResizeDataGrid()

    End Sub

    Private Sub Save_Click(sender As Object, e As EventArgs) Handles Save.Click

        DeleteEmptyRow()
        If CheckEmptyCell() Then
            MsgBox("cella vuota inserire valore")
            Exit Sub
        End If
        If CheckDuplicateFile() Then
            MsgBox("nome file duplicato")
            Exit Sub
        End If

        'AlternateColorRow()

        If System.IO.File.Exists(ActiveFile) Then
            SaveGridData(ActiveFile)
            My.Computer.Registry.SetValue(CurrentUserKey, CurrentUserRegistry, ActiveFile)
            My.Computer.Registry.SetValue(CurrentUserKey, CurrentSentinelRegistry, "1")
            CloseForm = True
            Close()
        Else
            Dim OpenFileDialog1 As New OpenFileDialog
            OpenFileDialog1.Filter = "Text Files(*.csv)|*.csv|All files (*.*)|*.*"
            OpenFileDialog1.Multiselect = False
            OpenFileDialog1.CheckFileExists = False
            OpenFileDialog1.Title = "Seleziona Csv"
            If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then
                SaveGridData(OpenFileDialog1.FileName)
                My.Computer.Registry.SetValue(CurrentUserKey, CurrentUserRegistry, OpenFileDialog1.FileName)
                My.Computer.Registry.SetValue(CurrentUserKey, CurrentSentinelRegistry, "1")
                Label2.Text = OpenFileDialog1.FileName
                ActiveFile = OpenFileDialog1.FileName
                CloseForm = True
                Close()
            End If
        End If

    End Sub

    Private Sub Cancel_Click(sender As Object, e As EventArgs) Handles Cancel.Click

        My.Computer.Registry.SetValue(CurrentUserKey, CurrentSentinelRegistry, "-1")
        CloseForm = True
        Close()
    End Sub

    Private Sub AddDxf_Click(sender As Object, e As EventArgs) Handles AddDxf.Click

        Dim OpenFileDialog1 As New OpenFileDialog

        OpenFileDialog1.Filter = "Text Files(*.dxf)|*.dxf|All files (*.*)|*.*"
        OpenFileDialog1.Multiselect = True
        OpenFileDialog1.Title = "Seleziona Dxf"

        If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then
            DeleteEmptyRow()

            Dim ListFile As New ArrayList()
            For i As Integer = 0 To DataGridView1.Rows.Count - 2
                ListFile.Add(DataGridView1.Rows(i).Cells(1).Value)
            Next
            For Each mFile As String In OpenFileDialog1.FileNames
                If Not ListFile.Contains(mFile) Then
                    'dt.Rows.Add("True", mFile, "-", "-", "-", "-", "-", "-")
                    dt.Rows.Add("True", mFile, "-", "-", Path.GetFileNameWithoutExtension(mFile), "-", "-", "-")
                Else
                    MsgBox("il file " & mFile & " è già presente nella lista")
                End If
            Next

            DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells
            DataGridView1.AutoResizeColumns()
            AddEmptyRow()
            ResizeDataGrid()
            'IndexDataGrid()
            'AlternateColorRow()
        End If
    End Sub

    Private Sub LoadJob_Click(sender As Object, e As EventArgs) Handles LoadJob.Click

        Dim OpenFileDialog1 As New OpenFileDialog

        If Not CheckEmptyDataGrid() Then
            SaveActualJob()
        End If

        OpenFileDialog1.Filter = "Text Files(*.csv)|*.csv|All files (*.*)|*.*"
        OpenFileDialog1.Title = "Seleziona csv"
        OpenFileDialog1.CheckFileExists = True

        If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then
            If System.IO.File.Exists(OpenFileDialog1.FileName) Then
                DeleteAllRow()
                LoadDataGridView(OpenFileDialog1.FileName)
                AddEmptyRow()
                'IndexDataGrid()
                ResizeDataGrid()
                My.Computer.Registry.SetValue(CurrentUserKey, CurrentUserRegistry, OpenFileDialog1.FileName)

                Label2.Text = OpenFileDialog1.FileName
                ActiveFile = OpenFileDialog1.FileName

            End If
        End If
    End Sub

    Private Sub Form1_FormClosing(sender As Object, e As FormClosingEventArgs) Handles Me.FormClosing
        If Not CloseForm Then
            e.Cancel = True
        End If
    End Sub

    '++++++++++++++++++++++
    '        Events
    '++++++++++++++++++++++
    Private Sub DataGridView1_CellValueChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles DataGridView1.CellValueChanged
        ResizeDataGrid()
    End Sub

    Private Sub DataGridView1_CellMouseUp(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellMouseEventArgs) Handles DataGridView1.CellMouseUp

        If e.Button = MouseButtons.Right And e.RowIndex > -1 And DataGridView1.SelectedRows.Count > 0 Then

            RowIndexSelect.Clear()
            For Each selectedItem As DataGridViewRow In DataGridView1.SelectedRows
                RowIndexSelect.Add(selectedItem.Index)
            Next

            ContextMenuStrip1.Show(DataGridView1, e.Location)
            ContextMenuStrip1.Show(Cursor.Position)
        End If

        If e.Button = MouseButtons.Right And DataGridView1.SelectedCells.Count > 0 And DataGridView1.SelectedRows.Count = 0 Then

            ContextMenuStrip2.Show(DataGridView1, e.Location)
            ContextMenuStrip2.Show(Cursor.Position)

        End If
    End Sub

    Private Sub DataGridView1_KeyDown(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles DataGridView1.KeyDown
        If e.KeyCode = Keys.C Then
            CopyToClipboard()
        End If
        If e.KeyCode = Keys.V Then
            PasteClipboardValue()
        End If
        If e.KeyCode = Keys.X Then
            CopyToClipboard()
            For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
                DataGridView1.SelectedCells(counter).Value = String.Empty
            Next
        End If
    End Sub

    Private Sub DataGridView1_RowsAdded(sender As Object, e As EventArgs) Handles DataGridView1.RowsAdded
        IndexDataGrid()
    End Sub

    Private Sub DataGridView1_RowsRemoved(sender As Object, e As EventArgs) Handles DataGridView1.RowsRemoved
        IndexDataGrid()
    End Sub

    '++++++++++++++++++++++
    '    Inser/Delete Row
    '++++++++++++++++++++++
    Private Sub ContextMenuStrip1_ItemClicked(sender As Object, e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles ContextMenuStrip1.ItemClicked

        Dim userInput As String
        Dim row As DataRow

        userInput = e.ClickedItem.ToString()

        If userInput = "Elimina riga" Then
            RowIndexSelect.Sort()
            RowIndexSelect.Reverse()
            For Each itm In RowIndexSelect
                If itm <> DataGridView1.Rows.Count - 1 Then
                    DataGridView1.Rows.RemoveAt(itm)
                End If
            Next
            ResizeDataGrid()
        End If

        If userInput = "Inserisci riga" Then
            ''row.Item(0) = ""
            ''row.Item(1) = ""
            ''row.Item(2) = ""
            RowIndexSelect.Sort()
            For Each itm In RowIndexSelect
                row = dt.NewRow
                dt.Rows.InsertAt(row, itm)
            Next
            ResizeDataGrid()
        End If
    End Sub

    '++++++++++++++++++++++
    '    Copy/Paste Cell
    '++++++++++++++++++++++
    Private Sub ContextMenuStrip2_ItemClicked(sender As Object, e As System.Windows.Forms.ToolStripItemClickedEventArgs) Handles ContextMenuStrip2.ItemClicked

        Dim userInput As String
        userInput = e.ClickedItem.ToString()

        If userInput = "Copia (Ctrl+C)" Then
            CopyToClipboard()
        End If
        If userInput = "Incolla (Ctrl+V)" Then
            PasteClipboardValue()
        End If
        If userInput = "Cancella (Ctrl+X)" Then
            CopyToClipboard()
            For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
                DataGridView1.SelectedCells(counter).Value = String.Empty
            Next
        End If


    End Sub

    Private Sub CopyToClipboard()
        Dim dataObj As DataObject = DataGridView1.GetClipboardContent
        If Not IsNothing(dataObj) Then
            Clipboard.SetDataObject(dataObj)
        End If
    End Sub

    Private Sub PasteClipboardValue()
        If DataGridView1.SelectedCells.Count = 0 Then
            MessageBox.Show("No Cell selected", "Paste")
            Exit Sub
        End If

        Dim StartingCell As DataGridViewCell = GetStartingCell(DataGridView1)
        Dim rowCount = DataGridView1.SelectedCells.OfType(Of DataGridViewCell)().Select(Function(x) x.RowIndex).Distinct().Count()
        Dim cbvalue As Dictionary(Of Integer, Dictionary(Of Integer, String)) = ClipboardValues(Clipboard.GetText)
        Dim repeat As Integer = 0

        'MsgBox(rowCount & " " & " " & cbvalue.Keys.Count)

        'If rowCount >= cbvalue.Keys.Count Then
        'If rowCount Mod cbvalue.Keys.Count <> 0 Then
        'MessageBox.Show("Selected destination doesn't match")
        'Exit Sub
        'Else
        'repeat = CInt(rowCount / cbvalue.Keys.Count)
        'End If
        'End If

        repeat = 0

        Select Case cbvalue.Keys.Count

            Case 1
                repeat = rowCount

            Case Else
                If rowCount = 1 Then
                    'repeat = cbvalue.Keys.Count
                    repeat = 1
                ElseIf rowCount Mod cbvalue.Keys.Count = 0 Then
                    repeat = Int(rowCount / cbvalue.Keys.Count)
                ElseIf rowCount Mod cbvalue.Keys.Count <> 0 Then
                    repeat = 0
                End If
        End Select


        Dim irowindex = StartingCell.RowIndex
        For x As Integer = 1 To repeat
            For Each rowkey As Integer In cbvalue.Keys
                Dim icolindex As Integer = StartingCell.ColumnIndex
                For Each cellkey As Integer In cbvalue(rowkey).Keys
                    If icolindex <= DataGridView1.Columns.Count - 1 And irowindex <= DataGridView1.Rows.Count - 1 Then
                        Dim cell As DataGridViewCell = DataGridView1(icolindex, irowindex)
                        cell.Value = cbvalue(rowkey)(cellkey)
                    End If
                    icolindex += 1
                Next
                irowindex += 1
            Next
        Next

    End Sub

    Private Function GetStartingCell(dgView As DataGridView) As DataGridViewCell
        If dgView.SelectedCells.Count = 0 Then Return Nothing

        Dim rowIndex As Integer = dgView.Rows.Count - 1
        Dim ColIndex As Integer = dgView.Columns.Count - 1


        For Each dgvcell As DataGridViewCell In dgView.SelectedCells

            If dgvcell.RowIndex < rowIndex Then rowIndex = dgvcell.RowIndex
            If dgvcell.ColumnIndex < ColIndex Then ColIndex = dgvcell.ColumnIndex
        Next

        Return dgView(ColIndex, rowIndex)
    End Function

    Private Function ClipboardValues(clipboardvalue As String) As Dictionary(Of Integer, Dictionary(Of Integer, String))

        Dim lines() As String = clipboardvalue.Split(CChar(Environment.NewLine))
        Dim copyValues As Dictionary(Of Integer, Dictionary(Of Integer, String)) = New Dictionary(Of Integer, Dictionary(Of Integer, String))

        For i As Integer = 0 To lines.Length - 1

            copyValues.Item(i) = New Dictionary(Of Integer, String)
            Dim linecontent() As String = lines(i).Split(ChrW(Keys.Tab))

            If linecontent.Length = 0 Then
                copyValues(i)(0) = String.Empty
            Else
                For j As Integer = 0 To linecontent.Length - 1
                    copyValues(i)(j) = linecontent(j)
                    'MsgBox(copyValues(i)(j))
                Next
            End If
        Next
        Return copyValues
    End Function

    '++++++++++++++++++++++++++++++
    '       Rapid Input Button
    '++++++++++++++++++++++++++++++

    Private Sub SiNoButton_Click(sender As Object, e As EventArgs) Handles SiNoButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1

            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 0 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)

                If IsDBNull(DataGridView1.SelectedCells.Item(counter).Value) Then
                    cell.Value = False
                End If

                If DataGridView1.SelectedCells.Item(counter).Value = True Then
                    cell.Value = False
                Else
                    cell.Value = True
                End If

            End If
        Next
    End Sub

    Private Sub FileButton_Click(sender As Object, e As EventArgs) Handles FileButton.Click

        Dim OpenFileDialog1 As New OpenFileDialog

        OpenFileDialog1.Filter = "Text Files(*.dxf)|*.dxf|All files (*.*)|*.*"
        OpenFileDialog1.Multiselect = False
        OpenFileDialog1.Title = "Seleziona Dxf"

        If OpenFileDialog1.ShowDialog <> Windows.Forms.DialogResult.Cancel Then

            Dim ListFile As New ArrayList()
            For i As Integer = 0 To DataGridView1.Rows.Count - 2
                ListFile.Add(DataGridView1.Rows(i).Cells(1).Value)
            Next

            If Not ListFile.Contains(OpenFileDialog1.FileName) Then

                For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
                    Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
                    Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

                    If iColIndex = 1 Then
                        Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                        cell.Value = OpenFileDialog1.FileName
                    End If
                Next
            Else
                MsgBox("il file " & OpenFileDialog1.FileName & " è già presente nella lista")
            End If

            DataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.AllCells
            DataGridView1.AutoResizeColumns()
        End If
    End Sub

    Private Sub CommessaButton_Click(sender As Object, e As EventArgs) Handles CommessaButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 2 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                cell.Value = CommessaTextBox.Text
            End If
        Next

    End Sub

    Private Sub FaseButton_Click(sender As Object, e As EventArgs) Handles FaseButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 3 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                cell.Value = FaseTextBox.Text
            End If
        Next


    End Sub

    Private Sub QuantitaButton_Click(sender As Object, e As EventArgs) Handles QuantitaButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 5 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                cell.Value = QuantitaTextBox.Text
            End If
        Next

    End Sub

    Private Sub SpessoreButton_Click(sender As Object, e As EventArgs) Handles SpessoreButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 6 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                cell.Value = SpessoreTextBox.Text
            End If
        Next

    End Sub

    Private Sub QualitaButton_Click(sender As Object, e As EventArgs) Handles QualitaButton.Click

        For counter As Integer = 0 To DataGridView1.SelectedCells.Count - 1
            Dim iRowIndex As Integer = DataGridView1.SelectedCells.Item(counter).RowIndex
            Dim iColIndex As Integer = DataGridView1.SelectedCells.Item(counter).ColumnIndex

            If iColIndex = 7 Then
                Dim cell As DataGridViewCell = DataGridView1(iColIndex, iRowIndex)
                cell.Value = QualitaTextBox.Text
            End If
        Next

    End Sub

End Class
