unit uMapa;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, ADODB, ComCtrls, Grids, DBGrids, SoftDBGrid,
  TFlatButtonUnit, StdCtrls, Buttons, fCtrls, ExtCtrls, TFlatPanelUnit,
  ToolWin;

type
  TfmMapa = class(TForm)
    grid: TSoftDBGrid;
    DataSource1: TDataSource;
    tb: TADOTable;
    pnTitulo: TFlatPanel;
    lbNumMp: TLabel;
    Label2: TLabel;
    lbDtAvaria: TLabel;
    Label5: TLabel;
    lbNome: TLabel;
    Label6: TLabel;
    mmObs: TfsMemo;
    Label3: TLabel;
    lbStatus: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    lbAprovador: TLabel;
    lbCriador: TLabel;
    PopupMenu1: TPopupMenu;
    Resumodeestoquedaslojas1: TMenuItem;
    Listarentradasdoproduto1: TMenuItem;
    Vendasnoperiodo1: TMenuItem;
    Resumoentradassaidas1: TMenuItem;
    Label8: TLabel;
    Verrequisicoes1: TMenuItem;
    cbCriticaQuant: TfsCheckBox;
    Panel1: TPanel;
    btNova: TFlatButton;
    btAbrir: TFlatButton;
    btSalvar: TFlatButton;
    btAprovar: TFlatButton;
    btImprimir: TFlatButton;
    btInsere: TFlatButton;
    lbCodCriador: TLabel;
    Label9: TLabel;
    lbDsUo: TLabel;
    RemoveositensMarcados1: TMenuItem;


    function errosDeSeparacao():Boolean;
    function GeraRequisicoes(autorizador:String):String;
    function getIs_uo(idx:integer):String;
    function colIsLoja(column:Tcolumn):boolean;
    function validaQuantidade(alteraValores,mostraErro:boolean):boolean;

    procedure btAbrirClick(Sender: TObject);
    procedure btAprovarClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btInsereClick(Sender: TObject);
    procedure btovaClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
    procedure carregaMapa(nMapa:String);
    procedure fecharMapa();
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure gridCellClick(Column: TColumn);
    procedure gridColEnter(Sender: TObject);
    procedure gridColExit(Sender: TObject);
    procedure gridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure gridTitleClick(Column: TColumn);
    procedure insereItem(codigo:String);
    procedure liberaEdicaoMapa();
    procedure Listarentradasdoproduto1Click(Sender: TObject);

    procedure Resumodeestoquedaslojas1Click(Sender: TObject);
    procedure salvaMapa();
    procedure tbAfterOpen(DataSet: TDataSet);
    procedure tbBeforePost(DataSet: TDataSet);
    procedure vendasNoPeriodo1Click(Sender: TObject);
    procedure verRequisicoes1Click(Sender: TObject);
    procedure mmObsDblClick(Sender: TObject);
    procedure RemoveositensMarcados1Click(Sender: TObject);


  private

    UO_DEST:String;

    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmMapa: TfmMapa;
  criticaQuantidade, MAPA_ALTERADO:Boolean;
  PERMITE_EDITAR:boolean;


implementation


uses uCriaMapa, uMain, fmAbrirAvarias, cf, uDm, uUsuarios, uEstoque, f, msg,
    uMapaSep, uReq, uProd, uLj ;

{$R *.dfm}

function TfmMapa.getIs_uo(idx: integer): String;
var
   uos: array[7..28] of String;
begin
   uos[07] := '10105362'; //01
   uos[08] := '10103979'; //03
   uos[09] := '10033588'; //05
   uos[10] := '10033589'; //06
   uos[11] := '10037736'; //07
   uos[12] := '10119422'; //08
   uos[13] := '10033592'; //09
   uos[14] := '10033590'; //10
   uos[15] := '10033593'; //11
   uos[16] := '10033594'; //12
   uos[17] := '10033595'; //17
   uos[18] := '10068438'; //18
   uos[19] := '10096793'; //21
   uos[20] := '10034573'; //99
   uos[21] := '10105365'; //27  areolino
   uos[22] := '10108662'; //28  pajucara deposito
   uos[23] := '10116625'; //29  joquei teresina
   uos[24] := ''; //    pajucar atacado
   uos[25] := '10134994'; //    jaboti
   uos[26] := '10137895'; //   guaxentoba
   uos[27] := '10137930'; //  maison joquei
   uos[28] := '10125512'; //  maison joquei


   result :=uos[idx];
end;

function TfmMapa.colIsLoja(column: Tcolumn): boolean;
begin
   result := ( uppercase( copy(column.FieldName, 01, 01) ) = 'L')   ;
end;

function TfmMapa.validaQuantidade(alteraValores, mostraErro:boolean): boolean;
var
   soma,i:integer;
   erro:String;
begin
   soma := 0;

   for i := 0 to  grid.Columns.Count - 1  do
     if (colIsLoja(grid.Columns[i]) = true) then
        soma := soma + tb.Fields[i].AsInteger;

   if (soma > tb.fieldByName('Estoque').asinteger) then
      erro := dm.getMsg('fmMapa.errSumQt');

   if (alteraValores = true) then
   begin
      tb.Edit;
      grid.Columns[ tb.FieldByName('saldo').Index ].ReadOnly := false;
      tb.FieldByName('saldo').asInteger := tb.FieldByName('Estoque').asInteger - soma;
      tb.Post;
      grid.Columns[ tb.FieldByName('saldo').Index ].ReadOnly := true;

      MAPA_ALTERADO := true;
   end;

   if (erro <> '') then
   begin
      result := false;
      if (mostraErro = true) then
         msg.msgerro(erro);
   end
   else
      result := true;
end;

function TfmMapa.errosDeSeparacao(): Boolean;
var
   erro:String;
begin
   tb.First;
   while tb.Eof = false do
   begin
      if validaQuantidade(false, false) = false then
        erro := erro + '    - ' +  tb.fieldByName('cd_ref').ASString + ' '+ tb.fieldByName('ds_ref').ASString + #13;
       tb.Next;
   end;
   tb.First;
   if erro <> '' then
   begin
      erro := dm.getMsg('fmMapa.errSep') + erro;
      msg.msgErro(erro);
      result := true;
   end
   else
     result := false;
end;


procedure TfmMapa.FormShow(Sender: TObject);
begin
   MAPA_ALTERADO := false;
   grid.Align := alClient;

   if (fmMain.isGrupoRestrito(fmMain.Mapadeseparao1.Tag) = true) then
   begin
   	btSalvar.Enabled := false;
      btAprovar.Enabled := false;
      btNova.Enabled := false;
      grid.Enabled := false;
   end;
end;

procedure TfmMapa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    fmMapa := nil;
    Action := Cafree;
end;

procedure TfmMapa.insereItem(codigo:String);
var
   dsMapa, dsItem:TdataSet;
   qtEmb, numMapa,cmd:String;

begin
   dsMapa := uMapaSep.getDadosMapa(lbNumMp.Caption);

   dsItem := uProd.getDadosProd(fmMain.getUoLogada(), codigo, '', dsMapa.fieldByName('pco').asString , true);

   if (dsItem.IsEmpty=false ) then
   begin
      qtEmb := dsItem.FieldByName('embalagem').AsString;
      if (qtEmb <> '') and (qtEmb <> '0') then
      begin
         numMapa := lbNumMp.Caption;
         tb.Cancel();
         cmd :=  'insert zcf_mapaSeparacaoI(num, is_ref, caixa, estI, saldo, pco) values (' +
                 lbNumMp.Caption  + ' , ' +
                 dsItem.FieldByName('is_ref').AsString + ' , ' +
                 dsItem.FieldByName('embalagem').AsString + ' , ' +
                 dsItem.FieldByName('estoque').AsString + ' , ' +
                 dsItem.FieldByName('estoque').AsString + ' , ' +
                 ValorSql(dsItem.FieldByName('preco').AsString) +')';
          dm.execSQL(cmd);
          btSalvarClick(nil);
          fecharMapa();
          carregaMapa(numMapa);

          dsMapa.free();
          dsItem.free();
      end;
   end
   else
      msg.msgErro(dm.getMsg('fmMapa.msgEst2'));
end;

procedure TfmMapa.carregaMapa(nMapa:String);
var
   qr:TdataSet;
   i:integer;
   lista:Tstringlist;
   aux:String;
begin
  f.gravaLog('carregaMapa()') ;

   // cria tabela temporaria dos itens
   dm.getTable(tb, dm.getCMD('fmMapa', 'getFieldsMapa') );

   // carregar os itens
   while tb.IsEmpty = false do
      tb.Delete;

   qr := uMapaSep.getDadosItens(nMapa);

   qr.First;
   while qr.Eof = false do
   begin
      tb.AppendRecord([
                       qr.FieldByName('seq').asString,
                       '',
                       qr.FieldByName('is_ref').asString,
                       qr.FieldByName('cd_ref').asString,
                       qr.FieldByName('ds_ref').asString,
                       qr.FieldByName('caixa').asString,
                       qr.FieldByName('Estoque').asString,
                       qr.FieldByName('l01').asString,
                       qr.FieldByName('l25').asString,
                       qr.FieldByName('l05').asString,
                       qr.FieldByName('l06').asString,
                       qr.FieldByName('l07').asString,
                       qr.FieldByName('l30').asString,
                       qr.FieldByName('l09').asString,
                       qr.FieldByName('l10').asString,
                       qr.FieldByName('l11').asString,
                       qr.FieldByName('l12').asString,
                       qr.FieldByName('l17').asString,
                       qr.FieldByName('l18').asString,
                       qr.FieldByName('l21').asString,
                       qr.FieldByName('l99').asString,
                       qr.FieldByName('l27').asString,
                       qr.FieldByName('l28').asString,
                       qr.FieldByName('l29').asString,
                       qr.FieldByName('l31').asString,
                       qr.FieldByName('l34').asString,
                       qr.FieldByName('l36').asString,
                       qr.FieldByName('l37').asString,
                       qr.FieldByName('l32').asString,                       
                       qr.FieldByName('saldo').asString,
                       qr.FieldByName('pco').asString
                     ]);
      qr.Next;
   end;
   qr.free();
   tb.First;
   tb.Edit;

// ajustar o tamanho da coluna das quantidades

   f.ajGridCol(grid, tb, 'seq', 0, '');
   f.ajGridCol(grid, tb, 'N', 10, 'D');
   f.ajGridCol(grid, tb, 'is_ref', 0, '');
   f.ajGridCol(grid, tb, 'cd_ref', 60, 'Codigo');
   f.ajGridCol(grid, tb, 'ds_ref', 120, 'Produto');

   f.ajGridCol(grid, tb, 'caixa', 30, 'Cx');
   f.ajGridCol(grid, tb, 'estoque', 50, 'Estoque');
   f.ajGridCol(grid, tb, 'Saldo', 50, 'Saldo');
   f.ajGridCol(grid, tb, 'pco', 50, 'Preco');

// ajusta os campos que podem ser editados
   for i:=1 to grid.Columns.Count -1 do
   begin
     grid.Columns[i].Title.font.style := [fsbold];

      if ( fmMapa.colIsLoja(grid.Columns[i]) = true) then
      begin
         grid.Columns[i].Width := 50;
         grid.Columns[i].ReadOnly := false
      end
      else
         grid.Columns[i].ReadOnly := true;
   end;
   grid.Fields[ tb.FieldByName('N').Index ].ReadOnly := false;
   grid.Fields[ tb.FieldByName('estoque').Index ].ReadOnly := false;

   MAPA_ALTERADO := false;


   qr := uMapaSep.getDadosMapa(nMapa);

   lbNumMp.Caption :=  f.preencheCampo(10,' ','e', qr.fieldByName('num').asString );
   lbNome.Caption :=  qr.fieldByName('nome').asString;
   lbDtAvaria.caption := qr.fieldByName('data').asString;
   lbCriador.Caption := qr.fieldByName('nm_usu').asString;
   lbAprovador.Caption := qr.fieldByName('aprovador').asString;
   lbCodCriador.Caption := qr.fieldByName('criador').asString;
   lbDsUo.Caption := qr.fieldByName('ds_uo').asString;

   UO_DEST :=  qr.fieldByName('uo').asString;

   mmObs.Lines.Clear;
   mmObs.Lines.Add( qr.fieldByName('historico').asString);

   if qr.fieldByName('ehFinalizada').AsBoolean = false then
   begin
      lbStatus.Caption := 'Aberta';
      grid.Enabled := true;
   end
   else
   begin
      lbStatus.Caption := 'Finalizada';
      mmObs.Enabled:=false;
      grid.Enabled := false;
   end;

   cbCriticaQuant.Checked := (qr.fieldByName('criticaEstoque').AsBoolean);

   if (fmMain.getUserLogado() = dm.GetParamBD('mapa.usAutEdicao','') ) or( fmMain.getGrupoLogado() <> '')  then
   begin
      PERMITE_EDITAR := true;
      btInsere.Enabled := true;
   end
   else
      PERMITE_EDITAR := false;

   lista := TStringList.Create();


// altera o nome da coluna para o nome da loja
   for i:=0 to grid.Columns.Count -1 do
   begin
   	aux := grid.Columns[i].FieldName;
      delete(aux, 01, 01);
   	if (colIsLoja(grid.Columns[i]) = true) then
      begin
			grid.Columns[i].Title.Caption := ulj.getNmCurto(aux);
// remove as colunas nao selecionadas no mapa
			grid.Columns[i].Visible := qr.FieldByName(grid.Columns[i].FieldName).AsBoolean = true;
      end;
   end;
end;

procedure TfmMapa.gridColExit(Sender: TObject);
begin
   validaQuantidade(true, cbCriticaQuant.Checked );
end;

procedure TfmMapa.tbAfterOpen(DataSet: TDataSet);
begin
   MAPA_ALTERADO := true;
end;

procedure TfmMapa.salvaMapa;
var
  cmd:String;
begin
   grid.Visible := false;
   fmMain.MsgStatus('Salvando mapa..');
   tb.First;
// ajuste para atualizar as contagens
   while tb.Eof = false do
   begin
      validaQuantidade(true, cbCriticaQuant.Checked );
      tb.Next;
   end;

   tb.First;
   while tb.Eof = false do
   begin
      cmd := 'Update zcf_mapaSeparacaoI set ';

      cmd := cmd + 'estI= ' + tb.fieldByName('estoque').AsString +', ';

      if tb.fieldByName('l01').AsString <> '' then
         cmd := cmd + 'l01= ' + tb.fieldByName('l01').AsString +', '
      else
         cmd := cmd + 'l01= null, ';

      if tb.fieldByName('l25').AsString <> '' then
         cmd := cmd + 'l25= ' + tb.fieldByName('l25').AsString +', '
      else
         cmd := cmd + 'l25= null, ';

      if tb.fieldByName('l05').AsString <> '' then
         cmd := cmd + 'l05= ' + tb.fieldByName('l05').AsString +', '
      else
         cmd := cmd + 'l05= null, ';

      if tb.fieldByName('l06').AsString <> '' then
         cmd := cmd + 'l06= ' + tb.fieldByName('l06').AsString +', '
      else
         cmd := cmd + 'l06= null, ';

      if tb.fieldByName('l07').AsString <> '' then
         cmd := cmd + 'l07= ' + tb.fieldByName('l07').AsString +', '
      else
         cmd := cmd + 'l07= null, ';

      if tb.fieldByName('l30').AsString <> '' then
         cmd := cmd + 'l30= ' + tb.fieldByName('l30').AsString +', '
      else
         cmd := cmd + 'l30= null, ';

      if tb.fieldByName('l09').AsString <> '' then
         cmd := cmd + 'l09= ' + tb.fieldByName('l09').AsString +', '
      else
         cmd := cmd + 'l09= null, ';

      if tb.fieldByName('l10').AsString <> '' then
         cmd := cmd + 'l10= ' + tb.fieldByName('l10').AsString +', '
      else
         cmd := cmd + 'l10= null, ';

      if tb.fieldByName('l11').AsString <> '' then
         cmd := cmd + 'l11= ' + tb.fieldByName('l11').AsString +', '
      else
         cmd := cmd + 'l11= null, ';

      if tb.fieldByName('l12').AsString <> '' then
         cmd := cmd + 'l12= ' + tb.fieldByName('l12').AsString +', '
      else
         cmd := cmd + 'l12= null, ';

      if tb.fieldByName('l17').AsString <> '' then
         cmd := cmd + 'l17= ' + tb.fieldByName('l17').AsString +', '
      else
         cmd := cmd + 'l17= null, ';

      if tb.fieldByName('l18').AsString <> '' then
         cmd := cmd + 'l18= ' + tb.fieldByName('l18').AsString +', '
      else
         cmd := cmd + 'l18= null, ';

      if tb.fieldByName('l21').AsString <> '' then
         cmd := cmd + 'l21= ' + tb.fieldByName('l21').AsString +', '
      else
         cmd := cmd + 'l21= null, ';

      if tb.fieldByName('L99').AsString <> '' then
         cmd := cmd + 'L99= ' + tb.fieldByName('L99').AsString +', '
      else
         cmd := cmd + 'L99= null, ';

      if tb.fieldByName('L27').AsString <> '' then
         cmd := cmd + 'L27= ' + tb.fieldByName('L27').AsString +', '
      else
         cmd := cmd + 'L27= null, ';

      if tb.fieldByName('L28').AsString <> '' then
         cmd := cmd + 'L28= ' + tb.fieldByName('L28').AsString +', '
      else
         cmd := cmd + 'L28= null, ';

      if tb.fieldByName('L29').AsString <> '' then
         cmd := cmd + 'L29= ' + tb.fieldByName('L29').AsString +', '
      else
         cmd := cmd + 'L29= null, ';

      if tb.fieldByName('L31').AsString <> '' then
         cmd := cmd + 'L31= ' + tb.fieldByName('L31').AsString +', '
      else
         cmd := cmd + 'L31= null, ';

      if tb.fieldByName('L32').AsString <> '' then
         cmd := cmd + 'L32= ' + tb.fieldByName('L32').AsString +', '
      else
         cmd := cmd + 'L32= null, ';

      if tb.fieldByName('L36').AsString <> '' then
         cmd := cmd + 'L36= ' + tb.fieldByName('L36').AsString +', '
      else
         cmd := cmd + 'L36= null, ';

      if tb.fieldByName('L37').AsString <> '' then
         cmd := cmd + 'L37= ' + tb.fieldByName('L37').AsString +', '
      else
         cmd := cmd + 'L37= null, ';

      cmd := cmd + 'saldo= ' + tb.fieldByName('saldo').AsString + ' where seq= ' + tb.fieldByName('seq').AsString ;

     dm.execSQL(cmd);
     tb.Next;
  end;
  cmd := ' update zcf_mapaSeparacao set historico= '+ copy(f.getLinhasMemo(mmObs.lines), 01, 400)+ ' where num= ' + lbNumMp.caption;
  dm.execSQL(cmd);

  tb.First();
  fmMain.MsgStatus('');
  MAPA_ALTERADO := false;
  grid.Visible := true;
end;

procedure TfmMapa.gridColEnter(Sender: TObject);
begin
   if (PERMITE_EDITAR = false) then
      if (colIsLoja(grid.Columns[grid.SelectedIndex]) = false) then
         grid.SelectedIndex  := 7;

end;

function TfmMapa.GeraRequisicoes(autorizador:String):String;
var
   QT_DIAS_PEND, i, qtItensPorReq:integer;
   tbReq:TADOTable;
   lj,cmd,nTbReq:String;
   ocoItens:TStringList;
begin
	qtItensPorReq := dm.getParamIntBD('mapa.qtItPorReq', '0');


   grid.Visible := false;
   QT_DIAS_PEND := strToInt( dm.GetParamBD('periodoParaReqPendentes', ''));

   ocoItens := TStringlist.Create();

   dm.getTable(tbReq, dm.getCMD('ava', 'getTbReq') );

   nTbReq := '';
   for i:=7 to 28 do
   if (getIs_uo(i) <> '') then
   begin
      f.gravaLog('Requisi�oes da loja: '+ grid.Fields[i].FieldName  );

      lj := '  '+grid.Fields[i].FieldName + ': ';
      cmd := '';
      tb.First;
      while tb.Eof = false do
      begin
         fmMain.MsgStatus('Gerando Requisicoes loja: ' + grid.Fields[i].FieldName );

         while tbReq.IsEmpty = false do
            tbReq.Delete;

         while (tbReq.RecordCount < qtItensPorReq ) and (tb.Eof = false )do
         begin
            if ( tb.Eof = false ) and ( tb.Fields[i].AsString <> '' )  and ( tb.Fields[i].AsInteger <> 0 ) then
            begin
               tbReq.Append;
               tbReq.FieldByName('is_ref').AsString :=  tb.FieldByName('is_ref').asString;
               tbReq.FieldByName('codigo').AsString :=  tb.FieldByName('cd_ref').asString;
               tbReq.FieldByName('ds_ref').AsString := tb.FieldByName('ds_ref').asString;
               tbReq.FieldByName('Qt Pedida').AsString :=  tb.Fields[i].AsString ;
               tbReq.post;
               tb.Next;
            end
            else
               tb.Next;
          end;

          if (tbReq.RecordCount <> 0) then
          begin
               f.gravaLog( grid.Fields[i].FieldName );
               f.gravaLog( getIs_uo(i) );

               cmd := uReq.gerarReq(tbReq, UO_DEST,  getIs_uo(i), autorizador, false, true, ocoItens, QT_DIAS_PEND);

             lj:= lj + cmd +'   ';
          end;
      end;
       nTbReq := nTbReq + lj + #13;
   end;

   if (ocoItens.Count  > 0) then
   begin
       {}
   end;

   ocoItens.free;
   msg.msgExclamation('Foram Geradas as requisicoes: ' + #13 + nTbReq);
   result := nTbReq;
   grid.Visible := true;
end;

procedure TfmMapa.gridKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   if key in [VK_DOWN,VK_UP, VK_LEFT, VK_RIGHT ] then
      gridColExit(nil);
end;
procedure TfmMapa.Resumodeestoquedaslojas1Click(Sender: TObject);
begin
   fmMain.obterResumoEstoque( tb.fieldByName('is_ref').asString, '1');
end;

procedure TfmMapa.Listarentradasdoproduto1Click(Sender: TObject);
begin
   fmMain.obterDetalhesEntrada(tb.fieldByName('is_ref').asString );
end;

procedure TfmMapa.Vendasnoperiodo1Click(Sender: TObject);
begin
   fmMain.obterDetalhesSaida( tb.fieldByName('is_ref').asString , fmMain.getUoLogada(), now );
end;

procedure TfmMapa.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  result:integer;
begin
    result := mrCancel;

    if (MAPA_ALTERADO = true) then
	    if (fmMain.isGrupoRestrito(fmMain.Mapadeseparao1.Tag) = false) then
   	   result := msg.msgQuestion(' Salvar as Altera��es no mapa?');

    if result = MrYes then
       btSalvarClick(nil);

    if (MAPA_ALTERADO = true) and (result = mrCancel) then
       CanClose := false;
end;

procedure TfmMapa.fecharMapa();
begin
   tb.Close;
   lbNumMp.Caption := '-';
   lbDtAvaria.caption := '-';
   lbNome.caption := '-';
   lbStatus.Caption := '-';
   lbAprovador.Caption := '-';
   lbCriador.Caption := '-';
   lbCodCriador.Caption := '-';
   lbDsUo.Caption := '-';
   UO_DEST := '';
   mmObs.Clear;
end;

procedure TfmMapa.VerRequisicoes1Click(Sender: TObject);
begin
   if tb.IsEmpty = false then
     fmMain.abreTelaConsultaRequisicao(tb.FieldByName('cd_ref').asString, '999', now()-30);
end;

procedure TfmMapa.gridTitleClick(Column: TColumn);
var
	coluna:String;
begin
	coluna := Column.FieldName;
   if ( coluna = 'n') then
   begin
      if (msg.msgQuestion( dm.getMsg('fmMapa.qstRemIt') ) = mrYes) then
      begin
         tb.First();
         while (tb.Eof = false) do
         begin
            if (tb.FieldByName('n').AsString = 'X') then
            begin
               dm.execSQl( dm.getCMD1('fmMapa', 'delItem', tb.fieldByName('seq').asString));
               tb.Delete();
            end
            else
              tb.Next;
         end;
      end;
      tb.First();
   end
   else
      dm.organizarTabela(tb, grid, Column);
end;

procedure TfmMapa.tbBeforePost(DataSet: TDataSet);
begin
    if tb.FieldByName('is_ref').AsString = '' then
     tb.Cancel;
end;

procedure TfmMapa.liberaEdicaoMapa;
var
   i:integer;
begin
   for i := 0 to grid.Columns.Count -1 do
      grid.Columns[i].ReadOnly :=  false;
end;

procedure TfmMapa.gridCellClick(Column: TColumn);
{var
  uo:string;
}
begin
{  	f.gravaLog('Coluna: ' + Column.FieldName + ' Loja: ' + getIs_uo( grid.SelectedIndex));
   uo := getIs_uo( grid.SelectedIndex);

   uo := dm.openSQL('select ds_uo from tbuo where is_uo = ' + uo, '');

   msg.msgErro( uo);
}

    if (Column.FieldName = 'n') then
    begin
       tb.Edit();
       if tb.FieldByName('n' ).asString <> 'X' then
          tb.FieldByName(Column.FieldName).asString := 'X'
       else
          tb.FieldByName('n').asString := '';
       tb.post;
    end;
end;

procedure TfmMapa.btovaClick(Sender: TObject);
begin
   if (MAPA_ALTERADO = true )then
      if (msg.msgQuestion( dm.getMsg('fmMapa.Salva') ) = mrYes) then
         btSalvarClick(Sender);

    fecharMapa();
    Application.CreateForm(TfmCriarMapa, fmCriarMapa);
    fmCriarMapa.showModal;
end;

procedure TfmMapa.btAbrirClick(Sender: TObject);
begin
   if fmAbrirAvaria = nil then
   begin
      if (MAPA_ALTERADO = true) then
        if (msg.msgQuestion( dm.getMsg('fmMapa.Salva') ) = mrYes) then
           btSalvarClick(nil);

      fecharMapa();
      Application.CreateForm(TfmAbrirAvaria, fmAbrirAvaria);
      fmAbrirAvaria.preparaParaListarMapa(nil);
      fmAbrirAvaria.showModal;


// destroi a janela  de abertura de avarias, depois de fechar
      fmAbrirAvaria := nil;
   end;
end;

procedure TfmMapa.btSalvarClick(Sender: TObject);
begin
   if (tb.IsEmpty = false) then
      salvaMapa();
end;

procedure TfmMapa.btAprovarClick(Sender: TObject);
var
  cmd, aut:String;
  numReq:String;
begin
   if trim(lbStatus.Caption) = 'Aberta' then
      if (msg.msgQuestion(dm.getMsg('fmMapa.dlgSalva') ) = mrYes) then
      begin
         btSalvarClick(nil);
         if (errosDeSeparacao() = false) then
         begin
            f.gravaLog('codCriador:' + lbCodCriador.Caption);
            aut := uUsuarios.getAutorizadorWell('', '-1',  dm.getParamBD('autorizadoresAvarias', '') + ', ' + '-999' );
            if  (aut <> '') then
            begin
                numReq := geraRequisicoes(aut);
                // aprova o mapa no BD
               cmd :=  dm.getCMD('FmMapa', 'setAprovada');
               dm.setParams(cmd, aut, f.getLinhasMemo(mmObs.Lines), quotedStr(numReq));
               dm.setParam(cmd, lbNumMp.Caption);
               dm.execSQL(cmd);

               carregaMapa(lbNumMp.Caption);
            end
            else
               fmMain.MsgStatus(lbStatus.Caption);

            MAPA_ALTERADO := false;
         end;
     end;
end;

procedure TfmMapa.btImprimirClick(Sender: TObject);
var
   Param:TStringList;
begin
   f.gravaLog('btImprimirClick()');

   if tb.IsEmpty = false then
   begin
      Param := TStringList.Create();
      param.Add(lbNumMp.caption);
      param.Add(lbNome.caption);
      param.Add(lbStatus.Caption);
      param.Add(lbCriador.caption);
      param.Add(lbAprovador.Caption);
      param.Add(fmMain.versao.Caption);
      fmMain.imprimeRave(tb, nil, nil, nil, nil, 'rpMapaSep', Param);
      Param.free();
   end;
end;

procedure TfmMapa.btInsereClick(Sender: TObject);
var
  str:String;
begin
   str:=  msg.msgInput('Digite o C�digo do produto ou EAN.', str);
   if (str <> '') then
      insereItem(str);
end;

procedure TfmMapa.mmObsDblClick(Sender: TObject);
begin
    gridTitleClick(grid.Columns[ tb.FieldByName('n').Index]);
end;


procedure TfmMapa.RemoveositensMarcados1Click(Sender: TObject);
var
	c:Tcolumn;
begin
	c:= Tcolumn.Create(nil);
   c.FieldName := 'n';
   gridTitleClick(c);
end;

end.
