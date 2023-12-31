unit uSpedCont;

interface

uses
  Windows, DB, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, Mask;

type
  TfmSpedCont = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    Memo1: TMemo;
    Label1: TLabel;
    Memo2: TMemo;
    GroupBox2: TGroupBox;
    Button2: TButton;
    edMesAno: TMaskEdit;
    SpinButton1: TSpinButton;
    Memo3: TMemo;
    cbValida: TCheckBox;
    Button3: TButton;

    function gera_blocoF(anoMes:String):Tstringlist;
    function gera_c180_c185(uo, anoMes, diaI, diaF:String):Tstringlist;
    function gera_c190_c195(uo, anoMes, diaI, diaF:String):Tstringlist;
    function gera_c490_c495(uo, anoMes, diaI, diaF:String):Tstringlist;
    function gera0200(anoMes, uo:String):Tstringlist;
    function gera0400(anoMes, uo:String):Tstringlist;
    function ajustac180Duplicado(fl:TStringlist):TStringlist;
    function geraRegistro(codRegistro, cmdRegistro:String): Tstringlist;
    function geraRegistroDasLojas(anoMes, diaI, diaF:String):Tstringlist;
    function geraBloco_M(anoMes:String):TStringlist;
    function getBloco_9900(fl:TStringlist):TStringlist;
    function getDsParam(registro:String):TdataSet;
    function getItemFromXml(srvNfe, anoMes, uo, cmdSql, xml:String;exclusao:TStrings; salvaNoBd:boolean):Tstringlist;
    function getRegistrosAbertura(anoMes, diaI, diaf:String):Tstringlist;
    function getReg_140_a_200(anoMes:String):TStringlist;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure lerArquivosSPED(arq:String; itens:TStrings; salvaNoBd:boolean);
    procedure SpinButton1DownClick(Sender: TObject);
    procedure SpinButton1UpClick(Sender: TObject);
    function  getItemFromReducao(anoMes, uo, cmd, fl:String;exclusao:TStrings):String;

    function getItemFromNfe(anoMes, uo, cmd, fl:String;exclusao:TStrings):String;
    function getStrSpedPC_C010(anoMes, uo:String):String;
    procedure Button3Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmSpedCont: TfmSpedCont;

implementation

uses fdt, uAcbr, rSped, f, msg, uAjustaSPED, uLj, udm, uMain, uProd;

{$R *.dfm}

function TfmSpedCont.getStrSpedPC_C010(anoMes, uo:String):String;
begin
   if (uo <> '') then
      uo := dm.getQtCMD1('fiscal', 'spedPC_C010.uo', uo);

   result := dm.getCMD2('fiscal', 'spedPC_C010', quotedStr(anoMes), uo);
end;

function TfmSpedCont.geraBloco_M(anoMes: String): TStringlist;
var
   i:integer;
   fl:Tstringlist;
   cfos, cfoEntForn, cfoDevCli:String;
   dsDados, dsParam:TdataSet;
begin
   fmMain.msgStatus('Registros Bloco M');

   fl := TStringlist.Create();
   fl.add('|M001|0|');

   cfoEntForn := dm.getCMD('fiscal', 'cfo.entFor');
   cfoDevCli := dm.getCMD('fiscal', 'cfo.devCli');
   cfos := cfoEntForn + ', '+ cfoDevCli;

   // M100
   f.addStringList(fl,
      fmSpedCont.geraRegistro('M100', dm.getCMD2('fiscal', 'spedPC_M100', anoMes, cfos) )
   );

   // m105
   dsDados:= dm.getDataSetQ( dm.getCMD2('fiscal', 'spedPC_M105', anoMes, cfos));
   dsParam := getDsParam('m105');

   f.addStringList(fl,  getDados(dsDados, dsParam, true));

   fl.add('|M990|' + intToStr(fl.Count +1) + '|') ;

   dsDados.Free;
   dsParam.Free();

   result := fl;
end;

function TfmSpedCont.getDsParam(registro:String):TdataSet;
begin
   result := dm.getDataSetQ( dm.getQtCMD1('fiscal', 'sped.getReg', registro));
end;

function TfmSpedCont.geraRegistro(codRegistro, cmdRegistro:String): Tstringlist;
var
   dsParam,dsDados:TdataSet;
begin
   dsParam := fmSpedCont.getDsParam(codRegistro);
   dsDados :=  dm.getDataSetQ( cmdREgistro);
   result := rSped.getDados(dsDados, dsParam, false);
end;

function TfmSpedCont.getItemFromReducao(anoMes, uo, cmd, fl:String;exclusao:TStrings):String;
var
   cfop, isRef, qt, vlUnd, vlTot, vlDesc:String;
begin
   isRef := rSped.getCp(2, fl);
   qt    := rSped.getCp(3, fl);
   cfop  := '5102';
   vlUnd := rSped.getCp(4, fl);
   vlTot := rSped.getCp(5, fl);
   vlDesc := '0';


   dm.setParams(cmd, quotedstr(anoMes), quotedStr(uo), quotedStr('cf'));
   dm.setParams(cmd, isRef,  quotedStr(cfop),   qt);
   dm.setParams(cmd, f.valorSql(vlUnd), f.valorSql(vlTot), f.valorSql(vlDesc));

   if (exclusao.IndexOf(isRef) < 0) and (exclusao.Count >0) then
      cmd := '';

   result := cmd ;
end;

function TfmSpedCont.gera_blocoF(anoMes:String): Tstringlist;
var
   fl:TStringlist;
begin
   fmMain.msgStatus('Registros Bloco F');

   fl := TStringlist.Create();
   fl.add('|F001|0|');

   f.addStringList(fl,
      fmSpedCont.geraRegistro('F010', getStrSpedPC_C010(anoMes, '') )
   );

   fl.add('|F990|' + inttoStr(fl.Count +1) + '|');
   result := fl;
end;


function TfmSpedCont.getItemFromNfe(anoMes, uo, cmd, fl:String;exclusao:TStrings):String;
var
   cfop, isRef, qt, vlUnd, vlTot, vlDesc:String;
begin
//getItemFromNfe(anoMes, uo, cmd, fl:String;exclusao:TStrings):String;

   isRef := rSped.getCp(3, fl);
   qt    := rSped.getCp(5, fl);
   vlTot := rSped.getCp(7, fl);
   vlDesc := rSped.getCp(8, fl);
   cfop  := rSped.getCp(11, fl);
   vlUnd := '0'   ;


   dm.setParams(cmd, quotedstr(anoMes), quotedStr(uo), quotedStr('nf'));
   dm.setParams(cmd, isRef,  quotedStr(cfop),   qt);
   dm.setParams(cmd, f.valorSql(vlUnd), f.valorSql(vlTot), f.valorSql(vlDesc));

   if (exclusao.IndexOf(isRef) < 0) and (exclusao.Count >0) then
      cmd := '';

   result := cmd;
end;

function TfmSpedCont.getItemFromXml(srvNfe, anoMes, uo, cmdSql, xml:String;exclusao:TStrings; salvaNoBd:boolean):Tstringlist;
var
   arq:String;
   dsTotIt,dsItNf:TdataSet;
   fl :String;
   res:TStringList;
   is_ref:String;
   aux:String;
   vItem, vDesc:String;

begin
   f.gravaLog('getItemFromXml(): ');
   f.gravaLog( 'server:'+ srvNfe + ' anomes:'+ anoMes + ' uo:'+ uo +' xml:'+ xml);


   res:= TStringlist.Create();
   arq := f.getDirExe() + 'nfe\' + srvNfe +'\'+ anoMes +'\'+ xml + '-nfe.xml';

   if (FileExists(arq) = true) then
   begin
     if (salvaNoBd = true) then
     begin
        f.gravaLog('Verificando Nfe:' + arq);

        dsItNf := uAcbr.getDaDosXml(arq, 'nfeEntItens.xtr');
        dsTotIt := uAcbr.getDaDosXml(arq, 'nfeTotItem.xtr');

        dsItNf.Open();
        dsItNf.First;
        while (dsItNf.Eof = false) do
        begin
           is_ref := dm.openSQL('select is_ref from dscbr (nolock) where cd_pesq= '+ quotedStr(dsItNf.fieldByName('cEAN').asString), '');

           if is_ref = '' then
              is_ref := dm.openSQL('select is_ref from crefe (nolock) where cd_ref = '+ quotedStr(dsItNf.fieldByName('cProd').asString), '');

//           if is_ref = '145210' then
//  /            is_ref := '145210';

           if (is_ref = '') then
           begin
             memo2.Lines.add( 'Codigo n�o encontrado');
             memo2.Lines.add( 'Arq: ' + arq);
             memo2.Lines.add( 'Codigo:'+ dsItNf.fieldByName('cProd').asString + ' EAN:'+ dsItNf.fieldByName('cEAN').asString);
           end;

           if (is_ref <> '') then
           begin
               vItem :=    f.pontoPorVirgula(dsItNf.fieldByName('vProd').AsString);
               vDesc :=    f.pontoPorVirgula(dsItNf.fieldByName('vDesc').AsString);

              fl := '|||' + is_ref +
                   '||'  + dsItNf.fieldByName('qCom').AsString +
                   '||'  + vItem +
                   '|'   + vDesc +
                   '|||' + dsItNf.fieldByName('CFOP').AsString +
                   '|||||';

              if strToFloat(vItem) <strToFloat(vDesc) then
                 showMessage('erro, valor desconto maior q valor do item');

//              f.gravaLog(fl);
              aux :=  fmSpedCont.getItemFromNfe(anoMes, uo, cmdSql, fl, exclusao);
//              f.gravaLog(aux);
              res.Add(aux);
           end;
           dsTotIt.Next;
           dsItNf.Next;
        end;
        dsItNf.Free();
        dsTotIt.Free();
     end;
   end
   else
      memo2.lines.Add('Arq n�o encontrado:' + arq);
   result := res;
end;

procedure TfmSpedCont.lerArquivosSPED(arq: String; itens:TStrings; salvaNoBd:boolean);
var
   i, j:integer;
   fl:TStringList;
   anoMes, uo:String;

   tpEmissao, cmd, str:String;
   statusNf:String;
   srvNfe:String;
   comandos:TStringlist;
begin
   str:= dm.getCMD('fiscal', 'insItSpedPis');
   f.gravaLog(arq);
   i:=0;

   fl := Tstringlist.Create();
   f.gravalog(arq[i]);
   fl.LoadFromFile(arq);

   uo := uLj.getIsUoFromCGF( rSped.getCp(10, fl[0]));
   anoMes := copy(rSped.getCp( 4, fl[0]), 05,04) + copy(rSped.getCp( 4, fl[0]), 03,02);
   srvNfe := dm.getParamBD('ServerNFE.ip', uo);


   if (salvaNoBd = true ) then
   begin
      cmd :=  'delete from zcf_SpedPiscofinsI where uo= ' + uo + ' and anoMes= '+ anoMes;
      dm.execSQL(cmd);
   end;


   for j:= 0  to fl.Count - 1 do
   begin
      fmMain.msgStatusProgresso(j, fl.Count-1, 'linhas ' );
      if (rSped.getCp(1, fl[j]) = 'C100') then
      begin
         statusNf := rSped.getCp(6, fl[j]);

         // notas de saida emitida na loja
         if (rSped.getCp(3, fl[j]) = '0' ) then
         begin
            comandos := fmSpedCont.getItemFromXml(srvNfe, anoMes, uo, str, rSped.getCp(9, fl[j]), itens, salvaNoBd);

            if (salvaNoBd = true) and (comandos.Count > 0) then
            begin
               f.gravaLog('inserir itens notas de saida emitida na loja: ' + rSped.getCp(9, fl[j]) );
               dm.execSQLs( comandos,  true);
               comandos.free();
            end;
         end;
      end;

      // notas de entrada
      cmd := '';
      if (rSped.getCp(1, fl[j]) = 'C170') and (statusNf = '00') then
      begin
         cmd := getItemFromNfe(anoMes, uo, str, fl[j], itens);

         if (salvaNoBd = true) and (cmd <> '')  then
            dm.execSQL(cmd);
      end;

      cmd := '';
      if (rSped.getCp(1, fl[j]) = 'C425') then
      begin
         cmd :=  fmSpedCont.getItemFromReducao(anoMes, uo, str, fl[j], itens);
         if (cmd <> '') then
            if (salvaNoBd = true) then
               dm.execSQL(cmd);
      end;
   end;
   dm.execSQl(dm.getQtCmd2('fiscal', 'spedPC_listaUo',  uo, anoMes));
end;

procedure TfmSpedCont.Button1Click(Sender: TObject);
var
  arquivos:TStrings;
  i:integer;
begin
   memo2.Lines.clear();
   memo3.Lines.clear();

   screen.cursor := crHourGlass;
   arquivos:= f.dialogAbrVariosArq('txt','c:\');
   if arquivos.Count > 0 then
   begin
      for i:=0 to arquivos.Count -1 do
      begin
        Memo3.lines.Add(intTostr(i) + ' de ' + intToStr(arquivos.count) + '  ' + arquivos[i]);
        fmSpedCont.Refresh();

        fmSpedCont.lerArquivosSPED(arquivos[i],  memo1.lines, not(cbValida.Checked) );
        Memo3.lines.Add('>>>>>>>>>>>>>>>  FIM' );

      end;
   end;
   screen.cursor := crDefault;
end;

procedure TfmSpedCont.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Memo1.Lines.Clear();
   Memo2.Lines.Clear();
   Memo3.Lines.Clear();

   f.salvaCampos(fmSpedCont);
   action := caFree;
   fmSpedCont := nil;

end;

function TfmSpedCont.gera0200(anoMes, uo:String):Tstringlist;
var
   dsItens, dsParam:Tdataset;
begin
   fmMain.msgStatus('Registros 0200');

   f.gravaLog('geraC200');
   dsItens := dm.getDataSetQ(dm.getQtCMD2 ('fiscal', 'spedPC0200', anoMes, uo ));
   dsParam := fmSpedCont.getDsParam('0200');
   result :=  rSped.getDados(dsItens, dsParam, true);
end;

function TfmSpedCont.gera0400(anoMes, uo:String):Tstringlist;
var
   dsItens, dsParam:Tdataset;
begin
   fmMain.msgStatus('Registros de 0400');

   f.gravaLog('geraC400');
   dsItens := dm.getDataSetQ(dm.getQtCMD2('fiscal', 'spedPC0400', anoMes, uo ));
   dsParam := fmSpedCont.getDsParam('0400');
   result :=  rSped.getDados(dsItens, dsParam, true);
end;

function TfmSpedCont.ajustac180Duplicado(fl:TStringlist):TStringlist;
var
   rAnt, rAtu:String;
   linAux:String;
   vlIt1, vlIt2:real;
begin

   if fl.Count > 3 then
   begin
      rAnt := rSped.getCp(5, fl[fl.count -6]);
      rAtu := rSped.getCp(5, fl[fl.count -3]);
   end;

   if (rAnt = rAtu) and (rAnt <>  '') then
   begin
      vlIt1 := rSped.getVlCampo(8, fl[fl.count -6]);
      vlIt2 := rSped.getVlCampo(8, fl[fl.count -3]);

      fl[fl.count -6] :=
      rSped.updateCampo(fl[fl.count -6], 8, floatToStr((vlIt1 + vlIt2)) );


      fl.Delete(fl.count -3);
      linAux := fl[fl.count -2];
      fl[fl.count -2] := fl[fl.count -3];
      fl[fl.count -3] := linAux;
   end;

//   f.gravaLog(fl.Count );

   rAnt := '';
   rAtu := '';
   if (fl.Count > 6) then
   begin
      rAnt := rSped.getCp(5, fl[fl.count -8]);
      rAtu := rSped.getCp(5, fl[fl.count -3]);
   end;

   if (rAnt = rAtu) and (rAnt <>  '') then
   begin
      vlIt1 := rSped.getVlCampo(8, fl[fl.count -8]);
      vlIt2 := rSped.getVlCampo(8, fl[fl.count -3]);

      fl[fl.count -8] :=
      rSped.updateCampo(fl[fl.count -8], 8, floatToStr((vlIt1 + vlIt2)) );


      fl.Delete(fl.count -3);

      linAux := fl[fl.count -2];
      fl[fl.count -2] := fl[fl.count -4];
      fl[fl.count -4] := linAux;
   end;
   fl.SaveToFile('c:\teste.txt');
   result := fl;
end;

function TfmSpedCont.gera_c180_c185(uo, anoMes, diaI, diaF:String):Tstringlist;
var
   fl:TStringlist;
   dsIt:TdataSet;
   dsC180, dsC181, dsC185:TdataSet;
   cmd:String;
   cfo:String;
begin
   dsC180:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c180'));
   dsC181:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c181'));
   dsC185:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c185'));

   cfo := dm.getcmd('Fiscal','cfo.vendas');

   fl := TStringlist.Create();
    // adiciona a loja

   dsIt :=
   dm.getDataSetQ(
      dm.getCMD6('fiscal', 'spedPC180c190',
         quotedStr(diaI),
         quotedStr(diaF),
         quotedStr(anoMes),
         quotedstr(uo),
         quotedstr('nf'),
         cfo
       )
   );

   dsIt.First();
   while (dsIt.Eof = false) do
   begin
      f.addStringList(fl, rSped.getDados(dsIt, dsC180, false));
      f.addStringList(fl, rSped.getDados(dsIt, dsC181, false));
      f.addStringList(fl, rSped.getDados(dsIt, dsC185, false));
      dsIt.Next();

      fl := ajustac180Duplicado(fl);
   end;

   dsIt.Free();
   dsC180.Free();
   dsC181.Free();
   dsC185.Free();

   result := fl;
end;

function TfmSpedCont.gera_c190_c195(uo, anoMes, diaI, diaF:String):Tstringlist;
var
   fl:TStringlist;
   dsIt, dsC190, dsC191, dsC195:TdataSet;
   cmd:String;
   cfos:String;
begin
   dsC190:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c190'));
   dsC191:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c191'));
   dsC195:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c195'));

   fl := TStringlist.Create();
    // adiciona a loja

   cfos := dm.getcmd('Fiscal','cfo.entFor') +', '+
           dm.getcmd('Fiscal','cfo.devCli');

    dsIt :=
    dm.getDataSetQ(
       dm.getCMD6('fiscal', 'spedPC180c190',
         quotedStr(diaI),
         quotedStr(diaF),
         quotedStr(anoMes),
         quotedstr(uo),
         quotedstr('nf'),
         cfos
       ));

    if (dsIt.IsEmpty = false) then
    begin
      dsIt.First();
      while (dsIt.Eof = false) do
      begin
         f.addStringList(fl,  getDados(dsIt, dsC190, false));
         f.addStringList(fl,  getDados(dsIt, dsC191, false));
         f.addStringList(fl,  getDados(dsIt, dsC195, false));

         dsIt.Next();

//         fl := ajustac180Duplicado(fl);
      end;
    end;

   dsIt.Free();
   dsC190.Free();
   dsC191.Free();
   dsC195.Free();

//   f.gravaLog(fl);

   result := fl;
{}
end;

function TfmSpedCont.gera_c490_c495(uo, anoMes, diaI, diaF:String):Tstringlist;
var
   fl:TStringlist;
   dsIt:TdataSet;
   dsC490, dsC491, dsC495:TdataSet;
   cmd:String;
begin
   dsC490:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c490'));
   dsC491:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c491'));
   dsC495:= dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c495'));


   dsIt :=
   dm.getDataSetQ(
      dm.getCMD6('fiscal', 'spedPC180c190',
         quotedStr(diaI),
         quotedStr(diaF),
         quotedStr(anoMes),
         quotedstr(uo),
         quotedstr('cf'),
         '5102, 5403'
      )
   );

   fl := TStringlist.Create();
   f.addStringList(fl,  getDados(dsIt, dsC490, false));

   f.addStringList(fl,  getDados(dsIt, dsC491, true));
   f.addStringList(fl,  getDados(dsIt, dsC495, true));

   dsIt.Free();
   dsC490.Free();
   dsC491.Free();
   dsC495.Free();

   result := fl;
end;

function  TfmSpedCont.getRegistrosAbertura(anoMes, diaI, diaf:String):Tstringlist;
var
   dsDados, dsParam:TdataSet;
   fl:Tstringlist;
   cfos:String;
begin
   fmMain.msgStatus('Registros de abertura');
   dsDados := dm.getDataSetQ( dm.getQtCmd2('Fiscal','spedPC_0000', diaI, diaf));
   dsParam := fmSpedCont.getDsParam('0000');

   fl:= Tstringlist.Create();

   f.addStringList(fl,
      rSped.getDados(dsDados, dsParam, false)
   );

   fl.Add('|0001|0|');

   // 0100 registro do contador da empresa
   dsDados := dm.getDataSetQ( 'select getdate()');
   dsParam := fmSpedCont.getDsParam('0100');
   f.addStringList(fl, rSped.getDados(dsDados, dsParam, false) );

   // registro do tipo de  tributacao
   fl.Add('|0110|1|2|1||');

   // 0111 gera o registro
   f.addStringList(fl,
      fmSpedCont.geraRegistro('0111', dm.getCMD1('fiscal', 'spedPC_0111', quotedStr(anoMes))));

   result := fl;
end;


function TfmSpedCont.geraRegistroDasLojas(anoMes, diaI, diaF:String):Tstringlist;
var
   dsUo, dsPUo:TdataSet;
   fl, flAux:TStringList;

begin
   fmMain.msgStatus('Registros Bloco C');


  fl:= TStringlist.create();

  fl.add('|C001|0|');

   // lista as  lojas
  dsUo := dm.getDataSetQ( getStrSpedPC_C010(anoMes, ''));
  dsPUo := dm.getDataSetQ(dm.getQtCMD1 ('fiscal', 'sped.getReg', 'c010'));

  while (dsUo.Eof = false) do
  begin
      // adiciona a loja
     f.addStringList(fl,  getDados(dsUo, dsPUo, false));

     f.gravaLog('--------------------- c180');
     f.addStringList(fl,
      gera_c180_c185(dsUo.fieldByName('uo').AsString, anoMes, diaI, diaF)
     );

     f.gravaLog('--------------------- c190');
     f.addStringList(fl,
        fmSpedCont.gera_c190_c195(dsUo.fieldByName('uo').AsString, anoMes, diaI, diaF)
     );

     f.gravaLog('--------------------- c490');
     flAux := gera_c490_c495(dsUo.fieldByName('uo').AsString, anoMes, diaI, diaF);
     f.addStringList(fl, flAux);

     dsUo.Next();
  end;
  fl.add('|C990|' +   intToStr(fl.Count +1) + '|');
  result := fl;
end;

procedure TfmSpedCont.SpinButton1DownClick(Sender: TObject);
begin
   edMesAno.Text:= fdt.ajustaDataMes(edMesAno.Text, '-');
end;

procedure TfmSpedCont.FormCreate(Sender: TObject);
begin
   f.carregaCampos(fmSpedCont);
   if (edMesAno.Text = '  /    ') then
      edMesAno.Text := '91/2015';
end;

procedure TfmSpedCont.SpinButton1UpClick(Sender: TObject);
begin
   edMesAno.Text:= fdt.ajustaDataMes(edMesAno.Text, '+');
end;

function TfmSpedCont.getBloco_9900(fl: TStringlist): TStringlist;
var
   res, lst:TStringlist;
   campos:String;
   i, j:integer;
   aux:String;
begin
   fmMain.msgStatus('Registros Bloco 99');

   res:= TStringlist.create();

   fmMain.msgStatus('Registro 9900');

   campos := '|0000|0100|0110|0111|0140|0145|0150|0190|0200|0400|C010|C180|C181'+
             '|C185|C190|C191|C195|C490|C491|C495|C500|C501|C505|F010|M100|M105'+
             '|M200|M205|M210|M400|M500|M505|M600|M605|M610|M800|P010|P100|P200'+
             '|0001|0990|A001|A990|C001|C990|D001|D990|F001|F990|I001|I990|M001'+
             '|M990|P001|P990|1001|1990|9001';//|9990|9999|';//9990|';
   lst := TStringlist.create();
   lst := f.camposToStringlist(campos);
   f.gravaLog( intToStr(lst.Count-1));

   res.add('|9001|0|');

   for i := 0 to lst.Count-1 do
   begin
      j:= rSped.contarRegistro( fl, 1, lst[i]);
      aux := intToStr( j+3 );

      res.add('|9900|'+ lst[i] + '|' + aux +'|');
   end;

   res.add('|9900|9990|1|');
   res.add('|9900|9999|1|');
   res.add('|9900|9900|'+  intTostr(res.Count) +'|');


   i := rSped.contarRegistroBloco(res, '9');
   res.add('|9990|'+ intToStr(i+2)+'|');

   i:= fl.Count + res.Count;
   res.add('|9999|'+ intToStr(i+1)+'|');

   result :=  res;
end;

function TfmSpedCont.getReg_140_a_200(anoMes: String): TStringlist;
var
   fl:TStringlist;
   dsUo:TdataSet;
   uo:String;
begin
   f.gravaLog('getReg_140_a_200() '+ anoMes );

   fl := TStringlist.Create();

   dsUo := dm.getDataSetQ( getStrSpedPC_C010(anoMes, '') ) ;

   dsUo.First();
   while dsUo.Eof = false do
   begin
      uo := dsuo.fieldByName('uo').asString;
      // 0140   REGISTRO 0140: TABELA DE CADASTRO DE ESTABELECIMENTO
      f.addStringList(fl,
         fmSpedCont.geraRegistro('0140', getStrSpedPC_C010(anoMes, uo))
      );

      // SOMENTE A LOJA 1
      // 0145  REGIME DE APURA��O DA CONTRIBUI��O PREVIDENCI�RIA SOBRE A RECEITA BRUTA
      if (dsUo.fieldByName('SR_CGC').AsString = '1') then
         f.addStringList(fl,
           fmSpedCont.geraRegistro('0145', dm.getCMD1('fiscal', 'spedPC_0111', quotedStr(anoMes)))
         );

      // 0150 codigo de participante
      fl.Add('|0150|SA201010100118301|COMPANHIA ENERGETICA DO CEARA|01058|07047251000170||061058483|2304400||AV BARAO DE STUDART|2817|||');

      //  0190 unidades de medidas usadas
      fl.Add('|0190|UN|UNIDADE|');

      // gera a listagem dos itens
      f.addStringList(fl,  fmSpedCont.gera0200(anoMes, uo));
        // gerao os registros de cfo
      f.addStringList(fl,  fmSpedCont.gera0400(anoMes, uo));

      dsUo.Next();
   end;
   dsUo.free();

   result := fl;
end;


procedure TfmSpedCont.Button2Click(Sender: TObject);
var
   fl:TStringlist;
   anoMes:String;
   diaI, diaF:String;
   data:Tdate;
   nLinhas_bl_A, nLinhas_bl_C:integer;
begin
   screen.Cursor := crHourGlass;

   anoMes := fdt.getDatePart('a', strTodate('01/'+ edMesAno.text )) + fdt.getDatePart('m', strTodate('01/'+ edMesAno.text ) );
   diaI := '01'+ copy(anoMes, 05, 02) + copy(anoMes, 01, 04);
   diaF :=  f.sohNumeros(fdt.getUltimoDiaMes(('01/'+ edMesAno.text )));

   fl := TStringlist.Create();
   f.addStringList(fl, getRegistrosAbertura(anoMes, diaI, diaF));


    // adiciona os registros
   // 0140, 0145, 150, 190, 200, 0400
   f.addStringList(fl,  getReg_140_a_200(anoMes) );


   nLinhas_bl_A := rSped.contarRegistroBloco(fl, '0') +1;
   fl.add('|0990|'+  intToStr(nLinhas_bl_A) +'|');
   fl.add('|A001|1|');
   fl.add('|A990|2|');

   // chama metodo para iserir os registros por loja
   // registro do bloco C
   f.addStringList(fl,  geraRegistroDasLojas(anoMes, diaI, diaF));


   // registro do bloco D
   fl.add('|D001|1|');
   fl.add('|D990|2|');

   // BLOCO f
   f.addStringList(fl,  gera_blocoF(anoMes) );


   // calcula informacoes do bloco M
   f.addStringList(fl,  geraBloco_M(anoMes));

   // adicionar o bloco 1
   fl.add('|1001|1|');
   fl.add('|1990|2|');

   // adicionar o bloco 9900
   f.addStringList(fl,  getBloco_9900(fl) );

   anoMes := ('_spedPisCofins_' + fdt.getDatePart('a',strTodate('01/'+ edMesAno.text)) +'_'+ fdt.getDatePart('m', strTodate('01/'+ edMesAno.text ))+'.txt');
   fl.SaveToFile(anoMes);

   screen.Cursor := crDefault;

   msg.msgExclamation('Salvo em: ' +#13+ f.getDirExe() + anoMes);
end;

procedure TfmSpedCont.Button3Click(Sender: TObject);
var
  i:integer;
  anoMEs,cmd:String;
  ds:TdataSet;

begin
   anoMes := fdt.getDatePart('a', strTodate('01/'+ edMesAno.text )) + fdt.getDatePart('m', strTodate('01/'+ edMesAno.text ) );

   Memo2.Lines.Clear();
   ds := dm.getDataSetQ( dm.getcmd1('fiscal', 'spedPC_listaUo', quotedStr(anoMes)));
   if (ds <> nil) then
   begin
      ds.First();
      while (ds.Eof = false) do
      begin
         cmd := '';


         for i:=0 to ds.FieldCount -2 do
            cmd := cmd +  f.preencheCampo(20,' ', 'D',  ds.Fields[i].AsString, true) + ', ';

        cmd := cmd + ds.Fields[ds.FieldCount-1].FieldName +':'+ ds.Fields[ds.FieldCount-1].AsString;

         Memo2.Lines.add(cmd);

         ds.Next();
      end;
   end;
end;


end.
