unit UpcoAlteradoPorPeriodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, adLabelComboBox, DB, ADODB,  RpCon,
  TFlatButtonUnit, ComCtrls, Grids, DBGrids, fCtrls, uMain ;

type
  TfmPrecosAlterados = class(TForm)
    cbLojas: TadLabelComboBox;
    cbPreco: TadLabelComboBox;
    Label1: TLabel;
    FlatButton1: TFlatButton;
    dp1: TfsDateTimePicker;
    procedure FlatButton1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmPrecosAlterados: TfmPrecosAlterados;

implementation

uses cf, uCF, uDm, uLj, f, msg, uPreco;

{$R *.dfm}

procedure TfmPrecosAlterados.FlatButton1Click(Sender: TObject);
var
   param:Tstringlist;
   ds:TdataSet;
begin
   fmMain.MsgStatus('Verificando as altera��es de pre�o....');
   Screen.Cursor := crhourglass;

   ds := uPreco.listarPrecosAlteradosPoPeriodo(
                                       f.getCodUO(cbLojas),
                                       fmMain.getCodPreco(cbPreco),
                                       dp1.Date
                                     );

   if  ds.IsEmpty = false then
   begin
      param := TStringList.create();
      param.add(fmMain.getDescUO(cbLojas) );
      param.add(fmMain.getDescPreco(cbPreco));
      param.add(dateToStr(dp1.Date));
      fmMain.imprimeRave(ds, nil, nil, nil, nil, 'rpRPVAL', param);
   end
   else
      msg.msgExclamation('N�o h� reajuste deste tipo de pre�o nesse dia para essa loja');

   Screen.Cursor := crDefault;      
   fmMain.MsgStatus ('');
end;

procedure TfmPrecosAlterados.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   f.salvaCampos(fmPrecosAlterados);
   action := caFree;
   fmPrecosAlterados := nil;
end;

procedure TfmPrecosAlterados.FormActivate(Sender: TObject);
begin
   uLj.getListaLojas(cbLojas, false, false, fmMain.getCdpesLogado(), fmMain.getUoLogada());

   cbPreco.items :=  uPreco.getListaPrecos(false, false, true, fmMain.getGrupoLogado() );
   fmMain.getParametrosForm(fmPrecosAlterados);
   dp1.Date := now();
end;

end.
