unit uNotasAgregadas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, SoftDBGrid, DB, ADODB, Menus;

type
  TfmNotasAgregadas = class(TForm)
    gdNotasAgregadas: TSoftDBGrid;
    RadioGroup1: TRadioGroup;
    gdNotasAgregadoras: TSoftDBGrid;
    RadioGroup2: TRadioGroup;
    dsNotasAgregadas: TDataSource;
    dsNotasAgregadoras: TDataSource;
    qrNotasAgregadoras: TADOQuery;
    qrNotasAgregadas: TADOQuery;
    PopupMenu1: TPopupMenu;
    InserirNota1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure gdNotasAgregadasDblClick(Sender: TObject);
    procedure gdNotasAgregadorasDblClick(Sender: TObject);
    procedure InserirNota1Click(Sender: TObject);
    procedure consultaNotasRElacionadas(Sender: TObject);
    procedure ajustaGridConsultaDeNotas(grid:TsoftDbGrid; ds:TdataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmNotasAgregadas: TfmNotasAgregadas;

implementation

uses cf, uAjustaNota, umain, Math, uFiscal, f, msg, uDm;
{$R *.dfm}

procedure TfmNotasAgregadas.consultaNotasRElacionadas(Sender: TObject);
begin
   qrNotasAgregadas := uFiscal.getNotasAgregadas(fmAjustaNota.edIsNota.Text, false);
   if ( qrNotasAgregadas <> nil) then
   begin
      dsNotasAgregadas.DataSet := qrNotasAgregadas;
      ajustaGridConsultaDeNotas(gdNotasAgregadas, qrNotasAgregadas);
   end;

   qrNotasAgregadoras := uFiscal.getNotasAgregadas(fmAjustaNota.edIsNota.Text, true);
   if ( qrNotasAgregadoras <> nil) then
   begin
      dsNotasAgregadoras.DataSet := qrNotasAgregadoras;
      ajustaGridConsultaDeNotas(gdNotasAgregadoras, qrNotasAgregadoras);
   end;
end;


procedure TfmNotasAgregadas.ajustaGridConsultaDeNotas(grid:TsoftDbGrid; ds:TdataSet);
var
   i:integer;
begin
   for i:=0 to grid.Columns.Count -1 do
      grid.Columns[i].Visible := false;

   f.ajGridCol(grid, ds, 'dt_emis', 70, 'Emiss�o');
   f.ajGridCol(grid, ds, 'Serie', 30, 'S�rie');
   f.ajGridCol(grid, ds, 'Tipo', 50, 'Tipo');
   f.ajGridCol(grid, ds, 'Situacao', 50, 'Situa��o');
   f.ajGridCol(grid, ds, 'Num', 50, 'N�mero');
   f.ajGridCol(grid, ds, 'Emissor/Destino', 120, 'Emissor/Destino');
   f.ajGridCol(grid, ds, 'Loja', 100, 'Loja');
   f.ajGridCol(grid, ds, 'Loja', 70, 'Valor');
end;

procedure TfmNotasAgregadas.FormShow(Sender: TObject);
begin
   consultaNotasRElacionadas(nil);
end;

procedure TfmNotasAgregadas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	action := caFree;
end;

procedure TfmNotasAgregadas.gdNotasAgregadasDblClick(Sender: TObject);
begin
//	if (qrNotasAgregadas.IsEmpty = false) then
   	if msg.msgQuestion( dm.getMsg('comum.delQuestion')) = mrYes then
	   begin
   		ufiscal.removeRegNfAgregada(fmAjustaNota.edIsNota.Text, true);
	      self.OnShow(fmNotasAgregadas);
   	end;
end;

procedure TfmNotasAgregadas.gdNotasAgregadorasDblClick(Sender: TObject);
begin
//	if (qrNotasAgregadas.IsEmpty = false) then
   	if msg.msgQuestion( dm.getMsg('comum.delQuestion')) = mrYes then
      begin
         ufiscal.removeRegNfAgregada(fmAjustaNota.edIsNota.Text, false);
         self.OnShow(fmNotasAgregadas);
      end;
end;

procedure TfmNotasAgregadas.InserirNota1Click(Sender: TObject);
var
   ds:Tdataset;
   cmd, isNota:String;
begin
   isNota := '';
   isNota := uFiscal.getIsNota();

   if (isNota <>  '' )then
   begin
      ds:= uFiscal.getDadosNota(isNota, '', '', '');

      cmd :=
      dm.getCMD4('Fiscal', 'insRefNfAgregadora',
         fmAjustaNota.lbIsEstoque.Caption,
         fmAjustaNota.lbIsDoc.Caption,
         ds.fieldByName('is_estoque').AsString,
         ds.fieldByName('is_doc').AsString
       );
       dm.execSQL(cmd);
       consultaNotasRElacionadas(nil);
       msg.msgExclamation('Criada a agrega��o....');
   end;
end;


end.
