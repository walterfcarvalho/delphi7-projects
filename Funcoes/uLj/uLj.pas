unit uLj;

interface

uses messages, ComCTRLs,ExtCtrls,  adLabelComboBox, Classes, DB, forms, f,
     StdCtrls, uDm, dialogs, windows,  uSelecionaUo,  Sysutils;

   function formataListaUos(ds:TdataSet; IncluirLinhaTodas:Boolean; IncluiNenhuma:Boolean):TstringList;
   function getCdUoFromIsUo(is_uo:String):String;
   function getCdRecebReq():Tstrings;
   function getComboBoxLojas(IncluirLinhaTodas:Boolean; IncluiNenhuma:Boolean; cdPes, uoLogada: String):TcomboBox;
   function getDadosUo(uo:String):TdataSet; overload;
   function getDadosUo(is_uo, campo:String):String;overload;
   function getDepositos():TdataSet;
   function getDsLojas(cdPes:String):TdataSet;
   function getIsUO(cd_uo:String):String; overload;
   function getIsUo(mostraEscritorio:boolean):String; overload;
   function getIsUoFromCGF(ie:String):String;
   function getIsUoFromCNPJ(CNPJ:String):String;
   function getStrDadosUO(uo:String):String;
   function getNomeUO(cbox:TCustomComboBox):string;
   function isCd(is_uo:String):boolean;
   function isDeposito(uo:String):boolean;
   function getNmCurto(cd_uo:String):String;

   procedure getComboBoxLjMapa(cb:TComboBox);
   procedure getListaEmpresas(cb:TadLabelComboBox);
   procedure getListaLojas(cb:TComboBox; IncluirLinhaTodas, IncluiNenhuma:Boolean; cdPes, uoLogada: String); overload;
   procedure getListaLojas(cb:TComboBox; IncluirLinhaTodas, IncluiNenhuma:Boolean; cdPes, uoLogada, uoParaRemover: String); overload


implementation


function getDadosUo(is_uo, campo:String):String;overload;
var
  ds:TdataSet;
begin
   ds := getDadosUo(is_uo);
   result := ds.fieldByName(campo).AsString;
   ds.free();
end;

function getNomeUO(cbox:TCustomComboBox):string;
begin
   result := copy(cbox.Items[cbox.itemIndex], 01, 30) ;
end;

function getDepositos():TdataSet;
begin
   result := dm.getDataSetQ(dm.getCMD('FmMapa', 'getUoRequisitadas'));
end;

function formataListaUos(ds:TdataSet; IncluirLinhaTodas:Boolean; IncluiNenhuma:Boolean):TstringList;
var
   aux:TStringList;
begin
   aux := TstringList.create();

   if (incluirLinhaTodas = true) then
     aux.Add(f.preencheCampo(100,' ','D','  Todas') + '999');

   if (incluiNenhuma = true) then
     aux.Add( f.preencheCampo(100,' ','D',' Nenhuma ' ) + '-1');

   ds.First;
   while (ds.Eof = false) do
   begin
      aux.add(f.preencheCampo(100,' ','D',ds.Fields[0].AsString) +ds.Fields[1].AsString );
      ds.Next;
   end;
   result := aux;
end;

function getDsLojas(cdPes:String):TdataSet;
var
  cmd:String;
begin
   if (cdPes = '') then
      cmd := dm.getCMD('uo', 'listaTodas')
    else
      cmd := dm.getCMD1('uo', 'comAcesso', cdPes);
   result := dm.getDataSetQ(cmd);
end;

procedure getListaLojas(cb:TComboBox;IncluirLinhaTodas:Boolean; IncluiNenhuma:Boolean; cdPes, uoLogada: String); overload;
begin
	getListaLojas(cb, IncluirLinhaTodas, IncluiNenhuma, cdPes, uoLogada, '');
//  f.gravaLog(cb.Items)
end;

procedure getListaLojas(cb:TComboBox;IncluirLinhaTodas, IncluiNenhuma:Boolean; cdPes, uoLogada, uoParaRemover: String); overload
var
   ds:TdataSet;
   i:integer;
begin
   cb.Items.Clear();

   ds:= getDsLojas(cdPes);

   cb.Items :=  formataListaUos(ds, IncluirLinhaTodas, IncluiNenhuma);

   if (uoParaRemover <> '') then
     for i:=0 to cb.Items.Count -1 do
     begin
        cb.ItemIndex := i;
        if (f.getCodUO(cb) = UoParaRemover )then
          cb.Items.Delete(i);
     end;

   cb.DropDownCount := cb.items.count;
	f.setUoNacomboBox(cb, uoLogada);
end;



function getComboBoxLojas(IncluirLinhaTodas, IncluiNenhuma:Boolean; cdPes, uoLogada: String):TcomboBox;
var
   cbLj :TComboBox;
begin
   cbLj := TComboBox.Create(nil);
   cbLj.ParentWindow := application.mainForm.Handle;

   uLj.getListaLojas(cbLj, false, false, cdPes, uoLogada);

   result := cbLj;
end;


function getIsUo(mostraEscritorio:boolean):String;
var
   aux:String;
begin
   Application.CreateForm(TfmSelecionaUo, fmSelecionaUo);

   aux := '';
   getListaLojas( fmSelecionaUo.cbLojas, false, false, '', '');

   if (mostraEscritorio = true) then
      fmSelecionaUo.cbLojas.Items.add(f.preencheCampo(50,' ','D','Escritorio'));

   fmSelecionaUo.showModal();

//   if (fmSelecionaUo.modalResult = mrOk) then
      aux:= f.getCodUO(fmSelecionaUo.cbLojas);

  fmSelecionaUo := nil;
  result := aux;
end;

procedure getComboBoxLjMapa(cb:TComboBox);
var
  ds:TdataSet;
begin
  //   retorna os depositos da empresa
   ds:=  getDepositos();
   cb.Items := formataListaUos(ds, false, false);
   cb.ItemIndex := 0;
   ds.Free();
end;

function getIsUO(cd_uo:String):String; overload;
begin
  result := dm.openSQL( dm.getQtCMD1('uo', 'getIsuoFromCduo', cd_uo), '');
end;

function isDeposito(uo:String):boolean;
var
  ds:TdataSet;
begin
   ds:= getDepositos();
   result := ds.Locate('is_uo', uo, []  );
   ds.Free();
end;

function getStrDadosUO(uo:String):String;
var
  cmd:String;
begin
   cmd := dm.getCMD('Fiscal', 'getDadosLoja' );

   if (uo <> '') and (uo <> '999')  then
      cmd := cmd + dm.getCMD1('Fiscal', 'getDadosLoja.uo', uo);

   cmd := cmd + dm.getCMD('Fiscal', 'getDadosLoja.order');

   result := cmd;
end;

function getDadosUo(uo:String):TdataSet;
begin
   result :=  dm.getDataSetQ(getStrDadosUO(uo));
end;

function getIsUoFromCNPJ(cnpj:String):String;
var
  ds:TdataSet;
begin
   ds:= getDadosUO('');

   ds.First();
   while (ds.Eof = false) do
   begin
      if ( f.sohNumerosPositivos(ds.FieldByName('CNPJ').AsString) = CNPJ) then
      begin
         result := ds.fieldByName('is_uo').asString;
         break;
      end;
      ds.Next();
   end;
   ds.free;
end;

function getIsUoFromCGF(ie:String):String;
begin
   result := dm.openSQL(dm.getCMD1('uo', 'getUoFromCgf', ie), '')
end;

procedure getListaEmpresas(cb:TadLabelComboBox);
begin
   cb.items :=  dm.getListagem(dm.getCMD('uo', 'getEmpresas'),0);
   cb.DropDownCount := cb.Items.Count;
end;

function getCdRecebReq():Tstrings;
var
	ds:Tdataset;
begin
	// lista os depositos que podem receber requisicao
	//   pararametro da zcf_paramgerais  = isCdRecebReq

	ds := dm.getDataSetQ( dm.getCMD('uo', 'getUoRecReq'));
   result := ulj.formataListaUos(ds, false, false);
end;

function isCd(is_uo:String):boolean;
begin
	result := (dm.getParamBD('uoIsCd', is_uo) = '1');
end;

function getCdUoFromIsUo(is_uo:String):String;
begin
	result := dm.openSQL(dm.getCMD1('uo','getCdUoFromIsUo', is_uo), '');
end;

function getNmCurto(cd_uo:String):String;
begin
	// retorna o nome curto da loja a partir do cd_uo
	result := dm.openSQL(dm.getCMD1('uo', 'getNomeCurto', quotedStr(cd_uo)), '');
end;




end.

