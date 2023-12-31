unit uDescPedido;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, adLabelEdit, StdCtrls, ExtCtrls, adLabelNumericEdit, Grids,
  DBGrids, SoftDBGrid, DB, ADODB, TFlatButtonUnit, Menus ;
type
  TfmDescPed = class(TForm)
    dsPed: TDataSource;
    SoftDBGrid1: TSoftDBGrid;
    tpDesconto: TRadioGroup;
    nmPed: TadLabelEdit;
    btConsultaPed: TFlatButton;
    gridParcelas: TSoftDBGrid;
    gridEntrada: TSoftDBGrid;
    DataSource2: TDataSource;
    dtsEnt: TDataSource;
    tbEnt: TADOTable;
    tbParc: TADOTable;
    tbEntN: TIntegerField;
    tbEntValor: TFloatField;
    tbParcN: TIntegerField;
    tbParcVenc: TDateTimeField;
    tbParcValor: TFloatField;
    lbParcelas: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lbItens: TLabel;
    gridItens: TSoftDBGrid;
    Label1: TLabel;
    Label4: TLabel;
    dsItens: TDataSource;
    tbItens: TADOTable;
    GroupBox1: TGroupBox;
    gbDescCusto: TGroupBox;
    FlatButton2: TFlatButton;
    btConfirmaCusto: TFlatButton;
    FlatButton3: TFlatButton;
    FlatButton4: TFlatButton;
    edValor: TadLabelNumericEdit;
    GroupBox3: TGroupBox;
    gridAvarias: TSoftDBGrid;
    dsAvaItem: TDataSource;
    tbAvarias: TADOTable;
    FlatButton5: TFlatButton;
    btRetiraDoCaixa: TFlatButton;
    PopupMenu1: TPopupMenu;
    Exportar1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure tpDescontoClick(Sender: TObject);
    procedure btConsultaPedClick(Sender: TObject);
    procedure nmPedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    function criticaErroDesconto(vDesconto:real):String;
    procedure calculaDesconto(UsrAutorizador:string; vDesconto:real);
    function getSomaDasParcelas():real;
    function GetValorDesconto():real;
    procedure gridEntradaExit(Sender: TObject);
    procedure FlatButton3Click(Sender: TObject);
    procedure AplicarDesconto(vDesconto:Real;autorizador:string);
    procedure FlatButton2Click(Sender: TObject);
    function existeitemSemCusto(Sender:Tobject):string;
    procedure aplicaPrecoDeCusto(Sender:TObject);
    procedure btConfirmaCustoClick(Sender: TObject);
    procedure FlatButton4Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
//    procedure carregaItensPedido();
    procedure gravaDescAvarias(pedido:String);
    procedure gridItensCellClick(Column: TColumn);
    procedure gridAvariasKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tbAvariasBeforePost(DataSet: TDataSet);
    procedure FlatButton5Click(Sender: TObject);

    function getvDescontoAvarias():Real;
    procedure btRetiraDoCaixaClick(Sender: TObject);

    function getVlDescPorProduto():real;
    procedure Exportar1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
   TITULO  = '- Inserir desconto em Pedido';

var
  fmDescPed: TfmDescPed;
  nmpedido :string;
  IS_TELA_RESTRITA:boolean;
implementation

uses uMain, uCF, uDm, uUsuarios, f, msg, uPedCliente;

{$R *.dfm}

function TfmDescPed.getVlDescPorProduto():real;
var
   cmd:String;
   ds:TdataSet;
   aux:real;
begin
   cmd := ' select isnull(sum(valor),0) as valor from zcf_ItensDescEspeciais '+ #13+
          ' where is_ref in '  +#13+
          '  ( select seqItemPedido from itensPedidoCliente '+  #13+
          '    where numPedido= '+ dsPed.DataSet.fieldByName('Pedido').AsString +#13+
          '  )';
   ds:= dm.getDataSetQ(cmd);

   aux := ds.fieldByName('valor').AsFloat;
   ds.free;
   result := aux;
end;


function TfmDescPed.getValorDesconto: real;
var
  aux:real;
begin
   aux:=0;
   Case TpDesconto.ItemIndex of
      0:aux := edValor.Value;
      1:aux := (dsPed.DataSet.fieldByName('Vl Produtos').AsFloat * edValor.Value)  / 100;
      2:aux := dsPed.DataSet.fieldByName('Vl Produtos').AsFloat - edValor.Value ;
   end;
   result := aux;
end;

procedure TfmDescPed.tpDescontoClick(Sender: TObject);
begin
   case tpDesconto.ItemIndex of
      0:edValor.LabelDefs.Caption := 'Valor do desconto';
      1:edValor.LabelDefs.Caption := 'Percentual de desconto';
      2:edValor.LabelDefs.Caption := 'Valor desejado';
   end;
end;


procedure TfmDescPed.FormCreate(Sender: TObject);
var
  cmd:string;

begin
   tpDescontoClick(Sender);

   IS_TELA_RESTRITA :=  fmMain.isGrupoRestrito(fmMain.Descontodepedido1.Tag);

   fmDescPed.Caption := TITULO;

   if (IS_TELA_RESTRITA = true) then
      fmDescPed.Caption := TITULO + ' - Modo de Desconto de avarias.'
   else
      fmDescPed.Caption := TITULO + ' - Modo Normal.';

   if (IS_TELA_RESTRITA = true )  then
   begin
      gbDescCusto.Visible := false;
      label2.Visible := false;
      label3.Visible := false;

      gridParcelas.visible := false;
      gridEntrada.visible := false;
      tpdesconto.Enabled := false;
   end;

   tbParc.TableName :=  dm.getNomeTableTemp();
   cmd := ' create table ' + tbParc.TableName + ' ( N int, Venc SmallDateTime, Valor money)';
   dm.GetValorWell('E',cmd,'@@error');
   tbEnt.TableName := dm.getNomeTableTemp();
   cmd := ' create table ' + tbEnt.TableName + ' ( N int, Valor money)';
   dm.execSQL(cmd);

   fmMain.getParametrosForm(fmDescPed);
end;

{procedure TfmDescPed.carregaItensPedido();
var
   cmd:String;
begin
   dm.getTable(tbItens, dm.getCMD('pedCliente', 'getTbDecPed'));
   tbItens.Close();

   cmd :=  dm.getCMD2('pedCliente', 'getItensTbDescPed', tbItens.TableName, nmPed.Text );
   dm.execSQL(cmd);

   tbItens.Open();
   dsItens.DataSet := tbItens;

   gridItens.Refresh();
   f.ajGridCol(gridItens, tbItens, 'und', 50, 'Und');
   f.ajGridCol(gridItens, tbItens, 'origem', 100, 'origem');
   gridItens.columns[tbItens.FieldByname('seq').index].visible := false;
   gridItens.columns[tbItens.FieldByname('is_ref').index].visible := false;
   gridItens.columns[tbItens.FieldByname('codLoja').index].visible := false;

   edValor.Value := 0;
end;
}

procedure TfmDescPed.btConsultaPedClick(Sender: TObject);
var
   cmd:String;
begin
   nmPedido := nmPed.Text;
   cmd :=  '';

   dsPed.DataSet := uPedCliente.getDadosPedCliente(nmpedido);

	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'is_uo',0, '');
	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'loja', 100, 'Loja');
	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'cliente', 80, 'Cliente');
	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'St', 15, 'st');
	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'opera��o', 100, 'Opera��o');
	f.ajGridCol(SoftDBGrid1, dsPed.DataSet, 'tipoBloqueio', 30, 'Tp Bloq');

  // query das parcelas
   tbParc.close;
   if tbParc.TableName <> '' then
   begin
      cmd := 'truncate table ' + tbParc.TableName;
      dm.execSQL(cmd);
   end;

   cmd := ' insert ' + tbParc.TableName +' Select numParcela as N, dataVencimento AS Venc, valorParcela as Valor from parcelasPedidoCliente where numPedido = ' +nmPedido +' and tipoParcela = ''P'' ';
   dm.execSql(cmd);
   tbParc.Open;

   gridParcelas.Columns[0].Width := 20;
   gridParcelas.Columns[1].Width := 70;
   gridParcelas.Columns[2].Width := 70;

   // query da entrada
   tbEnt.close;
   if tbEnt.TableName <> '' then
   begin
      cmd := 'truncate table ' + tbEnt.TableName;
      dm.execSQL(cmd);
   end;

   cmd := ' insert ' + tbEnt.TableName + ' Select numParcela as N, valorParcela as Valor from parcelasPedidoCliente where numPedido = ' + nmPedido +' and tipoParcela = ''E'' ';
   dm.execSQL(cmd);

   tbEnt.Open;
   gridEntrada.Columns[0].Width := 20;
   gridEntrada.Columns[1].Width := 70;
   gridEntradaExit(Sender);

//   carregaItensPedido();
   carregaItensPedido(tbItens, dsItens, gridItens, nmPed.Text);


   uCF.getProdAvariadosParaVenda( tbAvarias, gridAvarias, nmPedido);

   if dsPed.DataSet.IsEmpty then
   begin
      msg.msgErro('N�o achei esse pedido.');
      dsPed.DataSet := nil;
   end;
   edValor.Enabled := true;
end;

procedure TfmDescPed.nmPedKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if key = vk_return then
      btConsultaPedClick(Sender);
end;

function TfmDescPed.getSomaDasParcelas: real;
var
   aux: real;
begin
   aux:=0;
   if tbEnt.IsEmpty = false then
      aux := aux + tbEnt.fieldByName('Valor').asFloat;

   if tbParc.IsEmpty = false then
   begin
       tbParc.First;
       while tbParc.Eof = false do
       begin
          aux := aux + tbParc.fieldByName('valor').AsFloat;
          tbParc.Next;
       end;
   end;
   getSomaDasParcelas := aux;
end;

function TfmDescPed.criticaErroDesconto(vDesconto:real):String;
var
   erro:string;
   vDescAvarias:real;
begin
   erro:= '';

   if (IS_TELA_RESTRITA = true ) then
   begin
      vDescAvarias := getvDescontoAvarias();

      vDescAvarias := vDescAvarias + getVlDescPorProduto();

      if (edValor.Value  > vDescAvarias + 0.10 ) then
         erro := erro + ' - O  desconto m�ximo, � de: R$ ' +  f.floatToMoney(vDescAvarias) + #13;
   end;

   if edValor.Value < 0 then
      erro := erro + ' - O valor/percentual do desconto n�o pode ser menor que zero. ' + #13;

   if tpDesconto.ItemIndex = 0 then
      if edValor.Value > dsPed.DataSet.FieldByName('Vl Pedido').asFloat then
         erro := erro + ' - O valor do desconto n�o pode ser maior que o valor da compra ' + #13;

   if tpDesconto.ItemIndex = 2 then
      if edValor.Value > dsPed.DataSet.FieldByName('Vl Pedido').asFloat then
         erro := erro + ' - O valor desejado n�o pode ser maior que o valor da compra ' + #13;

   if tpDesconto.ItemIndex = 1 then
      if edValor.Value > 100 then
         erro := erro + ' - O percentual de  desconto n�o pode ser maior que 100%' + #13;

   if dsPed.DataSet.FieldByName('st').AsString = 'F' then
      erro := erro + ' - O pedido j� foi recebido no caixa' + #13;

   if dsPed.DataSet.FieldByName('st').AsString = 'A' then
      erro := erro + ' - O pedido esta aberto' + #13;

   if dsPed.DataSet.FieldByName('st').AsString = 'C' then
      erro := erro + ' - O pedido esta cancelado' + #13;

   if (tbParc.IsEmpty = false) or (tbEnt.IsEmpty = false) then
      if FloatToStrF( getSomaDasParcelas() , ffNumber,18,02) <>
         FloatToStrF( dsPed.DataSet.fieldByName('Vl Produtos').AsFloat - vDesconto, ffNumber, 18,02)  then
      begin
         gridEntradaExit(nil);
         erro := erro + ' - O valor das parcelas est� diferente do valor do pedido ' +#13+
                        'Valor com desconto: '+ floattostrf(  dsPed.DataSet.fieldByName('Vl Produtos').AsFloat - vDesconto , ffNumber, 18, 2) +#13+
                        'Valor Parcelas: ' + floattostrf(  getSomaDasParcelas() , ffNumber, 18, 2) +#13 ;
      end;
   if erro <> '' then
   begin
      erro := '    Erro! '+#13 + erro;
      msg.msgErro(erro);
   end;
      result := erro;
end;

procedure TfmDescPed.calculaDesconto(UsrAutorizador:string; vDesconto:real);
var
   Strdesconto,cmd:string;
begin
   StrDesconto := f.StrToPrecoSQL( floattostr(vDesconto) );
   cmd :=  ' Update pedidoCliente set ValorDesconto = round(' + StrDesconto +', 2 ) , '+
           ' valorNota = valorTotal - round(' +  StrDesconto  +' ,2) , '+
           ' codUsuarioAutorizacao = ' + UsrAutorizador  +' , '+
           ' ValorBaseDescontoFechamentoVenda = valorTotal ' +
           ' , Seqfator= 0 ' +
           ' where numPedido = ' + dsPed.DataSet.fieldByName('Pedido').AsString;
   dm.execSQL(cmd);

//LANCA o valor da entrada
   if (tbEnt.IsEmpty = false ) then
   begin
      cmd := ' update parcelasPedidoCliente ' +
             ' set valorParcela = ' + f.StrToPrecoSQL( tbEnt.fieldByname('valor').AsString) +
             ' where numpedido = '  +  dsPed.DataSet.fieldByName('Pedido').asString +
             ' and NumParcela = 1 and TipoParcela = ''E''  ';

      dm.execSQL(cmd);
   end;
// Lanca o novo valor das parcelas

   if ( tbParc.IsEmpty = false) then
   begin
      tbParc.First;
      while (tbParc.Eof = false) do
      begin
         cmd := ' Update parcelasPedidoCliente ' +
                ' set valorParcela = ' + f.StrToPrecoSQL( tbParc.fieldByname('valor').AsString) +
                ' where numpedido = '  +  dsPed.DataSet.fieldByName('Pedido').asString +
                ' and NumParcela = ' + tbParc.fieldByname('N').AsString +
                ' and TipoParcela = ''P''  ';
         dm.execSQL(cmd);
         tbParc.Next;
      end;
   end;

   gravaDescAvarias(dsPed.DataSet.fieldByname('Pedido').asString);

   nmPed.Enabled := true;
   btConsultaPed.Enabled := true;
   btConsultaPedClick(nil);
   btConsultaPed.Enabled := true;
end;

procedure TfmDescPed.AplicarDesconto(vDesconto: Real; autorizador:string);
begin
   if (dsPed.DataSet.IsEmpty = false) and ( autorizador <> '' ) then
   begin
         if (dsPed.DataSet.FieldByName('Vl Desconto').AsFloat <> 0) or (dsPed.DataSet.FieldByName('% Desconto').AsFloat <> 0) then
         begin
            if msg.msgQuestion('Ja existe desconto nesse pedido.' +#13+ 'Se aplicar esse desconto o anterior ir� ser descartado. '+#13+ 'Continua? ') = mrYes then
               calculaDesconto(autorizador, vDesconto );
         end
         else
            calculaDesconto(autorizador, vDesconto );
   end
end;

procedure TfmDescPed.gridEntradaExit(Sender: TObject);
begin
     lbParcelas.Caption :=  'Total das parcelas: ' + floattostrf(getSomaDasParcelas() , ffNumber,18,02);
     lbItens.Caption :=  'Total do pedido : ' +   floattostrf(dsPed.DataSet.fieldByName('Vl Produtos').AsFloat -  GetValorDesconto() , ffNumber,18,02);
end;

function TfmDescPed.existeitemSemCusto(Sender: Tobject):String;
var
   cmd:String;
   ds:Tdataset;
   erro:string;
begin
   cmd := ' select dbo.Z_CF_funObterPrecoProduto_CF(7, is_ref, 10033674,0) as custoreal from CREFE WHERE ' +
                 ' IS_REF IN (SELECT seqProduto FROM itenspedidocliente WHERE numpedido = ' + nmPedido + ')';
   ds:= dm.getDataSetQ(cmd);

   cmd := '';
   if (ds.IsEmpty = false) then
   begin
      erro := ' Os seguintes produtos n�o t�m pre�o de custo real ( cod pre�o 07 ). ' +#13 + #13+
               erro +#13+#13+
              ' S� posso aplicar as modifica��es quando todos os produtos t�m pre�o de custo.';
       msgErro(erro);
       cmd := erro;
   end;
   ds.Free();
   result := cmd;
end;

procedure TfmDescPed.aplicaPrecoDeCusto(Sender: TObject);
var
   vpreco, cmd:string;
begin
//   vPreco := '1';
   vPreco := '7';

   cmd := ' update itensPedidoCliente set ' +
          ' valorPrecoSugerido =   round( (dbo.Z_CF_funObterPrecoProduto_CF('+ vPreco + ', seqProduto, 10033674, 0) / 0.83), 2) , ' + #13+
          ' precoUnitarioLiquido = round( (dbo.Z_CF_funObterPrecoProduto_CF('+ vPreco + ', seqProduto, 10033674, 0) / 0.83), 2), '  + #13+
          ' valorTotal =           round( ((dbo.Z_CF_funObterPrecoProduto_CF('+ vPreco + ', seqProduto, 10033674,0) / 0.83) * quantPedido), 2) '+
          ' where numpedido = ' + nmPedido;

   if (dm.execSQL(cmd) = false) then
   msg.msgErro('erro na altera��o itens ');

// alterar os valores do pedido
  cmd :=  ' update pedidoCliente set ' +
          ' valorNota =  round( ( Select Sum(valorTotal) from itenspedidocliente where numpedido = '+nmPedido +' ) ,2) , '+
          ' valorTotal = round( ( Select Sum(valorTotal) from itenspedidocliente where numpedido = '+nmPedido +' ) ,2) '+
          ' where numPedido = ' + nmPedido ;

   if (dm.openSQL(cmd, '@@error')  <> '0') then
      msg.msgErro('erro na altera��o dos valores do pedido');
end;

procedure TfmDescPed.btConfirmaCustoClick(Sender: TObject);
var
   usAutorizador: string;
begin
   usAutorizador := uUsuarios.getAutorizadorWell('', ' 13, 6, 8, 111 ', '');
   if usAutorizador <> '' then
   begin
      AplicarDesconto(0,usAutorizador);
      nmPed.Enabled := true;
      btConfirmaCusto.Enabled := false;
      btConsultaPed.Enabled := true;
      FlatButton2.Enabled := true;
      FlatButton3.Enabled := false;
      FlatButton4.Enabled := true;
      nmPedido := nmped.Text;
   end;
end;

procedure TfmDescPed.FlatButton4Click(Sender: TObject);
var
   vDesconto:real;
begin
   gridEntradaExit(Sender);
   vDesconto := GetValorDesconto();
   if criticaErroDesconto( vDesconto ) = ''  then
   begin
      nmPed.Enabled := false;
      FlatButton2.Enabled := false;
      btConsultaPed.Enabled := false;
      FlatButton4.Enabled := false;
      FlatButton3.Enabled := true;
      edValor.Enabled := false; 
   end;
end;

procedure TfmDescPed.FlatButton2Click(Sender: TObject);
begin
    if dsPed.DataSet.IsEmpty = false then
       if criticaErroDesconto(0) = '' then
          if msg.msgQuestion (' ATEN��O   ' +#13+
                         ' Esse modo de desconto � exclusivo para faturamento  ' + #13+
                         ' a pre�o de custo( custo real ) para a loja Maracanau.   '+#13+
                         ' Deseja relamente aplicar o pre�o real de custo ao pedido ???') = mrYes then
          begin
             if (existeitemSemCusto(nil) = '') then
             begin
                aplicaPrecoDeCusto(nil);
                btConsultaPedClick(Sender);
                if (tbParc.IsEmpty = false) or (tbEnt.IsEmpty = false  )then
                  showmessage('Ajuste os valores das parcelas do pedido e depois clique em  confirma pre�o de custo');

                nmPed.Enabled := false;
                btConfirmaCusto.Enabled := true;
                btConsultaPed.Enabled := false;
                FlatButton2.Enabled := false;
                FlatButton3.Enabled := false;
                FlatButton4.Enabled := false;
                nmPedido := nmped.Text;
              end;
         end;
end;

procedure TfmDescPed.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   fmDescPed := nil;
   ACTION := caFree
end;


procedure TfmDescPed.gravaDescAvarias(pedido:String);
var
  pcDesconto:String;
  cmd:String;
  isDescAvarias:boolean;
begin
   isDescAvarias := false;
   tbAvarias.First();
   while (tbAvarias.Eof = false) do
   begin
      if (tbAvarias.FieldByName('qtParaVenda').AsInteger > 0) then
      begin
         isDescAvarias := true;
         break
      end;
      break;
   end;

   if (isDescAvarias = true) then
   begin
      dm.execSQL('delete from zcf_avariasDescontos where is_uo = ' +tbItens.fieldByName('codLoja').asString +' and pedido = ' + dsPed.DataSet.fieldByName('pedido').asString);

      pcDesconto := dm.openSQL(' Select ((valorDesconto*100)/valorTotal)/100  as pcDesconto from pedidocliente (nolock) where numPedido= ' + pedido , 'pcDesconto');
      pcDesconto := f.ValorSql(pcDesconto);
      cmd := 'insert zcf_avariasDescontos ' +
             'select codLoja, getdate(), ' + dsPed.DataSet.fieldByName('pedido').asString  + ' , is_ref, qt, round( und - (und * '+ pcDesconto +'),2 ) , und, ' +
             '(Select dbo.z_cf_funObterPrecoProduto_cf(5, is_ref, '+ fmMain.getUoLogada() +', 0)) from ' + tbItens.TableName ;
      dm.execSQL(cmd);
   end;

   tbAvarias.First();
   while (tbAvarias.Eof = false) do
   begin
      if (tbAvarias.FieldByName('qtParaVenda').AsInteger > 0) then
      begin
         cmd := 'update zcf_avariasItens set qtVendido = qtVendido + ' + tbAvarias.FieldByName('qtParaVenda').asString +
                'where  ref = ' + tbAvarias.FieldByName('ref').asString;
         dm.execSQL(cmd);
      end;
      tbAvarias.next();
   end;
   dm.execSQL(cmd);
end;

procedure TfmDescPed.gridItensCellClick(Column: TColumn);
var
   cmd :String;
begin
   cmd := ' select L.DS_uo as Loja, a.numAvaria [Num Avaria], a.DataAprovacao [Data Aprovacao], i.pcoSugerido as [ Valor sugerido], ' +
          'i.obsItem as [Observa��o], i.ref from zcf_avariasItens i inner join zcf_avarias a on i.numAvaria = a.numAvaria '+
          'inner join zcf_tbuo L on i.loja = L.is_uo ' +
          'where i.is_ref = ' + tbItens.fieldByname('is_ref').asString;
end;

procedure TfmDescPed.gridAvariasKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (key = VK_RETUrn ) then key :=  VK_down
end;

procedure TfmDescPed.tbAvariasBeforePost(DataSet: TDataSet);
var
   erro:String;
begin
   if ( tbAvarias.fieldByName('qtParaVenda').AsInteger > tbAvarias.fieldByName('Disponivel').AsInteger ) then
      erro := 'A quantidade � maior que a diposnivel';

   if ( tbAvarias.fieldByName('qtParaVenda').AsInteger > tbItens.FieldByName('qt').asinteger ) then
      erro := 'A quantidade � maior que a do pedido';

   if ( tbAvarias.fieldByName('Disponivel').AsString = '' ) then
      erro := ' Ajuste a quantidade somente onde tem item.';

   if (erro <> '') then
   begin
      raise Exception.Create(erro);
      tbAvarias.Edit;
   end;
end;

function TfmDescPed.getvDescontoAvarias():real;
var
  vDesc:real;
begin
   gridAvarias.Visible := false;
   vDesc:=0;
   tbItens.First();
   while (tbItens.Eof = false) do
   begin
      tbAvarias.First();
      while (tbAvarias.Eof = false) do
      begin

         if (tbItens.FieldByName('is_ref').asString = tbAvarias.FieldByName('is_ref').asString) and
            (tbAvarias.FieldByName('qtParaVenda').asString <> '0')                              and
            (tbAvarias.FieldByName('pcoSugerido').asString <> '0')                              then
             vDesc := vDesc+ (tbItens.FieldByName('und').AsFloat - tbAvarias.FieldByName('pcoSugerido').AsFloat) * tbAvarias.FieldByName('qtParaVenda').AsFloat;

         tbAvarias.next();
      end;
      tbItens.Next();
   end;
   tbAvarias.First();
   tbItens.First();

   gridAvarias.Visible := true;
   result := vDesc;
end;



procedure TfmDescPed.FlatButton3Click(Sender: TObject);
var
   vDesconto:real;
   autorizador:String;
begin
   vDesconto := GetValorDesconto();
   if (criticaErroDesconto(vDesconto ) = '') then
   begin
      msg.msgExclamation('Verifica��o confirmada. ');

      autorizador := uUsuarios.getAutorizadorWell('', dm.getParamBD('205.grupos', ''), dm.getParamBD('205.users','') );

      if (autorizador <> '') then
      begin
         AplicarDesconto(vDesconto, autorizador);
         nmped.Text := '';
         nmped.Enabled  := true;
         btConsultaPed.Enabled := true;
         FlatButton4.Enabled := true;
         FlatButton3.Enabled := false;
         FlatButton2.Enabled := true;
         btConfirmaCusto.Enabled:= false;
         btConsultaPed.Enabled := true;
      end;
   end;
end;

procedure TfmDescPed.FlatButton5Click(Sender: TObject);
begin
   if (tbAvarias.IsEmpty = false) then
      edValor.Value:= getvDescontoAvarias();
end;

procedure TfmDescPed.btRetiraDoCaixaClick(Sender: TObject);
begin
   if nmPed.Text<> '' then
   begin
      dm.execSQL( dm.getCMD1('pedCliente','retdoCaixa', nmPed.Text)  );
      msg.msgExclamation('Pedido '+ nmPed.Text +' retirado do caixa...');
   end;
end;

procedure TfmDescPed.Exportar1Click(Sender: TObject);
begin
   fmMain.exportaDataSet(tbItens, TStringlist.Create());
end;

end.
