unit uEtiquetas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fCtrls, DB, ADODB, TFlatButtonUnit, Grids, DBGrids,
  SoftDBGrid, adLabelEdit,  ExtCtrls, adLabelComboBox,
  Menus, RpBase, RpSystem, RpRave, RpDefine, RpCon, Spin,
  TFlatCheckBoxUnit, adLabelNumericEdit, adLabelSpinEdit, uDm;

type
  TfmEtiquetas = class(TForm)
    dsEan: TDataSource;
    Panel1: TPanel;
    FlatButton1: TFlatButton;
    cbTIpoImpressao: TadLabelComboBox;
    EdLocalImp: TadLabelEdit;
    cbImpPc: TfsCheckBox;
    gridItem: TSoftDBGrid;
    DsEtq: TDataSource;
    tb: TADOTable;
    Panel2: TPanel;
    lbItensaSeemImpressos: TLabel;
    EdCodigo: TadLabelEdit;
    DBGrid: TSoftDBGrid;
    btConsulta: TFlatButton;
    btAddItemParaImp: TFlatButton;
    cbPrecos: TadLabelComboBox;
    cbLojas: TadLabelComboBox;
    edQuant: TadLabelEdit;
    edQtMin: TadLabelEdit;
    Panel3: TPanel;
    LbDescricao: TLabel;
    StaticText1: TStaticText;
    pnImage: TPanel;
    Image1: TImage;
    lbTitLstProds: TLabel;
    lbDescImgProd: TLabel;

//    function preparaListaDeItens(Sender: Tobject):TStringList;
//    function QuantEtiquetas(sender:Tobject):integer;
    procedure AdicionaProdutoParaImpressao();
    procedure btAddItemParaImpClick(Sender: TObject);
    procedure btConsultaClick(Sender: TObject);
    procedure cbTIpoImpressaoChange(Sender: TObject);
    procedure EdCodigoKeyPress(Sender: TObject; var Key: Char);
    procedure edQuantKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
    procedure edQuantKeyPress(Sender: TObject; var Key: Char);
    procedure FlatButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure imprimeArgox(sender:Tobject);
    procedure imprimeDynaPos(sender:Tobject);
    procedure imprimeELimpaCampos(arq:String);
    procedure imprimeGondolaArgox(sender: Tobject);
    procedure imprimeGondolaArgoxAtacado();
    procedure imprimeGondolaArgoxGrande(sender: Tobject);
    procedure imprimeGondolaDynapos(Sender:Tobject);
    procedure imprimeGondolaZebra();
    procedure imprimeItemZebra();
    Procedure ListaEansProduto(sender:tobject);
	 procedure getTbItensParaimpressao();
    procedure ajGrid();
    procedure gridItemDblClick(Sender: TObject);
    procedure DBGridDblClick(Sender: TObject);
    procedure imprimeGondolaAtacarejo();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmEtiquetas: TfmEtiquetas;
  DS_ITEM:TDataSet;
  TB_IMP:TadoTable;
implementation
{$R *.dfm}

uses upallet, uMain, funcsql, f, uEstoque, uLj, msg, uPreco, uProd;

procedure TfmEtiquetas.imprimeGondolaAtacarejo;
var
  arq, temperatura:string;
  pcTot, qtMin:String;
  l1, l2, l3, l4,l5, l6:String;
begin
	getTbItensParaimpressao();

   f.gravaLog(TB_IMP, 'dataset com as  etiquetas');

   arq:= f.getArqImpPorta();
   deleteFile(arq);

   temperatura := dm.getParamBD('impCodBarras.tempArgox', fmMain.getUoLogada() );

   f.writeFile(arq,'F');
   TB_IMP.First();
   while (TB_IMP.Eof = false) do
   begin
      l1 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '1');
      l2 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '2');
      l3 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '3');
      l4 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '4');
      l5 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '5');
      l6 := dm.getParamBD('impCodBarras.GonArgoxAtarejo', '6');


      f.writeFile(arq,'L');
      f.writeFile(arq,'H' + temperatura );

//                      +----- Orientacao
//                      |+-----Fonte
//                      ||+-----multiplicador horzontal
//                      |||+----- mult verticcal
//                      |||| +---subtipo da fonte
//                      ||||_|__   x   y
//					         12110000 0700 010

// descricao
		dm.setParam(l1, copy(TB_IMP.fieldByName('ds_ref').AsString, 01, 35));
      f.writeFile(arq, l1);

// cod de barras
		dm.setParam(l2, TB_IMP.fieldByName('ean').AsString);
      f.writeFile(arq, l2);
// preco varejo
		dm.setParam(l3, 'R$' + TB_IMP.fieldByName('pc').AsString);
      f.writeFile(arq, l3);

		dm.setParam(L4, 'Preco atacado');
      f.writeFile(arq, L4 );

		dm.setParam(L5, f.preencheCampo(12,' ', 'E','R$' + TB_IMP.fieldByName('Preco atacado').AsString));
      f.writeFile(arq, L5);

      f.writeFile(arq, L6);

   	TB_IMP.Next();
	   f.writeFile(arq, 'E');
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeELimpaCampos(arq:String);
begin
   f.gravaLog( pchar('Print /d:'+ EdLocalimp.text+' '+arq) );
   f.imprimeArquivoPorta(arq, EdLocalImp.Text );

   EdCodigo.SetFocus;

   EdCodigo.SetFocus;
   EdCodigo.Text:='';

   while TB_IMP.IsEmpty = false do
   	TB_IMP.Delete();

   while tb.IsEmpty = false do
   	tb.Delete();
end;

{procedure TfmEtiquetas.imprimeGondolaDynapos(Sender: Tobject);
var
  i:integer;
  arq:string;
begin
   ARQ :=  f.getArqImpPorta();
   DeleteFile(arq);

   for i := 0 to LBItens.Count -1 do
   begin
      f.writeFile(arq, 'N');
      f.writeFile(arq, 'Q200,24');
      f.writeFile(arq, 'q800' );
      f.writeFile(arq, 'A700,188,2,3,2,2,N,"' + trim( copy(LBItens.items[i], 29, 20)) + '"');
      f.writeFile(arq, 'A700,150,2,3,2,2,N,"' + trim(copy(LBItens.items[i], 49, 20)) + '"');
      f.writeFile(arq, 'A700,100,2,3,1,1,N,"' + 'CODIGO: '+copy(LBItens.items[i], 01,07)   + '"');
      f.writeFile(arq, 'A600,050,2,4,2,2,N,"R$ '+ copy(LBItens.items[i],82,10) + '"');
      f.writeFile(arq, 'P1');
      f.writeFile(arq, 'N');
   end;
   imprimeELimpaCampos(arq);
end;
}
procedure TfmEtiquetas.ListaEansProduto(sender: tobject);
begin
   if (DS_ITEM <> nil) then
      DS_ITEM.Free();

   DS_ITEM:= uProd.getDadosProd( f.getCodUo(cbLojas), EdCodigo.Text, '', fmMain.getCodPreco(cbPrecos), true);
   if (DS_ITEM.IsEmpty = false ) then
   begin
      dsEan.DataSet := DS_ITEM;

      f.ajGridCol(DBGrid, dsEan.DataSet, 'CODIGO', 50, 'CODIGO');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'EAN', 85, 'EAN');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'Descricao', 200, 'Descricao');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'is_ref', 0, '0');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'Preco', 50, 'Preco');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'Estoque', 64, 'Estoque');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'fornecedor', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'Embalagem', 70, 'Embalagem');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'categoria', -0, 'categoria');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'ncm_sh', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'cd_pes', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'descRegra', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'TP_ICM', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'dt_imp', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'PercIcmsNaoContribuinte', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'PercIcmsContribuinte', 0, '');
      f.ajGridCol(DBGrid, dsEan.DataSet, 'codRegra', 0, '');

      if (edQtMin.Visible = true) then
      	edQtMin.Text := DS_ITEM.fieldByName('embalagem').AsString;

      if (edQtMin.Visible = true) then
        edQtMin.SetFocus()
      else
         btAddItemParaImp.SetFocus();

   	edQuant.SetFocus();
   end
   else
      EdCodigo.SetFocus();
end;

procedure TfmEtiquetas.FormCreate(Sender: TObject);
var
  computador, usuario, str:String;
begin
   LbDescricao.Caption := '';
   lbDescImgProd.caption := '';

   cbPrecos.Items := uPreco.getListaPrecos(false, false, false, fmMain.getGrupoLogado());
   cbPrecos.ItemIndex := 0;

   uLj.getListaLojas(cbLojas, false, false, fmMain.getCdPesLogado(), fmMain.getUoLogada() );

   fmMain.getParametrosForm(fmEtiquetas);

   edQuant.Text := '1';
   if (fmMain.isAcessoTotal(fmMain.Etiquetas1.Tag) = true ) then
      edQuant.MaxLength := 5
   else
      edQuant.MaxLength := 1;


   f.getComputadorUsuario(computador, usuario);

   // tenta ve se tem impressora configurada ara uma estacao
   str:= dm.getParamEstBD('impCodBarras', fmMain.getUoLogada(), usuario );

   if (str = '') then
      str := dm.getParamBD( 'impCodBarras', fmMain.getUoLogada() );

   edLocalImp.Text := str;

   self.Caption :=
   fmMain.getCaptionNivelAcesso('Impress�o de etiquetas', not(fmMain.isAcessoTotal(fmMain.Etiquetas1.Tag)) );

   dm.getTable(tb, dm.getCMD('tb','getTbEtqPc'));
	gridItem.Align := alClient;
   f.ajGridCol(gridItem, TB, 'is_ref',0, '');
   f.ajGridCol(gridItem, TB, 'preco atacado',0, '');



	cbTIpoImpressaoChange(nil);
   Image1.Align := alClient;
   gridItem.Align := alClient;
end;

procedure TfmEtiquetas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  f.salvaCampos(fmEtiquetas);
  action := caFree;
  fmEtiquetas := nil;
end;

procedure TfmEtiquetas.AdicionaProdutoParaImpressao();
var
	pc2, pcUnd, pcTot, qtEtq, qtMin:String;
   dsPc:TdataSet;
begin
   if strToint(f.getCp(2, cbTIpoImpressao)) = 7 then
   begin
      dsPc := uProd.getDadosProd(f.getCodUo(cbLojas), '', DS_ITEM.fieldByname('is_ref').AsString, '103', false);
      pc2 := floatToStrf(dsPc.fieldByname('preco').asfloat, ffNumber, 18, 2);
      dsPc.Free();
   end;

	if f.sohNumerosPositivos(edQtMin.Text) = '' then
   	qtEtq := '1'
   else
   	qtEtq := f.sohNumerosPositivos(edQtMin.Text);

	if f.sohNumerosPositivos(edQtMin.Text) = '' then
   	qtMin := '1'
   else
   	qtMin := f.sohNumerosPositivos(edQtMin.Text);

   if (cbImpPc.Checked = true) then
   begin
   	pcUnd := floatToStrf(DS_ITEM.fieldByname('preco').asfloat, ffNumber, 18, 2);

     	if (f.sohNumerosPositivos(edQtMin.Text) <> '') and (f.getCp(2, cbTIpoImpressao) = '5') then
	      pcTot := floatToStrf(DS_ITEM.fieldByname('preco').asfloat * StrToint(qtMin), ffNumber, 18, 2);
   end
   else
   begin
	  	pcUnd := '';
   	pcTot := '';
   end;

	tb.AppendRecord([
      DS_ITEM.FieldByName('codigo').AsString,
   	DS_ITEM.FieldByName('descricao').AsString,
   	DS_ITEM.FieldByName('ean').AsString,
      pcUnd,
      qtEtq,
      edQuant.Text,
      pcTot,
      pc2,
      DS_ITEM.FieldByName('is_ref').AsString
   ]);
   DS_ITEM.Close();

   EdCodigo.SetFocus();
end;

procedure TfmEtiquetas.edQuantKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (key = vk_return) then
      btAddItemParaImpClick(nil);
end;

procedure TfmEtiquetas.EdCodigoKeyPress(Sender: TObject; var Key: Char);
begin
   if ( f.isLetra(Key) = true) then
      Key := #0;

   if (key = #13) then
      btConsultaClick(nil);
end;

procedure TfmEtiquetas.btAddItemParaImpClick(Sender: TObject);
begin
   if ( DS_ITEM <> nil) then
      if (DS_ITEM.IsEmpty = false) then
         AdicionaProdutoParaImpressao();
end;

procedure TfmEtiquetas.imprimeGondolaArgox(sender: Tobject);
var
  Itens:TstringList;
  i:integer;
  arq:string;
  x01,x02,y01,y02:string;
begin
   arq:=   f.TempDir() + '_Etiquetas.txt';
   deleteFile(arq);
   i:=0;
   x01 := '0010';
   x02 := '0140';
   y01 := '0065';
   y02 := '0000';

//   itens := preparaListaDeItens(nil);

   while i <= itens.Count -1 do
   begin
      f.writeFile(arq,'L');
      f.writeFile(arq,'H15');
//                                           +----- Orientacao
//                                           |+-----Fonte
//                                           ||+-----multiplicador horzontal
//                                           |||+----- mult verticcal
//                                           |||| +---subtipo da fonte
//                                           ||||_|__
         f.writeFile(arq, '1211000'+ y01 + x01 + copy(itens[i], 15, 25));
         f.writeFile(arq, '1F21025'+ '0010' + '0000' + copy(itens[i], 01,13));
         if StrToInt(f.SohNumeros(copy(itens[i],80,10))) > 0 then
            f.writeFile(arq, '1212000' +  y02 + x02 +  'R$ '+ copy(itens[i],81,10) );
      inc(i);
      f.writeFile(arq, 'E');
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.btConsultaClick(Sender: TObject);
var
   erro:String;
begin
   Image1.Picture := nil;
   lbDescImgProd.caption:= '';
   erro := '';

   if (cbLojas.ItemIndex < 0) then
      erro := erro + dm.getMsg('MSG_ERR_LJ');

   if ( cbPrecos.ItemIndex < 0 ) then
      erro := erro + dm.getMsg('MSG_ERR_PC');

     if (erro <> '') then
        msg.msgErro( dm.getMsg('MSG_ERRO_TIT') + erro)
     else
       if (EdCodigo.Text <> '') then
          listaEansProduto(Sender)
end;

procedure TfmEtiquetas.cbTIpoImpressaoChange(Sender: TObject);
var
   idx:integer;
begin
   idx := strToint(f.getCp(2, cbTIpoImpressao));

   case idx of
      0:edQuant.Text:= '3';
   else
      edQuant.Text := '1';
   end;
	edQtMin.Visible :=  (strToint(f.getCp(2, cbTIpoImpressao)) = 5);
   ajGrid();
end;

procedure TfmEtiquetas.edQuantKeyPress(Sender: TObject; var Key: Char);
begin
   if (key = #13) then
      btAddItemParaImpClick(nil);
end;

procedure TfmEtiquetas.getTbItensParaimpressao();
var
	j, i, qt:integer;
begin
   TB_IMP := TadoTable.Create(nil);
   dm.getTable(TB_IMP, dm.getCMD('tb', 'getTbEtqPc'));


   tb.First();
   while ( tb.Eof = false) do
//   for j:=0 to tb.RecordCount do
   begin
   	qt := tb.fieldByName('qt').AsInteger;

      for i:=1 to qt do
      	TB_IMP.AppendRecord([
				tb.FieldByName('cd_ref').AsString,
				tb.FieldByName('ds_ref').AsString,
				tb.FieldByName('ean').AsString,
				tb.FieldByName('pc').AsString,
				tb.FieldByName('qtMin').AsString,
				tb.FieldByName('qt').AsString,
				tb.FieldByName('pcTotal').AsString,
  				tb.FieldByName('Preco Atacado').AsString,
				tb.FieldByName('is_ref').AsString
         ]);
      tb.Next();
   end;

   f.gravaLog(TB, 'Itens adicionados');


	while (tb.IsEmpty = false) do
   begin
   	tb.Delete
   end;
end;

procedure TfmEtiquetas.imprimeArgox(sender: Tobject);
var
   arq, temperatura:string;
   y012, pc, x01, x02, x03, y01, y02, y03, y04:string;
begin
	getTbItensParaImpressao();

   arq:= f.getArqImpPorta();

   deleteFile(arq);

   x01 := '0010';
   x02 := '0140';
   x03 := '0265';

   y01 := '0050';
   y012 := '0060';
   y02 := '0035';
   y03 := '0025';
   y04 := '0005';

   temperatura := dm.getParamBD('impCodBarras.tempArgox', fmMain.getUoLogada() );


   TB_IMP.First();
   while (TB_IMP.Eof = false) do
   begin
      f.writeFile(arq,'L');
      f.writeFile(arq,'H' + temperatura);

     if (TB_IMP.Eof = false) then
      begin
         f.writeFile(arq, '1F21025'+ y01 + '0020' + TB_IMP.fieldByName('ean').asString );

         f.writeFile(arq, '1011000'+ y02 + x01 + copy(TB_IMP.fieldByName('ds_ref').asString, 01, 20));
         f.writeFile(arq, '1011000'+ y03 + x01 + trim(copy(TB_IMP.fieldByName('ds_ref').asString, 21, 12)) + ' '+ TB_IMP.fieldByName('cd_ref').asString);

         if ( TB_IMP.fieldByName('pc').asString <> '' ) then
            f.writeFile(arq, '1012000' + y04 + x01 + '   R$ '+ TB_IMP.fieldByName('pc').asString);
      end;
      TB_IMP.Next;

      if (TB_IMP.Eof = false) then
      begin
         f.writeFile(arq, '1F31025'+ y01 + '0150' + TB_IMP.fieldByName('ean').asString );

         f.writeFile(arq, '1011000'+ y02 + x02 + copy( TB_IMP.fieldByName('ds_ref').asString, 01, 20) );
         f.writeFile(arq, '1011000'+ y03 + x02 + copy(TB_IMP.fieldByName('ds_ref').asString, 21, 12) + ' '+ TB_IMP.fieldByName('cd_ref').asString);

         if (TB_IMP.fieldByName('pc').asString <> '0') then
            f.writeFile(arq, '1012000' + y04  + x02 + '   R$ '+ TB_IMP.fieldByName('pc').asString);
      end;
      TB_IMP.Next;

      if (TB_IMP.Eof = false) then
      begin
         f.writeFile(arq, '1F31025'+ y01 + '0280' + TB_IMP.fieldByName('ean').asString);

         f.writeFile(arq, '1011000'+ y02 + x03 + copy( TB_IMP.fieldByName('ds_ref').asString, 01, 20) );
         f.writeFile(arq, '1011000'+ y03 + x03 + copy(TB_IMP.fieldByName('ds_ref').asString, 21, 12) + ' '+ TB_IMP.fieldByName('cd_ref').asString);

         if (TB_IMP.fieldByName('pc').asString <> '') then
            f.writeFile(arq, '1012000'+ y04 + x03 + '   R$ '+ TB_IMP.fieldByName('pc').asString  );
      end;
      TB_IMP.Next;

      f.writeFile(arq, 'E');
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeDynaPos(sender: Tobject);
var
  Itens:TstringList;
  j,i:integer;
  pc, arq:string;
begin
	getTbItensParaimpressao();

   f.gravaLog('imprimeDynaPos()');

   arq := f.getArqImpPorta();

   DeleteFile(arq);


   f.writeFile(arq, 'N');
   f.writeFile(arq, 'Q200,24');
   f.writeFile(arq, 'q800' );


   while (TB_IMP.Eof = false) do
   begin
      if i <= itens.Count -1 then
      begin
         // a � texto, b � codBarras  X, Y, o inicio � a direita,
         f.writeFile(arq, 'B265,180,2,E30,2,2,70,B,"' + TB_IMP.fieldByName('ean').AsString + '"');
         f.writeFile(arq, 'A265,088,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 15, 20) + '"');
         f.writeFile(arq, 'A265,070,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 35, 20) + '"');

         if (TB_IMP.fieldByName('pc').AsString <> '') then
            f.writeFile(arq, 'A265,030,2,3,1,1,N,"'+ TB_IMP.fieldByName('pc').AsString  + '"');
      end;
      TB_IMP.Next;

      if (TB_IMP.Eof = false) then
      begin
         f.writeFile(arq, 'B515,180,2,E30,2,2,70,B,"' + TB_IMP.fieldByName('ean').AsString + '"');
         f.writeFile(arq, 'A515,088,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 15, 20) + '"');
         f.writeFile(arq, 'A515,070,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 35, 20) + '"');

         if f.SohNumeros(copy(itens[i],80,10)) <> '' then
            f.writeFile(arq, 'A515,030,2,3,1,1,N,"'+ TB_IMP.fieldByName('pc').AsString + '"');
      end;
      tb.Next;

      if (TB_IMP.Eof = false) then
      begin
         f.writeFile(arq, 'B775,180,2,E30,2,2,70,B,"' + TB_IMP.fieldByName('ean').AsString + '"');
         f.writeFile(arq, 'A775,088,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 15, 20) + '"');
         f.writeFile(arq, 'A775,070,2,2,1,1,N,"'      + copy(TB_IMP.fieldByName('cd_ref').AsString, 35, 20) + '"');


         if f.SohNumeros(copy(itens[i],80,10)) <> '' then
            f.writeFile(arq, 'A775,030,2,3,1,1,N,"'+ TB_IMP.fieldByName('pc').AsString + '"');
      end;
      tb.Next();

      f.writeFile(arq,'P1');
      f.writeFile(arq,'N');
   end;

   itens.free();
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeGondolaArgoxGrande(sender: Tobject);
var
  arq, temperatura:string;
  x01,x02,y01,y02:string;
begin
   arq:= f.getArqImpPorta();
   deleteFile(arq);

   x01 := '0010';
   x02 := '0005';
   y01 := '0065';
   y02 := '0050';

   getTbItensParaimpressao();

   temperatura := dm.getParamBD('impCodBarras.tempArgox', fmMain.getUoLogada() );

   f.writeFile(arq, 'F');

   TB_IMP.First();

   while (TB_IMP.Eof = false) do
   begin
      f.writeFile(arq,'L');
      f.writeFile(arq,'H' + temperatura );

//                      +----- Orientacao
//                      |+-----Fonte
//                      ||+-----multiplicador horzontal
//                      |||+----- mult verticcal
//                      |||| +---subtipo da fonte
//                      ||||_|__
      f.writeFile(arq, '1211000'+ y01 + x01 + copy(TB_IMP.fieldByName('ds_ref').AsString, 01, 30)); // descricao

      f.writeFile(arq, '1F21025'+ '0010' + '0015' + TB_IMP.fieldByName('EAN').AsString);

      if (TB_IMP.fieldByName('pc').AsString <> '') then
         f.writeFile(arq, '1212000' +  '0000' + '0200' +  'R$ '+TB_IMP.fieldByName('pc').AsString );

      // codigo da loja no cantinho
      f.writeFile(arq, '1100000'+ '0085' + '0270' + TB_IMP.fieldByName('cd_ref').AsString);

      TB_IMP.Next();
      f.writeFile(arq, 'E');
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeGondolaDynapos(Sender: Tobject);
var
  arq:string;
begin
   ARQ :=  f.getArqImpPorta();
   deleteFile(arq);

   TB_IMP.First();
   while( TB_IMP.Eof = false)do
   begin
      f.writeFile(arq, 'N');
      f.writeFile(arq, 'Q200,24');
      f.writeFile(arq, 'q800' );
      f.writeFile(arq, 'A700,188,2,3,2,2,N,"' + copy(TB_IMP.fieldByName('ds_ref').asString, 01, 20) + '"');
      f.writeFile(arq, 'A700,150,2,3,2,2,N,"' + copy(TB_IMP.fieldByName('ds_ref').asString, 21, 20) + '"');
      f.writeFile(arq, 'A700,100,2,3,1,1,N,"' + 'CODIGO: '+TB_IMP.fieldByName('cd_ref').asString   + '"');
      f.writeFile(arq, 'A600,050,2,4,2,2,N,"R$ '+ TB_IMP.fieldByName('pc').asString + '"');
      f.writeFile(arq, 'P1');
      f.writeFile(arq, 'N');
      TB_IMP.Next();
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeGondolaZebra();
var
  i:integer;
  arq:string;
  l1,l2,l3,l4:String;
  l1i, l1t, l2i, l2t:String;
begin
   getTbItensParaimpressao();

   ARQ :=   f.getArqImpPorta();
   deleteFile(arq);

   l1:= dm.getParamBD('impEtq.ZebraGondola','1');
   l2:= dm.getParamBD('impEtq.ZebraGondola','2');
   l3:= dm.getParamBD('impEtq.ZebraGondola','3');
   l4:= dm.getParamBD('impEtq.ZebraGondola','4');

   l1i :=  dm.getParamBD('impEtq.ZebraGondolai','1');
   l1t :=  dm.getParamBD('impEtq.ZebraGondolaT','1');

   l2i :=  dm.getParamBD('impEtq.ZebraGondolai','2');
   l2t :=  dm.getParamBD('impEtq.ZebraGondolaT','2');


   f.writeFile(arq,'');
   f.writeFile(arq,'q575');
   f.writeFile(arq,'Q264,024');
   f.writeFile(arq,'ZT');
   f.writeFile(arq,'S3');
   f.writeFile(arq,'D08');
   f.writeFile(arq,'O');
   f.writeFile(arq,'OD');
   f.writeFile(arq,'UN');
   f.writeFile(arq,'I8,0,002');
   f.writeFile(arq,'JF');
   f.writeFile(arq,'');
   f.writeFile(arq, 'N');

  	TB_IMP.First();

	for i:= 1 to TB_IMP.RecordCount do
   begin
      f.writeFile(arq, l1 + '"' + trim(copy(TB_IMP.fieldByName('ds_ref').asString, strToInt(l1i), strToInt(l1t)) + '"'));
      f.writeFile(arq, l2 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, strToInt(l2i), strToInt(l2t)) + '"');
      f.writeFile(arq, l3 + '"' + 'CODIGO: '+ TB_IMP.fieldByName('cd_ref').asString   + '"');
      f.writeFile(arq, l4 + '"R$ '+ TB_IMP.fieldByName('pc').asString + '"');
      f.writeFile(arq,'P1');
      f.writeFile(arq,'N');
      f.writeFile(arq,'');
      TB_IMP.next;
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.imprimeGondolaArgoxAtacado();
var
  arq, temperatura:string;
  pcTot, qtMin:String;
  l1, l2, l3, l4,l5:String;
begin
	getTbItensParaimpressao();

  f.gravaLog(TB_IMP, 'Tabela TB_IMP') ;


   arq:= f.getArqImpPorta();
   deleteFile(arq);

   l1 := dm.getParamBD('impCodBarras.GonArgoxAta', '1');
   l2 := dm.getParamBD('impCodBarras.GonArgoxAta', '2');
   l3 := dm.getParamBD('impCodBarras.GonArgoxAta', '3');
   l4 := dm.getParamBD('impCodBarras.GonArgoxAta', '4');
   l5 := dm.getParamBD('impCodBarras.GonArgoxAta', '5');


   temperatura := dm.getParamBD('impCodBarras.tempArgox', fmMain.getUoLogada() );

   f.writeFile(arq,'F');
   TB_IMP.First;

   while (TB_IMP.Eof = false) do
   begin
      f.writeFile(arq,'L');
      f.writeFile(arq,'H' + temperatura );

//                      +----- Orientacao
//                      |+-----Fonte
//                      ||+-----multiplicador horzontal
//                      |||+----- mult verticcal
//                      |||| +---subtipo da fonte
//                      ||||_|__   x   y
//					         12110000 0700 010

      f.writeFile(arq,  l1 +  copy(TB_IMP.fieldByName('ds_ref').AsString, 01, 35));

// cod de barras
		dm.setParams(l2, TB_IMP.fieldByName('ean').AsString, TB_IMP.fieldByName('cd_ref').AsString, '');
      f.writeFile(arq, l2);

// informacao da quantidade minima
      qtMin := trim(TB_IMP.fieldByName('qtMin').AsString);
      if (length(qtMin) < 2) then
      	qtMin := '0' + qtMin;

      dm.setParam(l3, qtMin);
      f.writeFile(arq, l3);
      f.writeFile(arq, L4 + TB_IMP.fieldByName('pc').AsString );


	   if (TB_IMP.fieldByName('pcTotal').AsString <> '') then
      begin
         pcTot := 'R$ '+ TB_IMP.fieldByName('pcTotal').AsString ;
         pcTot := preencheCampo(10, ' ', 'E', pcTot);
         f.writeFile(arq, L5 + pcTot );
      end;

   	TB_IMP.Next;
	   f.writeFile(arq, 'E');
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.ajGrid;
begin
	f.ajGridCol(gridItem, tb, 'cd_ref', 52, 'Codigo');
   f.ajGridCol(gridItem, tb, 'ds_ref', 304, 'Descri��o');
   f.ajGridCol(gridItem, tb, 'ean', 82, 'Ean');
   f.ajGridCol(gridItem, tb, 'pc', 76, 'Preco');
   f.ajGridCol(gridItem, tb, 'qt', 64, 'Quant');
   f.ajGridCol(gridItem, tb, 'seq', 0, '');


	if strToint(f.getCp(2, cbTIpoImpressao)) = 5 then
   begin
	   f.ajGridCol(gridItem, tb, 'qtMin', 64, 'Quant Min');
	   f.ajGridCol(gridItem, tb, 'pcTotal', 76, 'ValorTo');
   end
   else
   begin
	   f.ajGridCol(gridItem, tb, 'qtMin', 0, '');
	   f.ajGridCol(gridItem, tb, 'pcTotal', 0, '');
   end;

end;

procedure TfmEtiquetas.gridItemDblClick(Sender: TObject);
begin
//	f.salvaColunasDbGrid(gridItem);
   tb.Delete();
end;

procedure TfmEtiquetas.imprimeItemZebra();
var
  i:integer;
  arq:string;
  c1l1,c1l2,c1l3,c1l4:String;
  c2l1,c2l2,c2l3,c2l4:String;
  c3l1,c3l2,c3l3,c3l4:String;
  c4l1,c4l2,c4l3,c4l4:String;
  coluna:integer;
begin
   getTbItensParaimpressao();

   ARQ := f.getArqImpPorta();
   deleteFile(arq);


   f.writeFile(arq,'');
   f.writeFile(arq,'q831');
   f.writeFile(arq,'Q264,024');
   f.writeFile(arq,'ZT');
   f.writeFile(arq,'S3');
   f.writeFile(arq,'D08');
   f.writeFile(arq,'O');
   f.writeFile(arq,'OD');
   f.writeFile(arq,'UN');
   f.writeFile(arq,'I8,0,002');
   f.writeFile(arq,'JF');
   f.writeFile(arq,'');
   f.writeFile(arq, 'N');

  	TB_IMP.First();
   coluna:=1;

   c1l1 := dm.getParamBD('impEtq.ZebraItC1','1');
{   c1l2 := dm.getParamBD('impEtq.ZebraItC1','2');
   c1l3 := dm.getParamBD('impEtq.ZebraItC1','3');
   c1l4 := dm.getParamBD('impEtq.ZebraItC1','4');

   c2l1 := dm.getParamBD('impEtq.ZebraItC2','1');
   c2l2 := dm.getParamBD('impEtq.ZebraItC2','2');
   c2l3 := dm.getParamBD('impEtq.ZebraItC2','3');
   c2l4 := dm.getParamBD('impEtq.ZebraItC2','4');

   c3l1 := dm.getParamBD('impEtq.ZebraItC3','1');
   c3l2 := dm.getParamBD('impEtq.ZebraItC3','2');
   c3l3 := dm.getParamBD('impEtq.ZebraItC3','3');
   c3l4 := dm.getParamBD('impEtq.ZebraItC3','4');
}

	for i:= 1 to TB_IMP.RecordCount do
   begin
      if coluna = 1 then
      begin
         f.writeFile(arq, c1l1 + '"' + TB_IMP.fieldByName('ean').asString   + '"');
         f.writeFile(arq, c1l2 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 01, 30) + '"');
         f.writeFile(arq, c1l3 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 31, 20) + '"');
         f.writeFile(arq, c1l4 + '"R$ '+ TB_IMP.fieldByName('pc').asString + '"');

         coluna :=2;
      end
      else if  (coluna=2) then
      begin
         f.writeFile(arq, c2l1 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 01, 30) + '"');
         f.writeFile(arq, c2l2 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 31, 20) + '"');
         f.writeFile(arq, c2l3 + '"' + 'CODIGO: '+ TB_IMP.fieldByName('cd_ref').asString   + '"');
         f.writeFile(arq, c2l4 + '"R$ '+ TB_IMP.fieldByName('pc').asString + '"');

         TB_IMP.next;
         coluna :=3;
      end
      else
      begin
         f.writeFile(arq, c3l1 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 01, 30) + '"');
         f.writeFile(arq, c3l2 + '"' + copy(TB_IMP.fieldByName('ds_ref').asString, 31, 20) + '"');
         f.writeFile(arq, c3l3 + '"' + 'CODIGO: '+ TB_IMP.fieldByName('cd_ref').asString   + '"');
         f.writeFile(arq, c3l4 + '"R$ '+ TB_IMP.fieldByName('pc').asString + '"');

         TB_IMP.next;
         coluna := 1;
      end;

      f.writeFile(arq,'P1');
      f.writeFile(arq,'N');
      f.writeFile(arq,'');

      TB_IMP.next;
   end;
   imprimeELimpaCampos(arq);
end;

procedure TfmEtiquetas.FlatButton1Click(Sender: TObject);
var
   idx:smallint;
begin
  idx := strToint(f.getCp(2, cbTIpoImpressao));
   case idx of
      0:imprimeArgox(sender);
//      1:imprimeDynaPos(sender);
      2:imprimeGondolaArgoxGrande(Sender);
//      3:imprimeGondolaDynapos(Sender);
      4:imprimeGondolaZebra();
		5:imprimeGondolaArgoxAtacado();
      6:imprimeItemZebra();
      7:ImprimeGondolaAtacarejo();
   end;
end;


procedure TfmEtiquetas.DBGridDblClick(Sender: TObject);
begin
   if DBGrid.DataSource.DataSet <> nil then
   begin
      uProd.carregaImagem(DBGrid.DataSource.dataSet.fieldByName('is_ref').AsString, Image1, true);
      lbDescImgProd.Caption := DBGrid.DataSource.dataSet.fieldByName('codigo').AsString + ' - '+ DBGrid.DataSource.dataSet.fieldByName('descricao').AsString
   end;
end;

end.

