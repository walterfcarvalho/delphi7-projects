unit AnaliseDeSaidaEstCd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, DB, ADODB, StdCtrls, fCtrls, ExtCtrls, adLabelEdit,
  adLabelComboBox, TFlatButtonUnit, adLabelNumericEdit, adLabelSpinEdit,
  Grids, DBGrids, SoftDBGrid;

type
  TfmAnEstCd = class(TForm)
    grid: TSoftDBGrid;
    pbRodape: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    spedit: TadLabelSpinEdit;
    btPrint: TFlatButton;
    btExport: TFlatButton;
    pnTitulo: TPanel;
    btGeraEstoque: TFlatButton;
    Bt_Saidas: TFlatButton;
    Bt_Entradas: TFlatButton;
    FlatButton5: TFlatButton;
    edit1: TadLabelEdit;
    FlatButton4: TFlatButton;
    FlatButton6: TFlatButton;
    Panel1: TPanel;
    lbNivel: TLabel;
    lbVlCat: TLabel;
    lbClasse1: TLabel;
    lbClasse2: TLabel;
    lbClasse3: TLabel;
    Bevel1: TBevel;
    Label5: TLabel;
    Label6: TLabel;
    Label2: TLabel;
    FlatButton7: TFlatButton;
    DataSource1: TDataSource;
    tbGE: TADOTable;
    PopupMenu1: TPopupMenu;
    VerdetalhesdaCMU1: TMenuItem;
    Pedidosdecompra1: TMenuItem;
    Vermovimentodoestoque1: TMenuItem;
    abrir1: TMenuItem;
    salva1: TMenuItem;
    comando1: TMenuItem;
    cbLoja: TadLabelComboBox;
    function validaCampos():boolean;
    procedure btGeraEstoqueClick(Sender: TObject);
    procedure analiseEstCD();
    procedure criaTabela();
    procedure listarItens();
    procedure FormCreate(Sender: TObject);
    procedure FlatButton7Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ajustaGrid();
    procedure gridDblClick(Sender: TObject);
    procedure btPrintClick(Sender: TObject);
    procedure gridTitleClick(Column: TColumn);
    procedure Bt_EntradasClick(Sender: TObject);
    procedure Bt_SaidasClick(Sender: TObject);
    procedure FlatButton6Click(Sender: TObject);
    procedure FlatButton5Click(Sender: TObject);
    procedure FlatButton4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmAnEstCd: TfmAnEstCd;

implementation

uses f, fdt, uDm, uMain, msg, uDadosGeraEst, uProd, uLj, uPreco;

{$R *.dfm}

procedure TfmAnEstCd.ajustaGrid;
begin
   f.ajGridCol(grid, tbGe, 'is_ref', -1, 'is_ref');
   f.ajGridCol(grid, tbGe, 'codigo', 60, 'C�digo');
   f.ajGridCol(grid, tbGe, 'descricao', 234, 'Descri��o');
   f.ajGridCol(grid, tbGe, 'Data Ultima Ent', 85, 'Data Ultima Ent');
   f.ajGridCol(grid, tbGe, 'Quant Ultima Ent', 84, 'Quant Ultima Ent');
   f.ajGridCol(grid, tbGe, 'dtUltSai', 91, 'Data �lt Saida');
   f.ajGridCol(grid, tbGe, 'diasSemMov', 85, 'Qt dias sem mov');
   f.ajGridCol(grid, tbGe, 'qtSaiUltEnt', 105, 'Qt Trans ap�s ult Ent');
   f.ajGridCol(grid, tbGe, 'percSaida', 57, '% Sa�da');
   f.ajGridCol(grid, tbGe, 'estoque', 64, 'Estoque');
   f.ajGridCol(grid, tbGe, 'cd_pes', -1, 'cd_pes');
   f.ajGridCol(grid, tbGe, 'nm_pes', -1, 'nm_pes');
   f.ajGridCol(grid, tbGe, 'categoria', 80, 'Categoria');
end;

function TfmAnEstCd.validaCampos: boolean;
var
	err:String;
begin
	if (edit1.Text = '') and (lbNivel.Caption = '0') then
		err := dm.getMsg('err_cad_cod');

   if (err <> '') then
		msg.msgErro(err);

   result := (err = '');
end;

procedure TfmAnEstCd.criaTabela();
begin
	f.gravaLog('criaTabela()');

	dm.getTable(tbge, dm.getCMD('anEstCd','getTB') );

	ajustaGrid();
end;

procedure TfmAnEstCd.listarItens();
var
	ds:TdataSet;
begin
	f.gravaLog('ListaItens()');

	ds:= uProd.getIsrefPorFaixaCodigo(edit1.Text, lbNivel.Caption, lbVlCat.Caption, true, false);

   // insere na tabela os itens
	uDadosGeraEst.getItensGeraEstoque(ds, tbGE, f.getCodUO(cbLoja), '101', true);

   // obter os dados das entradas dos itens
	uDadosGeraEst.getDadosEntrada(tbGE,  '999' {para pegar em qq uma}, false);

	uDadosGeraEst.preencheDadosUltimoMov(tbGE, '10033674');

// preenche as categorias do produtos


end;

procedure TfmAnEstCd.analiseEstCD;
begin //
	f.gravaLog('----------------------------------------------');
	f.gravaLog('fmAnEstCd.analiseEstCD()');

// criar tabela
	criaTabela();

// preecnhe os dados dos itens
   listarItens();

// pega a data q quant da ultima movimentacao
	preencheDadosUltimoMov(tbGe, f.getCodUO(cbLoja));

//
	uDadosGeraEst.preencheQtTransferida(tbGE, f.getCodUO(cbLoja) );

// preenche os dados das categorias
	uDadosGeraEst.preencheCategorias(tbGe);

   tbGe.Sort := 'categoria, nm_pes';
   tbGE.Refresh();

	ajustaGrid();
end;


procedure TfmAnEstCd.btGeraEstoqueClick(Sender: TObject);
begin
	if (validaCampos() = true) then
   	analiseEstCD();

//	tbGe.SaveToFile(f.getDirExe() + 'TbGe.dat');

//	tbge.LoadFromFile(f.getDirExe() + 'TbGe.dat');
end;

procedure TfmAnEstCd.FormCreate(Sender: TObject);
begin
   ulj.getComboBoxLjMapa(cbLoja);
	grid.Align := alClient;

	criaTabela();
end;

procedure TfmAnEstCd.FlatButton7Click(Sender: TObject);
begin
   fmMain.ajustaValoresCategorias(lbClasse1, lbClasse2, lbClasse3, lbNivel, lbVlCat);
end;

procedure TfmAnEstCd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	action := cafree;
   fmAnEstCd := nil;
end;


procedure TfmAnEstCd.gridDblClick(Sender: TObject);
begin
//   f.salvaColunasDbGrid(grid);

end;

procedure TfmAnEstCd.btPrintClick(Sender: TObject);
var
	param:TStringlist;
begin
	if (tbGe.IsEmpty = false) then
   begin
		param := TStringlist.Create();
      Param.Add(DateTimeToStr(now) );
      param.Add(f.getNomeCX(cbLoja));
      param.Add(edit1.Text);

      param.Add(lbClasse1.Caption);
      param.Add(lbClasse2.Caption);
      param.Add(lbClasse3.Caption);


		fmMain.imprimeRave(tbGE, nil, nil, nil, nil, 'rpAnEstCd', param);
   end;
end;

procedure TfmAnEstCd.gridTitleClick(Column: TColumn);
begin
	dm.organizarTabela(tbge, grid, Column);
end;

procedure TfmAnEstCd.Bt_EntradasClick(Sender: TObject);
begin
	UDadosGeraEst.listaEntradas(tbGE);
end;

procedure TfmAnEstCd.Bt_SaidasClick(Sender: TObject);
begin
	uDadosGeraEst.listaFormVendas(
   	tbGE,
      uDadosGeraEst.lojaAProcessar(true, cbLoja),
   	tbGE.fieldByName('Data Ultima Ent').AsDateTime
	);
end;

procedure TfmAnEstCd.FlatButton6Click(Sender: TObject);
begin
   if (tbGE.IsEmpty = false) then
      fmMain.obterResumoEntSai(tbGE.FieldByName('is_ref').AsString, uDadosGeraEst.lojaAProcessar(true, cbLoja));
end;

procedure TfmAnEstCd.FlatButton5Click(Sender: TObject);
begin
   if not(tbGE.IsEmpty) then
      fmMain.obterResumoEstoque(tbGE.fieldByName('is_ref').AsString, '1');
end;

procedure TfmAnEstCd.FlatButton4Click(Sender: TObject);
begin
	uDadosGeraEst.listaFormRequisicao(
   	tbGe,
	   uDadosGeraEst.lojaAProcessar(true,cbLoja),
      now-30
	);
end;

end.

