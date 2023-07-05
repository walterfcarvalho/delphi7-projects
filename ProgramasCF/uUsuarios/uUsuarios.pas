
unit uUsuarios;

interface
uses classes, SysUtils, db, adLabelComboBox, ADODB;

   function getCodUsuario(cb:TadLabelComboBox):String;

   function getUsuariosWell(loja, grupos, cd_usu:String):Tstrings;
   function getUsuariosPorLoja(loja:string):TStrings;
   function getTelasPermDoGrupo(grupo, cd_pes:String):TdataSet;
   function getGrupoAutPorTela(codTela:smallInt; grupoUser:String):String;
   function getAutorizadorWell(loja, grupos, usuarios:String): String;
   function getDadosUsuario(cd_usu:String):TDataSet;
   function getDadosPessoa(cdPes:String):TdataSet;
   function getListaAutPonto(autBatida:boolean):String;
   function getTelasPrograma():TstringList;
   function getDsUsuarios(loja, grupos, usuarios:String):TdataSet;

   procedure ajPermissaoUser(cd_pes, codTela:String; isRestrito, IsPedeAut, isTotal, isAcessa:boolean);
   procedure desativaUsuario(cd_pes:String);



implementation

uses uAutorizacao, Udm, f, msg;

function getUsuariosWell(loja, grupos, cd_usu:String ):Tstrings;
var
  aux:tstrings;
  ds:TdataSet;
begin
   ds:= uUsuarios.getDsUsuarios(loja, grupos, cd_usu) ;

   aux := TstringList.create();
   while (ds.Eof = false) do
   begin
      aux.add(
         f.preencheCampo(50, ' ', 'D', ds.fieldByName('nm_usu').AsString) +
         f.preencheCampo(50, ' ', 'D', ds.fieldByName('cd_usu').AsString) +
         f.preencheCampo(10, ' ', 'D', ds.fieldByName('sn_ope').AsString)
      );

      ds.Next;
   end;
   ds.free();
   result := aux;
end;

function getUsuariosPorLoja(loja:string):TStrings;
var
   lista:Tstringlist;
   qr:TADOQUery;
   str:String;
begin
   str:=
   'Select nm_usu, cd_usu from dsusu where cd_pes in ' +
   '(select distinct cd_pes from usuariosUo with(nolock) where is_uo = ' + loja + ' ) ' +
   ' and fl_ativo = 1  order by nm_usu';

   dm.getQuery(qr, str);
   qr.First;

   lista := Tstringlist.Create();
   while qr.Eof = false do
   begin
     lista.add( f.preencheCampo(50,' ', 'd',qr.fieldByname('nm_usu').asString) +     qr.fieldByname('cd_usu').asString);
     QR.Next;
   end;
   qr.free();
   result := lista;
end;

function getGrupoAutPorTela(codTela:smallInt; grupoUser:String):String;
var
   ds:TDataSet;
   cmd:String;
begin
   // retorna os grupos que podem autorizar uma tela


   cmd := 'select gruposAut from zcf_autorizadoresTelas where codTela = '+
           intToStr(codTela) +
          ' and grupoUser = ' + grupoUser;

   ds := dm.getDataSetQ(cmd);

   cmd := '';

   if (ds.isEmpty = true) then
      cmd  := '13'
   else
   begin
      ds.first();
      while (ds.eof = false) do
      begin
         cmd := cmd + ds.fieldByName('gruposAut').asString;
         if (ds.eof = false) then
            cmd := cmd + ', ';
         ds.next();
      end;
      cmd := cmd + ' 13';
   end;
   ds.free();
   result := cmd;
end;

function getDsUsuarios(loja, grupos, usuarios:String):TdataSet;
var
   cmd, cmd2:String;
   lst:TstringList;
   ds:Tdataset;
begin
   if usuarios = '' then usuarios := '-1';
   if grupos = '' then grupos := '-1';

   if (loja <> '') then
      cmd2:= dm.getCMD1('aut', 'get.porUo', loja)
   else
      cmd2:= dm.getCMD2('aut', 'get.GRupousers', grupos, usuarios);

   cmd := dm.getCMD1('aut', 'get', cmd2);

   result := dm.getDataSetQ(cmd);
end;

function getAutorizadorWell(loja, grupos, usuarios:String): String;
var
   ds:TdataSet;
   cmd:String;
   lst:Tstringlist;
   l1:Tstrings;
   i:integer;
begin
   try
      l1 := getUsuariosWell(loja,grupos, usuarios);
//      ds:= getDsUsuarios(loja, grupos, usuarios);
      lst := TStringlist.Create;

      for i:= 0 to l1.Count -1 do
         lst.add(l1[i]);

      cmd := uAutorizacao.getUserAutorizador( lst   );
   except
      on e:exception do
      begin
         f.gravaLog('erro:' + e.Message);
         msg.msgErro('Erro ao processar autorização');
         cmd  := '';
      end;
   end;
   result := cmd;
end;

function getTelasPermDoGrupo(grupo, cd_pes:String):TdataSet;
var
   cmd:String;
begin
   f.gravaLog('getTelasPermDoGrupo(grupo: '+ grupo + ', cd_pes: ' + cd_pes + ')' );
   cmd :=  dm.getCMD2('adm', 'getPermissaoUser', grupo, cd_pes );
   result := dm.getDataSetQ(cmd);
end;

function getDadosUsuario(cd_usu:String):TDataSet;
var
   cmd:String;
begin
   cmd :=  dm.getCMD('uo', 'getDadosUser');
   dm.setParam(cmd, cd_usu);
   result := dm.getDataSetQ(cmd);
end;


function getDadosPessoa(cdPes:String):TdataSet;
var
   cmd:String;
begin
   cmd:= dm.getCMD('Vendas', 'getDsPessoa');
   dm.setParam(cmd, cdPes);
   result := dm.getDataSetQ(cmd);
end;


function getListaAutPonto(autBatida:boolean):String;
var
  cmd:String;
begin
   cmd := dm.getCMD('usu', 'getAut');
   if (autBatida = true) then
      cmd := cmd + dm.getCMD('usu', 'getAut.autEnt');
   cmd := cmd + dm.getCMD('usu', 'getAut.order');

   result := dm.getListagemH(cmd);
end;

   function getCodUsuario(cb:TadLabelComboBox):String;
begin
   result := trim(copy(cb.Items[cb.itemIndex], 51, 20));
end;

procedure ajPermissaoUser(cd_pes, codTela:String; isRestrito, IsPedeAut, isTotal, isAcessa:boolean);
var
	cmd:String;
begin
   if (isAcessa = true) then
   begin
      cmd := dm.getCMD2('adm', 'usuInsPermUsu', cd_pes, codTela);
      dm.execSQL(cmd);

      cmd := dm.getCMD5('uo', 'setPermissaoUser', cd_pes, codTela, BoolToStr(isRestrito), BoolToStr(IsPedeAut), BoolToStr(isTotal));
      f.gravaLog(cmd);
      dm.execSQL(cmd);

   end
   else
   begin
      cmd := dm.getCMD2('adm', 'usuDelPermUsu', cd_pes, codTela);
      dm.execSQL(cmd);
   end;
end;

function getTelasPrograma():TstringList;
begin
  result := dm.getListagem('select tag from zcf_telas', 0);
end;

procedure desativaUsuario(cd_pes:String);
var
   cmd:String;
begin
   cmd := dm.getCMD1('usu', 'desativar', cd_pes);
   dm.execSQL(cmd);
end;


end.
