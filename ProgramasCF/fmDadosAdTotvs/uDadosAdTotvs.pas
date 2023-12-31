unit uDadosAdTotvs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, SoftDBGrid, TFlatButtonUnit, StdCtrls, fCtrls,
  adLabelEdit, DB, ADODB;

type
  TfmDadosAdTotvs = class(TForm)
    edCod: TadLabelEdit;
    edDesc: TadLabelEdit;
    btConsulta: TFlatButton;
    tb: TADOTable;
    DataSource1: TDataSource;
    gridItens: TSoftDBGrid;
    procedure btConsultaClick(Sender: TObject);
    procedure gridItensDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gridItensCellClick(Column: TColumn);
    procedure consultaItens();
    procedure gridItensTitleClick(Column: TColumn);
    procedure tbAfterPost(DataSet: TDataSet);
    procedure edCodKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edDescKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmDadosAdTotvs: TfmDadosAdTotvs;

implementation

{$R *.dfm}


uses uDm, uMain, f, uEstoque, uProd, msg;

procedure TfmDadosAdTotvs.btConsultaClick(Sender: TObject);
begin
   if Length(edCod.Text) >= 3 then
      consultaItens();
end;

procedure TfmDadosAdTotvs.consultaItens();
begin
   tb.Connection:= dm.con;
   if (tb.TableName <> '') then
      tb.Close();

   tb.TableName :=  uProd.getTbProdutosDadosTotvs(edCod.Text, edDesc.Text);
   tb.Open();

   f.ajGridCol(gridItens, tb, 'is_ref', 0, 'is_ref');
   f.ajGridCol(gridItens, tb, 'cd_ref', 80, 'Codigo');
   f.ajGridCol(gridItens, tb, 'ds_ref', 304, 'Descri��o');
   f.ajGridCol(gridItens, tb, 'qt_emb', 80, 'Embalagem');
   f.ajGridCol(gridItens, tb, 'xPdr', 100, 'Ponto de reposi��o');
   f.ajGridCol(gridItens, tb, 'xPdrEmCaixa', 50, 'cx');
   f.ajGridCol(gridItens, tb, 'xEm', 100, 'Estoque m�nimo');
   f.ajGridCol(gridItens, tb, 'xEmEmCaixa', 50, 'cx');

   f.ajGridCol(gridItens, tb, 'seq', 0, '');
   tb.ReadOnly := false;
end;

procedure TfmDadosAdTotvs.gridItensDblClick(Sender: TObject);
begin
   f.salvaColunasDbGrid(gridItens, tb);
end;

procedure TfmDadosAdTotvs.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   Action := caFree;
   fmDadosAdTotvs := nil;
end;

procedure TfmDadosAdTotvs.gridItensCellClick(Column: TColumn);
begin
   tb.Edit;
end;

procedure TfmDadosAdTotvs.gridItensTitleClick(Column: TColumn);
begin
   dm.organizarTabela(tb, gridItens, Column);
end;

procedure TfmDadosAdTotvs.tbAfterPost(DataSet: TDataSet);
begin
   if (tb.fieldByName('xPdr').AsString <> '') or (tb.fieldByName('xEm').AsString <> '') then
      uprod.insereDadosTotvs(tb);
end;

procedure TfmDadosAdTotvs.edCodKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
   if (key = VK_return) then
    btConsultaClick(nil);
end;

procedure TfmDadosAdTotvs.edDescKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
   if (key = VK_return) then
      btConsultaClick(nil);
end;

end.
