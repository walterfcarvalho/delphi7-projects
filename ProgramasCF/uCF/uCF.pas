unit uCF;

interface

   uses ADODB, Classes, sysutils, Dialogs, forms, DBGrids, QForms,
        ComCTRLs, mxExport, adLabelComboBox, windows, QStdCtrls, DB, DBCtrls,
        Controls, messages, adLabelCheckListBox, IdBaseComponent, IdComponent,
        IdRawBase, IdRawClient, IdIcmpClient, IdTelnet, SoftDBGrid, ExtCtrls;



   function alterarModPagamento(uo, seqtransacao, seqModalidade, codNovaModalidade, valor, numParcelas, seqTEFTransCaixa, dataTrans:String):String;
   function excluirCEP(cep:String):boolean;
   function getCEP(nr_CEP:String):TdataSet;
   function getCodModalidadesCartao():TStringList;
   function getDadosProdIvicom(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean):TdataSet;
   function getLstaBairros(uf, cd_cid, nm_bai:String):TdataSet;
   function getNomeImpressoraNFe():String;
   function getNsuTef():String;
   function getTiposLogradouro():TStringlist;
   function incluirCEP(CEP, cd_uf, cd_cid, cd_bai, tp_lograd, nm_log:String):boolean;
   function insereModPagamento (uo, seqTransacao, codNovaModalidade, valor, numParcelas,  dataTrans:String):String;
   function insereRegistroTEF(uo, seqTransacao, seqModalidade, tp_mve, valor, numParcelas, dataTrans, nsu:String):boolean;
   function isModaLidadePgtoTEF(codModalidade:String):boolean;
   function permiteExecutarRelatorio(tag:integer; uo:String):boolean;
   function removeModPagamento(seqModalidade, seqTEFTransCaixa:String):boolean;
   function removeRegistroTef(seqTEFTransCaixa:String):boolean;
   procedure alteraLojaPedidoCompra(uo:String; nPedido:String);
   procedure calCulaPercentualDoFornecedor(var tb:TADOTable);
   procedure carregaListarUosPorPreco(var clb: TadLabelCheckListBox; TpPreco:String);
   procedure criaTabelaDosTotaisDeAvarias(var tb: TADOTable);
   procedure getCompradores(cb:TadLabelComboBox);
   procedure getProdAvariadosParaVenda(tb:TADOTAble; grid:TSoftDBGrid; numPedido:String);
   procedure logAlteracoesBD(tela, usuario, alteracao:String);


implementation

uses uEstoque, uMain, uDm, fdt, f, uSelecionaUo, uListaImpNFE, msg, uProd;

function permiteExecutarRelatorio(tag:integer; uo:String):boolean;
var
  ds: TdataSet;
  strSelectHora, data, hora, intervExec, nmParam, cmd:String;
  res:boolean;
begin
   nmParam := quotedStr('intervRel.horaUltRel.'+intToStr(tag) +'.'+ fmMain.getGrupoLogado());

   strSelectHora :=
   'coalesce(( select valor from zcf_paramgerais where nm_param= '+nmParam+' and uo= + '+ fmMain.getUoLogada()+ '), ''2010-01-01 00:00:01'')';

   intervExec :=
   'Select coalesce(( select valor from zcf_paramGerais where nm_param= ' + quotedstr('intervRel.' + intToStr(tag) )+'), 120) as intervaloExec';

   intervExec :=   dm.openSQL(intervExec,'intervaloExec');

   cmd :=
   '  select datediff (minute,('+strSelectHora+'), getdate() ) as minutos '+#13+
   ', ' + strSelectHora + ' as data' + #13+
   ', dateadd(minute, ' + intervExec + ', ('+ strSelectHora +') ) as proxExecucao' +
   ', getdate() as dataHoraAtual';

   ds:= dm.getDataSetQ(cmd);

   if ( ds.fieldByname('minutos').AsFloat < strToFloat(IntervExec) ) then
   begin
      cmd := 'S� posso liberar a execu��o as ' +
             ds.fieldByName('proxExecucao').AsString +#13+
             '(Esse relat�rio � trabalhoso para calcular, faz�-lo muitas vezes deixa o sistema lento)';
      msg.msgWarning(cmd);
      res := false;
   end
   else
   begin
      data := copy(ds.fieldByName('dataHoraAtual').asString, 01, 10);
      hora := copy(ds.fieldByName('dataHoraAtual').asString, 12, 08);

      data := fdt.dateTimeToSqlDateTime(data, hora);

      // retirar o quote da string e do nome do parametro
      while pos('''', data) > 0 do
        delete(data, pos('''', data), 1);

      while pos('''', nmParam) > 0 do
        delete(nmParam, pos('''', nmParam), 1);


      dm.updateParamBD(nmParam, uo, data, '');
      res := true;
   end;
   ds.Free();
   result := res;
end;


function getNsuTef():String;
var
  nsuTEF:String;
begin
    nsuTEF :=  InputBox( '','Informe o n�mero da NSU TEF ( se nao informar vou assumir como zero.','0') ;
    result := nsuTEF;
end;

procedure carregaListarUosPorPreco(var clb: TadLabelCheckListBox; TpPreco:String);
var
   cmd: String;
   ds:TdataSet;
begin
   clb.Items.Clear();
   cmd := ' Select is_uo, ds_uo, p.valor from zcf_tbuo uo ' +
          ' inner join zcf_paramGerais P on uo.is_uo = p.uo and p.nm_param = '  +
          quotedStr('fmPrecos.Uos' + TpPreco) +
          ' order by uo.ds_uo';

   ds := dm.getDataSetQ(cmd);

   ds.First();
   while (ds.Eof = false ) do
   begin
      clb.Items.Add( f.preencheCampo(50, ' ', 'D', ds.fieldByname('ds_uo').AsString ) + ds.fieldByname('is_uo').AsString);
      clb.Checked[clb.Items.Count-1] :=  StrToBool( ds.fieldByname('valor').asString);
      ds.Next();
   end;
   ds.Free();
end;

function getDadosProdIvicom(uo, cd_ref, is_ref, preco:String; mostraMsg:boolean):TdataSet;
begin
end;


procedure calCulaPercentualDoFornecedor(var tb:TADOTable);
var
  vPercentual, valorTotal:Real;
begin//
   valorTotal := dm.somaColunaTable(tb, 'valorTotalVenda');
   tb.First();
   while (tb.Eof = false) do
   begin
      vPercentual := (tb.fieldByName('valorTotalVenda').AsFloat * 100) / valorTotal ;
      tb.Edit();
      tb.FieldByName('fornecedor').asString := f.floatToMoney(vPercentual) + '%';
      tb.Post();
      tb.Next();
   end;
end;

procedure criaTabelaDosTotaisDeAvarias(var tb: TADOTable);
var
   cmd:String;
begin
    if (tb.Active = true) then
       tb.Close();
    cmd := 'is_uo varchar(08), ds_uo varchar(30), TipoAvaria varchar(20), qtItens int, valorTotalCusto money, valorTotalPcVarejo money,  TotalVendido money, Fornecedor varchar(60)';
    dm.getTable(tb, cmd);
end;


procedure alteraLojaPedidoCompra(uo:String; nPedido:String);
var
   cmd:String;
begin
   cmd := ' update dsipe set is_estoque= '+uo+ 'where is_pedf = ' + nPedido;
   dm.execSQL(cmd);

   cmd := 'update DSPDF set is_estoque = ' +uo+ ' is_UOCOMPRA = is_estoque, UOPAGTO= is_estoque '+
          'where is_pedf = '  + nPedido;
   dm.execSQL(cmd);

   cmd := 'update DSEPF  set is_estoque= ' +uo+ ' where is_pedf= ' + nPedido;
   dm.execSQL(cmd);
end;

procedure logAlteracoesBD(tela, usuario, alteracao:String);
var
   cmd:String;
begin
   cmd := dm.getCMD('adm', 'logBd.insert');
   dm.setParams(cmd, dm.getDataBd(), quotedStr(tela), quotedStr(usuario));
   dm.setParams(cmd, QuotedStr(alteracao), dm.getDataBd, '');
   dm.ExecSQL(cmd);
end;

function isModaLidadePgtoTEF(codModalidade:String):boolean;
begin
   result := (dm.getDataSetQ('Select * from dsmve where cd_mve = ' + codModalidade).FieldByName('FL_TEF').AsString = 'S');
end;

function getCodModalidadesCartao():TStringList;
var
   cmd :String;
begin
  cmd := 'select cd_mve  from dsmve where tp_mve in ( ''T'', ''B'')' +
         ' union ' +
         'select cd_mve+999  from dsmve where tp_mve in ( ''T'', ''B'')';
  result := dm.getListagem(cmd,0);
end;


function removeRegistroTef(seqTEFTransCaixa:String):boolean;
var
   cmd:String;
begin
   f.gravaLog('ucf.removeRegistroTEF()');
   cmd := ' delete from tefTransCaixa where sequencial= ' + seqTEFTransCaixa;
   result := dm.ExecSQL(cmd);
end;

function removeModPagamento(seqModalidade, seqTEFTransCaixa:String):boolean;
var
   cmd:String;
begin
    removeRegistroTef(seqTEFTransCaixa);
    cmd := ' delete from ModalidadesPagtoPorTransCaixa where seqModPagtoPorTransCaixa = ' + seqModalidade;
    result := dm.ExecSQL(cmd);
end;

function insereRegistroTEF(uo, seqTransacao, seqModalidade, tp_mve, valor, numParcelas, dataTrans, nsu:String):boolean;
var
   cmd:String;
begin
   if (nsu = '' )then
     nsu := '0';

   cmd := dm.getCMD('TEF', 'insere');
   dm.setParams(cmd, uo, seqTransacao, seqModalidade);
   dm.setParams(cmd, quotedstr('T'), f.valorSql(valor), numParcelas );
   dm.setParams(cmd, fdt.dateToSqlDate(dataTrans), nsu, '0' );
   dm.setParams(cmd, quotedStr('P'), '0', '');

   result := dm.ExecSQL(cmd);
end;

function insereModPagamento (uo, seqTransacao, codNovaModalidade, valor, numParcelas,  dataTrans:String):String;
var
   nsuTEF, cmd, seqModPagtoPorTransCaixa:String;
begin
   try
      seqModPagtoPorTransCaixa := dm.getContadorWell('seqModPagtoPorTransCaixa');

      cmd :=
      'insert ModalidadesPagtoPorTransCaixa (codLoja, seqModPagtoPorTransCaixa, seqTransacaoCaixa, codEmpresa, codModalidadePagto, EntradaOuSaida, ' +
      'valorModalidade, valorRateioECF) ' + #13+ ' values (' +
      uo + ', '+
      seqModPagtoPorTransCaixa  + ', '+
      seqTransacao +', ' +
      dm.getParamBD('comum.CodEmpWell', '') +', '+
      codNovaModalidade  +', '+
      '''E'', '+
      f.valorSql(valor) +', '+
      '0' +') ';
      dm.ExecSQL(cmd);

      if (isModaLidadePgtoTEF(codNovaModalidade) = true) then
      begin
         nsuTEF := getNsuTef();
         insereRegistroTEF(uo, seqTransacao, seqModPagtoPorTransCaixa, codNovaModalidade, valor, numParcelas, dataTrans, nsuTEf);
      end;
      result := seqModPagtoPorTransCaixa;
   except
      result := '';
   end;
end;


function alterarModPagamento(uo, seqTransacao, seqModalidade, codNovaModalidade, valor, numParcelas, seqTEFTransCaixa, dataTrans:String):String;
var
   nsuTEF, cmd:String;
begin
   f.gravaLog('uCF.alterarModPagamento()');

// remova o sequencial TEF antigp, se tiver
   if (seqTEFTransCaixa <> '0') then
      removeRegistroTef(seqTEFTransCaixa);

// determinar se a nova modalidade � em cart�o, se sim, insere o registro TEF
   if (isModaLidadePgtoTEF(codNovaModalidade) = true) then
   begin
      nsuTEF := getNsuTef();
      insereRegistroTEF(uo, seqTransacao, seqModalidade, codNovaModalidade, valor, numParcelas, dataTrans, nsuTEF);
   end;

   cmd := '  update ModalidadesPagtoPorTransCaixa'+
          '  set codModalidadePagto = ' + codNovaModalidade +
          ', valorModalidade = ' + f.valorSql(valor) +
          '  where SeqModPagtoPorTransCaixa = ' + seqModalidade;
   if (dm.execSQL(cmd) = true) then
      result := seqModalidade
   else
      result := '';
end;



procedure getProdAvariadosParaVenda(tb:TADOTAble; grid:TSoftDBGrid; numPedido:String);
var
   cmd :String;
   i:integer;
begin
   f.gravaLog('getProdAvariadosParaVenda()');

   if (tb.TableName <> '') then
      tb.close();

   cmd := ' qtParaVenda int, cd_ref varchar(10), ds_ref varchar(60), Disponivel int, pcoSugerido money, is_ref int, ref int, is_alterado varchar(01), seq int identity(0,1) primary key';
   dm.getTable(tb, cmd);

   tb.close();

   cmd := ' insert ' + tb.tableName + #13+
          ' select  0 as qtParaVenda, C.cd_ref, C.ds_ref, (i.quant-i.qtVendido) as qtDisponivel, i.pcoSugerido, i.is_ref, i.ref, '''' as is_alterado '+#13+
          ' from zcf_avariasItens I with(nolock) ' +
          ' inner join zcf_avarias A with(nolock) on (i.numAvaria = A.numAvaria) and I.codLojaDesconto = a.codLojaDesconto and A.ehAprovada = 1  and a.tipoAvaria = 0 ' + #13+
          ' inner join crefe C with(nolock) on i.is_ref = c.is_ref '+ #13+
          ' inner join itensPedidocliente P with(nolock) on i.is_ref = P.seqProduto and I.codLojaDesconto = P.codLoja and   P.numPedido= ' + numPedido + #13+
          ' where ' +
          ' i.qtVendido < i.quant order by i.is_ref ';
    dm.execSQL(cmd);
    tb.open();

   grid.columns[tb.FieldByname('seq').index].visible := false;
   grid.columns[tb.FieldByname('is_alterado').index].visible := false;
   grid.columns[tb.FieldByname('ref').index].visible := false;
   grid.columns[tb.FieldByname('is_ref').index].visible := false;
   grid.columns[tb.FieldByname('cd_ref').index].title.caption := 'Codigo';
   grid.columns[tb.FieldByname('cd_ref').index].width := 60;
   grid.columns[tb.FieldByname('ds_ref').index].title.caption := 'Descricao';
   grid.columns[tb.FieldByname('ds_ref').index].width := 250;
   grid.columns[tb.FieldByname('qtParaVenda').index].title.caption := 'Quant';

   grid.columns[tb.FieldByname('pcoSugerido').index].title.caption := 'Pre�o para venda';

   for i:=0 to grid.columns.count-1 do
      grid.columns[i].readonly := true;

   grid.columns[tb.FieldByname('qtParaVenda').index].ReadOnly := false;
end;


function getNomeImpressoraNFe():String;
var
   aux:String;
begin
   application.createForm(TfmListaImpNFE, fmListaImpNFE);
   fmListaImpNFE.showModal();

   if (fmListaImpNFE.modalResult = mrOk) then
      aux:= fmListaImpNFE.cbLojas.items[fmListaImpNFE.cbLojas.itemIndex];

   fmListaImpNFE := nil;

   if (aux <> '') then
      result := dm.getParamBD('comum.impNFe_'+ aux, '')
   else
      result :='';
end;

function getLstaBairros(uf, cd_cid, nm_bai:String):TdataSet;
var
   cmd:String;
begin
   cmd := ' Select cd_bai, nm_bai from tbai where' +
//          ' cd_uf = ' + quotedStr(uf)+ ' and  ' +
          ' cd_cid = '+ cd_cid +
          ' and nm_bai like ' + quotedStr(nm_bai + '%') +
          ' order by nm_bai';
   result := dm.getDataSetQ(cmd);
end;

function excluirCEP(cep:String):boolean;
var
   cmd:String;
begin
   cmd := 'delete from tlog where nr_cep = ' + cep;
   result := dm.execSQL(cmd);
end;


function incluirCEP(CEP, cd_uf, cd_cid, cd_bai, tp_lograd, nm_log:String):boolean;
var
   cmd :String;
begin
   cmd :=
   'insert tlog values (' +
   cd_bai  + ', ' +
   '0'     + ', ' +
   cd_cid  + ', ' +
   quotedStr(nm_log)  + ', ' +
   quotedStr(cd_uf)   + ', ' +
   cep     + ', ' +
   quotedStr(tp_lograd)   + ', ' +
   'null'   + ', ' +
   '''A'''     + ', ' +
   '''A'''     + ')';
   result := dm.execSQL(cmd);
end;

function getCEP(nr_CEP:String):TdataSet;
var
   cmd:String;
begin
   nr_CEP := f.SohNumeros(nr_CEP);
   if (nr_cep = '') then
      nr_CEP := '-1';
   cmd :=
   ' select * from tlog (nolock)' +
   ' left join tbai (nolock) on tbai.cd_bai = tlog.cd_bai1 and tlog.cd_uf = tbai.cd_uf '+
   ' and tlog.cd_cid = tbai.cd_cid ' +
   ' left join tcid (nolock) on tcid.cd_cid = tlog.cd_cid and tcid.cd_uf = tcid.cd_uf '+
   ' where tlog.nr_cep='+ nr_cep;
   result := dm.getDataSetQ(cmd);
end;

function getTiposLogradouro():TStringlist;
var
   cmd:String;
   ds:TdataSet;
   lst:TStringlist;
begin
   cmd := 'select ds_chv, cd_chv  from dstab where cd_tab = ''10'' '+
          'order by  cd_chv ' ;

   ds := dm.getDataSetQ(cmd);

   lst := TStringlist.create();
   ds.first();
   while (ds.eof = false ) do
   begin
      lst.add( f.preencheCampo(50, ' ', 'D', ds.fieldByname('ds_chv').asString) +
               ds.fieldByname('cd_chv').asString);
      ds.next;
   end;
   ds.free;
   result := lst;
end;


procedure getCompradores(cb:TadLabelComboBox);
var
   cmd:String;
   ds:TdataSet;
begin
   cb.Items.clear();

   cmd := ' SELECT  NM_USU, DSUSU.CD_PES' +
       		' FROM  DSUSU (nolock) '+
          ' LEFT JOIN DSNCP (nolock) ON DSNCP.CD_USU = DSUSU.CD_PES '+
        	'	WHERE DSUSU.FL_ATIVO = 1 and FL_COMPRADOR = 1 '+
          ' or cd_grusu = ''6'' '+#13+
        	'	order by nm_usu';
   ds := dm.getDataSetQ(cmd);

   cb.items.add( f.preencheCampo(50, ' ', 'D',' Todos '));

   ds.First();
   while ( ds.Eof = false) do
   begin
      cb.items.add( f.preencheCampo(50, ' ', 'D', ds.fieldByname('nm_usu').AsString) + ds.fieldByname('cd_pes').AsString);
      ds.next();
   end;
   cb.ItemIndex := 0;
   ds.free;
end;


end.
