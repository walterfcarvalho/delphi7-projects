unit uProd;

interface

   uses classes, db, dialogs, ADODb, msg, uDM, fdt, f, windows, SysUtils,
        jpeg, controls, forms, ExtCtrls;

   function getCp(nmCpPesq, cpPesq, nmCpRetorno:String):String;
   function getDadosEntradaPorIslanc(is_lanc:String; vlDespExtra:real):TdataSet;
   function getDadosProd(uo, is_ref, ufE, ufD:String):TdataSet; overload;
   function getDadosProd(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean):TdataSet; overload;
   function getDadosProd(uo, cd_ref, preco:String; mostraMsg:boolean; tpEstoque:char):TdataSet; overload;
   function getDadosProd(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean; tpEstoque:char):TdataSet; overload;
   function getDadosProdBasico(uo, is_ref, pc, isDisponivel:String):tdataSet; overload;
   function getDadosProdBasico(uo, cd_ref, pc, isDisponivel, campo:String):tdataSet; overload;
   function getDadosProdCompleto(uo, is_ref, pc, isDisponivel:String):tdataSet;
   function getItensDigitado():TstringList; overload;

   function getDadosProdEst(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean; tpEstoque:char; ufE, ufD:String; isRetKit:boolean):TdataSet;
   function getDadosPrimEnt(is_ref:String):tdataSet;
   function getDataEntItem(is_ref, uo:String):TdataSet;

   function getDadosUltEntItem(is_ref, uo:String):TdataSet; overload;
   function getDadosUltEntItem(is_ref, uo:String; tpEntrada:String):TdataSet; overload;

   function getDadosUltMov(is_ref, is_uo, tp_mov:String):TdataSet;
   function getImagemProduto(is_ref:String; showItSemImg:boolean):TdataSet;
   function getIsRef(codigo:String):String;
   function getIsrefPorFaixaCodigo(cd_ref, numNivel, codCat:String; soAtivos:boolean;  dialogoRecCod:boolean):TdataSet; overload;
   function getIsrefPorFaixaCodigo(cd_ref, numNivel, codCat, uo:String; soQtPositiva:boolean; dialogoRecCod:boolean):TdataSet;overload;
   function getItens(isRefIni,isRefFim: String):TdataSet;
   function getItensFromListagem(isRefs:TStringlist):Tdataset;
   function getisLancUltEnt(is_ref, is_uo:String):TdataSet;
   function getIsrefsFromCdref(cdRefs:TStrings):TdataSet;
   function getMaiorQtVendPrd(is_ref, uo:String):String;
   function getProdVendidoPorData(di, df:Tdate):TdataSet;
   function getQtTransfPorPeriodo(uo, is_ref:String; dtIni, dtFim:Tdate):String;
   function listaProdutoPorPedido(strCat, pedido:String):TdataSet;
   function listaProdPorFornecedor(strCat, fornecedores, strAtivos:String ):TDataSet;
   function getStrCat(nivel, cat:String): String;
   function getStrAtivos(isAtivos:boolean):String;
   function getDadosUltSaiProd(uo, is_ref:String):Tdataset;
   function getVdItemDetPorLojaPeriodo(is_ref, uo:String; di, df:Tdate):TdataSet;
   function getVendaProduto(is_ref, uo :String; datai, dataf:Tdate):real; overload;
   function getVendaProduto(is_ref, uo :String; datai, dataf:Tdate; str:String):String; overload;
   function getDataEntrada(entradas:TdataSet; primOuUlt:String):String;
   function getTbVendaVarejoAtacado(uo, is_ref:String; di, df:TdateTime):String;
   function getTbProdutosDadosTotvs(cd_ref, ds_ref:String):String;
   function getItensFromXLS():TdataSet;

   procedure carregaImagem(is_ref:String; image: TImage; ShowItSemImg:boolean);
   procedure getIsRefFromItemPlanilha(colCod, colQt, nmTb:String);
   procedure AltEmbProd();
   procedure geraEanValido();
   procedure insereDadosTotvs(tb:TadoTable);
   procedure listaCustoDevendidos(uo:String; di, df:Tdate);


implementation

uses ufmSelColImport, uMain;


function getItensFromListagem(isRefs:TStringlist):Tdataset;
var
  cod:String;
  i:integer;
begin
	// mando uma listagem de is_Refs numa stringlist e devolvo o dataset

	if (isRefs.Count < 2) then
	   cod := isRefs[0]
   else
   begin
		for i:=0 to isRefs.Count-2 do
      	cod := cod + isRefs[i]+ ', ';
     	cod := cod + isRefs[isRefs.Count-1];
	end;
   cod := dm.getCMD1('estoque', 'getIsRefFromIsRefs', cod);
   result := dm.getDataSetQ(cod);
end;

function getDadosEntradaPorIslanc(is_lanc:String; vlDespExtra:real):TdataSet;
var
   cmd:String;
begin
	if (vlDespExtra < 0 )then
	   cmd := dm.getCMD2('preco', 'getDadosEntParaCusto', 'vl_dspExtra', is_lanc)
   else
	   cmd := dm.getCMD2('preco', 'getDadosEntParaCusto', valorSql(vlDespExtra), is_lanc);

   result := dm.getDataSetQ(cmd);
end;

function getisLancUltEnt(is_ref, is_uo:String):TdataSet;
var
  is_lanc, cmd:String;
  ds:TdataSet;
begin
   // retorna os dados da entrada para fazer o calculo do custo fiscal e do cmu

	ds:= uProd.getDataEntItem(is_ref, is_uo);

   if (ds.IsEmpty = false) then
      is_lanc := ds.fieldByName('is_lanc').AsString
   else
      is_lanc := '-1';

   ds.Free();

   result := getDadosEntradaPorIslanc(is_lanc, -1);
end;

function getIsref(codigo:String):String;
begin
   result := dm.openSQL(dm.getQtCMD3('Estoque', 'getIsref', codigo, codigo, ''), '' );
end;


function getDadosProdEst(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean; tpEstoque:char; ufE, ufD:String; isRetKit:boolean):TdataSet;
var
   codTpEst, cmd:String;
   ds:TdataSet;
   isForaDeData:boolean;
begin
   if (tpEstoque = 'D') then
      codTpEst := '1'
   else
      codTpEst := '0';

   ds:= TdataSet.Create(nil);
   if (cd_ref = '') and (is_ref = '') and (mostraMsg =true) then
      msg.msgErro(dm.getMsg('comum.cod'))
   else
   begin
      if (is_ref = '') then
        is_ref := getIsref(cd_ref);

      if (is_ref = '') then
      begin
      	f.gravaLog('is_ref nao cadastrado'+ is_ref);
         if (mostraMsg = true) then
            msg.msgErro( dm.getMsg('comum.codNaoCad') + '('+is_ref+' '+cd_ref + ')' );
      end
      else
      begin
         // testar se ja kit para o item
         ds:= dm.getDataSetQ(dm.getCMD2('Estoque', 'consKit', is_ref, fmMain.getUoEmpresa()));
         if (ds.IsEmpty = false) then
         begin
            isForaDeData :=
            ( ( fmMain.DATA_APLICACAO < ds.FieldByName('DataValidade').AsDateTime) or  (fmMain.DATA_APLICACAO > ds.FieldByName('DataValidadeFinal').AsDateTime));

            if (isForaDeData = true) then
               if  dm.getParamBD('comum.kitForaDeData', '0') = '1' then
                  isForaDeData := false;

            if (isForaDeData = false) then
               if (isRetKit = true) then
               begin
                  if (msgQuestion(dm.getCMD1('MSG', 'prdIsKit',  ds.fieldByName('ds_ref').AsString)) = mrYes) then
                     ds := dm.getDataSetQ('exec StoListarComponentesKits @CodProdutoKit= ' + ds.fieldByName('is_ref').AsString)
                  else
                  begin
                     cmd := dm.getCMD6('Estoque', 'getDadosProd', uo, preco, codTpEst, quotedStr(ufE), quotedStr(ufD), is_ref);
                     ds := dm.getDataSetQ(cmd);
                  end;
               end
               else
               begin
                  cmd := dm.getCMD6('Estoque', 'getDadosProd', uo, preco, codTpEst, quotedStr(ufE), quotedStr(ufD), is_ref);
                  ds := dm.getDataSetQ(cmd);
               end;

         end
         else
         begin
            cmd := dm.getCMD6('Estoque', 'getDadosProd', uo, preco, codTpEst, quotedStr(ufE), quotedStr(ufD), is_ref);
            ds := dm.getDataSetQ(cmd);
         end;

      end;
   end;
   result := ds;
end;

function getDadosProd(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean):TdataSet; overload;
begin
   //pega estoque disponivel
   result:= getDadosProdEst(uo, cd_ref, is_ref, preco, mostraMsg, 'D', 'CE', 'CE', false );
end;

function getDadosProd(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean; tpEstoque:char):TdataSet; overload;
begin
   result:= getDadosProdEst(uo, cd_ref, is_ref, preco, mostraMsg, UpCase(tpEstoque), 'CE', 'CE', false );
end;

function getDadosProd(uo, cd_ref, preco:String; mostraMsg:boolean; tpEstoque:char):TdataSet; overload;
begin
   result:= getDadosProd(uo, cd_ref, '', preco, mostraMsg, tpEstoque);
end;

function getDadosProd(uo, is_ref, ufE, ufD:String):TdataSet; overload;
begin
   //pega estoque disponivel
   result:= getDadosProdEst(uo, '', is_ref, '101', true, 'D', ufE, ufD, false);
end;

function getItens(isRefIni,isRefFim: String):TdataSet;
var
   cmd:String;
begin
   cmd := dm.getCMD2('estoque', 'getItensPorIsRef', isRefIni, isRefFim);
   result := dm.getDataSetQ(cmd);
end;

function getDataEntItem(is_ref, uo:String):TdataSet;
var
   cmd:String;
begin
// define a data da ultima entrada
   cmd := ' /* data ultima entrada */ select top 01 * from zcf_dsdei' +
          ' where '+
          ' is_ref= ' + is_ref ;

   if (uo <> '999') then
      cmd := cmd + ' and is_estoque= '+ uo ;

   cmd := cmd +
          ' and codTransacao=1 '+
          ' order by dt_mov desc';

   result := dm.getDataSetQ(cmd);
end;

function getDadosUltEntItem(is_ref, uo:String; tpEntrada:String):TdataSet; overload;
var
  cmd:String;
  ds:Tdataset;
begin
  f.gravaLog('getDadosUltEntItem('+is_ref+')');
  // pega a data da ultima entrada do produto na empresa

   ds:= getDataEntItem(is_ref, uo);
   if (ds.isEmpty = false) then
   begin
      cmd := ' /* qt ultima entrada */ select dt_mov, sum(qt_mov) as qt_Mov from zcf_dsdei' +
             ' where '+
             ' is_ref= ' + is_ref ;

      if (uo <> '999') then
         cmd := cmd + ' and is_estoque= '+ uo ;

      if tpEntrada <> '' then
         cmd := cmd + ' and codTransacao in (' + tpEntrada + ')';

      cmd := cmd +
             ' and dt_mov = ' + fdt.DateToSqlDate(ds.fieldByName('dt_mov').asString) +
             ' group by dt_mov';

      ds:= dm.getDataSetQ(cmd);
   end;
   result := ds;
end;

function getDadosUltEntItem(is_ref, uo:String):TdataSet; overload;
begin //
   result := getDadosUltEntItem(is_ref, uo, '1');
end;


function getDadosUltSaiProd(uo, is_ref:String):Tdataset;
var
   cmd:String;
begin
	if ( uo <> '999') then
   	uo := dm.getCMD1('estoque', 'getInfUltVd.uo', uo)
   else
   	uo := '';

	cmd := dm.getCMD2('estoque', 'getInfUltVd', is_ref, uo);
   result := dm.getDataSetQ(cmd);
end;

procedure geraEanValido();
var
  ean:String;
begin
  randomize;

  ean := '789';

  while length(ean) < 12 do
    ean := ean + intToStr(random(9));

  ean := ean + f.getDigVerEAN13(ean);

  ean := msg.msgInput('Para cancelar apague o c�digo.', ean);

  sleep(500);

  if (ean  <> '') then
     geraEanValido();
end;

function getProdVendidoPorData(di, df:Tdate):TdataSet;
var
	cmd:String;
begin
	cmd :=
   dm.getCMD2('vendas', 'getPrdVendPorData', fdt.dateToSqlDate(di), fdt.dateToSqlDate(df));
   result := dm.getDataSetQ(cmd);
end;

function getIsrefPorFaixaCodigo(cd_ref, numNivel, codCat:String; soAtivos:boolean; dialogoRecCod:boolean):TdataSet;overload;
var
  cmd:String;
begin
	f.gravaLog('getIsrefPorFaixaCodigo()');

   if (dialogoRecCod = true) and (cd_ref <> '0000000') then
      cd_ref := msg.msgInput(dm.getMsg('fmMapa.errFxCod'), '');

   if Length(cd_ref) < 3 then
      cd_ref := '0000000';

   cmd := 'Select is_ref, cd_ref from crefe (nolock)';

   if (numNivel <> '0') then
   	cmd := cmd + dm.getQtCMD2('geraEst', 'getItPed.Cat', numNivel, codCat );

    cmd := cmd + ' where crefe.cd_ref like ' + quotedStr( cd_ref + '%');

   if (soAtivos = true) then
      cmd := cmd + ' and crefe.fl_ativo = ''1''  order by cd_ref ';

   result := dm.getDataSetQ(cmd);
end;


function getIsrefPorFaixaCodigo(cd_ref, numNivel, codCat, uo:String; soQtPositiva:boolean; dialogoRecCod:boolean):TdataSet;overload;
var
	cmd:String;
   ds:TdataSet;
begin
   if (dialogoRecCod = true) then
      cd_ref := msg.msgInput(dm.getMsg('fmMapa.errFxCod'), '');

   if Length(cd_ref) < 3 then
      cd_ref := '0000000';

	ds := getIsrefPorFaixaCodigo(cd_ref, numNivel, codCat, true, false);

   cmd := 'Select is_ref from crefe (nolock)';

   if (numNivel <> '0') then
   	cmd := cmd + dm.getQtCMD2('geraEst', 'getItPed.Cat', numNivel, codCat );

   ds.First();
	cmd := cmd + ' where is_ref in ( ' + ds.fieldByname('is_ref').AsString;
   ds.Next();


	while ds.Eof = false do
   begin
		cmd := cmd + ', ' + ds.fieldByname('is_ref').AsString;
      ds.Next();
   end;

   cmd := cmd + ')';

   if (soQtPositiva = true )then
   	cmd := cmd + ' and dbo.z_cf_estoqueNaLoja(is_ref,' + uo + ', 0) > 0';

	cmd := cmd + ' order by cd_ref';

   f.gravaLog(cmd);

   result := dm.getDataSetQ(cmd);
end;

function listaProdutoPorPedido(strCat, pedido:String):TdataSet;
var
  cmd:String;
begin
   cmd := dm.getCMD2('geraEst', 'getItPed', strCat, pedido);
   result := dm.getDataSetQ(cmd);
end;

function listaProdPorFornecedor(strCat, fornecedores, strAtivos:String ):TDataSet;
var
	cmd:String;
begin
   cmd := dm.getCMD3('geraEst', 'getItForn', strCat, fornecedores, strAtivos);
   result := dm.getDataSetQ(cmd);
end;

function getStrCat(nivel, cat:String): String;
begin
   if (nivel <> '0') then
      result :=  dm.getQtCMD2('geraEst', 'getItPed.Cat', nivel, cat )
   else
      result := '/* */';
end;

function getStrAtivos(isAtivos:boolean):String;
begin
   if (isAtivos = true) then
      result := dm.getCMD('geraEst', 'getItAtivos')
   else
      result := '/* */';
end;


function getMaiorQtVendPrd(is_ref, uo:String):String;
begin
	if (uo = '999') then
		uo := ''
	else
		uo := dm.getCMD1('estoque', 'getqtMaiorVd.uo', uo);

	is_ref := dm.getCMD2('estoque', 'getqtMaiorVd', is_ref, uo);
   result := dm.openSQL(is_ref, '');
end;

function getDadosPrimEnt(is_ref:String):tdataSet;
var
	cmd:String;
begin
	cmd := dm.getCMD1('Estoque', 'getPrimEnt', is_ref);
	result := dm.getDataSetQ(cmd);
end;

function getVdItemDetPorLojaPeriodo(is_ref, uo:String; di, df:Tdate):TdataSet;
var
   cmd:String;
begin
	// Retorna a venda loja a loja

   cmd :=
   ' /* cf.getVdItemDetPorLojaPeriodo()*/ Select UO.ds_uo as Loja, sum(qt_mov) as qt_mov from zcf_dsdsi V with(nolock)'+
   ' inner join zcf_tbuo UO (nolock) on V.is_estoque = UO.Is_uo'+
   ' where' +
   ' V.dt_mov between '+
   fdt.dateTimeToSqlDateTime(di, '00:00:00') + ' and ' +
   fdt.dateTimeToSqlDateTime(df, '23:59:00') +
   ' and V.is_ref =  ' + is_ref ;

   if (uo <> '999') then
      cmd := cmd + ' and V.is_estoque = '+ uo
   else
      cmd := cmd + ' and V.is_estoque != 0';

   cmd := cmd + ' group by UO.ds_uo';

   result := dm.getDataSetQ(cmd);
end;

function getVendaProduto(is_ref, uo :String;  datai, dataf:Tdate; str:String):String; overload;
var
   res:real;
begin
   res := getVendaProduto(is_ref, uo, datai, dataf);
	result := floatTostrf( res, ffgeneral, 18, 0);
end;


function getVendaProduto(is_ref, uo :String; datai, dataf:Tdate):real; overload;
var
   ds:TdataSet;
begin
   ds:= getVdItemDetPorLojaPeriodo(is_ref, uo, datai, dataf);
   if ( ds.IsEmpty = true) then
      result := 0
   else
      result :=  dm.somaColunaTable(ds,'qt_mov');

   ds.free();
end;

function getDadosProdBasico(uo, is_ref, pc, isDisponivel:String):tdataSet; overload;
var
   cmd:String;
begin
	cmd :=
   dm.getCMD4('estoque','getDadosProdBasico', uo, is_ref, pc, isDisponivel);
	result := dm.getDataSetQ(cmd);
end;

function getDadosProdBasico(uo, cd_ref, pc, isDisponivel, campo:String):tdataSet; overload;
begin
	cd_ref := getIsRef(cd_ref);

   if cd_ref = '' then
   	cd_ref := '-1';

   result := getDadosProdBasico(uo, cd_ref, pc, isDisponivel);
end;


function getDataEntrada(entradas:TdataSet; primOuUlt:String):String;
var
   aux:String;
begin
   aux := '';
   if (entradas <> nil) and (entradas.isEmpty = false) then
   begin
      if ( upperCase(primOuUlt) = 'P') then
         entradas.last()
      else
         entradas.first();

      aux := entradas.fieldByName('data').AsString;
   end;
   result := aux;
end;

procedure getIsRefFromItemPlanilha(colCod, colQt, nmTb:String);
var
   tb:TADOTable;
   cod:String;
   dsIt:TdataSet;
   codOk, qtOk:boolean;
begin
	f.gravaLog('');
	f.gravaLog('validaItensPlanilha()');
	f.gravaLog('');


	tb:= TADOTAble.create(nil);
	tb.Connection := dm.con;
   tb.TableName := nmTb;
   tb.Open();

	tb.First();


   while (tb.Eof = false) do
   begin
   	codOk := true;
      qtOk := true;

   	f.gravaLog(
      	'Validando o item: ' + intToStr(tb.RecNo)
      );

		if (f.sohNumeros(tb.FieldByName(colCod).AsString) <> '') then
      begin
      	dsIt :=
         uprod.getDadosProd(
            fmMain.getUOCD(),
            trim(tb.FieldByName(colCod).AsString),
            '',
            '101',
            true
         );

	      if (dsIt.IsEmpty = true )then
	      	codOk := false;
      end
		else
      begin
      	dsIt := TdataSet.Create(nil);
      	codOk := false;
      end;

		if(dsIt <> nil) and (dsIt.IsEmpty = false)then
      begin
			if (f.sohNumeros(tb.FieldByName(colCod).AsString) <> trim(tb.FieldByName(colCod).AsString) ) then
         begin
            msg.msgErro( dm.getCMD1('MSG', 'msg_fil_excel_qt', f.sohNumeros(tb.FieldByName(colCod).AsString))) ;
         	qtOk := false;
         end;

      end;

		if (codOk = false) or ( qtOk = false) then
      	tb.Delete()
      else
      begin
      	tb.Edit();
         tb.FieldByName('is_ref').AsString := dsIt.FieldByName('is_ref').AsString;
         tb.FieldByName('qt_mov').AsString := trim(tb.FieldByName(colQt).AsString);
         tb.Post();
			tb.Next();
      end;

		dsIt.Free();
   end;
   tb.Close();
end;

function getItensFromXLS():TdataSet;
var
	colCod, colQt:String;
   nmTb, arq:String;
   isRefs:TStringlist;
begin
	colCod := '';
   colQt  := '';
   nmTb := '';

   arq :=
	f.dialogAbrArq('Arquivo de Planilha do Excel|*.XLS;*.xlsx', 'c:\' );

// ler os dados da planilha e montar uma tabela
   if (arq <> '') then
		nmTb :=	dm.getDsFromExcel(arq);

	if (nmTb <> '') then
   begin
   	application.createForm(TfmSelColImport, fmSelColImport);
   	fmSelColImport.carregaDadosTb(nmTb);
   	fmSelColImport.ShowModal();

      if (fmSelColImport.ModalResult = mrOk) then
      begin
      	colCod := fmSelColImport.cbCod.Items[fmSelColImport.cbCod.ItemIndex];
         colQt := fmSelColImport.cbQt.Items[fmSelColImport.cbQt.ItemIndex];

         // adiciona o is_ref aos itens da planilha
			getIsRefFromItemPlanilha(colCod, colQt, nmTb);

 		   result := dm.getDataSetQ( dm.getCMD1('estoque', 'getIsrefTbExcel', nmTb));
      end
      else
 		   result := dm.getDataSetQ('select is_ref from crefe where is_Ref < 0');

      fmSelColImport := nil;
   end
   else
      result := dm.getDataSetQ('select is_ref from crefe where is_Ref < 0');
end;

function getIsrefsFromCdref(cdRefs:TStrings):TdataSet;
var
  cod:String;
  i:integer;
  ds:TDataSet;
begin
	ds := TDataSet.Create(nil);

	if (cdRefs.Count > 0 )then
   begin
   	for i:=0 to cdRefs.Count-2 do
      	cod := cod + quotedStr(trim(cdRefs[i])) +', ';
    	cod := cod + quotedStr(trim(cdRefs[cdRefs.count -1]));

      ds := dm.getDataSetQ( dm.getCMD1('estoque', 'getIsRefFromCdrefs', cod)) ;
   end
   else
      ds := dm.getDataSetQ( 'select 0 as is_ref');

	result := ds;
end;

function getDadosUltMov(is_ref, is_uo, tp_mov:String):TdataSet;
var
   cmd:String;
begin
   cmd := dm.getCMD3('Estoque', 'getQtDiasSemMov', is_uo, is_ref, tp_mov);
	result := dm.getDataSetQ(cmd);
end;

function getQtTransfPorPeriodo(uo, is_ref:String; dtIni, dtFim:Tdate):String;
var
	ds:TdataSet;
   cmd:String;
begin
	cmd := dm.getCMD4('Estoque', 'getTrfPeriodo', uo, is_ref, fdt.dateToSqlDate(dtIni), fdt.dateToSqlDate(dtFim));

   ds:= dm.getDataSetQ(cmd);

	cmd := ds.FieldByName('qt_mov').AsString;

   if (cmd = '' )then
	   cmd := '0';

   ds.Free;
   result := cmd;
end;

function getDadosProdCompleto(uo, is_ref, pc, isDisponivel:String):tdataSet;
begin //
end;

function getItensDigitado():TstringList; overload;
var
	item:TStringList;
   continua:boolean;
   dsItem:Tdataset;
	codigo:String;
begin
   item := TStringlist.Create();

   continua := true;
   while (continua = true) do
   begin
		codigo := msg.msgInput('Digite o C�digo do produto ou EAN.', codigo);

 		if  (codigo <> '') then
      begin
	      dsItem := uProd.getDadosProd(fmMain.getUoLogada(), codigo, '', '101', true);
         if (dsItem.IsEmpty = false) then
         begin
            item.Add(dsItem.fieldByName('is_ref').AsString);
            continua := (msg.msgQuestion(dsItem.fieldByName('codigo').AsString + ' - '+dsItem.fieldByName('descricao').AsString +'#13'+ 'Mais algum produto ?') = mrYes )
         end;
         dsItem.Free();
         codigo := '';
      end
      else
      	continua := false;
   end;
   result := item;
end;

function getCp(nmCpPesq, cpPesq, nmCpRetorno:String):String;
var
	ds:TdataSet;
begin
	if (nmCpPesq = 'is_ref') then
		ds:= 	uProd.getDadosProdBasico(fmMain.getUOCD(), cpPesq, '101', '0')
   else
		ds:= 	uprod.getDadosProdBasico(fmMain.getUOCD(), cpPesq, '101', '0', 'esse campo n�o � usado');

   result := ds.fieldByName(nmCpRetorno).AsString;
   ds.Free();
end;

procedure AltEmbProd();
var
   cd_ref, cmd:string;
   ds:TdataSet;
   m:String;
begin
   cd_ref := msg.msgInput(dm.getMsg('infCodProd'), cd_ref);

   ds:= uProd.getDadosProdEst(fmMain.getGrupoLogado(), cd_ref, '', '101', true, '1', 'CE', 'CE', false);

   if (ds.IsEmpty = false) then
   begin
      m := dm.getCMD2('MSG', 'msgInsQtCx', ds.fieldByName('codigo').AsString +' '+ ds.fieldByName('descricao').AsString, ds.fieldByName('embalagem').AsString);

      cmd := msg.msgInput(m, '');

      if (cmd <> '') and (f.isNumero(cmd, true) = true) then
      begin
         cmd := dm.getCMD2('estoque', 'atuQtPorCaixa', cmd, ds.fieldByName('is_ref').AsString);
         dm.execSQL(cmd);
         msg.msgExclamation(dm.getMsg('altQtPrdOk'));
      end
      else
         msg.msgErro( dm.getMsg('errNumInval'));
   end;
end;

function getTbVendaVarejoAtacado(uo, is_ref:String; di, df:TdateTime):String;
var
   nmTbRes, nmTb, cmd:String;
   tbRes:TADOTable;
   ds:TDataSet;
   qv, qA:String;
   txtIsUo:String;
begin
   if (uo <> '999') then
      txtIsUo :=  dm.getCMD1('estoque', 'getUltimoIsLanc.uo', uo)
   else
      txtIsUo :=  '/*uo*/';

   nmTb := dm.criaTabelaTemporaria( dm.getCMD('Vendas', 'vdAtcVarGetTb'));

// rodar o comando para calcular em uma tabela
   cmd :=
   dm.getCMD7('Vendas', 'vdAtcVarP1',
      fdt.dateToSqlDate(di),
      fdt.dateToSqlDate(df),
      is_ref,
      nmTb,
      txtIsUo,
      nmTb,
      txtIsUo
   );
   dm.execSQL(cmd);

   nmTbRes := dm.criaTabelaTemporaria( dm.getCMD('Vendas', 'vdAtcVarTbDest'));

// popular a tabela de rerultados com a loja o qt zeradas
   if (uo <> '999') then
      dm.execSQL(dm.getCMD2('vendas', 'vdAtcVarTbDestPop', nmTbRes, ' and is_uo= '+uo ))
   else
      dm.execSQL(dm.getCMD2('vendas', 'vdAtcVarTbDestPop', nmTbRes, '/**/' ));

   tbRes := TADOTable.Create(nil);
   tbRes.Connection := dm.con;
   tbRes.TableName := nmTbRes;

   tbRes.Open();
   tbRes.First();
   while (tbRes.Eof = false) do
   begin
      tbRes.Edit();

      cmd := dm.getCMD3('vendas', 'vdAtcVar.getVlTpVend', nmTb, '101', tbRes.fieldByName('is_uo').AsString);
      qv := dm.openSQL(cmd, '');

      if (qV <> '') then
         tbRes.fieldByName('qtVarejo').AsString := qv;

      cmd := dm.getCMD3('vendas', 'vdAtcVar.getVlTpVend', nmTb, '103', tbRes.fieldByName('is_uo').AsString);
      qa := dm.openSQL(cmd, '');

      if (qA <> '') then
         tbRes.fieldByName('qtAtacado').AsString := qA;
      tbRes.Post();
      tbRes.Next();
   end;
   tbRes.Close();
   result := tbRes.TableName;
   tbRes.Free();
end;

function getTbProdutosDadosTotvs(cd_ref, ds_ref:String):String;
var
   nmTb, cmd:String;
begin
   if trim(ds_ref) <> '' then
      ds_ref:= ' and crefe.ds_ref like ' + quotedStr(ds_ref +'%');

   nmTb := dm.criaTabelaTemporaria( dm.getCMD('vendas', 'getCadDctotvs.Tb'));

   cmd := dm.getCMD3('Vendas', 'getCadDctotvs', nmTb,  quotedStr(cd_ref + '%'), ds_ref );
   dm.execSQL(cmd);

   result := nmTb;
end;

procedure insereDadosTotvs(tb:TadoTable);
var
   pdr, em, cmd:String;
begin
   if (tb.fieldByName('xPdr').AsString = '') then
      pdr := '0'
   else
      pdr := tb.fieldByName('xPdr').AsString;

   if (tb.fieldByName('xEm').AsString = '') then
      em := '0'
   else
      em := tb.fieldByName('xEM').AsString;


   cmd :=
   dm.getCMD3('vendas', 'getCadTotvsUp',
      tb.fieldByName('is_ref').AsString,
      pdr,
      em
   );

   dm.execSQL(cmd);
end;

procedure listaCustoDeVendidos(uo:String; di, df:Tdate);
var
   cmd:String;
   ds:TdataSet;
BEGIN
   cmd := dm.getCMD3('Vendas', 'lstCustoItVendidos', uo, fdt.dateToSqlDate(di), fdt.dateToSqlDate(df) );

   ds:= dm.getDataSetQ(cmd);

   fmMain.exportaDataSet(ds, nil);

END;

function getImagemProduto(is_ref:String; showItSemImg:boolean):TdataSet;
var
   cmd:String;
   ds:TdataSet;
begin
   screen.cursor := -11;
   cmd := ' select i.imagem from zcf_crefe_imagens i  where i.is_ref = ' + is_ref;
   ds:= dm.getDataSetQ(cmd);

   if (ds.IsEmpty = true) and (showItSemImg = true)  then
   begin
      cmd := ' select i.imagem from zcf_crefe_imagens i  where i.is_ref = ' + dm.getParamBD('comum.idImagemDefault', '');
      ds:= dm.getDataSetQ(cmd);
   end;
   result := ds;
   screen.cursor := crDefault;
end;

procedure carregaImagem(is_ref:String; image: TImage; ShowItSemImg:boolean);
var
  dsImagem:TdataSet;
begin
   screen.Cursor := crHourGlass;

   image.Picture.Assign(nil);
   image.Refresh();

   dsImagem := uProd.getImagemProduto( is_ref, ShowItSemImg );

   if not(dsImagem.IsEmpty) then
   begin
      Image.Picture.Assign(dsImagem.FieldByName('imagem'));
      image.Refresh();
   end;

   dsImagem.free();
   screen.Cursor := crDefault;
end;
{
procedure TfmGeraEstoque.getDadosEntrada(tb:TbAdoTable; uo:String; calculaEntSaiTotal:boolean);
var
   ds:TdataSet;
begin
//   uo := lojaAProcessar();

   if (CalculaEntSaiTotal.Checked = false) then
   begin
      tbGE.First();
      while (tbGE.Eof = false) do
      begin
         fmMain.msgStatusProgresso(tbGe.RecNo,  tbGE.RecordCount, 'Obtendo dados sobre as entradas...');

         ds:= uProd.getDadosUltEntItem(tbGE.fieldByName('is_ref').AsString, uo);
         if (ds.IsEmpty = false) then
         begin
            tbge.Edit();
            tbge.FieldByName('Data Ultima Ent').AsDateTime := ds.fieldByName('dt_mov').AsDateTime;
            tbge.FieldByName('Quant Ultima Ent').AsString := ds.fieldByName('qt_mov').asString;
            tbGE.post();
         end;
         ds.free;
         tbGE.Next();
      end;
   end
   else
   begin
      tbGE.First();
      while (tbGE.Eof = false) do
      begin
         ds:= uEstoque.getEntradasPorItem( tbGE.fieldByName('is_ref').AsString, uo, strToDate('01/01/2000'), now);

         if (ds.IsEmpty = false) then
         begin
            tbge.Edit();
            tbge.FieldByName('Data Ultima Ent').AsDateTime :=  strToDate( uProd.getDataEntrada(ds,'U'));
            tbge.FieldByName('Quant Ultima Ent').AsString := uEstoque.getTotalDeEntradasProduto(ds, false);
            tbGE.post();
         end;
         ds.free;
         tbGE.Next();
      end;
   end;
end;

}



end.
