{
  PERFIL = 2 REQUISICAO DE AASTECIMENTO
  PERFIL = 1 REQUISICAO DE VENDA
  PERFIL = 3 TELA DE APROVA��O
}
unit uOsDeposito;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, SoftDBGrid, TFlatButtonUnit, Math, StdCtrls, fCtrls,
  ADODB, DB, ExtCtrls, adLabelComboBox;

type
  TfmOsDeposito = class(TForm)
    grid: TSoftDBGrid;
    tb: TADOTable;
    DataSource1: TDataSource;
    Panel1: TPanel;
    btNova: TFlatButton;
    FlatButton2: TFlatButton;
    cbCritica: TfsCheckBox;
    cbLojas: TadLabelComboBox;
    cbDestReq: TadLabelComboBox;


    function  isEmSeparacao(is_ref:String; mostraMsgErro:boolean):Boolean;
    function  isQtPendente(uo, is_ref:String; showErro:boolean): Boolean;
    function isPrdMaison():boolean;
    function criticaQuantidade():String;
    function getValorMaxPedReabatecimento():Integer;
    procedure btNovaClick(Sender: TObject);
    procedure carregaTabelaRequisicao(uo:String);
    procedure cbCriticaClick(Sender: TObject);
    procedure cbDestReqClick(Sender: TObject);
    procedure cbLojasClick(Sender: TObject);
    procedure criaTabela();
    procedure destravaGrid(Sender:Tobject);
    procedure emailParaCD(nReq, uoCd, uo:String; itensNaoPed:TStringlist);
    procedure FlatButton2Click(Sender: TObject);
    procedure formatarGrid();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure geraRequisicaoReabastecimento();
    procedure GetDadosProdutos(cod:string);
    procedure gridColExit(Sender: TObject);
    procedure gridDblClick(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure preparaParaLiberarRequisicao();
    procedure preparaReqAbastecimento();
    procedure salvaReqAbastecimento(Sender:Tobject);
    procedure salvaReqVenda(Sender:Tobject);
    procedure setarParamReq();
    procedure setPerfil(P:integer);
    procedure tbAfterCancel(DataSet: TDataSet);
    procedure tbAfterOpen(DataSet: TDataSet);
    procedure tbAfterPost(DataSet: TDataSet);
    procedure tbBeforePost(DataSet: TDataSet);
    procedure tbPostError(DataSet: TDataSet; E: EDatabaseError; var Action: TDataAction);
    procedure travaGrid(Sender:Tobject);
    procedure FormCreate(Sender: TObject);

  private

     DS_ITEM:TdataSet;

    { Private declarations }
  public
    { Public declarations }
  end;
var
  fmOsDeposito: TfmOsDeposito;
  DUR_ESTOQUE, MESES_VD_MEDIA, MAX_ITENS_REQ, PERFIL,  QT_DIAS_PEND, MAX_LINHAS_TB: integer;
  CRITICA_PICKING, IS_VERIFICA_SEPARACAO, USA_QT_MAX_REQ, PEDE_PROD_MAISON,IS_REQ_SALVA:Boolean;
  IS_CRITICA_VD_MEDIA, UO_CD,  PC_VAREJO, COL_UO_MAPA_SEPARACAO, uProd:String;

  implementation

uses umain, f, fdt, cf, uUsuarios, uDm, uEstoque, msg, uLj, uReq, uProd;

{$R *.dfm}

function TfmOsDeposito.isPrdMaison: boolean;
begin
	result := (DS_ITEM.FieldByName('categoria').AsString = '15');
end;

procedure TfmOsDeposito.criaTabela();
begin
   dm.getTable(tb, dm.getCMD('Estoque', 'osDepCriaTbReq') );
end;

function TfmOsDeposito.getValorMaxPedReabatecimento():Integer;
var
  datai,dataf:Tdate;
  qtVenda,qtVendaSemestre, qtVendaMes: Real;
  diasDesdePrimVenda:integer;
//  cmd:String;
begin
   if ( IS_CRITICA_VD_MEDIA <> '0' ) then
   begin
      f.gravaLog ('Loja critica venda media' );
      fmMain.MsgStatus('Obtendo venda m�dia...');
      dataf := now();

//pega quantos dias desde a primeira venda
     diasDesdePrimVenda :=
     uEstoque.diasDesdeFirstVenda( tb.fieldByName('is_ref').AsString, fmMain.getUoLogada());


     if (diasDesdePrimVenda  > (MESES_VD_MEDIA * 30)) then
     begin
        datai := now - (MESES_VD_MEDIA * 30);
        diasDesdePrimVenda := (MESES_VD_MEDIA * 30);
     end
     else
        datai := now - diasDesdePrimVenda ;

//pegar a venda do ultimo semestre (ou antes, se houver)
      qtVendaSemestre :=   uProd.getVendaProduto(tb.fieldByname('is_ref').asString, fmMain.getUoLogada(), datai, dataf);
      f.gravaLog ( tb.fieldByname('codigo').asString + ' qtVendaUltimoSemestre: ' + floatToStr(qtVendaSemestre) );
      qtVendaSemestre :=  ( qtVendaSemestre / diasDesdePrimVenda ) * DUR_ESTOQUE;
      f.gravaLog ( tb.fieldByname('codigo').asString + ' Venda Media semestre: ' + floatToStr(qtVendaSemestre) );

//pegar a venda do ultimo mes
      qtVendaMes := uProd.getVendaProduto(tb.fieldByname('is_ref').asString, fmMain.getUoLogada(), datai-30, dataf);
      f.gravaLog ( tb.fieldByname('codigo').asString + ' qtVendaUltimoMes: ' + floatToStr(qtVendaMes) );
      qtVendaMes :=  ( qtVendaSemestre / 30 ) * DUR_ESTOQUE;
      f.gravaLog ( tb.fieldByname('codigo').asString + ' Venda Media mes: ' + floatToStr(qtVendaMes) );

      if (qtVendaSemestre > qtVendaMes) then
         qtVenda := qtVendaSemestre
      else
         qtVenda := qtVendaMes;

       if (qtVenda = 0) then
          qtVenda := 1;

      result := ( ceil( ( qtVenda / tb.fieldByname('Qt caixa').AsInteger))) *

      tb.fieldByname('Qt caixa').AsInteger + tb.fieldByname('Qt caixa').AsInteger;
   end
   else
   begin
      f.gravaLog ('Loja sem critica de venda para requisicao.' );
      result := tb.fieldByname('Est CD').AsInteger;
    end;
   fmMain.MsgStatus('');
end;

function TfmOsDeposito.isEmSeparacao(is_ref:String; mostraMsgErro:boolean):Boolean;
var
  cmd : String;
  ds:TDataSet;
  res:boolean;
begin
   res := false;

   fmMain.MsgStatus('Consultando mapa de separa��o.');

   cmd := dm.getCMD3('Estoque', 'osDepConsMapa', COL_UO_MAPA_SEPARACAO, is_ref, '');

   ds:= dm.getDataSetQ(cmd);

   if (ds.IsEmpty = false ) then
      if (ds.fieldByname('qtMapa').AsInteger > 0) then
      begin
         cmd := dm.getCMD3('msg', 'osDepErrMapa', ds.fieldByname('num').AsString, ds.fieldByname('qtMapa').AsString, '');
         msg.msgErro(cmd);
         res := true;
      end;
   ds.free();
   fmMain.MsgStatus('');
   result := res;
end;


function TfmOsDeposito.isQtPendente(uo, is_ref:String; showErro:boolean): Boolean;
var
  ds:TdataSet;
  cmd:String;
begin
   fmMain.MsgStatus('Verificando requisi��o pendente.');

   ds:=  uEstoque.isReqPendProduto(UO_CD, fmMain.getUoLogada, is_ref, QT_DIAS_PEND );
   if (ds.IsEmpty = false) then
   begin
      cmd := dm.getCMD3('MSG', 'osDepErrQtPend', IntToStr(QT_DIAS_PEND), ds.fieldByName('is_planod').AsString, ds.fieldByName('qt_ped').AsString);
      dm.setParam(cmd, ds.fieldByName('dt_movpd').AsString);

      if (showErro = true) then
         msg.msgErro(cmd);

      ds.free();

      if (PERFIL = 2) then
         result:= true
      else
         result:= false;
   end
   else
   begin
      ds.Destroy;
      result := false;
   end;
   fmMain.MsgStatus('');
end;

function TfmOsDeposito.criticaQuantidade():String;
var
   aux, erro:String;
begin
   f.gravaLog('criticaQuantidade()');

   if (DS_ITEM.IsEmpty = false) then
      aux := DS_ITEM.fieldbyname('cd_pes').AsString;

   if (DS_ITEM.fieldbyname('embalagem').AsInteger >= 1)  then
      if (cbCritica.Checked = false) then
         if  ( tb.FieldByName('Qt Pedida').AsInteger  mod DS_ITEM.fieldbyname('embalagem').AsInteger > 0 ) then
            erro := dm.getMsg('osDepQtCx') + ' '+  tb.fieldByName('qt caixa').AsString + ' unidades.' + #13;

   if (tb.FieldByName('is_Ref').AsString = '')  then
      erro := erro +' - Produto inv�lido. '+ #13;

   if (uEstoque.isPrdComPicking(DS_ITEM.fieldbyname('is_ref').AsString) = false) and
   	(CRITICA_PICKING = true) and
      (isPrdMaison() = false) then
   begin
      msg.msgErro( dm.getMsg('osDepErrPicking') );
      tb.Cancel;
   end
   else if (tb.Fields[1].asString = '0')  then
      erro := erro +  dm.getMsg('osDepErrQtZero')

   else if ( tb.FieldByName('Qt Pedida').AsInteger > tb.FieldByName('Est CD').AsInteger) then
      erro := erro + dm.getMsg('osDepQtNaoDisp')

   else if ( tb.FieldByName('Qt Pedida').AsInteger > (tb.FieldByName('Est CD').AsFloat/2) ) then
   begin   if cbCritica.Checked = false then
         msg.msgErro( dm.getMsg('osDepErrQtExcesso'))
   end;


   if PERFIL = 2 then
      if ( tb.FieldByName('Qt Pedida').AsInteger > tb.FieldByName('Pedido Maximo').AsInteger) then
         erro := erro +  dm.getMsg('osDepErrQtMax') + #13;

   if PERFIL = 1 then
      if (tb.RecordCount > MAX_ITENS_REQ) then
          erro := erro +  dm.getCMD1('msg', 'osDepQtIten', intToStr(MAX_ITENS_REQ));

   if (erro <> '') then
      msg.msgErro(erro);
   result := erro;
end;


procedure TfmOsDeposito.GetDadosProdutos(cod:string);
var
  cmd:string;
  itemEmSeparacao:boolean;
begin
   fmMain.MsgStatus('Consultando codigo.');

   if (DS_ITEM <> nil) then
      DS_ITEM.free();

// consulta o produto para ver se e cadastrado
   DS_ITEM := uProd.getDadosProd(UO_CD, cod, '', '101', true);

   destravaGrid(nil);

   if (DS_ITEM.IsEmpty = true) then
   begin
      f.gravaLog('ds_item vazio');
      tb.Cancel();
      tb.Append();
      grid.SelectedIndex :=  tb.fieldByName('Codigo').Index;
   end
   else if (PEDE_PROD_MAISON = false) and ( isPrdMaison() = true ) then
   begin
      cmd := dm.getMsg('osDepErrTpItem');
      dm.setParam(cmd, DS_ITEM.fieldByname('codigo').asString + ' ' + DS_ITEM.fieldByname('descricao').asString);
      msg.msgErro(cmd);
      tb.Cancel;
   end
   else
   begin
      if (perfil = 2) and (IS_VERIFICA_SEPARACAO = true) then
      begin
         itemEmSeparacao := isEmSeparacao(DS_ITEM.FieldByName('is_ref').AsString, true);

         if (itemEmSeparacao = true) then
          begin
             tb.Cancel();
             tb.Append();
             grid.SelectedIndex :=  tb.fieldByName('Codigo').Index;
          end;
       end;

      if ( isQtPendente(fmMain.getUoLogada(), DS_ITEM.FieldByName('is_ref').AsString, true ) = false) and(itemEmSeparacao = false) then
      begin
         tb.FieldByName('codigo').AsString := DS_ITEM.fieldByName('codigo').AsString;
         tb.FieldByName('Descricao').AsString := DS_ITEM.fieldByName('descricao').AsString;
         tb.FieldByName('Est CD').AsString := DS_ITEM.fieldByName('estoque').AsString;
         tb.FieldByName('qt caixa').AsString := DS_ITEM.fieldByName('embalagem').AsString;
         tb.FieldByName('is_ref').AsString := DS_ITEM.fieldByName('is_ref').AsString;

// pegar as informacoes do preco e estoque local
         fmMain.MsgStatus('Consultando dados de saldos...');

         destravaGrid(nil);

         DS_ITEM := uProd.getDadosProd( fmMain.getUoLogada(), cod, '', '101', false);

         tb.FieldByName('Est Loja').AsString := DS_ITEM.fieldByName('estoque').AsString;
         tb.FieldByName('Pc Loja').AsString := DS_ITEM.fieldByName('PRECO').AsString;

         if (perfil = 2) then
         begin
            if  (USA_QT_MAX_REQ = true) then
               tb.FieldByName('Pedido Maximo').AsInteger := getValorMaxPedReabatecimento()
            else
               tb.FieldByName('Pedido Maximo').AsInteger := tb.FieldByName('Est CD').asInteger;
         end;
      end;
   end;
   travaGrid(nil);
end;


procedure TfmOsDeposito.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   if (perfil = 2) and (tb.IsEmpty = false) then
     uEstoque.fechaSessaoReq(fmMain.getUoLogada(), UO_CD);

   if (perfil = 3 ) and (tb.IsEmpty = false) then
     uEstoque.fechaSessaoReq(fmMain.getUoLogada(), UO_CD);

   fmMain.MsgStatus ('');
   fmOsDeposito := nil;
   action := caFree;
end;

procedure TfmOsDeposito.gridColExit(Sender: TObject);
begin
   if (PERFIL <> 3) then
   begin
      if ( grid.SelectedIndex = tb.FieldByName('codigo').Index ) and ( grid.SelectedField.AsString <> '' ) then
         getDadosProdutos(grid.SelectedField.AsString);

      if ( grid.SelectedIndex = tb.FieldByName('Qt Pedida').Index) then
         if ( tb.FieldByName('is_ref').AsString <> '' ) then
         begin
             if (criticaQuantidade() <> '') then
             begin
                grid.SelectedIndex := tb.FieldByName('Qt Pedida').Index;
                tb.FieldByName('Qt Pedida').AsInteger := 0;
             end
             else
             begin
                tb.Post;
                tb.Append;
                grid.SelectedIndex := 0;
             end;
         end
         else
         begin
            grid.SelectedIndex := tb.FieldByName('codigo').Index;
            grid.SelectedIndex := tb.FieldByName('qt pedida').Index;            
         end;

   end
   else
      tb.cancel();

   fmMain.MsgStatus('');
end;

procedure TfmOsDeposito.travaGrid(Sender: Tobject);
begin
   grid.Columns[2].ReadOnly := true;
   grid.Columns[3].ReadOnly := true;
end;

procedure TfmOsDeposito.destravaGrid(Sender: Tobject);
begin
   grid.Columns[2].ReadOnly := false;
   grid.Columns[3].ReadOnly := false;
end;

procedure TfmOsDeposito.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (key = vk_return) or (key = vk_DOWN)then
     key  := vk_TaB;
end;


procedure TfmOsDeposito.tbPostError(DataSet: TDataSet; E: EDatabaseError;
  var Action: TDataAction);
begin
   if pos( 'Violation', e.Message ) > 0 then
   begin
      msg.msgWarning('Esse c�digo j� consta na requisi��o');
      action := daAbort;
      tb.Delete;
   end;
end;

procedure TfmOsDeposito.tbAfterPost(DataSet: TDataSet);
begin
   fmMain.MsgStatus('Itens na requisi��o: ' +  intTostr(tb.RecordCount) );
   IS_REQ_SALVA := false;
end;

procedure TfmOsDeposito.gridDblClick(Sender: TObject);
begin
    if (PERFIL <> 3) then
       if  msg.msgQuestion(' Remover esse item?') = mrYes then
       begin
          tb.Delete;
          tb.edit;
       end;
end;

procedure TfmOsDeposito.salvaReqVenda(Sender: Tobject);
var
  str:String;
  ocoItens:TStringList;
begin
   ocoItens:= TStringList.create();
   if tb.IsEmpty = false then
   str :=  uReq.gerarReq(tb, f.getCodUO(cbDestReq), fmMain.getUoLogada(),  fmMain.getUserLogado(), true, true, ocoItens, QT_DIAS_PEND);

   if (str <> '') then
   begin
      gravaLog('Requisicao gerada:' + str);

      emailParaCD(str, f.getCodUO(cbDestReq), fmMain.getUoLogada(), ocoItens );
   end;

   while (tb.IsEmpty = false) do
      tb.Delete;

   tb.close;
   ocoItens.free;
end;

procedure TfmOsDeposito.salvaReqAbastecimento(Sender: Tobject);
begin
   uReq.salvaReqAbastecimento(tb, fmMain.getUoLogada(), UO_CD );
end;

procedure TfmOsDeposito.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if (tb.IsEmpty = false) then
      if (IS_REQ_SALVA = false) then
         if (msg.msgQuestion('Deseja sair sem salvar ?') = mrNo) then
            canclose := false
end;

procedure TfmOsDeposito.gridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if key = VK_down then key := 0;
end;

procedure TfmOsDeposito.tbBeforePost(DataSet: TDataSet);
begin
   if (tb.FieldByName('Qt Pedida').AsInteger = 0) and (tb.FieldByName('Est CD').AsInteger <> 0)  then
    begin
      raise Exception.Create(dm.getMsg('osDepErrQtZero'));
      tb.Edit;
   end;

   if (tb.FieldByName('is_ref').AsString= '') then
   begin
      raise Exception.Create('Item inv�lido');
      tb.Edit;
   end;

   if (PERFIl = 1) then
	begin
   	if (tb.RecordCount >=  MAX_LINHAS_TB ) then
      begin
      	tb.Cancel();
      	msg.msgErro(dm.getCMD1('MSG', 'osDepReqMaxI', intToStr(MAX_LINHAS_TB)));
      end;
   end;

end;

procedure TfmOsDeposito.cbCriticaClick(Sender: TObject);
var
   grupos, users:String;
begin
   grupos:= dm.getParamBD('osDeposito.grupoAutorizador', '0');
   users := dm.getParamBD('osDeposito.usersAutorizador', '0');

   if (cbCritica.Enabled = true) then
   begin
      if cbCritica.Checked = true then
         if ( uUsuarios.getAutorizadorWell ('',grupos, users) <> '' )then
            cbCritica.Checked := true
         else
            cbCritica.Checked := false;
   end;
end;

procedure TfmOsDeposito.tbAfterCancel(DataSet: TDataSet);
begin
   tb.Edit;
end;

procedure TfmOsDeposito.carregaTabelaRequisicao(uo:String);
begin
  tb.Close();
   uReq.loadTableReq(tb.TableName, uo, UO_CD, PC_VAREJO);

   tb.Open();
   tb.Refresh();

   if (grid.Enabled = true) then
   begin
      formatarGrid();
      tb.Append();
   end;

   if tb.IsEmpty = true then
   begin
      msg.msgWarning('N�o h� itens para essa loja.');
      tb.Close();
      uEstoque.fechaSessaoReq(fmMain.getUoLogada(), UO_CD);
   end;
end;

procedure TfmOsDeposito.preparaReqabastecimento();
begin
   btNova.Visible := false;
	cbDestReq.Items := uLj.getCdRecebReq();

	MAX_LINHAS_TB := dm.getParamIntBD('osDeposito.maxitensReq', '0');

   cbDestReq.ItemIndex := -1;
   cbLojas.Visible := false;
   cbDestReq.Visible := true;
end;

procedure TfmOsDeposito.formatarGrid();
var
   i: integer;
begin
   f.gravaLog('formatarGrid()');
   if (tb.IsEmpty = false) then
   begin
      for i:=0 to grid.Columns.Count -1 do
        grid.Columns[i].Title.Font.Style := [fsbold];

      if (grid.Enabled = true) then
          grid.SetFocus;

      f.ajGridCol(grid, tb, 'is_ref', 0, '');

      f.ajGridCol(grid, tb, 'est cd', 70, 'Est Dep');
      f.ajGridCol(grid, tb, 'codigo', 70, 'C�digo');
      f.ajGridCol(grid, tb, 'Qt Pedida', 70, 'Qt Pedida');
      f.ajGridCol(grid, tb, 'Descricao', 250, 'Produto');

      if (f.dataSetTemCampo(tb,  'is_ref') = true )then
	      f.ajGridCol(grid, tb, 'is_ref', 0, '');

      f.ajGridCol(grid, tb, 'Pc Loja', 70, 'Pre�o Varejo');

      fmMain.MsgStatus('');

      if (perfil <> 2) then
        grid.Columns[tb.FieldByname('pedido maximo').Index].Visible := false;
   end;
end;

procedure TfmOsDeposito.preparaParaLiberarRequisicao();
begin
   UO_CD := fmMain.getUoLogada();

   uLj.getListaLojas(cbLojas, false, false, '', fmMain.getUoLogada());
   cbLojas.Visible := true;
   cbDestReq.Visible := false;
   btNova.Visible := false;
   grid.Enabled := false;
end;

procedure TfmOsDeposito.cbLojasClick(Sender: TObject);
begin
	setarParamReq();
   if (PERFIL = 3) then
   begin
      if ( uEstoque.isRequisicaoAberta( f.getCodUO(cbLojas), fmMain.getUoLogada(), fmMain.getUserLogado() ) = false) then
      begin
         uEstoque.criaSessaoReq( f.getCodUO(cbLojas), fmMain.getUoLogada(), fmMain.getUserLogado());
         criaTabela();
         carregaTabelaRequisicao( f.getCodUO(cbLojas) );

         formatarGrid();
      end;
   end;
end;

procedure TfmOsDeposito.geraRequisicaoReabastecimento();
var
  tbAux:TADOTable;
  uoRequisitora, aux, nGerados:String;
  i:integer;
  ocoReq, msgDeReq:Tstringlist;
begin
   f.gravaLog('geraRequisicaoReabastecimento()----Requisicao-------------');

   msgDeReq := TStringlist.create();

   ocoReq := TStringList.Create();

   uoRequisitora := f.getNumUO(cbLojas);

   nGerados := '';
   tb.First();

   while (tb.Eof = false) do
   begin
       dm.getTable(tbAux, dm.getCMD('req', 'getTbAbastec') );

      for i:= 1 to MAX_ITENS_REQ do
         if (tb.Eof = false) then
         begin
            tbAux.AppendRecord( [ tb.FieldByName('is_ref').asString, tb.FieldByName('codigo').asString, tb.FieldByName('descricao').asString, tb.FieldByName('Qt pedida').asString ]);
            tb.Next();
         end;

      aux := '';
      aux := uReq.gerarReq( tbAux, UO_CD, uoRequisitora, fmMain.getUserLogado(), false, false, ocoReq, QT_DIAS_PEND );

      if (aux <> '') then
         nGerados := nGerados  + aux + ' ';

       tbAux.free();
   end;

   if (nGerados <> '') then
   begin
      msg.msgExclamation('Foram geradas as requisi��es: ' + nGerados + #13+' Vou mandar um email para a loja, avisando.');

      emailParaCD(nGerados, UO_CD, uoRequisitora, ocoReq);

      if (ocoReq.Count > 0) then
      begin
         msgDeReq.Add('');
         msgDeReq.Add('Alguns produtos n�o foram requisitado, veja a lista abaixo:');
         for i := 0 to ocoReq.Count -1 do
            msgDeReq.add(ocoReq[i]);
      end;


      fmMain.EnviarEmail( dm.getEmail(uoRequisitora) ,'Requisi��es geradas para reabastecimento em ' + dateToStr(now),'', msgDeReq,'Requisi��es reabastecimento para: ' + uLj.getNomeUO(cbLojas) );
   end
   else
      msg.msgWarning( dm.getMsg('osDepSemReqs'));

   dm.execSQL('delete from zcf_dspd where is_uo=' + f.getNumUO(cbLojas) );
   uEstoque.fechaSessaoReq(uoRequisitora, UO_CD);
   tb.close();

   ocoReq.Free();
   msgDeReq.Free();
end;

procedure TfmOsDeposito.FlatButton2Click(Sender: TObject);
begin
  if (tb.IsEmpty = false) then
  begin
     case PERFIL of
        1:salvaReqVenda(nil);
        2:salvaReqAbastecimento(nil);
        3:geraRequisicaoReabastecimento();
     end;
     IS_REQ_SALVA := true;
  end;
end;

procedure TfmOsDeposito.emailParaCD( nReq, uoCd, uo: String; itensNaoPed:TStringlist);
var
    bodyEmail: TStringList;
    subject, aux:String;
    i:integer;
begin
   subject := 'Requisi��es venda/encarte geradas em ' + dateToStr(now);

   bodyEmail := TStringList.Create();
   bodyEmail.Add('Sr; ');
   bodyEmail.Add('Foi gerada uma requisi��o de venda/abastecimento para o cd.');
   bodyEmail.Add('Pela loja: ' +  uo  );
   bodyEmail.Add('N�mero(s) de requisi��o: ' +  nreq);
   bodyEmail.add('Feita por: ' + fmMain.getNomeUsuario() + ' em: '+ dm.getDataBd() );

   if (itensNaoPed <> nil) then
      if (itensNaoPed.Count > 0) then
      begin
         bodyEmail.add('Itens n�o requisitados:');

         for i:=0 to itensNaoPed.Count -1 do
            bodyEmail.add(itensNaoPed[i]);
      end;

   fmMain.EnviarEmail(dm.getEmail(fmMain.getUoLogada()), subject, '', bodyEmail, 'Enviando email para a loja geradora...');

   aux :=  dm.GetParamBD('emailDeRequisicao1', uoCd);
   if aux <> '' then
      fmMain.enviarEmail( aux , subject, '', bodyEmail, 'Email para ' + aux );

   aux :=  dm.GetParamBD('emailDeRequisicao2', uoCd);

   if (aux <> '') and (f.getIdxParam('-tray') > -1 ) then
      fmMain.enviarEmail( aux, subject, '', bodyEmail, 'Email para: ' + aux);
end;

procedure TfmOsDeposito.btNovaClick(Sender: TObject);
begin
   if tb.Active = false then
     criaTabela();

   if tb.IsEmpty = true then
      tb.Open
   else
   begin
      if (msg.msgQuestion( dm.getMsg('msgSairSemSalva'))= mrYes) then
          while tb.IsEmpty = false do
             tb.Delete;
    end;
    formatarGrid();
end;

procedure TfmOsDeposito.cbDestReqClick(Sender: TObject);
begin
   setarParamReq();

   UO_CD := f.getCodUO(cbDestReq);

   CRITICA_PICKING :=  dm.getParamBDBool('osDeposito.UsaPicking', UO_CD);

   if (PERFIL = 2) then
   begin
      if ( uEstoque.isRequisicaoAberta( fmMain.getUoLogada(), UO_CD, fmMain.getUserLogado() ) = false) then
      begin
         uEstoque.criaSessaoReq(fmMain.getUoLogada(), UO_CD, fmMain.getNomeUsuario() ) ;
         btNova.Enabled := false;
         criaTabela();
         carregaTabelaRequisicao( fmMain.getUoLogada());
//         formatarGrid();
      end
      else
         fmOsDeposito.Close();
   end;

   if ( PERFIL = 1) then
   begin
      criaTabela();
//      formatarGrid();
   end;
   formatarGrid();
end;

procedure TfmOsDeposito.setPerfil(P:integer);
begin
   PERFIL := P;

   f.gravaLog('-------------------------------<log> Requisicao, perfil ' + intToStr(PERFIL));

   case PERFIL of
      1,2:preparaReqAbastecimento();
      3:preparaParaLiberarRequisicao();
   end;
end;

procedure TfmOsDeposito.tbAfterOpen(DataSet: TDataSet);
begin
   formatarGrid();
end;

procedure TfmOsDeposito.setarParamReq;
begin
   f.gravaLog('TfmOsDeposito.setarParamReq()');

   IS_REQ_SALVA:=TRUE;
   QT_DIAS_PEND := strToInt(dm.GetParamBD('periodoParaReqPendentes',''));

   if (dm.getParamBD('PedeCat15DoCd', fmMain.getUoLogada()) <> '') then
      PEDE_PROD_MAISON := true
   else
      PEDE_PROD_MAISON := false;

   COL_UO_MAPA_SEPARACAO := 'l' + dm.openSQL('Select top 01 cd_uo from zcf_tbuo where is_uo = ' + fmMain.getUoLogada(), 'cd_uo');
   PC_VAREJO := dm.GetParamBD('pcVarejo', fmMain.getUoLogada() );
   MAX_ITENS_REQ := strToInt(dm.getParamBD('maxItensReqVenda', ''));
   MESES_VD_MEDIA :=  strToInt(dm.GetParamBD('mesesVendaMedia', '')  );
   DUR_ESTOQUE := strToInt(dm.GetParamBD('osDeposito.qtDiasDurEstoque', '')  );
   IS_CRITICA_VD_MEDIA := dm.GetParamBD('osDeposito.uosCriticaReq', fmMain.getUoLogada() ) ;
   IS_VERIFICA_SEPARACAO := (dm.GetParamBD('osDeposito.verificaSeparacao', '') <> '0');
   USA_QT_MAX_REQ := (dm.GetParamBD('osDeposito.usaQtMaxDeReq', '') <> '0');
   cbCritica.Enabled := (USA_QT_MAX_REQ);
end;


procedure TfmOsDeposito.FormCreate(Sender: TObject);
begin
	grid.Align := alClient;
end;

end.
