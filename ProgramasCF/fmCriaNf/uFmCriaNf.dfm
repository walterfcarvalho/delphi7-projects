object fmCriaNf: TfmCriaNf
  Left = 473
  Top = 194
  Width = 690
  Height = 450
  Caption = 'Gerar nota a partir dos itens de outra nota.'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 5
    Top = 5
    Width = 542
    Height = 134
    BevelOuter = bvNone
    TabOrder = 0
    object gbNfOrigem: TGroupBox
      Left = 4
      Top = 4
      Width = 539
      Height = 117
      Caption = 'Dados da nota de origem '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object Label1: TLabel
        Left = 33
        Top = 20
        Width = 29
        Height = 13
        Caption = 'Loja:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbLoja: TLabel
        Left = 63
        Top = 20
        Width = 35
        Height = 13
        Caption = 'lbLoja'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbNota: TLabel
        Left = 63
        Top = 35
        Width = 49
        Height = 13
        Caption = '000/000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label5: TLabel
        Left = 30
        Top = 35
        Width = 32
        Height = 13
        Caption = 'Nota:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 11
        Top = 50
        Width = 51
        Height = 13
        Caption = 'Emiss'#227'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbDtEmis: TLabel
        Left = 61
        Top = 50
        Width = 69
        Height = 13
        Caption = '00/00/0000'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbStatus: TLabel
        Left = 63
        Top = 65
        Width = 57
        Height = 13
        Caption = 'AAAAAAA'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label3: TLabel
        Left = 21
        Top = 65
        Width = 41
        Height = 13
        Caption = 'Status:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 28
        Top = 80
        Width = 34
        Height = 13
        Caption = 'Valor:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbValor: TLabel
        Left = 63
        Top = 80
        Width = 40
        Height = 13
        Caption = 'lbValor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbDest: TLabel
        Left = 275
        Top = 36
        Width = 30
        Height = 13
        Caption = 'lbDest'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
      object lbIsNota: TLabel
        Left = 394
        Top = 20
        Width = 39
        Height = 13
        Caption = 'lbIsNota'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object Label2: TLabel
        Left = 273
        Top = 20
        Width = 119
        Height = 13
        Caption = 'Identificador interno:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label6: TLabel
        Left = 2
        Top = 95
        Width = 60
        Height = 13
        Caption = 'Opera'#231#227'o:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbOperacao: TLabel
        Left = 63
        Top = 95
        Width = 66
        Height = 13
        Caption = 'lbOperacao'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lbUo: TLabel
        Left = 276
        Top = 51
        Width = 22
        Height = 13
        Caption = 'lbUo'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        Visible = False
      end
    end
  end
  object btNovo: TFlatButton
    Left = 562
    Top = 19
    Width = 96
    Height = 39
    Hint = 'Obter Dados do Cliente'
    Caption = '&Nova'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = btNovoClick
  end
  object gbNfDest: TGroupBox
    Left = 8
    Top = 129
    Width = 539
    Height = 235
    Caption = ' Dados da nota a ser gerada  '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object cbOperIntegrada: TadLabelComboBox
      Left = 12
      Top = 39
      Width = 326
      Height = 21
      AutoCloseUp = True
      BevelInner = bvNone
      BevelKind = bkFlat
      Style = csDropDownList
      BiDiMode = bdLeftToRight
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentBiDiMode = False
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnChange = cbOperIntegradaChange
      LabelDefs.Width = 97
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Opera'#231#227'o integrada:'
      LabelDefs.Font.Charset = DEFAULT_CHARSET
      LabelDefs.Font.Color = clWindowText
      LabelDefs.Font.Height = -11
      LabelDefs.Font.Name = 'MS Sans Serif'
      LabelDefs.Font.Style = []
      LabelDefs.ParentFont = False
      Colors.WhenEnterFocus.BackColor = clWindow
      Colors.WhenExitFocus.BackColor = clInfoBk
    end
    object rgTpDest: TRadioGroup
      Left = 14
      Top = 72
      Width = 457
      Height = 93
      Caption = ' Destinat'#225'rio/emitente '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemIndex = 0
      Items.Strings = (
        'Loja'
        'Cliente')
      ParentFont = False
      TabOrder = 1
      OnClick = rgTpDestClick
    end
    object pnTpDestEmis: TPanel
      Left = 76
      Top = 88
      Width = 346
      Height = 70
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object cbLoja: TadLabelComboBox
        Left = 57
        Top = 7
        Width = 179
        Height = 21
        BevelInner = bvLowered
        BevelKind = bkSoft
        BevelOuter = bvNone
        Style = csDropDownList
        BiDiMode = bdRightToLeft
        DropDownCount = 15
        ItemHeight = 13
        ParentBiDiMode = False
        TabOrder = 0
        LabelDefs.Width = 20
        LabelDefs.Height = 13
        LabelDefs.Caption = 'Loja'
        LabelPosition = adLeft
        Colors.WhenEnterFocus.BackColor = clInfoBk
      end
      object edMailDest: TadLabelEdit
        Left = 57
        Top = 44
        Width = 283
        Height = 19
        LabelDefs.Width = 35
        LabelDefs.Height = 13
        LabelDefs.Caption = 'Cliente:'
        LabelPosition = adLeft
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 1
        Text = 'edMailDest'
        Visible = False
        OnClick = edMailDestClick
      end
      object btEmisDest: TFlatButton
        Left = 320
        Top = 45
        Width = 19
        Height = 17
        Caption = '...'
        TabOrder = 2
        Visible = False
        OnClick = btEmisDestClick
      end
    end
    object edObs: TadLabelEdit
      Left = 15
      Top = 187
      Width = 456
      Height = 19
      LabelDefs.Width = 100
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Observa'#231#227'o da nota:'
      LabelDefs.Font.Charset = DEFAULT_CHARSET
      LabelDefs.Font.Color = clWindowText
      LabelDefs.Font.Height = -11
      LabelDefs.Font.Name = 'MS Sans Serif'
      LabelDefs.Font.Style = []
      LabelDefs.ParentFont = False
      Ctl3D = False
      ParentCtl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxLength = 250
      ParentFont = False
      TabOrder = 3
    end
    object cbUsaFatPreco: TfsCheckBox
      Left = 347
      Top = 42
      Width = 159
      Height = 16
      Caption = 'Usa Fator de pre'#231'o nos itens'
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      FlatFont.Charset = DEFAULT_CHARSET
      FlatFont.Color = clWindowText
      FlatFont.Height = -11
      FlatFont.Name = 'MS Sans Serif'
      FlatFont.Style = []
    end
  end
  object btOk: TfsBitBtn
    Left = 394
    Top = 370
    Width = 75
    Height = 25
    TabOrder = 3
    OnClick = btOkClick
    Kind = bkOK
  end
  object btCancela: TfsBitBtn
    Left = 473
    Top = 370
    Width = 74
    Height = 25
    Caption = 'Cancelar'
    TabOrder = 4
    OnClick = btCancelaClick
    Kind = bkCancel
  end
end
