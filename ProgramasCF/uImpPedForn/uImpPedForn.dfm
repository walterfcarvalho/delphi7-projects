object fmImpPedForn: TfmImpPedForn
  Left = 552
  Top = 251
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Impress'#227'o de pedido a fornecedor'
  ClientHeight = 92
  ClientWidth = 415
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
  DesignSize = (
    415
    92)
  PixelsPerInch = 96
  TextHeight = 13
  object edNumPed: TadLabelEdit
    Left = 17
    Top = 33
    Width = 145
    Height = 19
    LabelDefs.Width = 87
    LabelDefs.Height = 13
    LabelDefs.Caption = 'N'#250'mero do pedido'
    Ctl3D = False
    ParentCtl3D = False
    MaxLength = 8
    TabOrder = 0
    OnKeyPress = edNumPedKeyPress
  end
  object btImprime: TfsBitBtn
    Left = 171
    Top = 26
    Width = 70
    Height = 30
    Anchors = [akTop]
    Caption = '&Imprimir'
    TabOrder = 1
    OnClick = btImprimeClick
    Glyph.Data = {
      66010000424D6601000000000000760000002800000014000000140000000100
      040000000000F000000000000000000000001000000010000000000000000000
      8000008000000080800080000000800080008080000080808000C0C0C0000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00DDDDDDDDDDDD
      DDDDDDDD0000DDDDDDDDDDDDDDDDDDDD0000DDDDD7777777777DDDDD0000DDDD
      000000000007DDDD0000DDD07878787870707DDD0000DD0000000000000707DD
      0000DD0F8F8F8AAA8F0007DD0000DD08F8F8F999F80707DD0000DD0000000000
      0008707D0000DD08F8F8F8F8F080807D0000DDD0000000000F08007D0000DDDD
      0BFFFBFFF0F080DD0000DDDDD0F00000F0000DDD0000DDDDD0FBFFFBFF0DDDDD
      0000DDDDDD0F00000F0DDDDD0000DDDDDD0FFBFFFBF0DDDD0000DDDDDDD00000
      0000DDDD0000DDDDDDDDDDDDDDDDDDDD0000DDDDDDDDDDDDDDDDDDDD0000DDDD
      DDDDDDDDDDDDDDDD0000}
  end
  object btExportar: TfsBitBtn
    Left = 327
    Top = 25
    Width = 70
    Height = 30
    Anchors = [akTop, akRight]
    Caption = 'Exportar'
    TabOrder = 2
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
  object btEmail: TfsBitBtn
    Left = 249
    Top = 26
    Width = 70
    Height = 30
    Anchors = [akTop]
    Caption = '&E-mail'
    TabOrder = 3
    OnClick = btEmailClick
    Glyph.Data = {
      F2060000424DF206000000000000360400002800000019000000190000000100
      080000000000BC020000C40E0000C40E00000001000000000000000000000000
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
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFFFFFFFF
      F6F6F6F6FFFFFFFFFFFFFFFFFFFFFF000000FFFFFFFFFFFFFF07A49B5B9B5B9B
      F707F6FFFFF6FFFFF6FFFF000000FFFFF6FFFF07A45B525B5B5B5B525B5BA407
      F6FFFFFFFFF6FF000000FFFFFFF6F752525B9B5B5B5B5B5B5B5B5252F7F6FFFF
      FFFFFF000000FFFFFFF752525B5B5B52525252525B5B9B9B52A4F6FFFFFFF600
      0000FFFFF75B5B9B5252A4F7070707F75B5B5B525252F7F6F6FFF6000000FF08
      5B5B5B525B07FFF6FFF6F6FFFF07A45B9B525B07FFFFFF000000FFF7529B525B
      07FF07A4525B5B9BF7FF085B5B5B52A4FFFFFF000000F65B5B5B52F7FFF7529B
      A45B5B9BA4A4A45B5B5B9B52F6FFF6000000075B5B5B5BF6F652A4FFFFF6F7FF
      FFF6A45B5B9B5B5BF7FFFF000000F7525B52A4FFF75BFFF6A407FFF6F708FF9B
      5B5B5B5BF7FFFF000000A4525B52F7FFA45BFF08525BF6FF9B52F6075B5B5B52
      A4FFFF000000A4525B52F7FFA452FFF69B52F7FFA45208FF5B5B5B52A4FFFF00
      0000F7525B52A4FFF752F6FFF752A4FF075207F69B5B5B52A4FFFF000000F752
      5B5B9BF608529BF6FF0708FFFF5207FF5B5B5B52F7FFF6000000085B5B9B5BF7
      FFF752F708F608F707A4F6075B5B5B5B07FFFF000000FF9B5B5B525B08FFF75B
      5B5B52529B07FF9B525B5B5BF6FFFF000000F60852525B525B07FFF607F7F708
      FFF6F7525B5B5BF7FFFFFF000000FFF6A4525B9B5252F708FFFFFFF607A4525B
      9B52A4F6FFFFF6000000FFFFF6A4525B9B5B525B5B9B9B5B52525B5B529B07FF
      FFF6FF000000FFFFFF08A452529B9B5B525B5B5B9B9B5B529B07FFF6FFFFFF00
      0000FFFFFFFFF6F79B52525B9B5B5B5B5B5252A408FFFFFFFFFFF6000000FFFF
      FFFFFFF607A45B525252525B9BA407FFFFFFFFFFFFFFFF000000FFFFFFFFFFFF
      FFF6F607F707070708FFFFFFF6F6FFFFF6FFFF000000}
  end
end