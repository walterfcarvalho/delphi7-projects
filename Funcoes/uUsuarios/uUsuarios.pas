
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
   function getListaAutPonto(autBatida:boolean):Tstringlist;
   function getTelasPrograma():TstringList;

   procedure ajPermissaoUser(cd_pes, codTela:String; isRestrito, IsPedeAut, isTotal, isAcessa:boolean);
   procedure desativaUsuario(cd_pes:String);



implementation

uses uAutorizacao, Udm, f, msg;

function getStrConsultaUsuarios(loja, grupos, users:String):String;
var
  cmd:String;
  ds:TdataSet;
begin
//   if users = '' then users := '-1';
//   if Grupos = '' then Grupos := '-1';

   ds:= dm.getDataSetQ(dm.getCmd('aut', 'buscaWell'));

   if (ds.IsEmpty = false) then
   begin
      cmd:=
      'Select nm_usu, cd_usu, sn_ope from dsusu with(nolock) '+
      'where fl_ativo = 1 and ';

      if (length(loja) < 8) then
         loja := '';

      if (loja <> '') then
         cmd := cmd +
         'cd_pes in( select distinct cd_pes from wellcfreitas.dbo.usuariosUo with(nolock) where is_uo= ' + loja +')'
      else
         cmd := cmd +'( cd_grusu in ('+Grupos+') or cd_usu in ('+ users +') )'+ #13;

      cmd := cmd + ' order by nm_usu';
   end
   else
   begin
      cmd := dm.getCMD2('usu','listaAutPonto', loja, users);
 
   end;
   ds.free();
   result := cmd;
end;

function getUsuariosWell(loja, grupos, cd_usu:String ):Tstrings;
var
  aux:tstrings;
  ds:TdataSet;

begin
   ds:= dm.getDataSetQ( getStrConsultaUsuarios(loja, grupos, cd_usu) );

   aux := TstringList.create();
   while (ds.Eof = false) do
   begin
      aux.add(f.preencheCampo(50, ' ', 'D', ds.fieldByName('nm_usu').AsString) +
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

function getAutorizadorWell(loja, grupos, usuarios:String): String;
var
   ds:TdataSet;
   users:TStringList;
   cmd:String;
begin
   f.gravaLog('getAutorizadorWell() grupos: '+ grupos + ' usuarios:'+ usuarios);

   // abre a tela de autorizacao do well e valida a senha

   try
//      cmd := uUsuarios.getStrConsultaUsuarios(quotedStr(loja), grupos, usuarios);
//      ds:= dm.getDataSetQ( cmd );


       // formulario para informar a senha
      cmd := uAutorizacao.getUserAutorizador(nil);
      except
      begin
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


function getListaAutPonto(autBatida:boolean):Tstringlist;
var
  users:Tstringlist;
  cmd:String;
  dsUsuarios:Tdataset;
begin
{
   retorna a lista de usuarios autorizadores ja formatada
   user:   01-50 nome
   cd_usu: 51-08 cod usuario
   senha: 101-110
}

   cmd := dm.getCMD('usu', 'getAut');
   if (autBatida = true) then
      cmd := cmd + dm.getCMD('usu', 'getAut.autEnt');
   cmd := cmd + dm.getCMD('usu', 'getAut.order');

   dsUsuarios := dm.getDataSetQ(cmd);
   users := TStringList.Create();

   while (dsUsuarios.Eof = false) do
   begin
      users.Add(
         f.preencheCampo(50, ' ', 'D',  dsUsuarios.fieldByName('nm_usu').AsString) +
         f.preencheCampo(50, ' ', 'D',  dsUsuarios.fieldByName('cd_usu').AsString) +
         f.preencheCampo(10, ' ', 'D',  dsUsuarios.fieldByName('sn_ope').AsString)
      );
      dsUsuarios.next();
   end;
   dsUsuarios.Free();

   result := users;
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
