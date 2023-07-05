unit uFiscal;

interface

uses  QExtCtrls, f, Controls, SysUtils, classes, DB, ADODB, forms,
		dbClient,  XMLintf, Xmlxform, math;

	function ajDadosICMSItensNF(tbItens:TADOTable; sq_opf, cd_pes, uo:String):Boolean;
	function geraNotaApartirDeOutra(uo, cd_usu, cd_pesD, uoDestino, sq_opf, is_notaO, obs:String; usaFator:boolean):String;
	function gerarNf(cd_usu, uo, cd_pesD, uoDestino, usuario, sq_opf, obs:String; data:Tdate; is_notaO:String; usaFator:boolean; dsItNfOrigem:Tdataset):String;
   function getCampoCfo(ufEmis, ufDest, cd_sexo:String; codRegra:integer ):String;
   function getCfoNf(dsEmissor, dsDestino:TDataset):String;
	function getChaveXMLEnt(chaveXml:String):String;
	function getCuponsPorDia(uo, ecf:String; dti, dtf:Tdate):TdataSet;
	function getDadosIcmsItTmp(nmTbItens:String):Tdataset;
	function getDadosNota(is_nota:String):TADOquery;overload
	function getDadosNota(isNota, is_uo, sr_docf, nr_docf:String):TADOQuery; overload;
	function getDadosNota(isNota, is_uo, sr_docf, nr_docf:String; data:Tdate):TADOQuery; overload;
	function getDadosNota(notas:TStringlist):TADOQuery; overload;
	function getDadosNotaData(isNota, is_uo, sr_docf, nr_docf:String; di, df:Tdate):TADOQuery;
	function getDadosOprInt(sq_opf:String):TdataSet;
	function getDadosReducao(uo: String; di, df:Tdate; serieECF, empresa:string):TdataSet; overload;
	function getDadosReducao(uo: String; di, df:Tdate; serieECF:string):TdataSet; overload;
	function getDvModulo11(chave:String):String;
	function getIsNota():String;
	function getItensNota(isNota:String):TDataSet;
	function getNotasAgregadas(isNota:String; isReferenciado:boolean):TADOQuery;
	function getOperIntegradasFiscais():TStrings;
	function getOperIntOS():TStrings;
	procedure getPercICMItNf(is_ref, sexoDest, ufO, ufD, fl_icms:String; var pcIcm, tpIcm:String);
	function getProximoNumNF(uo, serie:String):String;
	function getStrInsertDMOVI(usuario, is_oper, is_nota, sr_docf, nr_docf, isDoc:String; data:Tdate; tbIt, dsTrans, dsUo, dsDest:TdataSet):TStringList;
	function getStrInsertDnota(is_emp, sq_opf, uo, cfo, is_nota, usuario, is_doc, is_oper, sr_docf, nr_docf, codCli, tpPreco, strValor, obsNota, isFilDest, entSai:String; data:Tdate ):String;
	function getStrInsertDsdoc(is_Emp, uo, is_doc, tpDoc, is_oper, codCli, usuario:String ; data:Tdate):String;
	function getStrInsertToper(is_emp, is_oper, sq_opf, cd_pes_Usuario, codTransacao:String; data:Tdate ):String;
   function getSrOperacao(uo, sq_opf:String):String;
	function getVendasEstornadas(uo, caixa:String; dti, dtf:Tdate):TdataSet;
	function getVendedorDaNota(isNota:String):String;
	function insereItemDeNota(dsI, dsN:TdataSet; is_ref, cd_usu:String):boolean;
	function isChNFeValida(chaveNfe:String): boolean;
	function isNotaDeVenda(isNota, codTransacao:String; mostraMsg:boolean):boolean;
	function isNotaExiste(uo, serie, numero:String):boolean;
	function procuraXmlNosServidores(isNota:String):String;
	function salvaChaveNFe(is_nota, chave:String):boolean;
	function salvarXmlNfe(opcao:String; caminhoArqXML, ipServidor, uo:String; dsXml:Tdataset):boolean;
	function salvaXmlEntrada(arq:String):boolean;
	function setObsNota(observacao, isNota:String):boolean;
	function upDadosNF(isNota, codTrans, cd_pes, sq_opf, cfo, obs:String; isCanc:boolean; vldspExtra:real; dtEmis, dtEntSai:Tdate; vNf, vitens, vlPrecDesc, vlDesc, vlDescItens, vlIpi, vlDespAce:String):boolean;

   function getTbItNfEntXml(xml:String):TStringlist;


	procedure ajustaContador(uo, srNota, numNovo:String);
	procedure ajustaDadosICM(tbICM:TdataSet; isNota, EntSai:String);
	procedure ajustaIcmdItem(tbItens:TadoTable);
   procedure aplicaCustoNfNoVa(uo, is_nota:String);
   procedure chamaRecalculoNf();
	procedure exportaXMLNota(is_nota:String; con:TADOConnection);
	procedure getTbAjNotas(tb:TADOTable; isNota:String);
	procedure getTbDadosIcmNf(tbIcms:TAdoTable; isNota:String);
   procedure gravaIcmNf(is_nota, sq_opf, entSai:String);
	procedure importarXmlNfe();
	procedure listaNotasVendaDia(tabela, uo:String; di, df:Tdate);
	procedure listaXmlEnt(qr:TADOQuery; serie, numero:String);
   procedure copiaRateioItens(dsNfO:TdataSet; is_NotaDest:String);
	procedure recalculaTotalItensNota(var tbIt:TADOTable);
   procedure recalcularValoresNf(is_nota:String; recalculaICM:boolean);
   procedure removeRegNfAgregada(is_nota:String;isAgregada:boolean);

	procedure sicVlIcmItensComNf(ds:TdataSet;tb:TAdotable; uo:String);
	procedure visualizaXmlEnt(uo, arquivo, chave:String);

   procedure chamaReceberTranfProtheus();

   function getItensNfFromXml(xml:String; uoEntrada:String; consultaProtheus:boolean):String;
   function getDadosNfFromXml(xml:String):String;


implementation

uses uDm,  fdt, uListaItensPorNota, uMain, uAcbr, uEnviaEmail, uUsuarios,
     msg, uLj, uFtp, uEstoque, uPessoa, uProd, uAjustaNota;

procedure gravaIcmNf(is_nota, sq_opf, entSai:String);
var
	tbItens:TadoTable;
   dsIcmIt:TdataSet;
begin
	f.gravaLog('uFiscal.gravaIcmNf()');
	f.gravaLog('Gravar na DNOTC');

   if (entSai = 'S') then
   	entSai := '1'
   else
   	entSai := '0';


// pegar o icms dos itens da nota
	tbItens := TADOTable.Create(nil);

   uFiscal.getTbajNotas(tbItens, is_nota);

   dsIcmIt :=  uFiscal.getDadosIcmsItTmp(tbItens.TableName);

	ajustaDadosICM(dsIcmIt, is_nota, entSai );

   tbItens.Free();
end;


procedure ajustaContador(uo, srNota, numNovo:String);
var
   cmd:String;
begin
	cmd := dm.getCMD3('fiscal', 'uodTserfil', f.SohNumeros(numNovo), uo, quotedStr(srNota));
   dm.execSQL(cmd);
end;

function getSrOperacao(uo, sq_opf:String):String;
begin
	// retorna a s�rie de uma operacao integrada
   result := dm. getCMD2('sql', 'getSrFromOf', uo, sq_opf);
end;

function getProximoNumNF(uo, serie:String):String;
var
   cmd:String;
begin
	cmd := dm.getCMD2('sql', 'getPrxNumNf', uo, quotedStr(serie));
   result := dm.openSQL(cmd, 'sq_nota');
end;

procedure getPercICMItNf(is_ref, sexoDest, ufO, ufD, fl_icms:String; var pcIcm, tpIcm:String);
var
  ds:TdataSet;
  codRegra:String;
  cmd:String;
begin
   cmd := dm.getQtCMD3('fiscal', 'getPcIcmItem', is_ref, ufO, ufD );

   ds:= dm.getDataSetQ(cmd);

   codRegra := ds.fieldByName('codRegra').AsString;

{   if ( codRegra= '12') or (codRegra = '16') or ( fl_icms = 'N') then
   begin
         pcIcm := '0';
         tpIcm := '6';
   end
   else
}   begin
      tpIcm :=  ds.fieldByName('tipoIcms').AsString;

      if (sexoDest = 'E') then
         pcIcm := ds.fieldByName('PercIcmsContribuinte').AsString
      else
         pcIcm := ds.fieldByName('PercIcmsNaoContribuinte').AsString;
	end;
   ds.Free();
end;

function getCampoCfo(ufEmis, ufDest, cd_sexo:String; codRegra:integer ):String;
var
	cfo:string;
begin
   // definir o cfo do item
   if ( ufEmis = ufDest )then
   begin
      case codRegra of
         12,16: cfo := 'cd_cfoI_st'
      else
         cfo := 'cd_cfoI';
      end;
   end
   else if ( (ufEmis = 'CE') and  (ufDest = 'GB') ) or ( (ufEmis = 'GB') and  (ufDest= 'CE') ) then
   begin

// criado para atender o bucho das lojas de estado = GB
   if (cd_sexo = 'E') then
   begin
      case codRegra of
         12,16: cfo := 'cd_cfoi_st'
      else
         cfo := 'cd_cfoI'
      end;
   end
   else
      cfo := 'cd_cfoI';
   end
   else
   begin
      if (cd_sexo = 'E') then
      begin
         case codRegra of
            12,16: cfo := 'cd_cfoe_st'
         else
            cfo := 'cd_cfoE'
         end;
      end
      else
         cfo := 'cd_cfoE';
   end;
   result := cfo;
end;


procedure exportaXMLNota(is_nota:String; con:TADOConnection);
var
  ds:TdataSet;
  msgEmail:Tstringlist;
  server, dirRemoto, dirLocal, arquivo:String;
begin
   ds :=  uFiscal.getDadosNota(is_nota , '', '', '');
   msgEmail := TStringList.create();

   if (ds.IsEmpty = true ) or ( ds.FieldByName('chave_acesso_nfe').asString = '') then
      msg.msgErro('N�o existe chave de acesso para essa nota. ')
   else
   begin
     try
        fmMain.MsgStatus('Solicitando arquivo XML...');

        server := dm.GetParamBD('ServerNFE.ip', ds.fieldByName('is_estoque').asString);

        dirRemoto :=
        dm.GetParamBD('ServerNFE.DirNFE', ds.fieldByName('is_estoque').asString )+
        fdt.getAnoMes(ds.fieldByName('dt_emis').asString)+'\';

        dirLocal :=  f.getDirLogs();
        arquivo:=  ds.FieldByName('chave_acesso_nfe').asString + '-NFE.XML';

        if ( uAcbr.getFileFromACBR(server, dirRemoto, dirLocal, arquivo ) = true) then
        begin
           msgEmail.Clear();
           msgEmail.add( 'Segue o XML da nota fiscal ' +  ds.FieldByName('Num').asString);
           msgEmail.add( 'Emitida pela loja: '+ ds.FieldByName('loja').asString );
           fmMain.enviarEmail('', 'Envio de XML nota fiscal eletr�nica', dirLocal+'\'+arquivo, msgEmail, 'Envio de XML' );
         end
       else
         msg.msgErro('N�o encontrei o XML dessa nota');
       msgEmail.Free();
     except
        on e:Exception do
          msg.msgErro('Erro ao processar o comando de captura do xml, '+#13+ 'Detalhes: ' + e.Message);
     end;
   end;
end;

function getIsNota():String;
var
  aux:String;
begin
   aux := '';
   application.CreateForm(TfmListaItensNota, fmListaItensNota );
   fmListaItensNota.ShowModal ;

   if (fmListaItensNota.ModalResult = mrOk) then
      aux := fmListaItensNota.Caption;

   fmListaItensNota := nil;
   result := aux;
end;

function getItensNota(isNota:String):TDataSet;
var
   cmd:String;
begin
   cmd :=  dm.getCMD('Fiscal', 'getItensNF');
   dm.setParam(cmd, isNota);
   result := dm.getDataSetQ(cmd);
end;

function getDvModulo11(chave:String):String;
var
   i,k : Integer;
   digito, Soma : Integer;
begin
   Soma := 0; k:= 2;
   for i := length(chave) downto 1 do
   begin
      Soma := Soma + (strToInt(chave[i])*k);
      inc(k);
      if k > 9 then
         k := 2;
   end;
   digito := 11 - soma mod 11;

   if (digito >= 10) then
      digito := 0;

   result := intToStr(digito);
end;


function isChNFeValida(chaveNfe:String): boolean;
var
   dvNFe, ultDig:String;
begin
   f.gravaLog('Validando a chave:'+ chaveNfe);
   Try
     chaveNfe := f.preencheCampo(44, '9', 'E', chaveNfe);
     ultDig := chaveNfe[length(chaveNfe)];
     dvNFe := getDvModulo11( copy(chaveNfe, 01, length(chaveNfe) -1) );
   except
      dvNFe := 'X';
   end;
  f.gravaLog('digitoCalculado: ' + dvNFe + ' ult digito:'+ ultDig);
  result := (dvNFe = ultDig);
end;

function salvaChaveNFe(is_nota, chave:String):boolean;
var
   ds:TdataSet;
   codNFe, cmd:String;
begin
   f.gravaLog('salvaChaveNFe(): is_nota:' +is_nota + ' chave:'+ chave );
   ds:= getDadosNota(is_nota, '', '', '');

   cmd :=
   'update dnota set codigo_nfe= null where is_nota= ' +
   ds.fieldByName('is_nota').asString;
   dm.execSQL(cmd);

// deleta a chave se tiver numero
   if (Length(ds.fieldByName('codigo_nfe').asString) > 10) then
   begin
      cmd :=
      'delete from  nf_eletronica where codigo_nfe= ' + ds.fieldByName('codigo_nfe').asString;
      dm.execSQL(cmd);
   end;

   if (chave <> '') then
   begin
      codNfe := dm.getContadorWell('CODIGO_NfE');
      cmd :=
      ' insert nf_eletronica values(' + codNfe + ' , -1, ''-'','+ quotedStr(chave)+ ', '''', '+
      fdt.dateToSqlDate( ds.fieldByName('dt_entsai').asString) +
      ', null, null)';
      dm.execSQL(cmd);

      cmd := 'update dnota set codigo_nfe= ' +quotedStr(codNFe) +
             'where is_nota= '+ is_nota ;
   end;
      result := dm.execSQL(cmd);
end;

function getOperIntegradasFiscais():TStrings;
var
  ds:TDataSet;
begin
   ds := dm.getDataSetQ( dm.getCMD('Fiscal', 'getOprint'));

   // formatar os itens da combo das operacoes no mesmo padrao das uos
   result := uLj.formataListaUos(ds, false, false );

   ds.free();
end;

function getOperIntOS():TStrings;
var
  ds:TDataSet;
begin
	// retorna as operacoes integradas que podem ser usadas oara tiar outras saidas/entradas
   ds := dm.getDataSetQ( dm.getCMD1('fiscal', 'getOprIntOs', dm.getParamBD('comum.sqopfParaNfBaseada', '')));

   // formatar os itens da combo das operacoes no mesmo padrao das uos
   result := f.getCpCombo(ds);

   //uLj.formataListaUos(ds, false, false );
   ds.free();
end;

function getNotasAgregadas(isNota:String; isReferenciado:boolean):TADOQuery;
var
   cmd:String;
   aux:TStringlist;
begin
   if (isReferenciado= true) then
   // retorna as notas que s�o agregadas
      cmd :=
      ' select is_nota from dnota where is_doc in( ' + #13+
      '    select is_doc from dsdocr where is_docRef in( ' + #13+
      '        select is_doc from dnota where is_nota=' + isNota +#13+
      '    ) '+#13+
      ' )'
   else
      cmd :=
      ' select is_nota from dnota where is_doc in( ' + #13+
      '    select is_docRef from dsdocr where is_doc in( ' + #13+
      '        select is_doc from dnota where is_nota=' + isNota +#13+
      '    ) '+ #13+
      ' )';

   aux := dm.getListagem(cmd, 0);

   if (aux.Count > 0) then
      result :=  getDadosNota(aux)
   else
      result :=  nil;
end;

procedure listaNotasVendaDia(tabela, uo:String; di, df:Tdate);
var
  campos, joins, where:String;
begin
   campos :=
   ' insert '+ tabela +
   ' select '+
   ' '''' as especie ' +#13+
   ' ,dnota.dt_emis '+#13+
   ' ,toper.codTransacao as transacao '+#13+
   ' ,dnota.sr_docf '+#13+
   ' ,dnota.nr_docf '+#13+
   ' ,dnota.vl_tot '+#13+
   ' ,dnota.vl_nota '+#13+
   ' ,dnota.cd_cfo '+#13+
   ' ,dnota.st_nf '+#13+
   ' ,dnotc.vl_base '+#13+
   ' ,dnotc.pc_icm '+#13+
   ' ,dnotc.vl_icm '+#13;

   joins :=
   ' from dnota  (nolock) '+#13+
   ' inner join toper (nolock) on dnota.is_oper = toper.is_oper '+#13+
   ' left join dnotc with (nolock) on dnota.is_estoque = dnotc.is_estoque '+
   ' and dnota.is_nota = dnotc.is_nota and dnotc.tp_icm in (1 ,2, 5) '+#13;
   where :=
   ' where '+#13+
   ' dnota.is_estoque = ' + uo  +#13+
   ' and dt_emis between ' + fdt.dateToSqlDate(di) +' and '
   + fdt.dateToSqlDate(df) +#13+
   ' and ((dnota.cd_cfo >=500  and dnota.cd_cfo <=800) or '+#13+
   '      (dnota.cd_cfo >=5000 and dnota.cd_cfo <=8000)) '+#13+
   ' and dnota.st_nf not in (''C'',''E'')';

   dm.execSQL(campos + joins + where);
end;

function getVendasEstornadas(uo, caixa:String; dti, dtf:Tdate):TdataSet;
var
   cmd:String;
begin
  cmd :=
  ' select S.dataSessaoCaixa, T.CodLoja, C.codCaixa, C.DescEstacao, dsmve.ds_mve,'+
  ' T.valorTransacao  from  sessoesdecaixa S'+
  ' inner join transacoesdocaixa T WITH(NOLOCK)'+
  ' on S.seqsessaocaixa = T.seqsessaocaixa and S.codloja = T.codloja'+
  ' inner join caixas C on s.codCaixa = C.codCaixa and S.codLoja = C.codLoja'+
  ' inner join modalidadespagtoportranscaixa M on M.seqTransacaoCaixa = T.seqtransacaoCaixa' +
  '       and m.entradaouSaida = ''S'''+
  ' inner join dsmve  on cd_mve = M.codModalidadePagto '+
  ' where' +
  ' S.dataSessaoCaixa between ' + fdt.dateToSqlDate(dti)+ ' and '
  + fdt.dateToSqlDate(dtf) + ' and T.tipotransacaoCaixa= ''E''';

  if ( uo <> '') and (uo <> '999') then
     cmd := cmd +' and S.codLoja= '+ uo ;

  if ( caixa <> '') then
     cmd := cmd + ' and C.codCaixa= ' + caixa;
  result := dm.getDataSetQ(cmd);
end;

function insereItemDeNota(dsI, dsN:TdataSet; is_ref, cd_usu:String):boolean;
var
  tpcte, is_movi:String;
  l:TStringList;
begin
   is_movi := dm.getContadorWell('is_movi');
   tpcte :=  quotedStr(dm.getParamBD('comum.ctEstAuditoria', '')); // conta da auditoria de distribuicao


   l := TStringList.create();
   l.add(' INSERT INTO DMOVI ( ');
   l.add('IS_ESTOQUE, IS_MOVI, CD_PES,IS_TPCTE, IS_REF, DT_MOVI,IS_OPER, IS_NOTA, ');
   l.add('CD_USU, DT_DIG, DT_EMIS, NR_DOCF, NR_ITEM, QT_MOV, SR_DOCF, sT_MOV, VL_MOVEST, ');
   l.add('VL_ITEM, PRECOUNITARIOLIQUIDO, CD_VEND, TP_ICM, CodigoSituacaoTributaria,');
   l.add('ValorIcms, ValorBaseIcms, Pc_ICM )' + #13);
   l.Add('values( ');
   l.add(      dsN.fieldByName('is_estoque').AsString );
   l.add(', '+ is_movi );
   l.add(', '+ dsN.fieldByName('cd_pes').AsString );
   l.add(', '+ tpcte );
   l.add(', '+ is_ref );
   l.add(', '+ fdt.dateToSqlDate(dsN.fieldByName('dt_entsai').asString) );
   l.add(', '+ dsN.fieldByName('is_oper').AsString );
   l.add(', '+ dsN.fieldByName('is_nota').AsString );
   l.add(', '+ cd_usu );
   l.add(', '+ fdt.dateToSqlDate(dsN.fieldByName('dt_entsai').asString) );
   l.add(', '+ fdt.dateToSqlDate(dsN.fieldByName('dt_emis').AsString) );
   l.add(', '+ dsN.fieldByName('num').AsString );
   l.add(', '+ '1' );
   l.add(', '+ '1' );
   l.add(', '+ quotedStr(dsN.fieldByName('serie').AsString) );
   l.add(', '+ '''''');
   l.add(', '+ f.valorSql( dsN.fieldByName('valor').AsString  ) );
   l.add(', '+ f.valorSql( dsN.fieldByName('valor').AsString  ) );
   l.add(', '+ f.valorSql( dsN.fieldByName('valor').AsString  ) );
   l.add(', '+ '''''');
   l.add(', '+ dsI.fieldByName('TP_ICM').AsString);
   l.add(', '+ '0');
   l.add(', '+ f.valorSql(dsN.fieldByName('vl_icm').AsString));
   l.add(', '+ f.valorSql(dsN.fieldByName('vl_icm').AsString));
   l.add(', '+ dsN.fieldByName('pc_icm').AsString );
   l.add(')');

   result := dm.execSQL( f.StringListToString(l, '#13') );
end;

function getDadosNotaData(isNota, is_uo, sr_docf, nr_docf:String; di, df:Tdate):TADOQuery;
var
   qr:TADOQuery;
   aux, cmd:String;
begin
   cmd := dm.getCMD('Fiscal', 'getNfL01') + dm.getCMD('Fiscal', 'getNfL02');

   if (isNota <> '') then
   begin
      aux := dm.getCmd('Fiscal', 'getNF.isNota');

      dm.setParam(aux, isNota);
      cmd := cmd +' '+ aux;
   end
   else
   begin
      if (sr_docf <> '') then
         cmd := cmd +' '+ dm.getQtCmd1('Fiscal', 'getNF.sr', sr_docf)
      else
         cmd := cmd +' '+ dm.getQtCmd1('Fiscal', 'getNF.semSr', '');

      if (nr_docf<> '') then
         cmd := cmd +' '+ dm.getQtCmd1('Fiscal', 'getNF.nr', nr_docf)
      else
         cmd := cmd +' '+ dm.getQtCmd1('Fiscal', 'getNF.semNr', '');

      if (is_uo <> '') and (is_uo <> '999') then
      begin
         aux := dm.getCmd('Fiscal', 'getNF.uo');
         dm.setQtParam(aux, is_uo);
         cmd := cmd +' '+ aux;
      end;

      if ( (di <> 0) or (df <> 0 ) ) then
      if (is_uo <> '') then
      begin
         aux := dm.getCmd('fiscal', 'getNF.dt');
         dm.setParam(aux, fdt.dateToSqlDate(di));
         dm.setParam(aux, fdt.dateToSqlDate(df));
         cmd := cmd +' '+ aux;
      end;
   end;

   cmd := cmd +' ' + dm.getCMD('fiscal', 'getNF.orderBy');

   qr := TADOQuery.Create(nil);
   dm.getQuery(qr, cmd );
   result := qr;
end;

function getDadosNota(isNota, is_uo, sr_docf, nr_docf:String):TADOQuery; overload;
begin
   result := getDadosNotaData(isNota, is_uo, sr_docf, nr_docf, 0, 0);
end;

function getDadosNota(isNota, is_uo, sr_docf, nr_docf:String; data:Tdate):TADOQuery; overload;
begin
   result := getDadosNotaData(isNota, is_uo, sr_docf, nr_docf, data, data);
end;


function getDadosNota(notas:TStringlist):TADOQuery; overload;
var
   i:integer;
   isNota:String;
begin
   for i:=0 to notas.count-2 do
      isNota := isNota + notas[i] +', ';

   isNota := isNota + notas[ notas.count-1];

   result := getDadosNota(isNota, '999', '', '');
end;

function getDadosNota(is_nota:String):TADOquery;overload
begin
   result := getDadosNotaData(is_Nota, '', '', '', 0, 0);
end;

function getVendedorDaNota(isNota:String):String;
var
  cmd:String;
begin
   cmd := dm.getCMD('Vendas', 'getVendDeUmaNota');
   dm.setParam(cmd, isNota);
   result := dm.openSQL(cmd, '');
end;

function setObsNota(observacao, isNota:String):boolean;
var
   cmd:String;
begin
   cmd := dm.getCMD('Fiscal', 'upObsNota');
   dm.setQtParams(cmd, observacao, isNota, '');

   result := dm.execSQL(cmd);
end;

function isNotaDeVenda(isNota, codTransacao:String; mostraMsg:boolean):boolean;
var
   aux:boolean;
   ds:TdataSet;
begin
   if (isNota <> '') then
   begin
     ds:= uFiscal.getDadosNota(isNota);
     codTransacao := ds.fieldByName('codTransacao').asString;
     ds.free();
   end;

   f.gravaLog(codTransacao + ' ' + dm.getParamBD('comum.opIntegradaVenda', ''));
   aux := ( pos( f.preencheCampo(2, '0', 'E', codTransacao), dm.getParamBD('comum.opIntegradaVenda', '') ) <> 0);

   if (aux = false) and (mostraMsg = true) then
      msg.msgErro(dm.getMsg('fiscal.errNotaVenda'));

   result := aux;
end;

procedure getSrNumProximaNota(uo, sq_opf:String; var sr_docf:String; var numDocf:String);
var
   cmd:String;
begin
// resolver qual serie a sq_opf usa
   cmd := dm.getCMD3('Fiscal', 'getSrDeOperacao', uo, sq_opf, '');
   sr_docf := dm.openSQL(cmd, '');

// retorna a proxima numeracao e reserva ela no contador

   cmd := dm.getCMD('Fiscal', 'getProxNumNF');
   dm.setParam(cmd, uo);
   dm.setQtParam(cmd, sr_docf);

   numDocf := dm.openSQL(cmd, '');

   f.gravaLog('Serie:' + sr_docf + ' num_doc:' + numDocf);
end;

function getStrInsertToper(is_emp, is_oper, sq_opf, cd_pes_Usuario, codTransacao:String; data:Tdate ):String;
begin
   f.gravaLog('getStrInsertToper()');
   result :=
   dm.getCMD7('sql', 'insToper',
   	is_oper,
		fdt.dateTimeToSqlDateTime(data, timeToStr(now)),
      is_emp,
      sq_opf,
		fdt.DateTimeToSqlDateTime(data, timeToStr(now)),
      cd_pes_Usuario,
      codTransacao
   )
end;

function getStrInsertDsdoc(is_Emp, uo, is_doc, tpDoc, is_oper, codCli, usuario:String ; data:Tdate):String;
var
   cmd:String;
begin
   f.gravaLog('getStrInsertDsdoc()');
   cmd := dm.getCMD('sql', 'insDsdoc');
   dm.setQtParams(cmd, uo, is_doc, codCli);
   dm.setParams(cmd, is_oper, fdt.dateToSqlDate(data), fdt.dateToSqlDate(data));
   dm.setParams(cmd, usuario, is_emp, quotedStr(tpDoc));
   result := cmd;
end;

function getStrInsertDNOTA(is_emp, sq_opf, uo, cfo, is_nota, usuario, is_doc, is_oper, sr_docf, nr_docf,
									codCli, tpPreco, strValor, obsNota, isFilDest, entSai :String; data:Tdate ):String;
var
   cmd:String;
begin
	if UpperCase(entSai) = 'S' then
   	entSai := '0'
   else
   	entSai := '1';

   if (isFilDest = '') then
      isFilDest := 'null';

	cmd := dm.getCMD('fiscal','insDnota');

   dm.setParam(cmd, is_nota);
   dm.setParam(cmd, uo);
   dm.setParam(cmd, quotedStr(sr_docf));
   dm.setParam(cmd, nr_docf);
   dm.setParam(cmd, codCli);
   dm.setParam(cmd, is_doc);
   dm.setParam(cmd, quotedStr(cfo));
   dm.setParam(cmd, is_oper);
   dm.setParam(cmd, usuario);
   dm.setParam(cmd, isFilDest);
   dm.setParam(cmd, isFilDest);
   dm.setParam(cmd, fdt.dateToSqlDate(data) );
   dm.setParam(cmd, fdt.dateToSqlDate(data) );
   dm.setParam(cmd, fdt.dateToSqlDate(data) );
   dm.setParam(cmd, strValor);
   dm.setParam(cmd, strValor);
   dm.setParam(cmd, is_emp);
   dm.setParam(cmd, tpPreco);
   dm.setParam(cmd, quotedStr(entSai){fl_entrada});
   dm.setParam(cmd, quotedStr(obsNota));
   dm.setParam(cmd, quotedStr(tpPreco));
	f.gravaLog(cmd);

	result := cmd;
end;

function getStrInsertDMOVI(usuario, is_oper, is_nota, sr_docf, nr_docf, isDoc:String; data:Tdate; tbIt, dsTrans, dsUo, dsDest:TdataSet):TStringList;
var
   codEmp, isMovi, cmd:String;
   res:Tstringlist;
   is_lanc, campoCfo:String;
   percIcm, vlIcms:real;
   percIcmStr, tpIcm:String;
begin
	f.gravaLog('getStrInsertDMOVI()');
	f.gravaLog('');

	res := tstringlist.create();

   codEmp := dm.getParamBD('comum.codEmpresa', '');

   tbIt.First();
   while(tbIt.Eof) = false do
   begin
		if dsTrans.FieldByName('fl_estoq').AsString = 'S' then
      	is_lanc := dm.getContadorWell('is_lanc')
      else
			is_lanc := 'null';

		isMovi := dm.getContadorWell('is_movi');

		campoCfo :=
      getCampoCfo(
	  		dsUo.fieldByName('cd_uf').AsString,
	     	dsDest.fieldByName('cd_uf').AsString,
	      dsDest.fieldByName('cd_sexo').AsString,
   	   tbIt.fieldByName('codRegra').AsInteger
   	);

      getPercICMItNf(
         tbIt.fieldByName('is_Ref').asString,
      	dsDest.fieldByName('cd_sexo').AsString,
  	   	dsUo.fieldByName('cd_uf').AsString,
  	   	dsDest.fieldByName('cd_uf').AsString,
         dsTrans.fieldByName('FL_ICMS').AsString,
         percIcmStr,
         tpIcm,
		);
      percIcm := strTofloat(percIcmStr);


      vlIcms := tbIt.fieldByName('vl_item').AsFloat * (percIcm/100);

		cmd :=
      dm.getCMD('Fiscal', 'strInsertDMOVI');
      dm.setParam(cmd, is_nota);
      dm.setParam(cmd, isMovi);
		dm.setParam(cmd, dsUo.fieldByName('is_uo').AsString);
      dm.setParam(cmd, dsDest.fieldByName('cd_pes').AsString);
      dm.setParam(cmd, dsTrans.fieldByName('sq_opf').asString);
      dm.setParam(cmd, is_oper);
      dm.setParam(cmd, tbIt.fieldByName('is_ref').AsString);
      dm.setParam(cmd, fdt.dateToSqlDate(data));
      dm.setParam(cmd, usuario);
      dm.setParam(cmd, fdt.dateToSqlDate(data));
      dm.setParam(cmd, fdt.dateToSqlDate(data));
      dm.setParam(cmd, sr_docf);
      dm.setParam(cmd, nr_docf);
      dm.setParam(cmd, tbIt.fieldByName('nr_item').AsString);
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('PrecoUnitarioLiquido').AsString, false) );
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('qt_mov').AsString, false));
      dm.setParam(cmd, FloatToStr(percIcm));
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('vl_item').AsString, false));
      dm.setParam(cmd, tpIcm + '/* tpIcm */' {tbIt.fieldByName('tp_icm').AsString});
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('vl_item').AsString, false));
      dm.setParam(cmd, codEmp);
      dm.setParam(cmd, isDoc);
      dm.setParam(cmd, is_lanc);
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('vl_item').AsString, false) );
      dm.setQtParam(cmd, dsTrans.fieldByName(campoCfo).asString);

      dm.setParam(cmd, f.valorSQL(vlICMS));
      dm.setParam(cmd, f.valorSql(tbIt.fieldByName('PrecoUnitarioLiquido').AsFloat));
      dm.setParam(cmd, dsDest.fieldByName('cd_pes').AsString);

      dm.setParam(cmd, '0.00' {f.valorSql(tbIt.fieldByName('vl_descRat').AsFloat)});

		res.Add(cmd);
      tbIt.Next();
	end;
   f.gravaLog(res);
   result := res;
end;

function getCfoNf(dsEmissor, dsDestino:TDataset):String;
begin
	f.gravaLog('getCfoNf()');

	f.gravaLog(dsEmissor, 'dataSet emissor');

	f.gravaLog(dsDestino, 'dataSet destino');


   result :=
	uFiscal.getCampoCfo(
   	dsEmissor.fieldByName('cd_uf').AsString,
	   dsDestino.fieldByName('cd_uf').AsString,
	   dsDestino.fieldByName('cd_sexo').AsString,
	   1 // assumir que na cabe�a o codigo da regra � 1
	);
   //cfo := dsTrans.fieldByName(cfo).AsString;
end;

procedure aplicaCustoNfNoVa(uo, is_nota:String);
var
   vlItem:real;
   ds:TdataSet;
   i:integer;
begin
      application.CreateForm(TfmAjustaNota, fmAjustaNota);
      fmAjustaNota.FormStyle:= fsNormal;
      fmAjustaNota.Hide();

      fmAjustaNota.edIsNota.Text := is_nota;
      fmAjustaNota.btCarregaNfClick(nil);

      fmAjustaNota.tbItens.First();

      for i:=0 to fmajustaNota.tbItens.RecordCount do
      begin
         // pega os dados do preco de custo  10 !
         ds := uProd.getDadosProd(uo, '', fmAjustaNota.tbItens.fieldByName('is_ref').AsString, '10', false);

         f.gravaLog(
            ' Codigo:' + fmAjustaNota.tbItens.fieldByName('cd_ref').AsString +
            ' Unidade NF:' + fmAjustaNota.tbItens.fieldByName('PrecoUnitarioLiquido').AsString +
            ' Pc custo:' + ds.FieldByName('preco').AsString
         );

         if  ds.FieldByName('preco').AsFloat <> 0 then
            vlItem := ds.FieldByName('preco').AsFloat + (ds.FieldByName('preco').AsFloat * 0.15)
         else
            vlItem := (fmAjustaNota.tbItens.fieldByName('PrecoUnitarioLiquido').AsFloat * 0.6);

         fmAjustaNota.tbItens.Edit();

         fmAjustaNota.tbItens.fieldByName('vl_descRat').AsFloat := 0;
         fmAjustaNota.tbItens.fieldByName('PrecoUnitarioLiquido').AsFloat := math.RoundTo(vlItem, -2);
         fmAjustaNota.gridItensColExit(nil);

         fmAjustaNota.tbItens.Next();
      end;

      fmAjustaNota.edVlDescRatIt.Value := 0;
      fmAjustaNota.edDescNf.Value := 0;

      fmAjustaNota.salvaValoresNf(false);

      fmAjustaNota.Close();
      fmAjustaNota := nil;
end;

procedure recalcularValoresNf(is_nota:String; recalculaICM:boolean);
begin
   application.CreateForm(TfmAjustaNota, fmAjustaNota);
   fmAjustaNota.FormStyle:= fsNormal;
   fmAjustaNota.Hide();

   fmAjustaNota.edIsNota.Text := is_nota;
   fmAjustaNota.btCarregaNfClick(nil);

   fmAjustaNota.tbItens.First();

   if (recalculaICM = true) then
      fmAjustaNota.recalculaICMSDaNota(is_nota);

   fmAjustaNota.recalculaValoresNf();
   fmAjustaNota.edCFO.Text :=    fmAjustaNota.tbItens.fieldByName('codCFO').AsString;

   fmAjustaNota.salvaValoresNf(false);

   fmAjustaNota.Close();
   fmAjustaNota := nil;
end;

function gerarNf(cd_usu, uo, cd_pesD, uoDestino, usuario, sq_opf, obs:String; data:Tdate; is_notaO:String;
                  usaFator:boolean; dsItNfOrigem:Tdataset):String;
var
   is_nota, cmd ,codEmp, is_oper, is_doc, sr_docf, nr_docf:String;
   codTransacao, cfo, tp_doc, tpPreco, entSai:String;
   vlNota:real;
   comandos:TStringList;
   i:integer;
   dsNfO, dsItens, dsUo, dsDest, {campoCfo, }dsTrans:TdataSet;
   cdPesNfOrigem:String;
   vl_Desc, pc_desc:real;
begin
	f.gravaLog('-----------------------------------------------------------------------');
	f.gravaLog('uFiscal.gerarNf()');
	f.gravaLog('');

   if (is_notaO <> '-1') and ( Length(is_notaO) < 10 ) then
   begin
      dsNfO := uFiscal.getDadosNota(is_notaO);
      cdPesNfOrigem := dsNfO.FieldByName('cd_pes').AsString;
      vl_desc :=       dsNfO.FieldByName('vl_Desc').AsFloat;
      pc_desc :=       dsNfO.FieldByName('pc_Desc').AsFloat;
   end
   else
   begin
      dsNfO :=  dm.getDataSetQ('select * from ' + getDadosNfFromXml(is_notaO));
   end;
   f.gravaLog(dsNfO, 'dataset da cabeca da nota -------------------------') ;


   if Length(is_notaO) > 10 then
      dsItens := dm.getDataSetQ('select * from ' +   ufiscal.getItensNfFromXml(is_notaO, uoDestino, true) )
   else
   begin
     if (dsItNfOrigem <> nil) then
        dsItens := dsItNfOrigem
     else
        dsItens := ufiscal.getItensNota(is_notaO);
   end;
   f.gravaLog(dsItens, 'dataset dos itens da nota -------------------------');


   dsUo := uLj.getDadosUo(uo);

   codEmp := dm.getParamBD('comum.codEmpresa', '');

   tp_doc := 'N';

   comandos := TStringList.Create();

// pegar os dados da transacao
   dsTrans := getDadosOprInt(sq_opf);
   codTransacao := dsTrans.FieldByName('cd_trans').AsString;

   if (dsTrans.fieldByname('FL_ENTRADA').AsString = '0') then
   	entSai := 'S'
	else
   	entSai := 'E';

// some o valor dos itens
   if (dsItNfOrigem <> nil) then
      vlNota := dm.somaColDataSet(dsItNfOrigem, 'vl_item')
   else
      vlNota := dsNfO.fieldByName('valor').AsFloat;
   //dm.somaColunaTable(dsItens, 'total_Item');

//pega o is_Doc
   is_doc := dm.getContadorWell('is_doc');

// pegar o is_oper
   is_oper := dm.getContadorWell('is_oper');

// pegar o is_nota
   is_nota := dm.getContadorWell('is_nota');

//definir a serie e o numero

	sr_docf := '';
   nr_docf := '';

   // se a nota nao for de for Outras entradas

   if (codTransacao = '12') or ((codTransacao = '6') and (cdPesNfOrigem = uo ) and (entSai = 'E') ) then
   begin
		sr_docf := dsNfO.fieldByName('serie').AsString;
	   nr_docf := dsNfO.fieldByName('num').AsString;

      cd_pesD := dsNfO.fieldByName('is_estoque').AsString;

      if dsNfO.IsEmpty = false then
   	   dsDest := uPessoa.getDadosPessoa( dsNfO.fieldByName('is_estoque').AsString )
      else
   	   dsDest := uPessoa.getDadosPessoa( uo )
   end
   else
   begin
	   getSrNumProximaNota(uo, sq_opf, sr_docf, nr_docf);

	   // pegar dados do destinatario
	   dsDest := uPessoa.getDadosPessoa(cd_pesD);
   end;

   tpPreco := dsTrans.fieldByName('tp_preco').AsString;

   if (sr_docf <> '') and (nr_docf <> '') then
	begin
      {  Comecar a inserir os dados. }

   // inserir na toper
      cmd :=
      getStrInsertToper(codEmp, is_oper, sq_opf, fmMain.getCdPesLogado(), codTransacao, data);
      comandos.add(cmd);

   // inserir na dsdoc
      cmd :=
      getStrInsertDsdoc( codEmp, uo, is_doc, 'N', is_oper, uo, usuario, data );
      comandos.add(cmd);

      // pegar o CFO
      if (entSai = 'S' )then
			cfo := getCfoNf(dsUo, dsDest)
      else
			cfo := getCfoNf(dsDest, dsUo);
      cfo := dsTrans.FieldByName(cfo).AsString;

      cmd :=
      getStrInsertDnota(
         codEmp, sq_opf, uo, cfo, is_nota, usuario,
         is_doc, is_oper, sr_docf, nr_docf, cd_pesD, tpPreco, f.valorSql(vlNota),
         obs, uoDestino, entSai, data
      );
      comandos.add(cmd);


//inserir os itens da nota na tb dmovi
      comandos.AddStrings(
         getStrInsertDMOVI(
            usuario, is_oper, is_nota, sr_docf, nr_docf,
            is_doc, data, dsItens, dsTrans, dsUo, dsDest
         )
      );
      f.gravaLog('**************************************************************');
      f.gravaLog(comandos);

      for i:=0 to comandos.Count -1 do
	   	dm.execSQL(comandos[i]);

      f.gravaLog('lancamento dos dados dos itens ---- fim');

      gravaIcmNf(is_nota, sq_opf, entSai);

      comandos.free;

// inicia o ajuste de fator de pre�o
      if (usaFator = true) then
         aplicaCustoNfNoVa(uo, is_nota)
      else  if (vl_Desc > 0) or  (pc_desc > 0) then
         copiaRateioItens(dsNfO, is_nota);

      uFiscal.recalcularValoresNf(is_nota, false);

      result := (sr_docf +'/'+ nr_docf);
	end
   else
   begin
   	msg.msgErro(dm.getMsg('fiscal.errOprSemNum'));
      result := '';
   end;

 	f.gravaLog('-----------------------------------------------------------------------');
	f.gravaLog('uFiscal.gerarNf() - fim');
	f.gravaLog('');
end;

function getDadosReducao(uo: String; di, df:Tdate; serieECF, empresa:string):TdataSet; overload;
var
   cmd, order:String;
begin
   if (uo <> '' ) and (uo <> '999') then
     uo := dm.getCMD1('fiscal', 'getDadosRedZ.uo', uo)
   else
     uo := '/* uo */';

   if (empresa <> '') then
      empresa := dm.getQtCMD1('fiscal', 'getDadosRedZ.emp', empresa)
   else
      empresa := '/* empresa */';

   if (serieECF <> '') then
      serieECF := dm.getCMD1('Fiscal', 'getDadosRedZ.serie', serieECF )
   else
      serieECF := '/* serie */';

   order := dm.getCMD('Fiscal', 'getDadosRedZ.order');

   cmd :=
   dm.getCMD6('Fiscal', 'getDadosRedZ',
      uo,
      fdt.dateToSqlDate(di),
      fdt.dateToSqlDate(df),
      serieECF,
      empresa,
      order
   );

   result := dm.getDataSetQ(cmd);
end;

function getDadosReducao(uo: String; di, df:Tdate; serieECF:string):TdataSet; overload;
begin
   result := getDadosReducao(uo, di, df, serieEcf, '');
end;

procedure getTbAjNotas(tb:TADOTable; isNota:String);
var
  cmd:String;
begin
// criar a tabela temporaria dos itens
   cmd := dm.getCMD('fiscal', 'ajNotaGetTbIt');
   dm.getTable(tb, cmd);

// inserir os itens na grid
   tb.Close();
   cmd := dm.getCMD3('fiscal', 'ajNotaInsTbIt', tb.tableName, isNota, '');
   dm.execSQL(cmd);
   tb.Open();
end;


function ajDadosICMSItensNF(tbItens:TADOTable; sq_opf, cd_pes, uo:String):Boolean;
var
   cmd:String;
   ds, dsOpr:TdataSet;
   campoCFO, ufEmit, ufUO:String;
begin
   f.gravaLog('ajDadosICMSItensNF(): valorBaseIMCMS: ' +{  dm.somaColTable(tbItens, 'valorBaseICMS', true)} '');
// pegar os dados do emitente;
   ds := uUsuarios.getDadosPessoa(cd_pes);
   ufEmit := ds.fieldByName('cd_uf').AsString;
   ds.free();

// pegar os dados da loja
   ds := uUsuarios.getDadosPessoa(uo);
   ufUO := ds.fieldByName('cd_uf').AsString;
   ds.free();


   dsOpr := getDadosOprInt(sq_opf);


   f.gravaLog( tbItens.RecordCount);
   f.gravaLog(tbItens, '');

   f.gravaLog(intToStr( tbItens.RecordCount));

   tbItens.First();
   if (tbItens.RecordCount > 0 ) then
      while (tbItens.Eof = false) do
      begin
         campoCFO := tbItens.fieldByName('codCfo').AsString;

         cmd := dm.getCMD('Fiscal', 'updateItemNF');
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('tp_icm').AsFloat) );
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('valorBaseICMS').AsFloat) );
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('valorICMS').AsFloat) );
         dm.setParam(cmd, campoCFO );
         dm.setParam(cmd, tbItens.fieldByName('pc_icm').asString );
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('total_Item').asString));
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('PrecoUnitarioLiquido').asString));
         dm.setParam(cmd, f.valorSql(tbItens.fieldByName('vl_descRat').asString));

         dm.setParam(cmd, tbItens.fieldByName('is_movi').asString);

         dm.execSQL(cmd);

         tbItens.Next();
      end;

   result := true;
   dsOpr.Free();
end;


procedure ajustaIcmdItem(tbItens:TadoTable);
var
   aux:Real;
   tp_cms:String;
begin
   if ( tbItens.IsEmpty = false) then
   begin
      tp_cms :=  tbItens.fieldByName('tp_icm').AsString[1];


      tbItens.edit();

      tbItens.fieldByName('total_Item').AsFloat :=
            tbItens.fieldByName('PrecoUnitarioLiquido').AsFloat *
            tbItens.fieldByName('qt_mov').AsFloat;


      if( tbItens.fieldByName('tp_icm').AsInteger = 2) then
      begin

         tbItens.fieldByName('valorBaseIcms').AsFloat :=
         tbItens.fieldByName('total_Item').AsFloat - tbItens.fieldByName('vl_descRat').AsFloat;

         aux := tbItens.fieldByName('valorBaseIcms').asFloat * (tbItens.fieldByName('pc_icm').asFloat / 100);
         tbItens.fieldByName('valorIcms').AsFloat:= Math.RoundTo(aux, -2);
      end
      else
         tbItens.fieldByName('valorIcms').AsFloat:=0;

      tbItens.post();
   end;
end;   

function salvaXmlEntrada(arq:String):boolean;
var
  server, arqRemoto, dirRemoto:String;
  res:boolean;
begin
   res:= false;
   if (arq <> '') then
      if (uAcbr.xmlExists(arq, server, dirRemoto) = false) then
      begin
         arqRemoto := SysUtils.ExtractFileName(arq);
         res := uAcbr.putFile(server, dirRemoto, arq );
      end
      else
      begin
         msg.msgErro(dm.getMsg('ftp.errArqExiste'));
         res := false;
      end;
   result := res;
end;

function isNotaExiste(uo, serie, numero:String):boolean;
begin
   result :=  not(getDadosNota('', uo, serie, numero).IsEmpty);
end;

function procuraXmlNosServidores(isNota:String):String;
var
   dsNfe,dsLojas:TdataSet;
   server, arqRemoto:String;
begin
   dsNfe := getDadosNota(isNota);

   dsLojas:= uLj.getDsLojas('');

   dsLojas.First();

   while (dsLojas.Eof = false) do
   begin
       f.gravaLog('buscando: ' + dsLojas.fieldByName('ds_uo').AsString);

      arqRemoto := uFtp.getStrBuscaXML(
                      dsLojas.fieldByName('is_uo').AsString,
                      dsNfe.fieldByName('serie').AsString,
                      dsNfe.fieldByName('num').AsString
                   );

      server :=   uACBR.getIPServer(dsLojas.fieldByName('is_uo').AsString);

     if  uftp.isArquivoExiste(server, arqRemoto ) <> '' then
      begin
         msg.msgExclamation( dsNfe.FieldByName('is_estoque').AsString);
         result:= dsNfe.FieldByName('is_estoque').AsString;
         Break;
      end;

     dsLojas.Next();
   end;
end;

function getDadosOprInt(sq_opf:String):TdataSet;
begin
   result :=
   dm.getDataSetQ( dm.getCMD1('Fiscal', 'getDadosOprInt', sq_opf) );
end;

function upDadosNF(isNota, codTrans, cd_pes,  sq_opf, cfo, obs:String; isCanc:boolean; vldspExtra:real;
                   dtEmis, dtEntSai:Tdate; vNf, vItens, vlPrecDesc, vlDesc, vlDescItens, vlIpi, vlDespAce:String):boolean;
var
   strStNota, cmd:String;
   res:boolean;
begin
   cmd := dm.getCMD('Fiscal', 'updNF');

   if (codTrans <> '2') then
      dm.setParam(cmd,  dm.getCMD1('Fiscal', 'updNF.cd_pes', cd_pes))
   else
      dm.setParam(cmd,  'cd_pes= cd_pes');

   if(isCanc = true) then
      strStNota := 'C'
   else
      strStNota := '';

   dm.setParams (cmd, quotedStr(cfo), f.valorSql(vldspExtra), fdt.dateToSqlDate(dtEmis) );
   dm.setParams (cmd, fdt.dateToSqlDate(dtEntSai), QuotedStr(strStNota), QuotedStr(obs) );
   dm.setParams (cmd, f.valorSql(vItens), f.valorSql(vNf), f.valorSql(vlDesc ));
   dm.setParams (cmd, f.valorSql(vlPrecDesc), f.valorSql(vlDescItens),f.valorSql(vlIpi));
   dm.setParams (cmd, f.valorSql(vlDespAce),isNota, '');

   dm.setParam(cmd, isNota);

   f.gravaLog(cmd);

   dm.execSQL(cmd);

   f.gravaLog('Grava na DMOVI se e cancelada ou nao.' );
   cmd := dm.getCMD2('Fiscal', 'updNF.stItem', quotedStr(strStNota), isNota);
   dm.execSQL(cmd);

   f.gravaLog('Altera a opera��o integrada.' );

   cmd := dm.getCMD2('Fiscal', 'updNF.codOpr', sq_opf, isNota);

   res := dm.execSQL(cmd);

// se a nota � de entrada ele atualiza a dsdoc
   if (codTrans = '1') or (codTrans = '30') then
      cmd := dm.getCMD2('Fiscal', 'updNF.dsdoc', cd_pes, isNota);

   res:= dm.execSQL(cmd);

   result := res;
end;

procedure ajustaDadosICM(tbICM:TdataSet; isNota, EntSai:String);
var
   cmd:String;
begin
   f.gravaLog('');
   f.gravaLog('ajustaDadosICM()' );
   f.gravaLog('');

// exclui os registros antigos
  cmd := 'delete from dnotc where is_nota = ' + isNota;
  dm.execSQL(cmd);

// insere os novos
  tbICM.First();
  while (tbICM.Eof = false) do
  begin
     cmd := dm.getCMD('Fiscal', 'salvaIcmNF');

     dm.setParams(cmd, tbICM.FieldByName('is_estoque').AsString, isNota, tbICM.FieldByName('seq').AsString );
     dm.setParams(cmd, tbICM.FieldByName('%ICMS').AsString, quotedStr(entSai), tbICM.FieldByName('tp_icm').AsString );
     dm.setParams(cmd, f.ValorSql(tbICM.FieldByName('base').AsString), f.ValorSql(tbICM.FieldByName('valor ICMS').AsString), '' );
     dm.execSQL(cmd);
     tbICM.Next();
  end;

  f.gravaLog('ajustaDadosICM() - fim' );
end;


procedure getTbDadosIcmNf(tbIcms:TAdoTable; isNota:String);
begin
   dm.getTable(tbIcms, dm.getCMD('Fiscal', 'getTbIcmNf') );

   tbIcms.Close();
   dm.execSQL(dm.getCMD2('Fiscal', 'getDadosIcmNF', tbIcms.TableName, isNota));
   tbIcms.open();
end;

function getDadosIcmsItTmp(nmTbItens:String):Tdataset;
var
  tbRes, cmd:String;
begin
	tbRes := dm.getNomeTableTemp();

   cmd := dm.getCMD2('Fiscal', 'getDadosIcmItTmp', tbRes, nmTbItens );
	dm.execSQL(cmd);

   cmd := 'Select * from '+ tbRes;
   result := dm.getDataSetQ(cmd);
end;

procedure importarXmlNfe();
var
  uo, ipServer, cnpj:String;
  arqs,arqOk, arqErro:TStrings;
  ds:TdataSet;
  i,j:integer;
begin
	arqOk := TStringlist.Create();
   arqErro := TStringlist.Create();

	f.gravaLog('uFiscal.importarXmlNfe()'+#13+#13);
   deleteFile(f.getDirLogs() + 'XmlInvalidos.txt');

   i:=0;
   arqs := f.dialogAbrVariosArq('xml', 'c:\');

   if (arqs.Count > 0) then
   begin
      try
         for i:=0 to arqs.Count -1 do
         begin
            fmMain.msgStatusProgresso(i+1, arqs.Count, 'Enviando XML ');

            // buscar os dados do arquivo XML
            ds := uAcbr.getDaDosXml(arqs[i], f.getDirExe() + 'nfeEnt.xtr');

            if (ds.IsEmpty = false) then
            begin
					if (ds.fieldByName('dest_CNPJ').AsString = '' )then
						cnpj := ds.fieldByName('emit_CNPJ').AsString
					else
						cnpj := ds.fieldByName('dest_CNPJ').AsString;

               uo := uLj.getIsUoFromCNPJ(cnpj);

               ipServer := uAcbr.getIPServer(uo);

               if (ipServer <> '') then
               begin
                  // verifica se ja � cadastrada a nota
                  if (uFiscal.getChaveXMLEnt(ds.fieldByName('chNFe').AsString) = '') then
                  begin
                     if (uFiscal.salvarXmlNfe('insert', arqs[i], ipServer, uo, ds) = true) then
                     	arqOk.add(arqs[i])
                  end
                  else
                  begin
                     if (uFiscal.salvarXmlNfe('update', arqs[i], ipServer, uo, ds) = true) then
	                    	arqOk.add(arqs[i]);

                     f.gravaLog( dm.getCMD1('msg', 'fiscal.xmlEntExiste', arqs[i])) ;
	                    	arqOk.add(arqs[i]);
                  end;
               end
               else
               begin
                  f.gravaLog(dm.getMsg('fiscal.xmlSemDest'));
                  msg.msgErro( dm.getMsg('fiscal.xmlSemDest'));
						arqErro.add(arqs[i]);
               end;
            end;

            if (arqOk.Count > 0) then
            begin
	           	if ( msg.msgQuestion(dm.getMsg('XmlSalvoOk')) = mrYes  )then
               	for j:=0 to arqOk.Count-1 do
                  	deleteFile(arqOk[j]);
            end;

				if ( arqErro.Count > 0) then
            begin
	           	if ( msg.msgQuestion(dm.getMsg('XmlComErro')) = mrYes  )then
               	for j:=0 to arqOk.Count-1 do
                  	deleteFile(arqErro[j]);
            end;

            ds.Free();
         end;
      except
         on e:exception do
            msg.msgErro( dm.getCMD1('msg', 'fiscal.xmlErEnv', arqs[i]) );
      end;
   end;
   fmMain.msgStatus('');
end;

function salvarXmlNfe(opcao:String; caminhoArqXML, ipServidor, uo:String; dsXml:Tdataset):boolean;
var
   cd_pes, nomeArq, cmd, chave, sr, nr:String;
   nrCgc, filCgc, dgCgc:String;
   put, exec:boolean;
begin
	nrCgc := copy(dsXml.fieldByName('emit_CNPJ').AsString, 01,08);
   filCgc := copy(dsXml.fieldByName('emit_CNPJ').AsString, 09, 04);
   filcgc := intToStr( strToint(filCgc));
   dgCgc := copy(dsXml.fieldByName('emit_CNPJ').AsString, 13, 02);


   if (dsXml.fieldByName('dest_CNPJ').AsString = '' ) then
   	cd_pes := fmMain.getCD_PES('F')
   else
		cd_pes :=  dm.openSQL( dm.getCMD3('fiscal', 'cdPesFromCNPJ', nrCgc, filCgc, dgCgc), 'cd_pes' );

	sr := dsXml.fieldByName('serie').AsString;
   nr := dsXml.fieldByName('nNf').AsString;
   chave := dsXml.fieldByName('chNfe').AsString;
   nomeArq := extractFileName(caminhoArqXML);

   if (cd_pes <> '' )then
   begin
      if (opcao = 'insert') then
      begin
         cmd :=
         dm.getQtCMD6('Fiscal', 'gravaChaveXMLEnt', chave, sr, nr, uo, nomeArq, cd_pes);
      end
      else
      begin
         cmd := dm.getQtCMD6('Fiscal', 'updateChaveXMLEnt', sr, nr, uo, nomeArq, cd_pes, chave);
      end;

      if (uACBR.putFile(ipServidor, 'nfe/Entradas', caminhoArqXML) = false) then
      begin
         msg.msgErro(dm.getMsg('ftp.errCopia'));
      	put:= false;
      end
      else
			put:= true;

      exec := dm.execSQL(cmd);

      result := (put) and (exec);
	end
   else
   begin
      msg.msgErro( dm.getCMD1('MSG','fiscal.xmlSemForn', caminhoArqXML));
      f.gravaLinhaEmUmArquivo(f.getDirLogs() + 'XmlInvalidos.txt', caminhoArqXML);
		result := false;
   end;
end;

function getChaveXMLEnt(chaveXml:String):String;
begin
   result :=  dm.openSQL( dm.getQtCMD1('fiscal', 'getChaveXMLEnt', chaveXml), '');
end;

procedure listaXmlEnt(qr:TADOQuery; serie, numero:String);
var
   cmd:String;
begin
   cmd := dm.getCMD2('fiscal', 'lstXmlEnt', serie, numero);
   dm.getQuery(qr, cmd);
end;

procedure visualizaXmlEnt(uo, arquivo, chave:String);
var
  cmd, arqRemoto, dirRemoto:String;
begin
   dirRemoto:= 'C:\Dropbox\Nfe\Entradas\';
   arqRemoto :=  uAcbr.gerarPDF(uo, dirRemoto, arquivo);

   cmd := uAcbr.getArqFromACBR(uo, {chave} arqRemoto );
   f.execFileExternal( cmd );
end;

function getCuponsPorDia(uo, ecf:String; dti, dtf:Tdate):TdataSet;
var
   cmd:String;
begin
   ecf := f.preencheCampo(15, '0', 'E', trim(ecf));

   cmd :=
   dm.getCMD3(
      'fiscal',
      'getCuponsData',
      ecf,
      fdt.dateToSqlDate(dti),
      uo
   );

   result := dm.getDataSetq(cmd);
end;

function geraNotaApartirDeOutra(uo, cd_usu, cd_pesD, uoDestino, sq_opf, is_notaO, obs:String; usaFator:boolean):String;
begin
	result := uFiscal.gerarNf(cd_usu, uo, cd_pesD, uoDestino, cd_usu, sq_opf, obs, dm.getDateBd(), is_notaO, usaFator, nil);
end;

procedure recalculaTotalItensNota(var tbIt:TADOTable);
var
	totItem:real;
   i:integer;
   aux:real;
begin
   f.gravaLog('recalculando os valore dos itens');
   f.gravaLog('------------------------------------------------------');

	tbIt.First();

   f.gravaLog(intToStr(tbIt.RecordCount));

   for i:=0 to tbIt.RecordCount do
//   while tbIt.Eof = false do
   begin
   	tbIt.Edit();

   	f.gravaLog(tbIt.fieldByName('nr_item').AsString);

      totItem :=
      tbIt.fieldByName('PrecoUnitarioLiquido').AsFloat *
      tbIt.fieldByName('qt_mov').AsFloat;

   	tbIt.fieldByName('total_Item').AsFloat := totItem;

//      if  tbIt.fieldByName('tp_icm').AsString = '2' then
      begin
         tbIt.fieldByName('valorBaseIcms').AsFloat := (totItem - tbIt.fieldByName('vl_descRat').AsFloat);

         aux := (totItem - tbIt.fieldByName('vl_descRat').AsFloat) * (tbIt.fieldByName('pc_icm').AsFloat /100.00);
  	   	tbIt.fieldByName('valorICMS').AsFloat := Math.RoundTo(aux, -2);

      end;

      tbIt.Post();
      tbIt.Next();
   end;
   tbIt.First();

   f.gravaLog('-------------------------------------------------------------');
   f.gravaLog('');
end;

procedure sicVlIcmItensComNf(ds:TdataSet;tb:TAdotable; uo:String);
var
	isNota:String;
   i:integer;
begin
	f.gravaLog('ajustaOsValores do ICMS na dnotc com base nos itens da tabela de itens()');



	while (tb.IsEmpty = false) do
   begin
		tb.Delete();
      f.gravaLog('delete');
   end;

   ds.First();
   for i:=1 to ds.RecordCount do
   begin
      if (ds.FieldByName('tp_icm').asString <> '6') then
      	tb.AppendRecord(  [isNota, ds.FieldByName('seq').asString,	ds.FieldByName('tp_icm').asString,
                      		ds.FieldByName('%icms').asString, ds.FieldByName('base').asString, ds.FieldByName('Valor ICMS').asString, '1', uo
         ])
      else
        	tb.AppendRecord(  [isNota, ds.FieldByName('seq').asString,	ds.FieldByName('tp_icm').asString,
                           ds.FieldByName('%icms').asString, '0', '0', '1', uo
         ]);

      ds.Next();
   end;
   f.gravaLog('terminei');
end;

procedure removeRegNfAgregada(is_nota:String;isAgregada:boolean);
var
	cmd:String;
begin
	// se is agregada = true remove as asgregadas se nao remove as agregadoras

	if (isAgregada = true) then
		cmd :=	dm.getCMD1('fiscal', 'remRegNfAgregada', is_nota)
   else
		cmd :=	dm.getCMD1('fiscal', 'remRegNfAgregadora', is_nota);

	dm.execSQL(cmd);
end;

procedure copiaRateioItens(dsNfO:TdataSet; is_NotaDest:String);
var
   i:integer;
   cmd:String;
   tbIo, tbId:TADOTable;
   dsNfDest:Tdataset;
begin
   f.gravaLog('--------------copiaRateioItens()');
   f.gravaLog('');

   dsNfDest := uFiscal.getDadosNota(is_NotaDest,'','','');

   tbIo := TADOTable.Create(nil);
   uFiscal.getTbajNotas(tbIo, dsNfO.FieldByName('is_nota').AsString);

   tbId := TADOTable.Create(nil);
   uFiscal.getTbajNotas(tbId, is_notaDest);

   for i:=0 to tbIo.RecordCount do
   begin
      tbId.Edit();
      tbId.FieldByName('vl_descRat').Assign( tbIo.FieldByName('vl_descRat'));
      tbId.post();

      tbIo.Next();
      tbId.Next();
   end;

   ajDadosICMSItensNF(
      tbId,
      dsNfDest.fieldByName('sq_opf').asString,
      dsNfDest.fieldByName('cd_pes').asString,
      dsNfDest.fieldByName('is_estoque').asString
   );

   f.gravaLog('--------------copiaRateioItens() - fim');

end;

procedure chamaRecalculoNf();
var
   isNota:String;
   ds:TdataSet;
begin
   isNota := uFiscal.getIsNota();

   if (isNota <> '') then
   begin
      ds:= uFiscal.getDadosNota(isNota,'','','');
      if  (ds.FieldByName('chave_acesso_nfe').AsString = '') then
      begin
         recalcularValoresNf(isNota, true);
         msg.msgExclamation(dm.getMsg('fiscal.RecalculoOk'));
      end
      else
         msg.msgErro(dm.getMsg('fiscal.errNfAutorizada'));
      ds.Free();
   end;
end;

function getItensNfFromXml(xml:String; uoEntrada:String; consultaProtheus:boolean):String;
var
   tb:TADOTable;
   dsXml, dsIt:Tdataset;
   stIsRef:TStringlist;
   i:integer;
begin
   // le o XML e pega os itens, ent�o retorna um dataSet
   // com os campos de nfe para ser usado na funcao de criar
   // nfe com os itens de outra

   if (consultaProtheus = true) then
      stIsRef := getTbItNfEntXml(xml);


   tb := TADOTable.Create(nil);
   dm.getTable(tb, dm.getCMD('fiscal', 'getTbItensNFGeraNfDeoutra'));

   dsXml:= uAcbr.getDaDosXml(xml, 'nfeEntItens.xtr');
   f.gravaLog(dsXml, 'xmlItens');

   dsXml.First();
   while dsXml.Eof = false do
   begin
      //   Registro 4 nItem:4, cProd:37060001, cEAN:0018281500003, xProd:VENTILADOR DE COLUNA 40CM 264/6196 BELMONTE, NCM:84145190,
      //   CFOP:6152, uCom:UN, qCom:30.0000, vUnCom:22.704500000, vProd:681.14, cEANTrib:0018281500003, uTrib:UN, qTrib:30.0000,
      //   vUnTrib:22.704500000, indTot:1, orig:2, ICMS00_CST:00, modBC:0, ICMS00_vBC:681.14, pICMS:4.0000, vICMS:27.25, PISAliq_CST:01,
      //   PISAliq_vBC:0.00, pPIS:0.0000, vPIS:0.00, COFINSAliq_CST:01, COFINSAliq_vBC:0.00, pCOFINS:0.0000, vCOFINS:0.00, cEnq:999,
      //   IPITrib_CST:99, IPITrib_vBC:0.00, pIPI:0.00, vIPI:0.00

      if (consultaProtheus = true) then
         dsIt := uprod.getDadosProd(fmMain.getUoLogada(), '',  f.getCp(2, stIsRef[i]), '1', true)
      else
         dsIt := uprod.getDadosProd(fmMain.getUoLogada(), dsXml.fieldByName('cEAN').asString, '', '1',true);

       inc(i);

      //is_ref int, cd_ref varchar(08), ds_ref varchar(60), qt_mov int, PrecoUnitarioLiquido money,
      //total_Item money, ncm_sh varchar(08), EAN varchar(08), tp_icm  varchar(01), valorBaseICMs money,
      //valorICMS money, vl_descRat money, vl_item money, is_movi money, is_estoque varchar(08), dmovi.codCfo  varchar(04),
      //crefe.codRegra varchar(2), nr_item int identity(0,1)

      f.gravaLog(dsXml.fieldByName('qTrib').AsString);

      tb.Append();
      tb.FieldByName('is_ref').AsFloat := dsit.FieldByName('is_ref').AsFloat;
      tb.FieldByName('cd_ref').AsString := dsit.FieldByName('CODIGO').AsString;
      tb.FieldByName('qt_mov').AsString:=  f.replace(dsXml.fieldByName('qTrib').AsString, '.', ',');
      tb.FieldByName('PrecoUnitarioLiquido').AsString :=   f.replace(dsXml.fieldByName('vUnTrib').asString, '.', ',');
      tb.FieldByName('total_Item').AsString :=  f.replace(dsXml.fieldByName('vProd').AsString, '.', ',');
      tb.FieldByName('tp_icm').AsString := '6';
      tb.FieldByName('is_estoque').AsString := uoEntrada;
      tb.FieldByName('valorBaseICMs').AsFloat := 0;
      tb.FieldByName('valorICMS').AsString := '0';
      tb.FieldByName('codRegra').Assign( dsit.FieldByName('codRegra'));
      tb.Post();

      dsIt.free();
      dsXml.Next();
   end;
   f.gravalog(tb, '');

   tb.Close();
   result := tb.TableName;
end;

function getDadosNfFromXml(xml:String):String;
var
   tb:TADOTable;
   dsXml, dsXmlTotal:Tdataset;
   uoEmissor, uoEntrada:String;
begin
   f.gravalog('getDadosNfFromXml()');

   // le o XML e pega os dados da nota, ent�o retorna um dataSet
   // com os campos de nfe para ser usado na funcao de criar
   // nfe com os itens de outra
   tb := TADOTable.Create(nil);
   dm.getTable(tb, dm.getCMD('fiscal', 'getTbNFGeraNfDeoutra'));

   dsXml:= uAcbr.getDaDosXml(xml, 'nfeEnt.xtr');
   dsXmlTotal := uAcbr.getDaDosXml(xml, 'nfeEntTotais.xtr');


   uoEmissor := uLj.getIsUoFromCNPJ(dsXml.fieldByName('emit_CNPJ').AsString);
   uoEntrada  := uLj.getIsUoFromCNPJ(dsXml.fieldByName('dest_CNPJ').AsString);


   //     Registro 1 serie:1, nNF:54291, dEmi:, dest_CNPJ:01740627002004, emit_CNPJ:01740627000494, chNFe:23150701740627000494550010000542911002961977
   //    Registro 1 serie:1, nNF:54291, dEmi:, dest_CNPJ:01740627000141, emit_CNPJ:01740627000494, chNFe:23150701740627000494550010000542911002961977


   //cd_pes varchar(08), vl_Desc money, pc_Desc money,valor money, serie varchar(03), num varchar(09), is_estoque varchar(08)


    tb.Append();
    tb.FieldByName('cd_pes').AsString := uoEntrada;
    tb.FieldByName('vl_Desc').AsString := '0';
    tb.FieldByName('pc_Desc').AsString := '0';
    tb.FieldByName('valor').AsString :=   f.replace(dsXmlTotal.fieldByName('vProd').AsString, '.', ',') ;
    tb.FieldByName('serie').Assign( dsXml.fieldByName('serie'));
    tb.FieldByName('num').Assign( dsXml.fieldByName('nNF'));
    tb.FieldByName('is_estoque').AsString := uoEntrada;

    tb.Post();

    dsXml.Next();

    result := tb.TableName;
end;

function getTbItNfEntXml(xml:String):TStringlist;
var
   dmP:Tdm;
   is_ref:String;
   err:String;
   itens:Tstringlist;
   ds:TdataSet;
begin
   ds:= uAcbr.getDaDosXml(xml, 'nfeEntItens.xtr');

   itens := TStringlist.Create();

   Application.CreateForm(Tdm, dmP);
   dmP.closeConnection();
   dmP.openConnection( f.getdirExe() + 'protheus.ini');
   dmP.loadCommandsBD(f.getdirExe() + 'cmdSQL.dll');

   ds.First();

   while ds.Eof = false do
   begin
      is_ref := dmP.openSQL( dm.getCMD1('prot', 'getYCodAnt', ds.fieldByname('cProd').AsString), 'B1_YCODANT');

      if is_ref <> '' then
         itens.Add('||'+
                   trim(is_ref)                             + '|' +
                   ds.FieldByName('qCom').asString          + '|' +
                   ds.FieldByName('vUnTrib').asString       + '|' +
                   ds.FieldByName('vProd').asString         + '|'
                  )
      else
         err := err+ ds.fieldByname('cProd').AsString +' '+ ds.fieldByname('xProd').AsString + #13;
      ds.Next();
   end;

   ds.Free();
   dmp.Free();

   if (err <> '') then
   begin
      err :=  dmP.getMsg('protErrSemIt') + err;
      msg.msgErro(err);
      result := nil;
   end
   else
      result := itens;
end;

function insItNfXMlEnt(ds:TStringlist):Tadotable;
var
   i:integer;
   tb:Tadotable;
   linha:String;
begin
   f.gravaLog(ds);

   dm.getTable(tb, 'codRegra varchar(1), is_ref int, qt_mov int, tp_icm varchar(1), PrecoUnitarioLiquido money, vl_item money, nr_item int identity(0,1) primary key');
                                    //   getItensNF
   for i:=0 to ds.Count -1 do
   begin
      linha := ds[i];
      tb.Append;
      tb.fieldByName('codRegra').AsString := '0';
      tb.fieldByName('is_ref').AsString := f.getCp(2, linha);
      tb.fieldByName('qt_mov').AsString := copy(f.getCp(3, linha), 01, pos('.', f.getCp(3, linha))-1);
      tb.fieldByName('tp_icm').AsString := '1';
      tb.fieldByName('PrecoUnitarioLiquido').AsString :=  MoneyXmlToADOMoney(f.getCp(4, linha));
      tb.fieldByName('vl_item').AsString := MoneyXmlToADOMoney(f.getCp(5, linha));

   end;

   f.gravaLog(tb, 'itens da nota');

   result:= tb;
end;

procedure chamaReceberTranfProtheus();
var
   arqXml:String;
   tb:TADOTable;
   uoEmiss,  uoDest:String;
   dsCabecalho, dsEmis, dsEnt:TdataSet;
   cmd:String;
   stItens:TStringList;
   sq_opf:String;
begin
   arqXml:= f.dialogAbrArq('xml', '');

   if (arqXml <> '' )then
   begin
      stItens :=  getTbItNfEntXml(arqXml);

      // monta o dataSet com os itens
      if (stItens = nil) then
         exit;

      tb:= insItNfXMlEnt(stItens);

      dsCabecalho := uAcbr.getDaDosXml(arqXml, 'nfeEnt.xtr');
      f.gravaLog(dsCabecalho, '');

      if dm.openSQL( dm.getCMD1('fiscal','selectftpw', dsCabecalho.fieldByName('chNFe').AsString), 'chave') <> '' then
      begin
         dsCabecalho.free();
         msg.msgErro('Essa nota j� foi dada entrada!');
         exit;
      end;

      uoEmiss := uLj.getIsUoFromCNPJ(dsCabecalho.fieldByName('emit_CNPJ').AsString);
      uoDest  := uLj.getIsUoFromCNPJ(dsCabecalho.fieldByName('dest_CNPJ').AsString);

      f.gravaLog('UoEmiss:'+ uoEmiss);
      f.gravaLog('uoDest:'+ uoDest);

      dsEmis := uLj.getDadosUo(uoEmiss);

      cmd := dm.getCMD3('fiscal', 'inserenftpw', dsCabecalho.fieldbyname('chNFe').AsString, uoEmiss, uoDest);
      dm.execSQL(cmd);

      if  msg.msgQuestion('Deseja que essa entrada seja adicionada ao estoque ?') = mrYes then
         sq_opf := '10000260'
      else
         sq_opf := '10000259';

      uFiscal.gerarNf(
         fmMain.getUserLogado(),
         fmMain.getUoLogada(),
         uoEmiss,
         fmMain.getUoLogada(),
         fmMain.PARAMS_APLICACAO.Values['CD_USU'],
         sq_opf,
         'nf inserida pelo PCF',
         dm.getDateBd(),
         arqXml,
         false,
         tb
      );
   end;
end;


end.

