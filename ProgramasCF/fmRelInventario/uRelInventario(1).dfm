object fmRelInventario: TfmRelInventario
  Left = 387
  Top = 164
  Width = 841
  Height = 483
  Caption = 'Invent'#225'rio'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  WindowState = wsMaximized
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    825
    444)
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 7
    Top = 143
    Width = 801
    Height = 242
    Anchors = [akLeft, akTop, akRight]
    Color = clBtnFace
    Ctl3D = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
  end
  object Button1: TButton
    Left = 512
    Top = 176
    Width = 75
    Height = 25
    Caption = 'monta script wms'
    TabOrder = 1
    Visible = False
    OnClick = Button1Click
  end
  object GroupBox1: TGroupBox
    Left = 407
    Top = 16
    Width = 197
    Height = 89
    Caption = 'Exporta Contagem  para Well '
    TabOrder = 2
    object fsBitBtn1: TfsBitBtn
      Left = 6
      Top = 21
      Width = 171
      Height = 25
      Caption = 'Consolidar Arquivos da contagem'
      TabOrder = 0
      OnClick = fsBitBtn1Click
    end
    object fsBitBtn2: TfsBitBtn
      Left = 6
      Top = 60
      Width = 182
      Height = 25
      BiDiMode = bdLeftToRight
      Caption = 'Salva arq consolidado'
      ParentBiDiMode = False
      TabOrder = 1
      OnClick = fsBitBtn2Click
      Layout = blGlyphTop
    end
    object edCdUo: TadLabelEdit
      Left = 154
      Top = 63
      Width = 30
      Height = 19
      LabelDefs.Width = 23
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Loja:'
      BiDiMode = bdRightToLeft
      Ctl3D = False
      ParentBiDiMode = False
      ParentCtl3D = False
      MaxLength = 4
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 191
    Top = 7
    Width = 211
    Height = 127
    Caption = 'Arquivos de contagem '
    TabOrder = 3
    object btCarregaContagem: TfsBitBtn
      Left = 6
      Top = 18
      Width = 193
      Height = 25
      Caption = 'Imprime uma contagem'
      TabOrder = 0
      OnClick = btCarregaContagemClick
    end
    object btCalculaDivergencia: TfsBitBtn
      Left = 6
      Top = 82
      Width = 193
      Height = 25
      Caption = 'Ver diverg'#234'ncias entre 02 contagens'
      TabOrder = 1
      OnClick = btCalculaDivergenciaClick
    end
    object cbExporta: TfsCheckBox
      Left = 8
      Top = 46
      Width = 111
      Height = 17
      Caption = 'Exporta para excel'
      TabOrder = 2
      FlatFont.Charset = DEFAULT_CHARSET
      FlatFont.Color = clWindowText
      FlatFont.Height = -11
      FlatFont.Name = 'MS Sans Serif'
      FlatFont.Style = []
    end
    object cbExportaWell: TfsCheckBox
      Left = 8
      Top = 63
      Width = 193
      Height = 17
      Caption = 'Exporta formato  de leitura do well'
      TabOrder = 3
      FlatFont.Charset = DEFAULT_CHARSET
      FlatFont.Color = clWindowText
      FlatFont.Height = -11
      FlatFont.Name = 'MS Sans Serif'
      FlatFont.Style = []
    end
    object fsJeitoNovo: TfsCheckBox
      Left = 6
      Top = 106
      Width = 193
      Height = 17
      Caption = 'jeito novo'
      Checked = True
      State = cbChecked
      TabOrder = 4
      Visible = False
      FlatFont.Charset = DEFAULT_CHARSET
      FlatFont.Color = clWindowText
      FlatFont.Height = -11
      FlatFont.Name = 'MS Sans Serif'
      FlatFont.Style = []
    end
  end
  object GroupBox3: TGroupBox
    Left = 7
    Top = 7
    Width = 182
    Height = 119
    Caption = 'Exporta Arquivos para  coletor '
    TabOrder = 4
    object fsBitBtn3: TfsBitBtn
      Left = 6
      Top = 18
      Width = 168
      Height = 25
      Caption = 'Gera arquivo p/ carga coletor'
      TabOrder = 0
      OnClick = fsBitBtn3Click
    end
    object edQtDigDesc: TadLabelEdit
      Left = 8
      Top = 59
      Width = 111
      Height = 19
      LabelDefs.Width = 109
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Tamanho da descricao'
      BiDiMode = bdRightToLeft
      Ctl3D = False
      ParentBiDiMode = False
      ParentCtl3D = False
      MaxLength = 4
      TabOrder = 1
      Text = '0015'
    end
    object edFxCodigo: TadLabelEdit
      Left = 8
      Top = 94
      Width = 111
      Height = 19
      LabelDefs.Width = 75
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Faixa de c'#243'digo'
      BiDiMode = bdRightToLeft
      Ctl3D = False
      ParentBiDiMode = False
      ParentCtl3D = False
      MaxLength = 8
      TabOrder = 2
    end
  end
  object gridDirv: TSoftDBGrid
    Left = 12
    Top = 152
    Width = 789
    Height = 147
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    DataSource = DataSource1
    ParentCtl3D = False
    TabOrder = 5
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Visible = False
    OnCellClick = gridDirvCellClick
    AlternateColor = True
    ColorLow = clInfoBk
    ColorHigh = 15790322
  end
  object Button2: TButton
    Left = 432
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 6
    Visible = False
    OnClick = Button2Click
  end
  object GroupBox4: TGroupBox
    Left = 612
    Top = 16
    Width = 190
    Height = 74
    Caption = 'Zera Estoque f'#237'sico de filial '
    TabOrder = 7
    object fsBitBtn4: TfsBitBtn
      Left = 150
      Top = 28
      Width = 35
      Height = 23
      Caption = 'Ok'
      TabOrder = 0
      OnClick = fsBitBtn4Click
    end
    object cbLoja: TadLabelComboBox
      Left = 8
      Top = 29
      Width = 139
      Height = 21
      BevelInner = bvLowered
      BevelKind = bkSoft
      BevelOuter = bvNone
      Style = csDropDownList
      BiDiMode = bdRightToLeft
      DropDownCount = 15
      ItemHeight = 13
      ParentBiDiMode = False
      TabOrder = 1
      LabelDefs.Width = 23
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Loja:'
      Colors.WhenEnterFocus.BackColor = clInfoBk
    end
  end
  object tbItens: TADOTable
    Left = 240
    Top = 184
  end
  object tbNmArquivos: TADOTable
    Left = 152
    Top = 184
  end
  object tbDirvg: TADOTable
    Left = 200
    Top = 184
  end
  object tbErr: TADOTable
    Left = 24
    Top = 224
  end
  object DataSource1: TDataSource
    DataSet = tb_dirvg2
    Left = 120
    Top = 288
  end
  object tb_dirvg2: TADOTable
    Left = 288
    Top = 184
  end
end
