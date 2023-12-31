unit Unit8;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, TFlatButtonUnit, StdCtrls, adLabelComboBox, Grids,
  DBGrids, SoftDBGrid, DB, ADODB, unit1, funcoes, ExtCtrls, ImgList,
  DBCtrls, fDBCtrls, Menus;

type
  TForm8 = class(TForm)
    cbLojas: TadLabelComboBox;
    BitBtn2: TFlatButton;
    Query: TADOQuery;
    DataSource1: TDataSource;
    grid: TSoftDBGrid;
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    cbTpListas: TadLabelComboBox;
    GroupBox3: TGroupBox;
    dt1: TDateTimePicker;
    dt2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btGeraCredito: TFlatButton;
    PopupMenu1: TPopupMenu;
    Gerarorecibodobonus1: TMenuItem;
    procedure BitBtn2Click(Sender: TObject);
    procedure gridTitleClick(Column: TColumn);
    procedure preparaTelaCredito(usuario:String);
    procedure FormCreate(Sender: TObject);
    procedure consultaRelatorioVendas(tipoDeLista:String);
    procedure chamaConsultaCredito(Sender:Tobject);
    procedure btGeraCreditoClick(Sender: TObject);
    procedure gerarCreditos(usAutorizador:String);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Gerarorecibodobonus1Click(Sender: TObject);
  private
    { Private declarations }
  public
    PERFIL:integer;

    { Public declarations }
  end;

var
  Form8: TForm8;
  AUTORIZADOR:String;
implementation

uses uDm, msg, uCredCli, fdt, uLista, f;

{$R *.dfm}


procedure TForm8.consultaRelatorioVendas(tipoDeLista:String);
var
   NumLoja ,cmd :String;
begin
  query.SQL.Clear();
  grid.Visible := false;
  NumLoja := funcoes.SohNumeros( cbLojas.Items[cblojas.itemIndex]);

  cmd := 'exec stoListaValoresComprasPorListas ' +
         fdt.DateTimeToSqlDateTime( dt1.Date,'') +', '+
         fdt.DateTimeToSqlDateTime( dt2.Date,'') +', '+
         quotedstr(numLoja)  +' , ';

  if tipoDeLista <> '' then
     cmd := cmd +  quotedStr(tipoDeLista)
  else
     cmd := cmd + quotedStr(funcoes.tiraEspaco(copy(cbTpListas.items[cbTpListas.ItemIndex], 40, 20))) ;


   dm.getQuery(Query, cmd);

   grid.Columns[0].Width := 22;
   grid.Columns[1].Width := 134;
   grid.Columns[2].Width := 176;
   grid.Columns[3].Width := 185;
   grid.Columns[4].Width :=54;
   grid.Columns[5].Width :=72;
   grid.Columns[6].Width :=62;
   grid.Columns[7].Width :=82;
   grid.Columns[8].Width :=82;


   grid.Columns[ Query.Fields.IndexOf(query.FieldByName('codWell'))].visible := false;
   grid.Columns[ Query.Fields.IndexOf(query.FieldByName('numLista'))].visible := false;   

   label2.caption :=    dm.somaColTable( query, 'valor', true);
   label3.caption :=    dm.somaColTable( query, 'Itens comprados', true);
   grid.Visible := true;
   query.First();   
end;

procedure TForm8.gridTitleClick(Column: TColumn);
begin
    dm.OrganizarQuery(query, grid, column);
end;

procedure TForm8.preparaTelaCredito(usuario:String);
begin
   if (fmMain.RParReg('loja') = '00') then
   begin
     cbLojas.Items.Clear;
     cbLojas.Items.Add( fmMain.RParReg('loja') );
   end;
   cbLojas.ItemIndex := 0;
   dt1.Date := now -1;
   dt2.Date := dt1.Date;
   cbTpListas.Visible := false;
   perfil := 2;
   AUTORIZADOR:= usuario;
   form8.Caption := 'Gera��o de cr�dito.';
end;

procedure TForm8.FormCreate(Sender: TObject);
begin
   cblojas.Items := fmMain.GetNumLojas(fmMain.RParReg('Loja'));
   cbTpListas.Items := fmMain.GetTiposListas(true,'');
   cbTpListas.ItemIndex := 0;
   cblojas.ItemIndex := 0;
   dt1.Date := now;
   dt2.Date := now;
   form8.Width := screen.Width;
   form8.Left := 0;
   form8.Top := 1;
end;


procedure TForm8.chamaConsultaCredito(Sender: Tobject);
var
  tiposDelista:String;
begin
   tiposDelista := fmMain.GetParamBD('TpListasPCredito', fmMain.RParReg('loja'));

   if (dt1.Date >= now)  or  (dt2.Date >= now) then
      msg.msgErro('Voce s� pode consultar listas que os eventos em que a data seja menor que a data de hoje. ')
    else
    begin
      consultaRelatorioVendas(tiposDelista );
      if (query.IsEmpty = false) then
         btGeraCredito.Visible := true;


      f.ajGridCol(grid, Query, 'percBonus', 0, '');
    end;
end;

procedure TForm8.BitBtn2Click(Sender: TObject);
begin
   funcoes.gravaLog('perfil selecionado: '  + intToStr(perfil));
   case perfil of
      1:consultaRelatorioVendas('');
      2:chamaConsultaCredito(nil);
   end;
end;

procedure TForm8.gerarCreditos(usAutorizador:String);
var
  errocad, erro, itensFora:String;
  valor:real;
  aviso:boolean;
begin
   erro := '';
   errocad := '';
   aviso:= false;
   valor:=0;

   if Query.FieldByName('codWell').AsInteger = 0 then
      erro := 'Falta o c�digo do cliente no well'

   else if (fmMain.isCodClClienteWell(Query.FieldByName('codWell').AsString) = false) then
      erroCad := 'O c�digo informado para o cliente Well � inv�lido.';

   if Query.FieldByName('Credito gerado').asString = 'Sim' then
      erro := erro + ' J� consta cr�dito gerado para essa lista.'+ #13;

   if (erro <> '') or (errocad <> '')  or ( query.fieldByname('valor').asFloat = 0 ) then
   begin
      if (erro <> '') then
      begin
          erro := 'Corrija antes esses erros: ' +#13+ erro;
          msg.msgErro(erro);
      end;

      if (erroCad <> '') then
         msg.msgErro(' O codigo de cliente informado para well � inv�lido, '+#13);

      if (query.fieldByname('valor').asFloat = 0) then
        msg.msgErro(' Nenhum item foi comprado para essa lista., '+#13);

      if (query.fieldByname('valor').AsString = 'sim' ) then

   end
   else
   begin
      valor :=
      uLista.calcVlBonusLista( itensFora, query.fieldByname('numLista').asString);

      valor := valor * query.fieldByname('percBonus').AsFloat;

      if (itensFora <> '' )then
	      msgWarning(itensFora);

//gerar credito de cliente no well
      uCredCli.gerarCreditoDecliente(
         fmMain.GetParamBD('codEmpWell',''),
         usAutorizador,
         query.fieldByname('codWell').AsString ,
         fmMain.RParReg('loja'),
         funcoes.valorSql(valor),
         fmMain.getconexaoWell()
       );

      dm.execSQL(dm.getCMD1('LST', 'setCredGerado',query.fieldByname('numLista').asString));

      msg.msgExclamation(dm.getCMD1('MSG', 'bonusGerado', funcoes.floatToMoney(valor)) );
      BitBtn2Click(nil);
   end;
end;

procedure TForm8.btGeraCreditoClick(Sender: TObject);
begin
   msg.msgWarning ( dm.getMsg('avisoCredito'));
   begin
      gerarCreditos( AUTORIZADOR );
   end;
end;


procedure TForm8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   action := CaFree;
end;

procedure TForm8.Gerarorecibodobonus1Click(Sender: TObject);
var
  lst:Tstringlist;
begin
   if Query.fieldByname('Credito gerado').AsString = 'Sim' then
   begin
      lst := TStringList.Create();
      lst.Add( Query.fieldByname('Noiva').AsString );
      lst.Add( Query.fieldByname('Noivo').AsString );
      lst.Add( funcoes.floatToMoney( (Query.fieldByname('Valor').AsFloat * 0.1)));
      lst.Add( DateToStr(now) );
      lst.Add( fmMain.RParReg('TitRel') );
      lst.Add( fmMain.RParReg('arqLogo') );
      fmMain.imprimeRave (Query, nil, nil, 'rpRecibo', lst);
   end
   else
      msg.msgWarning('S� � gerado o recibo de bonus ap�s a gera��o do cr�dito');
end;

end.
