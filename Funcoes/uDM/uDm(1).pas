unit uDm;
// Provider=SQLOLEDB.1;Password=welladm;Persist Security Info=True;User ID=secrel;Initial Catalog=WellCfreitas;Data Source=125.0.0.200;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Workstation ID=DELLVALTER;Use Encryption for Data=False;Tag with column collation when possible=False

interface

uses
  SysUtils, msg, Classes, Controls, DB, dbGrids, ADODB, forms, QForms, mxExport, IniFiles, SoftDBGrid;

type
  Tdm = class(TDataModule)
    con: TADOConnection;

    function criaTabelaTemporaria(camposTabela:String):String;
    function delParamBD(nParametro, loja: String):boolean;
    function execSQL(comando:string):boolean;
    function execSQL2(cmd:string):String;
    function execSqlInt(cmd:String):integer;
    function execSQLs(comandos:Tstringlist; execSeparado:boolean):boolean;
    function exportacaoDeTabela(tb:TdataSet;  tipoSaida:TmxExportType;  estilo:TmxExportStyle; nomeArq:String):String;
    function exportacaoDeTabelaExcel(tb: TdataSet): String;
    function getCMD(setor, chave:String):String;
    function getCMD1(setor, chave, p:String):String;
    function getCMD2(setor, chave, p1, p2:String):String;
    function getCMD3(setor, chave, p1, p2, p3:String):String;
    function getCMD4(setor, chave, p1, p2, p3, p4:String):String;
    function getCMD5(setor, chave, p1, p2, p3, p4, p5 :String):String;
    function getCMD6(setor, chave, p1, p2, p3, p4, p5, p6:String):String;
    function getCMD7(setor, chave, p1, p2, p3, p4, p5, p6, p7 :String):String;
    function getCMD8(setor, chave, p1, p2, p3, p4, p5, p6, p7, p8:String):String;
    function getCMDArq(arq:String):String;
    function getContadorWell(campo:String):String;
    function getCustoPorData(uo,is_ref, data:String):String;
    function getDataAntBd(diasARecuar:integer):String;
    function getDataBd():String;
    function getDataHoraBD(): String;
    function getDataSetQ(comando:String):TDataSet;
    function getDataSetQArq(arq:String):TDataSet;
    function getDateAntBd(diasARecuar:integer):TDate;
    function getDateBd():TDate;
    function getDsFromExcel(arqXls:String):String;
    function getEmail(loja:string):string;
    function getHint(nObjeto:String):String;
    function getHoraBD():String;
    function getIdentity():String;
    function getListagem(Comando:String;  idx:integer):Tstringlist;
    function getListagemH(Comando:String):String;
    function getMediaDeUmaColuna(ds:TDataSet; coluna:String):String;
    function getMsg(codMSg:String):String;
    function getNomeTableTemp():String;
    function getParamBD(nParametro, loja: String):String; overload;
    function getParamBDBool(nParametro, loja: String):boolean;
    function getParamEstBD(nParametro, loja, estacao: String):String; overload;
    function getParamIntBD(nParametro, loja: String):integer;
    function getQtCMD1(setor, chave, p:String):String;
    function getQtCMD2(setor, chave, p1, p2:String):String;
    function getQtCMD3(setor, chave, p1, p2, p3:String):String;
    function getQtCMD4(setor, chave, p1, p2, p3, p4:String):String;
    function getQtCMD5(setor, chave, p1, p2, p3, p4, p5:String):String;
    function getQtCMD6(setor, chave, p1, p2, p3, p4, p5, p6:String):String;
    function getStrConexao(arq:String):String; overload;

    function getValoresSQL(lista:Tstrings; comando:String):Tstrings;
    function getValoresSQL2(Comando:String):Tstrings;
    function getValorWell(ExeOrOpen:char; Comando:String; campoRetorno:String):string;
    function insertParamBD(nParametro, loja, valor, descricao: String): boolean;
    function isHoraPermitida(tela:integer; grupo:String):boolean;
    function openSQL(cmd, retorno:String):String;
    function setParamBD(parametro, uo, valor:String):boolean;
    function somaColDataSet(Table:TDataSet;Coluna:String):real;
    function somaColTable(Table:TDataSet; Coluna:String; isFormatado:boolean):String;
    function somaColunaTable(Table:TDataSet;Coluna:String):real;
    function updateParamBD(nParametro, loja, valor, descricao: String): boolean;
    procedure closeConnection();
    procedure conExecuteComplete(Connection: TADOConnection; RecordsAffected: Integer; const Error: Error;   var EventStatus: TEventStatus; const Command: _Command; const Recordset: _Recordset);
    procedure conInfoMessage(Connection: TADOConnection;const Error: Error; var EventStatus: TEventStatus);
    procedure conWillExecute(Connection: TADOConnection; var CommandText: WideString; var CursorType: TCursorType; var LockType: TADOLockType; var CommandType: TCommandType;  var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus; const Command: _Command; const Recordset: _Recordset);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
    procedure deleteTbTemp(nmTable:String);
    procedure getQuery(var qr:TADOQuery; cmd:string);
    procedure getQuerySemTimeOut(var qr:TADOQuery; cmd:string; timeOut:integer);
    procedure getTable(var tb:TADOTable; tbFields:string);
    procedure getTableComNome(var tb:TADOTable; tbFields, nomeTb:String);
    procedure loadCommandsBD(arquivo:String);
    procedure OrdenaDs(ds:TdataSet; grid: TSoftDbGrid; col:TColumn);
    procedure openConnection(arqIni:String);
    procedure ordernaQuery(qr: TADOQuery; grid:TsoftDbGrid; col: Tcolumn);
    procedure organizarQuery(var query:TADOQuery;grid:TsoftDbGrid; Coluna:Tcolumn);
    procedure organizarTabela(var tabela:TADOTable; grid:TsoftDbGrid; Coluna:Tcolumn);
    procedure organizarTabelaGrid(var tabela:TADOTable; grid:TSoftDbGrid; Coluna:Tcolumn);
    procedure persistirParam(setor, nmParam, valor:String);
    procedure setaCampoMoneyParaDuasCasas(ds:TdataSet; fieldName:String);
    procedure setParam(var cmd:String; vlParam:String);
    procedure setParams(var cmd:String; vp1, vp2, vp3 :String);
    procedure setQt4Params(var cmd:String; vlp1, vlp2, vlp3, vlp4 :String);
    procedure setQtParam(var cmd:String; p:String);
    procedure setQtParams(var cmd:String; vlp1, vlp2, vlp3 :String);
    procedure setQtParamsLst(var cmd:String; Params:TStringList);
    procedure setParamsLst(var cmd:String; Params:TStringList);



  private

    { Private declarations }
  public
     ARQ_RESOURCE:TiniFile;
  end;

var
  dm: Tdm;

implementation

uses f, funcSQL, uCmd;

{$R *.dfm}

procedure Tdm.conExecuteComplete(Connection: TADOConnection;  RecordsAffected: Integer; const Error: Error;  var EventStatus: TEventStatus; const Command: _Command;  const Recordset: _Recordset);
begin
   Screen.cursor := 0;
end;

procedure Tdm.setParam(var cmd:String; vlParam:String);
begin
   uCmd.setParam(cmd, vlParam);
end;

procedure Tdm.conWillExecute(Connection: TADOConnection;  var CommandText: WideString; var CursorType: TCursorType;  var LockType: TADOLockType; var CommandType: TCommandType;  var ExecuteOptions: TExecuteOptions; var EventStatus: TEventStatus;  const Command: _Command; const Recordset: _Recordset);
begin
   Screen.cursor := -11{crHourGlass};
   f.gravaLog(CommandText);
end;

function Tdm.getDataSetQ(comando: String): TDataSet;
begin
   result :=funcSQL.getDataSetQ(comando, con);
end;

function Tdm.getDataSetQArq(arq:String):TDataSet;
begin
   result :=funcSQL.getDataSetQArq(arq, con);
end;

function Tdm.getListagem(Comando:String; idx:integer):Tstringlist;
begin
   result := funcSQL.getListagem(Comando, idx, con);
end;

procedure Tdm.getTable(var tb: TADOTable; tbFields: string);
begin
   // cria a tabela e retorna ela aberta
   funcSQL.getTable(con, tb, tbFields);
end;

procedure Tdm.getTableComNome(var tb:TADOTable; tbFields, nomeTb:String);
begin
   funcSQL.getTable(con, tb, tbFields, nomeTb);
end;

function Tdm.openSQL(cmd, retorno: String): String;
begin
   result := funcSQL.openSQL(cmd, retorno, con);
end;

function Tdm.somaColunaTable(Table:TDataSet;Coluna:String):real;
begin
   result := funcSQL.somaColunaTable(Table, Coluna);
end;

function Tdm.somaColDataSet(Table:TDataSet;Coluna:String):real;
begin
   result := funcSQL.somaColunaTable(Table, Coluna, true);
end;

function Tdm.execSQL(comando:string):boolean;
begin
   screen.Cursor := crHourGlass;
   result := funcSQL.execSQL(comando, con);
   screen.Cursor := crHourGlass;
end;

function Tdm.execSQL2(cmd:string):String;
begin
   result := funcSQL.openSQL( cmd, '@@error', con);
end;

function Tdm.getMediaDeUmaColuna(ds:TDataSet; coluna:String):String;
begin
   result := funcSQL.getMediaDeUmaColuna(con, ds, coluna);
end;

procedure Tdm.getQuery(var qr:TADOQuery; cmd:string);
begin
   funcSQL.getQuery(con, qr, cmd );
end;

procedure Tdm.getQuerySemTimeOut(var qr:TADOQuery; cmd:string; timeOut:integer);
begin
   funcSQL.getQuery(con, qr, cmd, timeout );
end;

function Tdm.criaTabelaTemporaria(camposTabela:String):String;
begin
   // cria uma tabela temporaria e retorna no nome da bichinha
   result := funcSQL.criaTabelaTemporaria(con, camposTabela);
end;

function TDM.getContadorWell(campo:String):String;
begin
{  contadpres que ja sei que podem retornar
   is_doc
   is_Lanc
   is_movi
   is_oper
   is_planod
   is_nota
   SeqItemPedido
}
   result := funcSQL.getContadorWell(con, campo);
end;

function Tdm.getParamBD(nParametro, loja: String):String;
var
   str:String;
   cmd:String;
begin
  str := funcSQL.getParamBD(nParametro, loja, con);
  f.gravaLog('parametro: ' + nParametro + ' loja: ' + loja +' Resultado: '+ str );
  result := str;
end;

function Tdm.getParamEstBD(nParametro, loja, estacao: String): String;
var
   cmd:String;
begin
   cmd := dm.getQtCMD3('sql','getParamBd', nParametro, loja, estacao );

   cmd := openSQL(cmd, '');

   if cmd = '' then
      f.gravaLog(#13+'Parametro: ' + nParametro + ' ' + estacao + ' n�o existe.' +#13 );

   result := cmd;
end;

function Tdm.getParamIntBD(nParametro, loja: String):Integer;
begin
	result := strToint(getParamBD(nParametro,loja));
end;

function Tdm.getParamBDBool(nParametro, loja: String):boolean;
begin
   result := strtoBool(getParamBD(nParametro, loja));
end;

function Tdm.getDateBd():TDate;
begin
   f.gravaLog('Tdm.getDateBd()');
   result := funcSQL.getDateBd(con, 0);
end;

function Tdm.getDateAntBd(diasARecuar:integer):TDate;
begin
   result := funcSQL.getDateBd(con, diasARecuar);
end;

function Tdm.getDataAntBd(diasARecuar:integer):String;
begin
//   retorna a data no padrao aa/mm/ddd
   result := funcSQL.getDataBd(con, diasARecuar);
end;

function Tdm.getDataBd():String;
begin
//   retorna a data no padrao aa/mm/ddd
   result := funcSQL.getDataBd(con, 0);
end;

function Tdm.somaColTable(Table:TDataSet; Coluna:String; isFormatado:boolean):String;
begin
   result := funcSQL.somaColTable(Table, Coluna, isFormatado);
end;

function Tdm.getValorWell(ExeOrOpen:char; Comando:String; campoRetorno:String):string;
begin
   result := funcSQL.getValorWell(ExeOrOpen, Comando, campoRetorno, con);
end;

function Tdm.getEmail(loja:string):String;
begin
   result := OpenSQl( 'Select email from zcf_tbuo (nolock) where is_uo= ' + loja , 'email');
end;

function Tdm.getNomeTableTemp():String;
var
  i:integer;
begin
   randomize;
   i:= random(99999);
   result := '#' +  f.getNomeDaEstacao() +'_'+  f.sohNumeros(dm.getDataHoraBD()) +  inttostr(i);
end;

function Tdm.getValoresSQL2(Comando:String):Tstrings;
begin
   result := funcSQL.getValoresSQL2(Comando, con);
end;

function Tdm.getValoresSQL(lista:Tstrings; comando:String):Tstrings;
begin
   result := funcSQL.getValoresSQL(Lista, Comando, con)
end;

function Tdm.getCustoPorData(uo, is_ref, data: String): String;
begin
   result := funcSQL.getCustoPorData(uo, is_ref, data, con);
end;

function Tdm.getDataHoraBD(): String;
begin
	//retonna a data e hora do banco
   // 22/04/2014 23:43:23
   result := dateTimeToStr( funcSQL.getDateTimeBd(con, 0));
end;

function Tdm.getHoraBD():String;
var
  hora, min, seg, msec:word;
begin
   DecodeTime(funcSQL.getDateTimeBd(con,0), hora, min, seg, msec);
   result :=   f.preencheCampo(02, '0', 'E', floatToStr(hora)) +':'+ f.preencheCampo(02, '0', 'E', floatToStr(min));
end;

function Tdm.delParamBD(nParametro, loja: String): boolean;
begin
   result :=funcSQL.delParamBD(nParametro, loja, con);
end;

function Tdm.insertParamBD(nParametro, loja, valor,
  descricao: String): boolean;
begin
   result := funcSQL.insertParamBD(nParametro, loja, valor, descricao, '', con);
end;

function Tdm.updateParamBD(nParametro, loja, valor,  descricao: String): boolean;
begin
   result := funcSQL.updateParamBD(nParametro, loja, valor, descricao, '', con);
end;

function Tdm.setParamBD(parametro, uo, valor:String):boolean;
begin
   result := funcSQL.setParamBD(parametro, uo, valor, con);
end;


function Tdm.isHoraPermitida(tela: integer; grupo: String): boolean;
begin
   result := funcSQL.isHoraPermitida(con, tela, grupo);
end;

function Tdm.getHint(nObjeto: String): String;
begin
   result :=funcSQL.getHint(nObjeto, con);
end;

function Tdm.execSqlInt(cmd:String):integer;
begin
   result := funcSQL.executeSQLint(cmd, con );
end;

procedure Tdm.loadCommandsBD(arquivo:String);
begin
   if (fileExists(arquivo) = true) then
   begin
      f.gravaLog('Carregando o resources: ' + arquivo );
      ARQ_RESOURCE := TIniFile.Create(arquivo);
   end
   else
   begin
      f.gravaLog('Nao existe esse arquivo de resources: ' + arquivo );
      Application.Terminate();
   end;
end;

procedure Tdm.organizarQuery(var query: TADOQuery; grid:TsoftDbGrid; Coluna: Tcolumn);
begin
   OrdenaDs(query, grid, coluna);
   funcSQL.organizarQuery(query, Coluna);
end;

procedure Tdm.OrdenaDs(ds:TdataSet; grid: TSoftDbGrid; col:TColumn);
var
   i:integer;
   asc, desc, aux:String;
begin
   asc:= '-> ';
   desc := '<- ';
   for i:= 0 to grid.Columns.Count -1 do
   begin
      aux :=grid.Columns[i].Title.Caption;
      if (pos(asc, aux) > 0  ) or
         (pos(desc, aux) > 0  ) then
      begin
         f.gravaLog(aux);
         f.gravaLog(pos(desc, aux));
         f.gravaLog(pos(asc, aux));

         aux := copy(aux, 4, 100);

         grid.Columns[i].Title.Caption := aux;
      end
      else
      grid.Columns[i].Title.Caption := trim(aux);
   end;

   if  (ds.Tag = 1)  then
      grid.Columns[ col.Index ].Title.Caption :=  asc + grid.Columns[col.Index].Title.Caption
   else
      grid.Columns[ col.Index ].Title.Caption :=  desc + grid.Columns[col.Index].Title.Caption;
end;   

procedure Tdm.ordernaQuery(qr: TADOQuery; grid:TsoftDbGrid; col: Tcolumn);
begin
   if qr.IsEmpty = false then
   begin
      funcSQL.organizarQuery(qr, Col);
      OrdenaDs(qr, grid, col);
   end;
end;

procedure Tdm.organizarTabela(var tabela:TADOTable; grid:TsoftDbGrid; Coluna:Tcolumn);
begin
   funcSQL.organizarTabela(tabela, coluna);
end;

procedure Tdm.organizarTabelaGrid(var tabela:TADOTable; grid:TSoftDbGrid; Coluna:Tcolumn);
begin
   funcSQL.organizarTabela(tabela, coluna);
   OrdenaDs(tabela, grid, Coluna);
end;

function Tdm.exportacaoDeTabela(tb: TdataSet; tipoSaida: TmxExportType; estilo: TmxExportStyle; nomeArq: String): String;
begin
   result := funcSQL.exportacaoDeTabela(tb, tipoSaida, estilo, nomeArq);
end;

function Tdm.exportacaoDeTabelaExcel(tb: TdataSet): String;
begin
   result := funcSQL.exportacaoDeTabela(tb, xtExcel, xsView,  '');
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin
  ARQ_RESOURCE.Free();
  con.Free();
end;

procedure Tdm.persistirParam(setor, nmParam, valor: String);
begin
   ARQ_RESOURCE.WriteString(setor, nmParam, valor);
end;

function Tdm.getCMD(setor, chave:String):String;
begin
   gravaLog('/*  '+ setor + '*/');
   gravaLog('/*  '+ chave + '*\');
   result := uCmd.getCMD(ARQ_RESOURCE, setor, chave);
end;

function Tdm.getCMD1(setor, chave, p:String):String;
var
   aux:String;
begin
   aux := getCMD(setor, chave);
   setParam(aux, p);
   result := aux;
end;

function Tdm.getQtCMD1(setor, chave, p:String):String;
var
   aux:String;
begin
   aux := getCMD(setor, chave);
   setQtParam( aux, p);
   result := aux;
end;

function Tdm.getCMD2(setor, chave, p1, p2:String):String;
begin
   result := getCMD3(setor, chave, p1, p2, '');
end;

function Tdm.getCMD3(setor, chave, p1, p2, p3:String):String;
var
   aux:String;
begin
   aux := getCMD(setor, chave);
   setParams(aux, p1, p2, p3);
   result := aux;
end;

function Tdm.getCMD4(setor, chave, p1, p2, p3, p4 :String):String;
var
   aux:String;
begin
   aux := getcmd3( setor, chave, p1, p2, p3);
   setParam(aux, p4);
   result := aux;
end;

function Tdm.getCMD5(setor, chave, p1, p2, p3, p4, p5 :String):String;
var
   aux:String;
begin
   aux := getcmd4( setor, chave, p1, p2, p3, p4);
   setParam(aux, p5);
   result := aux;
end;

function Tdm.getCMD6(setor, chave, p1, p2, p3, p4, p5, p6 :String):String;
var
   aux:String;
begin
   aux := getcmd5( setor, chave, p1, p2, p3, p4, p5);
   setParam(aux, p6);
   result := aux;
end;

function Tdm.getCMD7(setor, chave, p1, p2, p3, p4, p5, p6, p7 :String):String;
var
   aux:String;
begin
   aux := getcmd6( setor, chave, p1, p2, p3, p4, p5, p6);
   setParam(aux, p7);
   result := aux;
end;

function Tdm.getCMD8(setor, chave, p1, p2, p3, p4, p5, p6, p7, p8:String):String;
var
   aux:String;
begin
   aux := getcmd7( setor, chave, p1, p2, p3, p4, p5, p6, p7);
   setParam(aux, p8);
   result := aux;
end;

procedure Tdm.setParams(var cmd:String; vp1, vp2, vp3 :String);
begin
   setParam(cmd, vp1);
   setParam(cmd, vp2);
   setParam(cmd, vp3);
end;

procedure Tdm.setQt4Params(var cmd:String; vlp1, vlp2, vlp3, vlp4 :String);
begin
	setQtParams(cmd, vlp1, vlp2, vlp3);
   setQtParam(cmd, vlp4);
end;

procedure Tdm.setQtParams(var cmd:String; vlp1, vlp2, vlp3 :String);
begin
   setQtParam(cmd, vlp1);
   setQtParam(cmd, vlp2);
   setQtParam(cmd, vlp3);
end;

procedure Tdm.setQtParamsLst(var cmd:String; Params:TStringList);
var
  i:integer;
begin
   for i:=0 to params.count -1 do
      setQtParam(cmd, Params[i]);
end;

procedure Tdm.setParamsLst(var cmd:String; Params:TStringList);
var
  i:integer;
begin
   for i:=0 to params.count -1 do
      setParam(cmd, Params[i]);
end;

procedure Tdm.setQtParam(var cmd:String; p:String);
begin
    uCMD.setQtParam(cmd, p);
end;

function Tdm.getMsg(codMSg: String): String;
begin
   result := uCmd.getCMD(ARQ_RESOURCE, 'MSG', codMSg);
end;

function Tdm.getQtCMD3(setor, chave, p1, p2, p3:String):String;
var
   aux:String;
begin
   aux := getCMD( setor, chave);
   setQtParams(aux, p1, p2, p3);
   result := aux;
end;

function Tdm.getQtCMD4(setor, chave, p1, p2, p3, p4:String):String;
var
   aux:String;
begin
   aux := getCMD( setor, chave);
   setQtParams(aux, p1, p2, p3);
   setQtParam(aux, p4);
   result := aux;
end;

function Tdm.getQtCMD5(setor, chave, p1, p2, p3, p4, p5:String):String;
var
   aux:String;
begin
   aux := getQtCMD4(setor, chave, p1, p2, p3, p4);
	setQtParam(aux, p5);
   result := aux;
end;

function Tdm.getQtCMD6(setor, chave, p1, p2, p3, p4, p5, p6:String):String;
var
   aux:String;
begin
   aux := getQtCMD5(setor, chave, p1, p2, p3, p4, p5);
	setQtParam(aux, p6);
   result := aux;
end;



function Tdm.getQtCMD2(setor, chave, p1, p2:String):String;
begin
   result := getQtCMD3(setor, chave, p1, p2, '');
end;


function Tdm.getStrConexao(arq:String):String;
var
  url, db, userName, password, server:String;
begin
	try
      f.gravaLog('getStrConexao(): '+ arq);

      url := f.getParamIni(arq, 'Conexao', 'url');
      server := f.getParamIni(arq, 'Conexao', 'server');
      db := f.getParamIni(arq, 'Conexao', 'bd');
      password := f.getParamIni(arq, 'Conexao', 'password');
      userName := f.getParamIni(arq, 'Conexao', 'user');

      setParam(url, server );
      setParam(url, db );
      setParam(url, userName );
      setParam(url, password );
      setParam(url, 'pcf_'+f.getNomeDaEstacao() );

      f.gravaLog('String de conex�o:---------------------------- ');
      f.gravaLog(url);

      if (trim(url) = '') or  (trim(server) = '') or  (trim(db) = '') or
         (trim(password) = '') or (trim(userName) = '') then
         msgErro('Arquivo de conex�o incompleto, falta algum par�metro.');

      result := url;
      f.gravaLog('getStrConexao() - fim ');
	except
   	on e:exception do
      begin
      	f.gravaLog('Erro em getStrConexao()' + e.Message);
         result := '';
      end;
   end
end;



procedure Tdm.DataModuleCreate(Sender: TObject);
begin
   openConnection('');
end;

procedure Tdm.closeConnection();
begin
   con.Close();
end;

procedure Tdm.openConnection(arqIni:String);
begin
	try
      f.limparLog();
      f.gravaLog('Tdm.DataModuleCreate()');

      con.ConnectionString := getStrConexao(arqIni);

      con.Connected := true;
      dm.execSQL('set dateformat ymd');
      con.CommandTimeout := 0;
   except
     on e:exception do
     begin
        f.gravaLog('Erro ao conectar o bd, erro' + e.Message );
        msgErro('Erro ao conectar ao banco de dados.');
        Application.Terminate();
     end;
   end;
   f.gravaLog('Tdm.DataModuleCreate() - Fim');   
end;

function Tdm.getListagemH(Comando:String):String;
begin
   result := funcSQL.getListagemH(Comando, con, false);
end;

function Tdm.execSQLs(comandos:Tstringlist; execSeparado:boolean):boolean;
var
  cmd:String;
  i:integer;
begin
   if (execSeparado = false) then
   begin
     cmd := '';
     for i:=0 to comandos.Count -1 do
        cmd := cmd + comandos[i] + #13;

     result := execSQL(cmd);
   end
   else
   begin
      for i:=0 to comandos.Count -1 do
         result := execSQL(comandos[i]);
   end
end;

function TDm.getIdentity():String;
begin
   result := funcSQL.getIdentity(con);
end;

function TDm.getDsFromExcel(arqXls:String):String;
begin
	result := funcSQL.getDsFromExcel(con, arqXls);
end;


procedure Tdm.conInfoMessage(Connection: TADOConnection;
  const Error: Error; var EventStatus: TEventStatus);
begin
//   if (EventStatus = esErrorsOccured) then
   	f.gravaLog(error.SQLState);
end;


procedure Tdm.deleteTbTemp(nmTable: String);
begin
   dm.execSQL('drop table ' + nmTable);
end;

function Tdm.getCMDArq(arq: String): String;
var
   lst:TStringlist;
   i:integer;
   cmd:String;
begin
   lst := TStringlist.Create();
   lst.LoadFromFile(arq);
   for i:= 0 to lst.Count-1 do
      cmd:= cmd + lst[i] + ' ';
   lst.Free();
   result := cmd;
end;



procedure Tdm.setaCampoMoneyParaDuasCasas(ds: TdataSet; fieldName: String);
begin
   funcSQL.setaCampoMoneyParaDuasCasas(ds, fieldName);
end;

end.
