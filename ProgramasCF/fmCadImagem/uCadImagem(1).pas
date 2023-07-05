unit uCadImagem;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, DB, ADODB, StdCtrls, Grids, DBGrids, adLabelEdit, TFlatButtonUnit,
  TFlatCheckBoxUnit, jpeg, FileCtrl;

type
  TfmCadastro = class(TForm)
    edCodigo: TadLabelEdit;
    edDescricao: TadLabelEdit;
    pnBotoes: TPanel;
    btConsultar: TFlatButton;
    btIncluir: TFlatButton;
    btAlterar: TFlatButton;
    btExcluir: TFlatButton;
    CheckBox1: TFlatCheckBox;
    FlatButton3: TFlatButton;
    Panel2: TPanel;
    Image1: TImage;
    edFaixa: TadLabelEdit;
    btExportarImg: TFlatButton;
    edIsRef: TadLabelEdit;
    Label1: TLabel;
    procedure btConsultarClick(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure edCodigoKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LimparCampos();
    procedure btIncluirClick(Sender:Tobject);
    procedure incluirImgagem(mostraMsg:Boolean);
    procedure cadastraProduto(is_ref:String);
    procedure btAlterarClick(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure btExcluirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure getImgFromFile(nArquivo:String);
    procedure ajustaDimensaoBitmap(arq:String);
    procedure FlatButton1Click(Sender: TObject);
    procedure FlatButton3Click(Sender: TObject);
    procedure chamaAlteracaoProduto(mostraMsg:boolean);
    procedure btExportarImgClick(Sender: TObject);
    procedure mostrarImagem();
    procedure FormCreate(Sender: TObject);
    procedure cadastraListaImagens();
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmCadastro: TfmCadastro;

implementation

uses uMain, cf, uDm, f, funcsql, uEstoque, msg, uProd;

{$R *.dfm}


procedure TfmCadastro.mostrarImagem();
var
  dsImagem:Tdataset;
  image:Timage;
begin
   dsImagem := uProd.getImagemProduto(edIsRef.Text, false);
   if (dsImagem.FieldByName('imagem').AsString <> '') then
   Image1.Picture.Assign(dsImagem.FieldByName('imagem'));
   Image1.Refresh();
   dsImagem.free;
end;

procedure TfmCadastro.btConsultarClick(Sender: TObject);
var
  dsImagem, dsProduto:TdataSet;
begin
   image1.Picture.Assign(nil);
   image1.Refresh();

   screen.Cursor := crHourglass;
   dsProduto := uProd.getDadosProd( fmMain.getUoLogada(), edCodigo.Text, '', '101', true );

   if (dsProduto.IsEmpty = false ) then
   begin
     edCodigo.Text := dsProduto.fieldByname('codigo').asString;
     edIsRef.Text := dsProduto.fieldByname('is_ref').asString;
     edDescricao.Text := dsProduto.fieldByname('DESCRICAO').asString;

     mostrarImagem();

   end
   else
   begin
      edDescricao.Text := '';
      edIsRef.Text := '';
   end;
   if (edCodigo.Visible = true) then
      edCodigo.SetFocus();

   dsProduto.Free();
   screen.Cursor := crDefault;
end;

procedure TfmCadastro.getImgFromFile(nArquivo:String);
var
   delTemp:boolean;
begin
   if (nArquivo <> '') then
   begin
     f.gravaLog('carregando arquivo:' + nArquivo);
     if ( pos('.JPG', nArquivo)  > 0) then
     begin
        fmMain.msgStatus('Imagem carregada � jpg, convertendo...');
        nArquivo :=  fmMain.ConverterJPegParaBmp(nArquivo);
        delTemp := true;
     end;
//     else

//     if ( tamArquivo(nArquivo) > 10000000 ) then
        ajustaDimensaoBitmap(nArquivo);

     begin
        Image1.Picture.LoadFromFile( nArquivo );
        f.gravaLog('Tamanho do arquivo salvo: ' + floatToStr( tamArquivo(nArquivo))  );
        if (delTemp = true )then
//           deleteFile(nArquivo);
     end;
  end;
  fmMain.msgStatus('');  
end;

procedure TfmCadastro.Image1DblClick(Sender:TObject);
var
   nArquivo:String;
begin
   nArquivo := f.DialogAbrArq('Arquivos bmp, jpg |*.bmp;*.jpg','c:\');
   if (nArquivo <> '') then
      getImgFromFile(nArquivo);
end;

procedure TfmCadastro.edCodigoKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   if (key = VK_RETURN) then
      if (edIsRef.Text <> '' )then
         mostrarImagem()
      else
         btConsultarClick(nil);
end;

procedure TfmCadastro.LimparCampos;
begin
   image1.Picture.Assign(nil);
   edCodigo.Text := '';
   edDescricao.Text := '';
   edIsRef.Text := '';
   if (edCodigo.Visible = true) then
      edCodigo.SetFocus();
end;

procedure TfmCadastro.btAlterarClick(Sender: TObject);
begin
   chamaAlteracaoProduto(true);
end;

procedure TfmCadastro.CheckBox1Click(Sender: TObject);
begin
   Image1.Stretch := CheckBox1.Checked ;
end;

procedure TfmCadastro.btExcluirClick(Sender: TObject);
begin
   if (edIsRef.Text <> '') then
      if (msg.msgQuestion('Deseja excluir a imagem ?') = mrYes ) then
      begin
         dm.execSQL('Delete from zcf_crefe_imagens where is_ref = ' + edIsRef.Text );
         LimparCampos();
         msg.msgExclamation('Imagem Exclu�da.');
         LimparCampos();
      end;
end;


procedure TfmCadastro.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   fmCadastro := nil;
   action := caFree;
end;

procedure TfmCadastro.cadastraListaImagens;
var
  nArquivos,i:integer;
  nArquivo:String;
  arqs:TStrings;
begin
// pega o codigo do produto no nome do arquivo e tenta incluir.
   nArquivos := 0;

   arqs := f.dialogAbrVariosArq('Arquivos bmp, jpg |*.bmp;*.jpg','c:\');

    f.gravaLog(arqs);

   for i:=0 to arqs.Count -1 do
      if (pos('.JPG', UPPERCASE(arqs[i]) ) > 0) or (pos('.BMP', UPPERCASE(arqs[i]) ) > 0) then
      begin
          fmMain.msgStatus('Processando ' + intToStr(i+1) +' de '+ intToStr( arqs.Count) );
          nArquivos := nArquivos+1;
          nArquivo := ExtractFileName(arqs[i]);
          delete(nArquivo, length(nArquivo)-3, 04);

          edCodigo.Text := f.SohNumeros(nArquivo);

          btConsultarClick(nil);

          if (Image1.Picture.Width <= 1 ) and (edDescricao.Text <> '') then
          begin
             fmMain.msgStatus(edCodigo.Text + ' ' + edDescricao.Text + #13+ 'Imagem n�o cadastrada, incluir');
             getImgFromFile(arqs[i]);
             edCodigo.Text := nArquivo;
//             uProd.carregaImagem( nArquivo, Image1, false);
             chamaAlteracaoProduto(false);
//             incluirImgagem(false);
          end
          else
          begin
             fmMain.msgStatus(edCodigo.Text + ' ' + edDescricao.Text + #13+ 'Imagem j� cadastrada, alterar' );
             Image1.Picture.LoadFromFile(arqs[i]);
             image1.Refresh();
//             carregaImagem( arqs[i], Image1, false );
             chamaAlteracaoProduto(false);
          end;

     end;
     if nArquivos > 0 then
       msg.msgExclamation('Processo concluido')
     else
       msg.msgErro('N�o encontrei nenhum arquivo para processar.');

   FlatButton1Click(nil);
end;

procedure TfmCadastro.ajustaDimensaoBitmap(arq:String);
var
   bitmap, resizedbitmap : tbitmap;
   newheight, newwidth : integer; stretchrect : trect;
 w,h:integer;
begin
  f.gravaLog('ajustaDimensaoBitmap()'+ arq );

  w := 320;
  h := 240;

  bitmap := tbitmap.create;
  resizedbitmap := tbitmap.create;
  bitmap.loadfromfile( arq );
  if bitmap.Width <> bitmap.height then begin
     if bitmap.height > bitmap.width then begin
        newheight := h;
        newwidth := (newheight * bitmap.width) div bitmap.height;
     end
     else begin
        newwidth := w;
        newheight := (newwidth * bitmap.height) div bitmap.width;
     end;
   end
   else begin
        newheight := w;
        newwidth := h;
   end;

   if (bitmap.Width > w) or (bitmap.Height > h) then
   begin
      stretchrect.left := 0;
      stretchrect.Top := 0;
      stretchrect.right := newwidth;
      stretchrect.bottom := newheight;
      resizedbitmap.Width := newwidth;
      resizedbitmap.height := newheight;
      resizedbitmap.Canvas.StretchDraw(stretchrect, bitmap);
      resizedbitmap.SaveToFile(arq);

      bitmap.Free();
      resizedbitmap.Free();
   end;
  f.gravaLog('ajustaDimensaoBitmap()'+  intToStr(f.TamArquivo( arq)) );
end;


procedure TfmCadastro.FlatButton1Click(Sender: TObject);
begin
   pnBotoes.Visible :=true;
   edCodigo.Visible := true;
   edDescricao.Visible := true;
end;

procedure TfmCadastro.FlatButton3Click(Sender: TObject);
begin
   LimparCampos();
   pnBotoes.Visible := false;
   edCodigo.Visible := false;
   edDescricao.Visible := false;

   cadastraListaImagens();
end;

procedure TfmCadastro.cadastraProduto(is_ref: String);
var
   tb:TADOTable;
   cmd:String;
begin
   f.gravaLog('cadastraProduto(is_ref: String)');

   dm.getTable(tb, 'is_ref int, imagem image');
   tb.Open();
   tb.Append();
   tb.fieldByName('is_ref').AsString := is_ref;
   tb.fieldByName('imagem').Assign( Image1.Picture );
   tb.Post();
   tb.Close();

   cmd := dm.getCMD1('cpr', 'salvaImg', tb.TableName);

   dm.execSQL(cmd);

   cmd := tb.TableName;
   tb.Free();
   dm.deleteTbTemp(cmd);
end;

procedure TfmCadastro.incluirImgagem(mostraMsg: Boolean);
var
  is_ref:String;
  erro: String;
begin
   screen.Cursor := crHourglass;
   erro := '';
   is_ref := edIsRef.Text;

   if  (edCodigo.Text = '') then
      erro := erro+' - Informe um c�digo.'+#13;

   if (is_ref = '') then
      erro := erro+' - Esse produto n�o � cadastrado.'+#13
   else
      if (edCodigo.Text <> '') then
         if ( dm.openSQL('Select is_ref from zcf_crefe_imagens where is_ref = ' + is_ref, 'is_ref') <> '' ) and (mostraMsg = true) then
           erro := erro+' - Esse c�digo j� tem uma imagem cadastrada.'+#13;

   if (Image1.Picture = nil) then
      erro := erro+' - Selecione uma imagem.'+#13;

   if (erro <> '') then
      msg.msgErro(erro)
   else
   begin
     cadastraProduto(is_ref);
     if (mostraMsg = true) then
        msg.msgExclamation('Inclus�o efetuada.');
     LimparCampos();
   end;
   screen.Cursor := crdefault;
end;

procedure TfmCadastro.btIncluirClick(Sender:TObject);
var
  idx:String;
begin
   if (f.getIdxParam('-tray') > -1) and ( edCodigo.Text = 'logo') then
   begin
      idx := msg.msgInput('Qual o �ndice da imagem?', idx);

      if idx <> '' then
         cadastraProduto(idx)
   end      
   else
      incluirImgagem(true);
end;

procedure TfmCadastro.chamaAlteracaoProduto(mostraMsg: boolean);
var
  altera:boolean;
begin
   altera := true;

   if (mostraMsg = true) then
      if( msg.msgQuestion('Deseja alterar a imagem desse produto? ') = mrNo ) then
         altera := false;

   if (altera = true) then
      if (edIsRef.Text <> '') then
      begin
         dm.execSQL('Delete from zcf_crefe_imagens where is_ref = ' + edIsRef.Text );
         incluirImgagem(false);
         LimparCampos();

         if (mostraMsg = true) then
            msg.msgExclamation('Altera��o efetuada.');
      end;

end;

procedure TfmCadastro.btExportarImgClick(Sender: TObject);
var
  ds:TdataSet;
  cod:String;
begin
	ds:= dm.getDataSetQ('Select cd_Ref from crefe inner join zcf_crefe_imagens i on crefe.is_ref = i.is_ref where crefe.cd_ref like '+  quotedStr(edFaixa.Text+'%') + ' order by cd_ref');


   ds.First;
   while ( ds.Eof =  false ) do
   begin
      edCodigo.Text := ds.fieldByName('cd_ref').AsString;
      btConsultarClick(nil);

// colocar o codigo do protheus
      if  length(edCodigo.Text) = 7 then
         cod := '8' + edCodigo.Text
      else
         cod := edCodigo.Text;

      cod := cod + '00001';

      if (Image1.Picture <> nil) then
      begin
        cod := f.getDirLogs()+ cod + '.bmp';
        f.gravaLog('Arquivo a salvar: '+ cod);
        Image1.Picture.SaveToFile( cod );
      end
      else
        f.gravaLog('Nao tem imagem:' +  edCodigo.Text  );
     ds.Next();
   end;
   ds.Free();

end;

procedure TfmCadastro.FormCreate(Sender: TObject);
begin
   edIsRef.Visible := fmMain.isAcessoTotal(fmMain.Cadastrodeimagens1.Tag);
   edFaixa.Visible := edIsRef.Visible;
   btExportarImg.Visible := edIsRef.Visible;
end;


end.
