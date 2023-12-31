unit uRRANA;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,  DB, ADODB, StdCtrls, ComCtrls,
  TFlatButtonUnit, adLabelComboBox, adLabelEdit, ExtCtrls, uRelGeral,
  fCtrls;

type
    TfmRelGeral1 = class(TfmRelGeral)
    edCodigo: TadLabelEdit;
    procedure FormCreate(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelGeral1: TfmRelGeral1;

implementation

{$R *.dfm}
uses uMain, uCF, f, fdt, funcSQL, cf, uDm, msg, uLj, uEstoque, uProd;


procedure TfmRelGeral1.FormCreate(Sender: TObject);
begin
   inherited;
   cbCaixas.Visible := false;
   cbDetAvaForn.Visible := false;
   di.date := dm.getDateBd();
   df.Date := di.Date;
end;

procedure TfmRelGeral1.btOkClick(Sender: TObject);
var
  dsItens:TdataSet;
  tbMov,tbItens:TADOTable;
  params, itens:TStringList;
  cmd :String;
begin
  f.gravaLog('---------------------------RRANA-------------------' );

  if ( length(edCodigo.Text) >= 3) then
  begin
     itens := TSTringlist.Create();

     dsItens:= uProd.getIsrefPorFaixaCodigo(trim(edCodigo.Text), '0','0', false, false);

     if (dsItens.IsEmpty = false) then
     begin
        while (dsItens.Eof = false) do
        begin
           itens.Add(dsItens.fieldByName('is_ref').AsString);
           dsItens.Next();
        end;
     end;
     dsItens.free();

     cmd := dm.getCMD('Estoque','rrana.criatbTemp');
     dm.getTable(tbItens, cmd);

     cmd := dm.getCMD('Estoque','rrana.criatbTempItens');
     dm.getTable(tbMov, cmd);

     uEstoque.calculaRRANA( tbItens, tbMov, itens, f.getCodUO(cbLojas), di.Date, df.Date);

    if (tbMov.IsEmpty = false) then
     begin
        Params:= TStringlist.create();
        params.Add(dateToStr(di.Date));
        params.Add(dateToStr(df.date));
        params.Add(uLj.getNomeUO(cbLojas));
        params.Add(fmMain.getNomeUsuario()) ;

        fmMain.imprimeRave(tbItens, tbMov, nil, nil, nil, 'rpRRANA', params )
     end
     else
        msg.msgExclamation('Sem movimenta��o no per�odo.');

     tbItens.Close();
     tbMov.Close();
  end;
end;

procedure TfmRelGeral1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   inherited;
   action := CaFree;
   fmRelGeral1 := nil;
end;

procedure TfmRelGeral1.FormShow(Sender: TObject);
begin
  inherited;
  cbCaixas.Visible := false;
end;

procedure TfmRelGeral1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
   btOk.Left := self.Width - (btOk.Width + 30)
end;

end.
