inherited fmItensSemMov: TfmItensSemMov
  Left = 410
  Top = 185
  Width = 921
  Caption = 'Produtos Sem Movimenta'#231#227'o'
  OldCreateOrder = True
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnParam: TPanel
    Width = 905
    Height = 140
    inherited cbDetAvaForn: TfsCheckBox
      Left = 452
      Top = 53
      Width = 197
      Caption = 'Data de entrada por transfer'#234'ncia'
    end
    inherited pnSelCat: TPanel
      Top = 53
      Width = 212
      object btExportar: TfsBitBtn
        Left = 656
        Top = 61
        Width = 66
        Height = 29
        Caption = 'Exportar'
        TabOrder = 1
        OnClick = btExportarClick
        Glyph.Data = {
          B2050000424DB205000000000000360400002800000013000000130000000100
          0800000000007C010000C40E0000C40E00000001000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
          A6000020400000206000002080000020A0000020C0000020E000004000000040
          20000040400000406000004080000040A0000040C0000040E000006000000060
          20000060400000606000006080000060A0000060C0000060E000008000000080
          20000080400000806000008080000080A0000080C0000080E00000A0000000A0
          200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
          200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
          200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
          20004000400040006000400080004000A0004000C0004000E000402000004020
          20004020400040206000402080004020A0004020C0004020E000404000004040
          20004040400040406000404080004040A0004040C0004040E000406000004060
          20004060400040606000406080004060A0004060C0004060E000408000004080
          20004080400040806000408080004080A0004080C0004080E00040A0000040A0
          200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
          200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
          200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
          20008000400080006000800080008000A0008000C0008000E000802000008020
          20008020400080206000802080008020A0008020C0008020E000804000008040
          20008040400080406000804080008040A0008040C0008040E000806000008060
          20008060400080606000806080008060A0008060C0008060E000808000008080
          20008080400080806000808080008080A0008080C0008080E00080A0000080A0
          200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
          200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
          200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
          2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
          2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
          2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
          2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
          2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
          2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
          2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
          FFF7525252525252495249520000FFFFFFFFF6F7075BF70807A35A49F6FFFFFF
          5200FFFFFFFFF6005952525200F0E952070808FF5200FFFFFFFFFFF706E9A100
          F0FE9AA407F608FF4A00FFFFFFFFFFFFF50600F0FE540092070708FF4A00FFF6
          F7070707F70AF0FE54A4FFFFFFF607FF4A00FF07F708080751E8FE9B9853EEFF
          FFF6F6FF4A00FF0707FFF6A4F4F3A4A306F0A9F7FFF6F6FF5200FF0707F6F700
          920007F6A3484852080707FF5200FF070708FFF6FFA40808FFFFFFF6FF0808FF
          4900FF0707080707F6A4080807070707079B49494900FF070708F608FFA408FF
          FFF6F6FFFFF7A4A3FF00FF070708F608FFA407F6F6080808F6A45208FF00FF07
          0708080708A452525252499B5BA4F6FFFF00FF070707F608F6F6FFFFFFFF07FF
          FFB507FFFF00FF070708F608F608F60708EDA4F6F7429D9CF600FF0707FFF608
          08F6FFF707A408F643C78200F700FF0707FFFFF6F6FFFF07A408FFFFF749ACF7
          F600FF08A4F7F7F7F7F7F7A408FFFFFFFFF6FFFFFF00}
      end
    end
    object edCodigo: TadLabelEdit
      Left = 4
      Top = 65
      Width = 145
      Height = 19
      LabelDefs.Width = 75
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Faixa de c'#243'digo'
      Colors.WhenEnterFocus.BackColor = clWindow
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 6
    end
    object spedit: TadLabelSpinEdit
      Left = 343
      Top = 71
      Width = 55
      Height = 22
      Cursor = crDefault
      LabelDefs.Width = 149
      LabelDefs.Height = 13
      LabelDefs.Caption = 'Dias sem movimento maior que:'
      LabelPosition = adLeft
      Colors.WhenEnterFocus.BackColor = clInfoBk
      Ctl3D = False
      ParentCtl3D = False
      Decimals = -1
      MaxValue = 9999.000000000000000000
      MinValue = 1.000000000000000000
      Format = nfStandard
      TabOrder = 7
      Value = 30.000000000000000000
      Increment = 1.000000000000000000
      RoundValues = False
      Wrap = False
    end
    object FlatButton1: TFlatButton
      Left = 737
      Top = 22
      Width = 66
      Height = 26
      Layout = blGlyphLeft
      NumGlyphs = 2
      TabOrder = 8
      ModalResult = 1
      OnClick = FlatButton1Click
    end
  end
  object grid: TSoftDBGrid [1]
    Left = 0
    Top = 140
    Width = 905
    Height = 246
    Align = alClient
    Ctl3D = False
    DataSource = DataSource1
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    ParentCtl3D = False
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnTitleClick = gridTitleClick
    AlternateColor = True
    ColorLow = clInfoBk
    ColorHigh = clWindow
  end
  inherited tbValoresAvarias: TADOTable
    Left = 704
    Top = 199
  end
  inherited tbValoresAvarias_Total: TADOTable
    Left = 705
    Top = 240
  end
  inherited tbPreviaDeCaixa: TADOTable
    Left = 480
    Top = 112
  end
  inherited tbOperadores: TADOTable
    Left = 520
    Top = 112
  end
  inherited tbTotRec: TADOTable
    Left = 560
    Top = 112
  end
  inherited tbSangrias: TADOTable
    Left = 600
    Top = 112
  end
  inherited tbVendasCartao: TADOTable
    Left = 648
    Top = 112
  end
  inherited qr: TADOQuery
    Left = 704
    Top = 160
  end
  object DataSource1: TDataSource
    DataSet = tbOperadores
    Left = 152
    Top = 184
  end
end
