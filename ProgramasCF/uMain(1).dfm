object fmMain: TfmMain
  Left = 476
  Top = 174
  Width = 768
  Height = 502
  Caption = 'fmMain'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIForm
  KeyPreview = True
  Menu = menuPrincipal
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 432
    Width = 760
    Height = 19
    Panels = <
      item
        Width = 170
      end
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 150
      end>
  end
  object versao: TStaticText
    Left = 32
    Top = 16
    Width = 37
    Height = 17
    Caption = 'Versao'
    TabOrder = 1
    Visible = False
  end
  object sub_versao: TStaticText
    Left = 32
    Top = 40
    Width = 37
    Height = 17
    Caption = 'Versao'
    TabOrder = 2
    Visible = False
  end
  object menuPrincipal: TMainMenu
    Left = 56
    Top = 120
    object Estoques1: TMenuItem
      Tag = 100
      Caption = '&Estoques'
      object ConsultaaRequisies1: TMenuItem
        Tag = -101
        Caption = 'Fun'#231#245'es'
        object Analisedeestoque1: TMenuItem
          Tag = 110
          Caption = 'An'#225'lise de estoque para compras'
          OnClick = Analisedeestoque1Click
        end
        object Cadastrodeavarias1: TMenuItem
          Tag = 103
          Caption = 'Cadastro de avarias'
          OnClick = Cadastrodeavarias1Click
        end
        object Consultaarequisies2: TMenuItem
          Tag = 101
          Caption = 'Consulta a requisi'#231#245'es CD'
          OnClick = Consultaarequisies2Click
        end
        object ConsultaarequisioCDporproduto1: TMenuItem
          Tag = 107
          Caption = 'Consulta a requisi'#231#227'o  CD  - por produto'
          OnClick = ConsultaarequisioCDporproduto1Click
        end
        object Mapadeseparao1: TMenuItem
          Tag = 105
          Caption = 'Mapa de separa'#231#227'o'
          OnClick = Mapadeseparao1Click
        end
        object Requisicoentreloas1: TMenuItem
          Tag = 102
          Caption = 'Requisi'#231#227'o entre lojas'
          OnClick = Requisicoentreloas1Click
        end
        object Requisicaoparaocd1: TMenuItem
          Tag = 104
          Caption = 'Requisi'#231#227'o para o CD - vendas/encartes'
          OnClick = Requisicaoparaocd1Click
        end
        object Requisiodereposio1: TMenuItem
          Tag = 108
          Caption = 'Requisi'#231#227'o para o CD - Abastecimento'
          OnClick = Requisiodereposio1Click
        end
        object RequisioparaoCDAbastecimento1: TMenuItem
          Tag = 109
          Caption = 'Requisi'#231#227'o para o CD - Criar OS'
          OnClick = RequisioparaoCDAbastecimento1Click
        end
        object Cargadadosdasvendas1: TMenuItem
          Tag = 115
          Caption = 'Carga dados das vendas'
          OnClick = Cargadadosdasvendas1Click
        end
        object GeraReqvendaapartirdepedido1: TMenuItem
          Tag = 117
          Caption = 'Gera Requisi'#231#227'o de venda a partir de pedido'
          OnClick = GeraReqvendaapartirdepedido1Click
        end
        object Acertodeestoque1: TMenuItem
          Tag = 122
          Caption = 'Acerto de estoque'
          OnClick = Acertodeestoque1Click
        end
      end
      object Relatorios1: TMenuItem
        Tag = -102
        Caption = 'Relat'#243'rios'
        object Relacaodenotasdetransferncia1: TMenuItem
          Tag = 106
          Caption = 'Rela'#231#227'o de notas de  transfer'#234'ncia'
          OnClick = Relacaodenotasdetransferncia1Click
        end
        object Geraestoque1: TMenuItem
          Tag = 111
          Caption = 'Gera estoque'
          OnClick = Geraestoque1Click
        end
        object Produtostransferidos1: TMenuItem
          Tag = 112
          Caption = 'Listar itens por tipo de movimento.'
          OnClick = Produtostransferidos1Click
        end
        object Processarinventrio1: TMenuItem
          Tag = 113
          Caption = 'Relatorio de invent'#225'rio'
          OnClick = Processarinventrio1Click
        end
        object RazoAnalticoRRANA1: TMenuItem
          Tag = 114
          Caption = 'Raz'#227'o Anal'#237'tico RRANA'
          OnClick = RazoAnalticoRRANA1Click
        end
        object ListaItenssemmovimentao1: TMenuItem
          Tag = 118
          Caption = 'Lista Itens sem movimenta'#231#227'o'
          OnClick = ListaItenssemmovimentao1Click
        end
        object DadosEntradasadaevenda1: TMenuItem
          Tag = 123
          Caption = 'Lista '#250'ltima entrada/venda e m'#233'dia de venda'
          OnClick = DadosEntradasadaevenda1Click
        end
        object mnAnMovEstCd: TMenuItem
          Tag = 124
          Caption = 'An'#225'lise de movimento do estoque CD.'
          OnClick = mnAnMovEstCdClick
        end
      end
      object WMS1: TMenuItem
        Tag = -103
        Caption = 'WMS'
        object Cancelarrequisiespendentes1: TMenuItem
          Tag = 121
          Caption = 'Cancelar requisi'#231#245'es pendentes'
          OnClick = Cancelarrequisiespendentes1Click
        end
        object FinalizarOSnoWMS1: TMenuItem
          Tag = 120
          Caption = 'Finalizar OS no WMS'
          OnClick = FinalizarOSnoWMS1Click
        end
        object FinalizarnotadeentradanoWMS1: TMenuItem
          Tag = 119
          Caption = 'Finalizar nota de entrada no WMS'
          OnClick = FinalizarnotadeentradanoWMS1Click
        end
        object ListaItensemseparaonoCD1: TMenuItem
          Tag = 116
          Caption = 'Lista Itens em separa'#231#227'o no CD'
          OnClick = ListaItensemseparaonoCD1Click
        end
        object ListaitensmovimentadoswellxWms1: TMenuItem
          Tag = 125
          Caption = 'Lista itens por movimentos Well x Wms'
          OnClick = ListaitensmovimentadoswellxWms1Click
        end
        object ListaestoquedivergenteWellxWms1: TMenuItem
          Tag = 126
          Caption = 'Lista estoque divergente Well x Wms'
          OnClick = ListaestoquedivergenteWellxWms1Click
        end
        object Zerarpickingestoquenegativo1: TMenuItem
          Tag = 118
          Caption = 'Zerar pickings com estoque negativo'
          OnClick = Zerarpickingestoquenegativo1Click
        end
        object mnRestoreOs: TMenuItem
          Tag = 127
          Caption = 'Restaurar OS finalizada'
          OnClick = mnRestoreOsClick
        end
        object imprim1: TMenuItem
          Caption = '&Imprime etiquetas CD'
          OnClick = imprim1Click
        end
      end
    end
    object compras1: TMenuItem
      Tag = 600
      Caption = 'Compras'
      object Funes1: TMenuItem
        Tag = -601
        Caption = 'Fun'#231#245'es'
        object Classificaodepro1: TMenuItem
          Tag = 602
          Caption = 'Ajuste de categoria dos produtos'
          OnClick = Classificaodepro1Click
        end
        object Cadastrarcodigodebarrasdeproduto1: TMenuItem
          Tag = 603
          Caption = 'Cadastrar EAN de produto'
          OnClick = Cadastrarcodigodebarrasdeproduto1Click
        end
        object CadastrarNCM1: TMenuItem
          Tag = 604
          Caption = 'Cadastrar NCM dos itens de uma nota'
          OnClick = CadastrarNCM1Click
        end
        object Cadastrodeimagens1: TMenuItem
          Tag = 605
          Caption = 'Cadastro de imagens'
          OnClick = Cadastrodeimagens1Click
        end
        object RemoverEansinvalidos2: TMenuItem
          Tag = 606
          Caption = 'Remover EAN'#39'S invalidos'
          OnClick = RemoverEansinvalidos2Click
        end
        object Alterafornpedidodecompra1: TMenuItem
          Tag = 601
          Caption = 'Altera dados pedido de compra'
          OnClick = Alterafornpedidodecompra1Click
        end
        object GeraEANvlidoaleatrio1: TMenuItem
          Tag = 610
          Caption = 'Gera EAN v'#225'lido, aleat'#243'rio'
          OnClick = GeraEANvlidoaleatrio1Click
        end
        object AlterarQuantidadeporcaixa1: TMenuItem
          Tag = 612
          Caption = 'Alterar Quantidade por caixa'
          OnClick = AlterarQuantidadeporcaixa1Click
        end
        object CadastradadosparaoProtheus1: TMenuItem
          Caption = 'Cadastra dados para o Protheus'
          OnClick = CadastradadosparaoProtheus1Click
        end
      end
      object Relatrios1: TMenuItem
        Tag = -602
        Caption = 'Relat'#243'rios'
        object Listapedidosdecompra1: TMenuItem
          Tag = 607
          Caption = 'Lista pedidos de compra'
          OnClick = Listapedidosdecompra1Click
        end
        object Impressodepedidodefornecedor1: TMenuItem
          Tag = 609
          Caption = 'Impress'#227'o de pedido de fornecedor'
          OnClick = Impressodepedidodefornecedor1Click
        end
      end
    end
    object Preos1: TMenuItem
      Tag = 200
      Caption = '&Pre'#231'os'
      object abeladePreos1: TMenuItem
        Tag = -201
        Caption = 'Funcoes'
        object AjustedePrecos1: TMenuItem
          Tag = 204
          Caption = 'Ajuste de Precos'
          OnClick = AjustedePrecos1Click
        end
        object Descontodepedido1: TMenuItem
          Tag = 205
          Caption = 'Desconto de pedido'
          OnClick = Descontodepedido1Click
        end
        object Geracaopreodecusto1: TMenuItem
          Tag = 206
          Caption = 'Gera'#231#227'o de pre'#231'o de custo'
          OnClick = Geracaopreodecusto1Click
        end
      end
      object Precosalteradosporperodo1: TMenuItem
        Tag = -202
        Caption = 'Relatorios'
        object Precosalteradosporperodo2: TMenuItem
          Tag = 201
          Caption = 'Precos alterados por per'#237'odo'
          OnClick = Precosalteradosporperodo2Click
        end
        object abeladePreos2: TMenuItem
          Tag = 202
          Caption = 'Tabela de Pre'#231'os'
          OnClick = abeladePreos2Click
        end
        object Etiquetas1: TMenuItem
          Tag = 203
          Caption = 'Etiquetas de Codigo de barras'
          OnClick = Etiquetas1Click
        end
        object Listarcustodeitensporpedido1: TMenuItem
          Tag = 207
          Caption = 'Listar custo de itens por pedido'
          OnClick = Listarcustodeitensporpedido1Click
        end
        object Exportacaodeitesdepedido1: TMenuItem
          Tag = 208
          Caption = 'Exportacao de itens de pedido'
          OnClick = Exportacaodeitesdepedido1Click
        end
      end
    end
    object Fiscal1: TMenuItem
      Tag = 300
      Caption = '&Fiscal'
      object Funcoes2: TMenuItem
        Tag = -301
        Caption = 'Funcoes'
        object Ajustedenotas1: TMenuItem
          Tag = 302
          Caption = 'Ajuste de notas'
          OnClick = Ajustedenotas1Click
        end
        object AjustaNFJaboti1: TMenuItem
          Tag = 320
          Caption = 'Recalcula ICMS Nfe Transfer'#234'ncia'
          OnClick = AjustaNFJaboti1Click
        end
        object AjustedoarquivoSPED1: TMenuItem
          Tag = 301
          Caption = 'Ajuste do arquivo SPED'
          OnClick = AjustedoarquivoSPED1Click
        end
        object Comporavendafiscal1: TMenuItem
          Tag = 303
          Caption = 'Compor a venda fiscal'
          OnClick = Comporavendafiscal1Click
        end
        object EnviarXML1: TMenuItem
          Tag = 304
          Caption = 'Enviar XML de NFe por e-mail'
          OnClick = EnviarXML1Click
        end
        object EnviarespelhoPDFdeNFeparaemail1: TMenuItem
          Tag = 307
          Caption = 'Enviar DANFE por e-mail'
          OnClick = EnviarespelhoPDFdeNFeparaemail1Click
        end
        object ListaCuponspordia1: TMenuItem
          Tag = 310
          Caption = 'Lista Cupons por dia'
          OnClick = ListaCuponspordia1Click
        end
        object ImprimirDANFE1: TMenuItem
          Tag = 309
          Caption = 'Imprimir DANFE'
          OnClick = ImprimirDANFE1Click
        end
        object Saldofiscalpormes1: TMenuItem
          Tag = 306
          Caption = 'Saldo fiscal por mes'
          OnClick = Saldofiscalpormes1Click
        end
        object ImprimirNFe1: TMenuItem
          Tag = 305
          Caption = 'Visualizar DANFE'
          OnClick = visualizarDANFE
        end
        object ConfiguraSeriesparacontingencia1: TMenuItem
          Tag = 311
          Caption = 'Ativa desativada Emiss'#227'o NF-e em conting'#234'ncia'
          OnClick = ConfiguraSeriesparacontingencia1Click
        end
        object Ajustanumerodenota1: TMenuItem
          Tag = 313
          Caption = 'Ajusta n'#250'mero de nota'
          OnClick = Ajustanumerodenota1Click
        end
        object AjustachaveNFe1: TMenuItem
          Tag = 314
          Caption = 'Ajusta chave NFe'
          OnClick = AjustachaveNFe1Click
        end
        object BuscarnosservidoresXMLdeumanota1: TMenuItem
          Tag = 319
          Caption = 'Buscar nos servidores XML de uma nota'
        end
        object SalvarXMLdenfe1: TMenuItem
          Tag = 315
          Caption = 'Arquiva XML entradas'
          OnClick = SalvarXMLdenfe1Click
        end
        object PesquisaXML1: TMenuItem
          Tag = 316
          Caption = 'Pesquisa XML notas entrada'
          OnClick = PesquisaXML1Click
        end
        object Gerarumanotacomositensdeoutra1: TMenuItem
          Tag = 318
          Caption = 'Gerar NF com os itens de outra nota'
          OnClick = Gerarumanotacomositensdeoutra1Click
        end
        object mnSpedContabil: TMenuItem
          Tag = 321
          Caption = 'Sped PIS COFINS'
          OnClick = mnSpedContabilClick
        end
        object ReceberNotadeTransfernciaXML1: TMenuItem
          Tag = 322
          Caption = 'Receber Nota de Transfer'#234'ncia XML'
          OnClick = ReceberNotadeTransfernciaXML1Click
        end
      end
    end
    object Vendas1: TMenuItem
      Tag = 400
      Caption = '&Vendas'
      object Funcoes1: TMenuItem
        Tag = -401
        Caption = 'Funcoes'
        object DeletarRegistrodecartoTEF1: TMenuItem
          Tag = 405
          Caption = 'Ajuste de recebimento de caixa'
          OnClick = DeletarRegistrodecartoTEF1Click
        end
        object Ajustedecaddecidade1: TMenuItem
          Tag = 421
          Caption = 'Ajusta cadastro de cidade'
          OnClick = Ajustedecaddecidade1Click
        end
        object mnAprovaPedCli: TMenuItem
          Tag = 415
          Caption = 'Aprova pedido de Cliente'
          OnClick = mnAprovaPedCliClick
        end
        object Cargadedadosparaconciliao1: TMenuItem
          Tag = 407
          Caption = 'Carga de dados para concilia'#231#227'o'
          OnClick = Cargadedadosparaconciliao1Click
        end
        object Propostasdaloja1: TMenuItem
          Tag = 401
          Caption = 'Propostas da loja'
          OnClick = Propostasdaloja1Click
        end
        object CadastrodeCEP1: TMenuItem
          Tag = 408
          Caption = 'Cadastro de CEP'
          OnClick = CadastrodeCEP1Click
        end
        object ResumoCaixa1: TMenuItem
          Tag = 409
          Caption = 'ResumoCaixa'
        end
        object CrditodeCliente1: TMenuItem
          Tag = 410
          Caption = 'Ajuste de Cr'#233'dito de Cliente'
          OnClick = CrditodeCliente1Click
        end
        object Cadastrodebairros1: TMenuItem
          Tag = 411
          Caption = 'Cadastro de bairros'
          OnClick = Cadastrodebairros1Click
        end
        object mnResDiario: TMenuItem
          Tag = 414
          Caption = 'Resumo do movimento di'#225'rio'
          OnClick = mnResDiarioClick
        end
        object IncluirItememOramento1: TMenuItem
          Tag = 422
          Caption = 'Incluir Item em Or'#231'amento'
          OnClick = IncluirItememOramento1Click
        end
        object CalcularFatordopedido1: TMenuItem
          Tag = 423
          Caption = 'Calcular Fator do pedido (aproximado)'
          OnClick = CalcularFatordopedido1Click
        end
      end
      object Relatorios2: TMenuItem
        Tag = -402
        Caption = 'Relatorios'
        object AnaliseVLC1: TMenuItem
          Tag = 402
          Caption = 'Analise VLC'
          OnClick = AnaliseVLC1Click
        end
        object emiteGuiaEntrega: TMenuItem
          Tag = 412
          Caption = 'Emiss'#227'o da Guia de entrega'
          OnClick = emiteGuiaEntregaClick
        end
        object Etiquetasparatapetes1: TMenuItem
          Caption = 'Etiquetas para tapetes'
          OnClick = Etiquetasparatapetes1Click
        end
        object EtiquetasDeClientes1: TMenuItem
          Tag = 403
          Caption = 'Etiquetas De Clientes'
          OnClick = EtiquetasDeClientes1Click
        end
        object Fluxodeclientesporhora1: TMenuItem
          Tag = 416
          Caption = 'Fluxo de clientes por hora'
          OnClick = Fluxodeclientesporhora1Click
        end
        object mnRelCredCli: TMenuItem
          Tag = 418
          Caption = 'Lista cr'#233'ditos de cliente em aberto'
          OnClick = mnRelCredCliClick
        end
        object Pagamentosemcarto1: TMenuItem
          Tag = 406
          Caption = 'Pagamentos em cart'#227'o - pr'#233'via de caixa'
          OnClick = PagamentosEmCartao1Click
        end
        object RelatriodeComisso1: TMenuItem
          Tag = 404
          Caption = 'Relat'#243'rio de vendas por vendedor'
          OnClick = RelatriodeComisso1Click
        end
        object Rebibodevenda1: TMenuItem
          Tag = 413
          Caption = 'Recibo de venda'
          OnClick = Rebibodevenda1Click
        end
        object Vendabrutafornecedorvalor1: TMenuItem
          Tag = 417
          Caption = 'Venda bruta de fornecedor por valor'
          OnClick = Vendabrutafornecedorvalor1Click
        end
        object ListarDescontosporperodo1: TMenuItem
          Tag = 419
          Caption = 'Listar Vendas com Descontos por per'#237'odo'
          OnClick = ListarDescontosporperodo1Click
        end
        object Espelhodetrocadeprodutos1: TMenuItem
          Tag = 420
          Caption = 'Espelho de troca de produtos'
          OnClick = Espelhodetrocadeprodutos1Click
        end
        object ListaVarejoecustodeitensvendidos1: TMenuItem
          Caption = 'Lista Varejo e custo de itens vendidos'
          OnClick = ListaVarejoecustodeitensvendidos1Click
        end
      end
    end
    object administrao1: TMenuItem
      Tag = 500
      Caption = 'Administra'#231#227'o'
      object Contbil1: TMenuItem
        Tag = -501
        Caption = 'Cont'#225'bil'
        object Removerlancamentos1: TMenuItem
          Tag = 512
          Caption = 'Remover lancamentos/lotes.'
          OnClick = Removerlancamentos1Click
        end
        object Fichasdefornecedorpordata1: TMenuItem
          Tag = 506
          Caption = 'Fichas de fornecedor por data'
          OnClick = Compromissosdefornecedorespordata1Click
        end
        object Sincronizarplanodecontas1: TMenuItem
          Tag = 513
          Caption = 'Sincronizar plano de contas'
          OnClick = Sincronizarplanodecontas1Click
        end
        object Listafichasporcatcontabil1: TMenuItem
          Tag = 514
          Caption = 'Lista fichas por categoria contabil'
          OnClick = Listafichasporcatcontabil1Click
        end
      end
      object Permisses1: TMenuItem
        Tag = 501
        Caption = 'Permiss'#245'es'
        OnClick = Permisses2Click
      end
      object Fornecedoresaignorarnarequisio1: TMenuItem
        Tag = 503
        Caption = 'Fornecedores a ignorar na requisi'#231#227'o'
        OnClick = Fornecedoreacriticar1Click
      end
      object Mudafinanceiradeboleto1: TMenuItem
        Tag = 504
        Caption = 'Muda financeira de boleto'
        OnClick = Mudarfinanceiradeboleto1Click
      end
      object MudaversodoBD1: TMenuItem
        Tag = 505
        Caption = 'Muda vers'#227'o do BD'
        OnClick = Setaaversonobd1Click
      end
      object parmetrosdosistema1: TMenuItem
        Tag = 507
        Caption = 'Par'#226'metros do sistema'
        OnClick = parmetrosdosistema1Click
      end
      object Log1: TMenuItem
        Tag = 508
        Caption = 'Log'
        OnClick = Log1Click
      end
      object AlteraStatusdoCaixa1: TMenuItem
        Tag = 509
        Caption = 'Altera Status do Caixa'
        OnClick = AlteraStatusdoCaixa1Click
      end
      object ImpressorasNFE1: TMenuItem
        Tag = 510
        Caption = 'Impressoras NFE'
        OnClick = ImpressorasNFE1Click
      end
      object RotinasDiversas1: TMenuItem
        Tag = 511
        Caption = 'RotinasDiversas'
        OnClick = RotinasDiversas1Click
      end
      object Formatacomando1: TMenuItem
        Tag = 515
        Caption = 'Formata comando'
        OnClick = Formatacomando1Click
      end
    end
    object rocardeUsuario1: TMenuItem
      Tag = 700
      Caption = 'Trocar de Usu'#225'rio / Loja (F11)'
      ShortCut = 122
      OnClick = rocardeUsuario1Click
    end
    object N1: TMenuItem
      Tag = 800
      Caption = '  ...  '
      ImageIndex = 0
      ShortCut = 16506
      OnClick = N1Click
    end
  end
  object RvProject1: TRvProject
    Engine = RvSystem1
    Left = 8
    Top = 342
  end
  object RvSystem1: TRvSystem
    TitleSetup = 'Op'#231#245'es de impress'#227'o'
    TitleStatus = 'Status da impress'#227'o'
    TitlePreview = 'Previa da impress'#227'o'
    SystemSetups = [ssAllowSetup, ssAllowCopies, ssAllowDestPreview, ssAllowDestPrinter, ssAllowPrinterSetup, ssAllowPreviewSetup]
    DefaultDest = rdPrinter
    SystemFiler.StatusFormat = 'Generating page %p'
    SystemPreview.FormState = wsMaximized
    SystemPreview.ZoomFactor = 100.000000000000000000
    SystemPrinter.ScaleX = 100.000000000000000000
    SystemPrinter.ScaleY = 100.000000000000000000
    SystemPrinter.StatusFormat = 'Printing page %p'
    SystemPrinter.Title = 'ReportPrinter Report'
    SystemPrinter.UnitsFactor = 1.000000000000000000
    Left = 49
    Top = 344
  end
  object RvDSConn: TRvDataSetConnection
    RuntimeVisibility = rtEndUser
    Left = 80
    Top = 344
  end
  object RvDSConn2: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    Left = 112
    Top = 344
  end
  object RvRenderPDF1: TRvRenderPDF
    DisplayName = 'Adobe Acrobat (PDF)'
    FileExtension = '*.pdf'
    EmbedFonts = False
    ImageQuality = 45
    MetafileDPI = 150
    FontEncoding = feWinAnsiEncoding
    DocInfo.Creator = 'Rave (http://www.nevrona.com/rave)'
    DocInfo.Producer = 'Nevrona Designs'
    Left = 147
    Top = 344
  end
  object RvDSConn3: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    Left = 80
    Top = 376
  end
  object RvDSConn4: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    Left = 112
    Top = 376
  end
  object ApplicationEvents1: TApplicationEvents
    OnException = AppException
    Left = 16
    Top = 129
  end
  object mxOneInstance1: TmxOneInstance
    SwitchToPrevious = True
    Terminate = True
    Version = '1.2'
    OnInstanceExists = mxOneInstance1InstanceExists
    Left = 56
    Top = 160
  end
  object RvDSConn5: TRvDataSetConnection
    RuntimeVisibility = rtDeveloper
    Left = 147
    Top = 376
  end
  object CoolTrayIcon1: TCoolTrayIcon
    CycleInterval = 0
    ShowHint = False
    Icon.Data = {
      0000010001002020100000000000E80200001600000028000000200000004000
      0000010004000000000080020000000000000000000000000000000000000000
      000000008000008000000080800080000000800080008080000080808000C0C0
      C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF009999
      9999999999999999999999999999999999999999999999999999999999999999
      999999999999999999999999999999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB9999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB9999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB9999BBBBBB99999BBBBBB99BBBBBBBBB9999BB
      BB999999999BBBB99BBBBBBBBB9999BBB9999999999BBBB99BBBBBBBBB9999BB
      B999BBBB9999BBB99BBBBBBBBB9999BB999BBBBBB99BBBB99BBBBBBBBB9999BB
      999BBBBBBBBBBBB99BBBBBBBBB9999BB99BBBBBBBBBBBBB99999999BBB9999BB
      99BBBBBBBBBBBBB99999999BBB9999BB999BBBBBBBBBBBB99999999BBB9999BB
      999BBBBBB99BBBB99BBBBBBBBB9999BBB999BBBB9999BBB99BBBBBBBBB9999BB
      B9999999999BBBB999999999BB9999BBBB99999999BBBBB999999999BB9999BB
      BBBB99999BBBBBB999999999BB9999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB9999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB9999BBBBBBBBBBBBBBBBBBBBBBBBBBBB9999BB
      BBBBBBBBBBBBBBBBBBBBBBBBBB99999999999999999999999999999999999999
      9999999999999999999999999999999999999999999999999999999999990000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    IconVisible = False
    OnClick = CoolTrayIcon1Click
    Left = 16
    Top = 158
  end
  object ImageList1: TImageList
    Masked = False
    Left = 16
    Top = 184
    Bitmap = {
      494C010105000900040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080008000000080000000008080000080800000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000800000000080000000800000800000000080800000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000800000000080
      0000008000000080000000800000008000008000000000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800080000000008000000080
      00000080000000FF000000800000008000000080000080000000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000800000008000000080
      000000FF00000080800000FF0000008000000080000080000000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000FF00000080000000FF
      000000808000008080000080800000FF00000080000000800000800000000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008080000080800000FF00000080
      8000008080000080800000808000008080000080000000800000008000008000
      0000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      80000080800000808000008080000080800000FF000000800000008000000080
      0000800000000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000FF0000008000000080
      0000008000008000000000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      800000808000008080000080800000808000008080000080800000FF00000080
      0000008000000080000080000000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000FF00000080000000800000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      80000080800000FF000000800000008000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000FF0000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000080800000808000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000008080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00000000000000000000000000000000000000000080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0
      C00000FFFF000000000000000000000000000000000080808000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      00000000000000FFFF00C0C0C00000FFFF00C0C0C00000FFFF00C0C0C00000FF
      FF00C0C0C00000FFFF0000000000000000000000000080808000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF000000000000FFFF000000000000FFFF000000000000FFFF000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000FFFF000000000000FFFF000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000FFFF000000
      000000FFFF000000000000FFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000008080800080808000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000000FF
      FF000000000000FFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080008080800080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC00FC00FFFFFFFFF80079FF7FDFFFFFF
      A003AFFBF8FFFFFF9001B7FDF07FFFFFA801B801F23FFFFF954FBFEFF71FFFFF
      AAAFBFEFFF9FFFFF951FBF1FFFDFFFFFCAFFDEFFFFFFFFFFC0FFE1FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object mxDataSetExport1: TmxDataSetExport
    DateFormat = 'dd/MM/yyyy'
    TimeFormat = 'hh:mm'
    DateTimeFormat = 'hh:mm dd/MM/yyyy'
    ExportType = xtExcel
    ExportTypes = [xtHTML, xtExcel, xtWord, xtTXT, xtCSV, xtTAB, xtRTF, xtDIF, xtSYLK, xtClipboard]
    ExportStyle = xsView
    HTML.CustomColors.Background = clWhite
    HTML.CustomColors.DefaultLink = clRed
    HTML.CustomColors.DefaultFontFace = 'Arial,Helvetica'
    HTML.CustomColors.VisitedLink = clAqua
    HTML.CustomColors.ActiveLink = clBlue
    HTML.CustomColors.DefaultText = clBlack
    HTML.CustomColors.TableFontColor = clBlack
    HTML.CustomColors.TableFontFace = 'Arial,Helvetica'
    HTML.CustomColors.TableBackground = 16777167
    HTML.CustomColors.TableOddBackground = clWhite
    HTML.CustomColors.HeaderBackground = 3368601
    HTML.CustomColors.HeadersFontColor = clWhite
    HTML.Options = [hoShowGridLines, hoBoldHeaders, hoAutoLink, hoOddRowColoring, hoDisplayTitle]
    HTML.Template = ctStandard
    Messages.Caption = 'Exporting DataSet'
    Messages.CopiedToClipboard = 'Data was copied to clipboard!'
    Messages.CancelCaption = '&Cancel'
    Messages.CreatedText = 'Created:'
    Messages.DocumentFilter.HTML = 'HTML Documents'
    Messages.DocumentFilter.Excel = 'Excel Files'
    Messages.DocumentFilter.Word = 'Word Documents'
    Messages.DocumentFilter.Text = 'Text Files'
    Messages.DocumentFilter.Comma = 'CSV (Comma delimited)'
    Messages.DocumentFilter.Tab = 'Text (Tab delimited)'
    Messages.DocumentFilter.RTF = 'Rich Text Format'
    Messages.DocumentFilter.DIF = 'Data Interchange Format'
    Messages.DocumentFilter.SYLK = 'SYLK Files'
    Messages.ExportCaption = '&Export'
    Messages.ExportToFile = 'Export &to file'
    Messages.FalseText = 'False'
    Messages.Height = 80
    Messages.SaveTitle = 'Save document'
    Messages.SelectFormat = 'E&xport formats:'
    Messages.Text = 'Processing...'
    Messages.TrueText = 'True'
    Messages.Width = 300
    Messages.ViewOnly = '&View only'
    TruncateSymbol = '...'
    RowNumberFormat = '%d'
    DOC_RTF.Template = rtStandard
    DOC_RTF.Options = [roShowGridLines, roOddRowColoring]
    DOC_RTF.CustomSettings.TableBackground = 16777167
    DOC_RTF.CustomSettings.TableOddBackground = clWhite
    DOC_RTF.CustomSettings.HeaderBackground = 3368601
    DOC_RTF.CustomSettings.DefaultFont.Charset = DEFAULT_CHARSET
    DOC_RTF.CustomSettings.DefaultFont.Color = clWindowText
    DOC_RTF.CustomSettings.DefaultFont.Height = -11
    DOC_RTF.CustomSettings.DefaultFont.Name = 'MS Sans Serif'
    DOC_RTF.CustomSettings.DefaultFont.Style = []
    DOC_RTF.CustomSettings.HeaderFont.Charset = DEFAULT_CHARSET
    DOC_RTF.CustomSettings.HeaderFont.Color = clWindowText
    DOC_RTF.CustomSettings.HeaderFont.Height = -11
    DOC_RTF.CustomSettings.HeaderFont.Name = 'MS Sans Serif'
    DOC_RTF.CustomSettings.HeaderFont.Style = [fsBold]
    DOC_RTF.CustomSettings.TableFont.Charset = DEFAULT_CHARSET
    DOC_RTF.CustomSettings.TableFont.Color = clWindowText
    DOC_RTF.CustomSettings.TableFont.Height = -11
    DOC_RTF.CustomSettings.TableFont.Name = 'MS Sans Serif'
    DOC_RTF.CustomSettings.TableFont.Style = []
    DOC_RTF.CellWidth = 1400
    DOC_RTF.TopMargin = 101
    DOC_RTF.BottomMargin = 101
    DOC_RTF.LeftMargin = 461
    DOC_RTF.RightMargin = 562
    EXCEL.Options = [reSetMargins, reUseBorders]
    EXCEL.ColumnWidth = 20
    EXCEL.Protected = False
    EXCEL.Footer = '&P'
    EXCEL.DefaultFont.Charset = DEFAULT_CHARSET
    EXCEL.DefaultFont.Color = clWindowText
    EXCEL.DefaultFont.Height = -11
    EXCEL.DefaultFont.Name = 'MS Sans Serif'
    EXCEL.DefaultFont.Style = []
    EXCEL.HeaderFont.Charset = DEFAULT_CHARSET
    EXCEL.HeaderFont.Color = clWindowText
    EXCEL.HeaderFont.Height = -11
    EXCEL.HeaderFont.Name = 'MS Sans Serif'
    EXCEL.HeaderFont.Style = [fsBold]
    EXCEL.TableFont.Charset = DEFAULT_CHARSET
    EXCEL.TableFont.Color = clWindowText
    EXCEL.TableFont.Height = -11
    EXCEL.TableFont.Name = 'MS Sans Serif'
    EXCEL.TableFont.Style = []
    EXCEL.TopMargin = 0.300000000000000000
    EXCEL.BottomMargin = 0.300000000000000000
    EXCEL.LeftMargin = 0.300000000000000000
    EXCEL.RightMargin = 0.300000000000000000
    Options = [xoClipboardMessage, xoFooterLine, xoHeaderLine, xoShowExportDate, xoShowHeader, xoShowProgress, xoUseAlignments]
    Version = '2.37'
    Left = 376
    Top = 184
  end
end
