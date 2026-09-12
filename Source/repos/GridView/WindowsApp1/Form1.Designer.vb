<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class Form1
    Inherits System.Windows.Forms.Form

    'Form esegue l'override del metodo Dispose per pulire l'elenco dei componenti.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Richiesto da Progettazione Windows Form
    Private components As System.ComponentModel.IContainer

    'NOTA: la procedura che segue è richiesta da Progettazione Windows Form
    'Può essere modificata in Progettazione Windows Form.  
    'Non modificarla mediante l'editor del codice.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.DataGridView1 = New System.Windows.Forms.DataGridView()
        Me.FlowLayoutPanel1 = New System.Windows.Forms.FlowLayoutPanel()
        Me.LoadJob = New System.Windows.Forms.Button()
        Me.NewJob = New System.Windows.Forms.Button()
        Me.AddDxf = New System.Windows.Forms.Button()
        Me.Save = New System.Windows.Forms.Button()
        Me.Show = New System.Windows.Forms.Button()
        Me.Cancel = New System.Windows.Forms.Button()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.ContextMenuStrip1 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.EliminaRigaToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.InserisciRigaToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.ContextMenuStrip2 = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.CopiaToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.IncollaToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.CancellaToolStripMenuItem = New System.Windows.Forms.ToolStripMenuItem()
        Me.FaseButton = New System.Windows.Forms.Button()
        Me.FaseTextBox = New System.Windows.Forms.TextBox()
        Me.SpessoreButton = New System.Windows.Forms.Button()
        Me.SpessoreTextBox = New System.Windows.Forms.TextBox()
        Me.QuantitaButton = New System.Windows.Forms.Button()
        Me.QuantitaTextBox = New System.Windows.Forms.TextBox()
        Me.QualitaButton = New System.Windows.Forms.Button()
        Me.QualitaTextBox = New System.Windows.Forms.TextBox()
        Me.CommessaTextBox = New System.Windows.Forms.TextBox()
        Me.CommessaButton = New System.Windows.Forms.Button()
        Me.FileButton = New System.Windows.Forms.Button()
        Me.SiNoButton = New System.Windows.Forms.Button()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.FlowLayoutPanel1.SuspendLayout()
        Me.ContextMenuStrip1.SuspendLayout()
        Me.ContextMenuStrip2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.SuspendLayout()
        '
        'DataGridView1
        '
        Me.DataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize
        Me.DataGridView1.Location = New System.Drawing.Point(6, 31)
        Me.DataGridView1.Name = "DataGridView1"
        Me.DataGridView1.Size = New System.Drawing.Size(240, 150)
        Me.DataGridView1.TabIndex = 0
        '
        'FlowLayoutPanel1
        '
        Me.FlowLayoutPanel1.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.FlowLayoutPanel1.Controls.Add(Me.LoadJob)
        Me.FlowLayoutPanel1.Controls.Add(Me.NewJob)
        Me.FlowLayoutPanel1.Controls.Add(Me.AddDxf)
        Me.FlowLayoutPanel1.Controls.Add(Me.Save)
        Me.FlowLayoutPanel1.Controls.Add(Me.Show)
        Me.FlowLayoutPanel1.Controls.Add(Me.Cancel)
        Me.FlowLayoutPanel1.Location = New System.Drawing.Point(161, 443)
        Me.FlowLayoutPanel1.Name = "FlowLayoutPanel1"
        Me.FlowLayoutPanel1.Size = New System.Drawing.Size(576, 25)
        Me.FlowLayoutPanel1.TabIndex = 1
        '
        'LoadJob
        '
        Me.LoadJob.Location = New System.Drawing.Point(3, 3)
        Me.LoadJob.Name = "LoadJob"
        Me.LoadJob.Size = New System.Drawing.Size(88, 21)
        Me.LoadJob.TabIndex = 0
        Me.LoadJob.Text = "Carica Archivio"
        Me.LoadJob.UseVisualStyleBackColor = True
        '
        'NewJob
        '
        Me.NewJob.Location = New System.Drawing.Point(97, 3)
        Me.NewJob.Name = "NewJob"
        Me.NewJob.Size = New System.Drawing.Size(88, 21)
        Me.NewJob.TabIndex = 5
        Me.NewJob.Text = "Nuovo Archivio"
        Me.NewJob.UseVisualStyleBackColor = True
        '
        'AddDxf
        '
        Me.AddDxf.Location = New System.Drawing.Point(191, 3)
        Me.AddDxf.Name = "AddDxf"
        Me.AddDxf.Size = New System.Drawing.Size(79, 21)
        Me.AddDxf.TabIndex = 1
        Me.AddDxf.Text = "Aggiungi Dxf"
        Me.AddDxf.UseVisualStyleBackColor = True
        '
        'Save
        '
        Me.Save.Location = New System.Drawing.Point(276, 3)
        Me.Save.Name = "Save"
        Me.Save.Size = New System.Drawing.Size(96, 21)
        Me.Save.TabIndex = 2
        Me.Save.Text = "Salva e Importa"
        Me.Save.UseVisualStyleBackColor = True
        '
        'Show
        '
        Me.Show.Location = New System.Drawing.Point(378, 3)
        Me.Show.Name = "Show"
        Me.Show.Size = New System.Drawing.Size(96, 21)
        Me.Show.TabIndex = 17
        Me.Show.Text = "Show"
        Me.Show.UseVisualStyleBackColor = True
        '
        'Cancel
        '
        Me.Cancel.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Cancel.Location = New System.Drawing.Point(480, 3)
        Me.Cancel.Name = "Cancel"
        Me.Cancel.Size = New System.Drawing.Size(79, 21)
        Me.Cancel.TabIndex = 4
        Me.Cancel.Text = "Esci"
        Me.Cancel.UseVisualStyleBackColor = True
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(10, 9)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(89, 16)
        Me.Label1.TabIndex = 2
        Me.Label1.Text = "Archivio file"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(102, 9)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(55, 16)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Label2"
        '
        'ContextMenuStrip1
        '
        Me.ContextMenuStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.EliminaRigaToolStripMenuItem, Me.InserisciRigaToolStripMenuItem})
        Me.ContextMenuStrip1.Name = "ContextMenuStrip1"
        Me.ContextMenuStrip1.Size = New System.Drawing.Size(140, 48)
        '
        'EliminaRigaToolStripMenuItem
        '
        Me.EliminaRigaToolStripMenuItem.Name = "EliminaRigaToolStripMenuItem"
        Me.EliminaRigaToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.EliminaRigaToolStripMenuItem.Text = "Elimina riga"
        '
        'InserisciRigaToolStripMenuItem
        '
        Me.InserisciRigaToolStripMenuItem.Name = "InserisciRigaToolStripMenuItem"
        Me.InserisciRigaToolStripMenuItem.Size = New System.Drawing.Size(139, 22)
        Me.InserisciRigaToolStripMenuItem.Text = "Inserisci riga"
        '
        'ContextMenuStrip2
        '
        Me.ContextMenuStrip2.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.CopiaToolStripMenuItem, Me.IncollaToolStripMenuItem, Me.CancellaToolStripMenuItem})
        Me.ContextMenuStrip2.Name = "ContextMenuStrip2"
        Me.ContextMenuStrip2.Size = New System.Drawing.Size(165, 70)
        '
        'CopiaToolStripMenuItem
        '
        Me.CopiaToolStripMenuItem.Name = "CopiaToolStripMenuItem"
        Me.CopiaToolStripMenuItem.Size = New System.Drawing.Size(164, 22)
        Me.CopiaToolStripMenuItem.Text = "Copia (Ctrl+C)"
        '
        'IncollaToolStripMenuItem
        '
        Me.IncollaToolStripMenuItem.Name = "IncollaToolStripMenuItem"
        Me.IncollaToolStripMenuItem.Size = New System.Drawing.Size(164, 22)
        Me.IncollaToolStripMenuItem.Text = "Incolla (Ctrl+V)"
        '
        'CancellaToolStripMenuItem
        '
        Me.CancellaToolStripMenuItem.Name = "CancellaToolStripMenuItem"
        Me.CancellaToolStripMenuItem.Size = New System.Drawing.Size(164, 22)
        Me.CancellaToolStripMenuItem.Text = "Cancella (Ctrl+X)"
        '
        'FaseButton
        '
        Me.FaseButton.Location = New System.Drawing.Point(6, 95)
        Me.FaseButton.Name = "FaseButton"
        Me.FaseButton.Size = New System.Drawing.Size(76, 20)
        Me.FaseButton.TabIndex = 7
        Me.FaseButton.Text = "Fase"
        Me.FaseButton.UseVisualStyleBackColor = True
        '
        'FaseTextBox
        '
        Me.FaseTextBox.Location = New System.Drawing.Point(86, 95)
        Me.FaseTextBox.Name = "FaseTextBox"
        Me.FaseTextBox.Size = New System.Drawing.Size(60, 20)
        Me.FaseTextBox.TabIndex = 6
        '
        'SpessoreButton
        '
        Me.SpessoreButton.Location = New System.Drawing.Point(6, 145)
        Me.SpessoreButton.Name = "SpessoreButton"
        Me.SpessoreButton.Size = New System.Drawing.Size(76, 20)
        Me.SpessoreButton.TabIndex = 9
        Me.SpessoreButton.Text = "Spessore"
        Me.SpessoreButton.UseVisualStyleBackColor = True
        '
        'SpessoreTextBox
        '
        Me.SpessoreTextBox.Location = New System.Drawing.Point(86, 145)
        Me.SpessoreTextBox.Name = "SpessoreTextBox"
        Me.SpessoreTextBox.Size = New System.Drawing.Size(60, 20)
        Me.SpessoreTextBox.TabIndex = 8
        '
        'QuantitaButton
        '
        Me.QuantitaButton.Location = New System.Drawing.Point(6, 120)
        Me.QuantitaButton.Name = "QuantitaButton"
        Me.QuantitaButton.Size = New System.Drawing.Size(76, 20)
        Me.QuantitaButton.TabIndex = 11
        Me.QuantitaButton.Text = "Quanita'"
        Me.QuantitaButton.UseVisualStyleBackColor = True
        '
        'QuantitaTextBox
        '
        Me.QuantitaTextBox.Location = New System.Drawing.Point(86, 120)
        Me.QuantitaTextBox.Name = "QuantitaTextBox"
        Me.QuantitaTextBox.Size = New System.Drawing.Size(60, 20)
        Me.QuantitaTextBox.TabIndex = 10
        '
        'QualitaButton
        '
        Me.QualitaButton.Location = New System.Drawing.Point(6, 170)
        Me.QualitaButton.Name = "QualitaButton"
        Me.QualitaButton.Size = New System.Drawing.Size(76, 20)
        Me.QualitaButton.TabIndex = 13
        Me.QualitaButton.Text = "Qualita'"
        Me.QualitaButton.UseVisualStyleBackColor = True
        '
        'QualitaTextBox
        '
        Me.QualitaTextBox.Location = New System.Drawing.Point(86, 170)
        Me.QualitaTextBox.Name = "QualitaTextBox"
        Me.QualitaTextBox.Size = New System.Drawing.Size(60, 20)
        Me.QualitaTextBox.TabIndex = 12
        '
        'CommessaTextBox
        '
        Me.CommessaTextBox.Location = New System.Drawing.Point(86, 70)
        Me.CommessaTextBox.Name = "CommessaTextBox"
        Me.CommessaTextBox.Size = New System.Drawing.Size(60, 20)
        Me.CommessaTextBox.TabIndex = 4
        '
        'CommessaButton
        '
        Me.CommessaButton.Location = New System.Drawing.Point(6, 70)
        Me.CommessaButton.Name = "CommessaButton"
        Me.CommessaButton.Size = New System.Drawing.Size(76, 20)
        Me.CommessaButton.TabIndex = 5
        Me.CommessaButton.Text = "Commessa"
        Me.CommessaButton.UseVisualStyleBackColor = True
        '
        'FileButton
        '
        Me.FileButton.Location = New System.Drawing.Point(6, 45)
        Me.FileButton.Name = "FileButton"
        Me.FileButton.Size = New System.Drawing.Size(76, 20)
        Me.FileButton.TabIndex = 15
        Me.FileButton.Text = "File Dxf"
        Me.FileButton.UseVisualStyleBackColor = True
        '
        'SiNoButton
        '
        Me.SiNoButton.Location = New System.Drawing.Point(6, 20)
        Me.SiNoButton.Name = "SiNoButton"
        Me.SiNoButton.Size = New System.Drawing.Size(76, 20)
        Me.SiNoButton.TabIndex = 14
        Me.SiNoButton.Text = "Carica Si/No"
        Me.SiNoButton.UseVisualStyleBackColor = True
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.SiNoButton)
        Me.GroupBox1.Controls.Add(Me.QualitaTextBox)
        Me.GroupBox1.Controls.Add(Me.FileButton)
        Me.GroupBox1.Controls.Add(Me.QualitaButton)
        Me.GroupBox1.Controls.Add(Me.CommessaButton)
        Me.GroupBox1.Controls.Add(Me.SpessoreTextBox)
        Me.GroupBox1.Controls.Add(Me.CommessaTextBox)
        Me.GroupBox1.Controls.Add(Me.SpessoreButton)
        Me.GroupBox1.Controls.Add(Me.FaseButton)
        Me.GroupBox1.Controls.Add(Me.QuantitaTextBox)
        Me.GroupBox1.Controls.Add(Me.FaseTextBox)
        Me.GroupBox1.Controls.Add(Me.QuantitaButton)
        Me.GroupBox1.Location = New System.Drawing.Point(685, 25)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(153, 199)
        Me.GroupBox1.TabIndex = 16
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Input rapido"
        '
        'Form1
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.ClientSize = New System.Drawing.Size(850, 480)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.FlowLayoutPanel1)
        Me.Controls.Add(Me.DataGridView1)
        Me.Name = "Form1"
        Me.Text = "Dxf"
        CType(Me.DataGridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.FlowLayoutPanel1.ResumeLayout(False)
        Me.ContextMenuStrip1.ResumeLayout(False)
        Me.ContextMenuStrip2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

    Friend WithEvents DataGridView1 As DataGridView
    Friend WithEvents FlowLayoutPanel1 As FlowLayoutPanel
    Friend WithEvents LoadJob As Button
    Friend WithEvents AddDxf As Button
    Friend WithEvents Save As Button
    Friend WithEvents Label1 As Label
    Friend WithEvents Label2 As Label
    Friend WithEvents Cancel As Button
    Friend WithEvents NewJob As Button
    Friend WithEvents ContextMenuStrip1 As ContextMenuStrip
    Friend WithEvents EliminaRigaToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents InserisciRigaToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents ContextMenuStrip2 As ContextMenuStrip
    Friend WithEvents CopiaToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents IncollaToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents CancellaToolStripMenuItem As ToolStripMenuItem
    Friend WithEvents FaseButton As Button
    Friend WithEvents FaseTextBox As TextBox
    Friend WithEvents SpessoreButton As Button
    Friend WithEvents SpessoreTextBox As TextBox
    Friend WithEvents QuantitaButton As Button
    Friend WithEvents QuantitaTextBox As TextBox
    Friend WithEvents QualitaButton As Button
    Friend WithEvents QualitaTextBox As TextBox
    Friend WithEvents CommessaTextBox As TextBox
    Friend WithEvents CommessaButton As Button
    Friend WithEvents FileButton As Button
    Friend WithEvents SiNoButton As Button
    Friend WithEvents GroupBox1 As GroupBox
    Friend WithEvents Show As Button
End Class
