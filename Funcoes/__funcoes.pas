unit funcoes;

interface
uses printers, windows, dialogs, SysUtils, classes, MaskUtils, Registry,   unMsgTela2,
     Messages, Variants, Graphics, Controls, Forms, StdCtrls,dateUtils,
     adLabelComboBox, TFlatButtonUnit, ADODB, SoftDBGrid, fCtrls, QExtCtrls,
     ShellAPI, adLabelCheckListBox, ComCtrls, TFlatCheckBoxUnit, IniFiles, db,
     adLabelMaskEdit, dbGrids, grids, uInput2, msg, uDirDialog,adLabelListBox;

       function aaaaMdDdToDdMmAaaa(str:string):string;
       function ajPrecos(NumDginteiro,NumDgdec:integer;str:String):string;
       function ajustaNumPag(str:string):string;
       function arredondarPreco(num:real):real;
       function bolToStr(valor:boolean):String;
       function buscaEmCombobox(str:string; cbox:TCustomComboBox):integer;
       function calculaReajuste(valor,percentual:Real; Arredonda:boolean):String;
       function calDgCNPJCPF( str:string):string;
       function dataSetTemCampo(ds:TdataSet; campo:String):boolean;
       function dataDoArquivo(arq:String):TDateTime;
       function dataToInt(data:Tdate):integer;
       function dateToInteiro(data:Tdate):integer; overload;
       function dateToInteiro(str:string):string; overload;
       function dateToSQLDateInt(data:String):String; overload;
       function dateToSQLDateInt(data:Tdate):String; overload;
       function dialogAbrArq(tpArquivo,dirInicial:String):String;
       function dialogAbrVariosArq(extensao, DirInicial:string):TStrings;
       function dialogSalvaArq(DirInicial,extensao,SugestaoNmArq:string):string;
       function digCNPJCPF(Num09Digitos:String):String;
       function ehCodigo(str:string):boolean;
       function ehHoraValida(hora:string):boolean;
       function ehParametroInicial(param:String):boolean;
       function execAndWait(const FileName, Params: string;  const WindowState: Word): boolean;
       function execFileExternal(arq:String):Boolean; overload;
       function execFileExternal(arq:String; usaShell:boolean; showWindow:boolean):Boolean; overload;
       function existsParam(sessao, parametro:String):boolean;
       function extractCdref(linha:String):string;
       function faltaLoja(cb:TadLabelComboBox):boolean;
       function filtraNum(str:string;NumDec:integer):string;
       function filtraStr(str:string):string;
       function floatToMoney(valor:Real):String;
       function floatToStrFomatado(Str:string):String; overload;
       function floatToStrFomatado(valor:real; retiraMilhares:boolean):String; overload;
       function getArqImpPorta():String;
       function getArqLog():String;
       function getCamposDataSet(ds:TDataSet):Tstringlist;
       function getCodCaixa(cb:TCustomComboBox): String;
       function getCodModPagto(cb:TCustomComboBox): String;
       function getCodPc(cb:TCustomComboBox):String;
       function getCodUO(cb:TadLabelCheckListBox):String; overload;
       function getCodUO(cb:TCustomComboBox):String;  overload;
       function getCodUsuario(cb:TCustomComboBox):String;
       function getDadosConexaoUDL(nomeArq:string):string;
       function getDigVerEAN13(CodS:string):string;
       function getDirExe():String;
       function getDirLogs():String;
       function getFilesFromDir(mask:String):Tstrings;
       function getIdxParam(parametro:String):integer;
       function getLinhasMemo(linhas:Tstrings):String;
       function getNomeCX(cbox:TcomboBox):string;
       function getNomeDaEstacao() : string;
       function getNomeDoCx(cb:TCustomComboBox):String;
       function getNomeDoExecutavel():String;
       function getNomeDoMicro() : string;
       function getNomeModPagto(cbox:TcomboBox):string;
       function getNomePc(cb:TCustomComboBox):String;
       function getNumUO(cbox:TcomboBox):string;
       function getParamIni(secao, param:String):String;
       function getParamLnComando(nmParam:String):String;
       function getPortaImpressora: String;
       function getQuant(linha:String):String;
       function getSerialFromDisk(FDrive:String) :String;
       function getUos(cb:TadLabelCheckListBox):TstringList;
       Function getWinDir: String;
       function gravaArqParam(sessao,parametro,valor:String):boolean;
       function gravaLinhaEmUmArquivo(nomeArq,texto:string):boolean; overload;
       function gravaLinhaEmUmArquivo(nomeArq:String; ds:TdataSet; descDataSet:String ):boolean; overload;
       function gravaLog(cmd:String):Boolean; overload;
       function gravaLog(ds:TdataSet; descDataSet:String):boolean; overload;
       function gravaLog(lista:TStrings):Boolean; overload;
       function gravaLog(valorInt:integer):Boolean; overload;
       function gravaParam(nomeArq,Str:string;numParam:integer):boolean;
       function horaToInt(hora:string):integer;
       function insereGoEmComandosSQL(arq:String):TStrings;
       function intToHora(x:integer):String;
       function inverteString(s:String):String;
       function isEAN13(cod:String):boolean;
       function isLetra(tecla:char):boolean;
       function isNumero(palavra:String):boolean; overload;
       function isNumero(tecla:char):boolean;    overload;
       function lerParam(nomeArq:string;numParam:integer):string;
       function lerParamNome(nomeArq:string;nomeParam:string):string;
       function limparLog():boolean;
       function loadStrFromFile(arq:String):String;
       function NumLinArq(Arquivo: string): String;
       function precoSqlToStr(Str:String):string;
       function preencheCampo(tamanho:integer;Com,Onde,Str:string):string; overload;
       function preencheCampo(tamanho:integer;Com,Onde,Str:string; truncaStrMaior:boolean):string; overload
       function readArqParamStr(sessao,parametro,valor:String):String;
       function remAcentos(str:String):String;
       function retiraCaracter(str, Caractere:String):String;
       function rParReg(folder,Key:string):string;
       function rParRegBool(folder,Key:string):Boolean;
       function rParRegDate(folder,Key:string):Tdate;
       function rParRegDateTime(folder,Key:string):TdateTime;
       function rParRegInt(folder,Key:string):integer;
       function sohLetras(str:string):string;
       function sohNumeros(str:string):string;
       function sohNumerosPositivos(str:string):string;
       function soLetrasNumerosPositivos(str:String):String;
       function stringListToString(L:TstringList; quebraLinha:boolean):String;
       function strToData(Str:String):TdateTime;
       function strToMoney(Valor: String) : String;
       function strToPrecoSQL(Str:String):String; overload;
       function strToPrecoSQL(Valor:real):String; overload;
       function tamArquivo(Arquivo: string): Integer;
       Function tempDir: String;
       function tiraCaracter(str, caracter:string):string;
       function tiraEspaco(str:string):string;
       function tiraEspacoDuplo(str:string):string;
       function tiraEspacoFim(str:string):string;
       function getLista(lista:TStrings):String;
       function valorSql(str:string):string; overload;
       function valorSql(valor:Real):string; overload;
       function writeFile(nomeArq,texto:string):boolean;


       procedure ajGridCaptions(grid:TSoftDBGrid);
       procedure ajGridCol(grid:TSoftDBGrid; qr:TdataSet; col:String; width:integer; title:String);
       procedure carregaCampos(form:Tform);
       procedure criaparametro(arq,nome,valor:string; numParam:integer);
       procedure executaScript(comandos:TstringList; mostraExecucao:boolean);
       procedure imprimeArquivoPorta(NomeArq:String; nomePorta:string);overload;
       procedure imprimeArquivoPorta(NomeArq:String; nomePorta:string; isConfirmaImpr:boolean); overload;
       procedure limparCampoform(nmForm:String);
       procedure renomearArquivoUpgrade(arqNovo, arqAntigo:String);
       procedure salvaCampos(form:Tform);
       procedure salvaColunasDbGrid(grid: TSoftDbgrid);
       procedure setParamIni(secao, nomeParam, valor:String);
       procedure setUoNacomboBox(cb:TComboBox;{cb:TadLabelComboBox; }uo:String);
       procedure showColGridInvalid(grid:TSoftDbGrid;const Rect: TRect; field:Tfield; column:Tcolumn; State: TGridDrawState; teste:boolean);
       procedure wParReg(folder, NomeParametro,valor:string);
       procedure wParRegBolean(folder, NomeParametro:string; valor:Boolean);
       procedure wParRegDate(folder, NomeParametro:string; valor:Tdate);
       procedure wParRegint(folder, NomeParametro:string; valor:integer);




implementation

uses Math, fdt;

function getCodUsuario(cb:TCustomComboBox):String;
begin
   result := trim(copy(cb.Items[cb.itemIndex], 51, 20));
end;

function getCodUO(cb:TCustomComboBox): String; overload;
begin
   result := trim(copy(cb.Items[cb.itemIndex], 51, 150));
end;

function getCodUO(cb:TadLabelCheckListBox):String; overload;
begin
   result := trim(copy(cb.Items[cb.itemIndex], 51, 150));
end;

function getCodCaixa(cb:TCustomComboBox): String;
begin
   result := getCodUO(cb);
end;

function getCodModPagto(cb:TCustomComboBox): String;
begin
   result :=getCodUO(cb);
end;

function getNomeDoCx(cb:TCustomComboBox):String;
begin
   result := trim(copy(cb.Items[cb.itemIndex], 01, 50));
end;

function getDirLogs():String;
begin
  result :=  ExtractFilePath(paramStr(0)) + 'logs\';
end;

function getArqImpPorta():String;
begin
   // retorna o arquivo texto default da aplicacao
   result := getDirLogs() + 'impressao.txt';
end;

function getNumUO(cbox:TcomboBox):string;
begin
   if cbox.ItemIndex < 0 then
      result := '0'
   else
      result := funcoes.preencheCAmpo(8,'0','d', sohNumeros(copy(cbox.Items[cbox.itemIndex],50,150)) );
end;


function getNomeModPagto(cbox:TcomboBox):string;
begin
   result := copy(cbox.Items[cbox.itemIndex], 01, 30);
end;

function getNomeCX(cbox:TcomboBox):string;
begin
   result := getNomeModPagto(cbox);
end;

function FloatToStrFomatado(str:string):String; overload;
begin
   while pos(',', str) > 0 do delete(str, pos(',',str), 01);
   while pos(' ', str) > 0 do delete(str, pos(' ',str), 01);
   while pos('.', str) > 0 do delete(str, pos('.',str), 01);

   str:= funcoes.sohNumeros(str);
   FloatToStrFomatado := floattostrf(StrTofloat(str), ffNumber, 18, 2);
end;

function FloatToStrFomatado(valor:real; retiraMilhares:boolean):String; overload;
var
   aux:String;
begin
   aux := floattostrf(valor, ffNumber, 18, 2);

   if (retiraMilhares = true) then
      while pos('.', aux) > 0 do delete(aux, pos('.', aux), 01);

   result :=  aux;
end;


function DataDoArquivo(arq:String):TDateTime;
var
   Fhandle: integer;
begin
   try
      FHandle := FileOpen(arq,0);
      result := FileDateToDateTime(FileGetDate(FHandle));
      FileClose(FHandle);
   except
      result := strToDateTime('01/01/1900 00:00:00');
   end;
end;

procedure Criaparametro(arq,nome,valor:string; numParam:integer);
var
   lista:tstringlist;
begin
   lista := tstringlist.Create;
   lista.LoadFromFile(arq);
   while numParam >= lista.Count do
      lista.add('');

   lista[numParam] := IntTostr(numParam);
   if length(lista[numParam]) < 2 then
      lista[numParam] := '0' + lista[numParam];
   lista[numParam] := lista[numParam] + ' ' + nome + '=' + valor;
   lista.SaveToFile(arq);
end;

function valorSql(str:string):string; overload;
var
   i:integer;
begin
   if str = '' then
      str := '0,00';

//   funcoes.gravaLog('valorSql()' + str);

   while pos('.',str) > 0  do
      delete( str, pos('.', str) ,1);

   for i:=0 to length(str) do
      if str[i] = ',' then
      begin
         delete(str, i, 01);
         insert('.', str, i);
      end;

   // deixa com no maximo 3 casas decimais
   if pos('.',str) > 0 then
     delete(str, pos('.',str) +4, 100);

   valorSql:=str;
end;

function valorSql(valor:real):String; overload;
begin
   result := valorSQL(floatToStr(valor));
end;

Function GetWinDir: String;
var TempDir: array[0..255] of Char;
begin
   GetWindowsDirectory(@TempDir,255);
   Result := StrPas(TempDir);
end;


Function TempDir: String;
var TempDir: array[0..255] of Char;
begin
   GetTempPath(255, @TempDir);
   Result := StrPas(TempDir);
end;

function StrToMoney(Valor: String) : String;
var
   i:integer;
begin
   for i:=1 to length(Valor) do
   begin
      if Valor[i] in ['0'..'9',',']  = false then
         delete(Valor,i,01);
   end;
   if valor = '' then
      valor := '0';
   Result := tiraespaco(FormatMaskText('!aaaaaaaaaaaaaa;0; ',(FormatFloat('#,##0.00',StrToFloat(valor))))  );
end;

function EhHoraValida(hora:string):boolean;
begin
      EhHoraValida := false;
   if (StrToInt(Copy(hora,01,02)) >= 0 ) and (StrToInt(Copy(hora,01,02)) < 24 ) and
      (StrToInt(Copy(hora,04,02)) >= 0 )or (StrToInt(Copy(hora,04,02)) < 60 ) then
      EhHoraValida := true;
end;

function soLetrasNumerosPositivos(str:String):String;
var
  i:smallint;
  aux:string;
begin
   aux:='';
   for i:=1 to length(str) do
      if str[i] in ['a'..'z', 'A'..'Z', '0'..'9'] then
         aux := aux + str[i];
  result :=aux;
end;

function SohLetras(str:string):string;
var
  i:smallint;
  aux:string;
begin
   aux:='';
   for i:=1 to length(str) do
      if str[i] in ['a'..'z','A'..'Z'] then
         aux := aux + str[i];
  result :=aux;
end;

function SohNumeros(str:string):string;
var
  i:smallint;
  aux:string;
begin
   aux:='';
   for i:=1 to length(str) do
      if str[i] in ['-','0'..'9'] then
         aux := aux + str[i];
  result :=aux;
end;

function SohNumerosPositivos(str:string):string;
begin
   str := sohNumeros(str);
   while pos('-',str) > 0 do
      delete( str, pos('-',str) , 1 );
   result := str;
end;

function dateToInteiro(str:string):string;  overload;
begin
//01/01/2011
  result := copy(str, 07, 04) +
            copy(str, 04, 02) +
            copy(str, 01, 02);
end;

function dateToInteiro(data:Tdate):integer; overload;
var
   aux: String;
begin
   aux := dateToStr(data);
   result :=  strToInt(dateToInteiro(aux)) ;
end;

function AaaaMdDdToDdMmAaaa(str:string):string;
begin
   if length(str) < 8 then
      AaaaMdDdToDdMmAaaa := '00000000'
   else
      AaaaMdDdToDdMmAaaa := copy(str,07,02) +copy(str,05,02)+ copy(str,01,04);
end;

function AjPrecos(NumDginteiro,NumDgdec:integer;str:string):string;
var
  PosDecSep:integer;
  p1,p2:string;
begin
   if pos(',',str) > 0 then
      PosDecSep := pos(',',str)
   else
      if pos('.',str) > 0 then
         PosDecSep := pos('.',str)
   else
      PosDecSep := length(str)+1;

   p1 := copy(str, 01, PosDecSep -1 );
   p2 := copy(str, PosDecSep +1, NumDgdec );

   while length(p1) < NumDginteiro do
      p1 := '0'+p1;
   while length(p2) < NumDgdec do
      p2 := p2+ '0';
   AjPrecos := p1+p2;
end;

function StrToSqlDate(Str:string):string;
var
   aux:string;
begin
   aux := copy(Str,07,04) + '-' + copy(Str,04,02) +'-'+ copy(Str,01,02);
   if pos(' ',str) = 0 then
      aux  := quotedStr(aux);
   result := aux;
end;

function AjustaNumPag(str:string):string;
begin
   while length(str) < 3 do
      insert('0',str, 01);
   AjustaNumPag := str;
end;

function tiraCaracter(str, caracter:string):string;
begin
   while pos(caracter, str) > 0 do
      delete(str,pos(caracter, str), 01);
   result := str;
end;

function tiraEspaco(str:string):string;
begin
   while pos(' ',str) > 0 do
      delete(str,pos(' ',str),01);
   tiraEspaco:= str;
end;

function tiraEspacoDuplo(str:string):string;
begin
   while pos('  ', str) > 0 do
      delete(str, pos('  ', str), 01);
   result:= str;
end;

function tiraEspacoFim(str:string):string;
begin
   while pos('  ',str) > 0 do
      delete(str,pos('  ',str),01);
   tiraEspacoFim:= str;
end;

function preencheCampo(tamanho:integer;Com,Onde,Str:string):string;
begin
   if pos('NULL',STR) > 0 then
      delete(str,pos('NULL', STR), 04);
   if upcase(onde[1]) = 'D' then
      while length(str) < tamanho do
         insert(com, str,length(str)+1)
   else
      while length(str) <> tamanho do
      begin
          if length(str) < tamanho then
             insert(com, str, 01)
          else
             delete(str, length(str)-1,01);
      end;
   result := (str);
end;

function preencheCampo(tamanho:integer;Com,Onde,Str:string; truncaStrMaior:boolean):string; overload
var
  aux:String;
begin
   aux := preencheCampo(tamanho, com, onde, str);

   if (truncaStrMaior = true) then
      while (length(aux) > tamanho) do
         delete(aux, length(aux), 01);

 //   funcoes.gravaLog(aux);
    result := aux;
end;



function gravaParam(nomeArq,Str:string;numParam:integer):boolean;
var
   Arq:TstringList;
   aux:string;
begin
   try
      arq:= Tstringlist.Create();
      arq.loadFromFile(nomeArq);
      if numParam > arq.Count -1 then
         arq.Add(str)
      else
      begin
         aux := arq[numParam];
         delete( aux, pos('=',aux)+1, length(aux));
         aux:= aux+ str;
         arq[numParam] := aux;
         arq.SaveToFile(nomeArq);
      end;
      result := true;
   except
         result := false;
   end;
end;

function lerParam(nomeArq:string;numParam:integer):string;
var
   arq:Tstringlist;
   l:string;
begin
   arq := Tstringlist.Create;
   if FileExists(nomeArq) = true then
   begin
      arq.LoadFromFile(nomeArq);
      if numparam >= arq.count then
         lerParam:= '*'
      else
      begin
         l:= arq[numParam];
         while pos('=',l) > 0 do
            delete(l,01,01);
         lerParam := l;
      end;
     arq.Destroy;
   end
   else
      result := '';
end;

function lerParamNome(nomeArq:string;nomeParam:string):string;
var
   arq:Tstringlist;
   l:string;
   i:integer;
begin
   if (FileExists(nomeArq) = true )then
   begin
      arq := Tstringlist.Create;
      arq.LoadFromFile(nomeArq);
      l:='';
      for i:=0 to arq.Count-1 do
      begin
         l:= arq[i];
         if nomeParam = copy( arq[i],01, pos('=', arq[i]) -1) then
         begin
             while pos('=',l) > 0 do
                delete(l,01,01);
             Break;
         end;
      end;
      result := l;
      arq.Destroy;
   end
   else
      msg.msgErro('Erro ao ler o par�metro, ' + nomeParam +#13+' N�o encontrei o arquivo: '+ nomeArq);
end;


function EhCodigo(str:string):boolean;
var
   i:integer;
begin
  result := true;
  for i:=1 to length(str) do
     if str[i] in ['0'..'9'] = false  then
     begin
        result:= false;
        break;
     end;
  if length(soHnumeros(str)) <> 7 then
     result:= false;
end;

function FiltraStr(str:string):string;
var
  i:smallint;
begin
   result := '';
   if pos('NULL',str) > 0 then
      delete( str,pos('NULL',str),04);
   if pos('NU',str) > 0 then
      delete( str,pos('NU',str),02);

   for i:=1 to length(str) do
      if str[i] in ['a'..'z','A'..'Z','0'..'9',' '] then
         result:= result + str[i];
end;


function FiltraNum(str:string;NumDec:integer):string;
var
  i:smallint;
  aux:string;
begin
   result := '';
   for i:=1 to length(str) do
      if str[i] in ['0'..'9'] then
         aux := aux + str[i];

   if numdec > 0 then
      insert('.',aux,(length(aux)) - (NumDEc-1));

  result :=aux;
end;

function limparLog():boolean;
begin
   result := DeleteFile(ExtractFilePath(ParamStr(0)) +'logs\'+ ExtractFilename(ParamStr(0)) + '_log.txt');
end;

function getDirExe():String;
begin
   result := ExtractFilePath(paramStr(0));
end;

function getArqLog():String;
var
  dir:String;
begin
   dir := getDirExe();
   ForceDirectories(dir +'logs' );
   result :=  dir +'logs\' + ExtractFilename(ParamStr(0))  + '_log.lOG';
end;

function gravaLog(cmd:String):Boolean; overload;
begin
   result := GravaLinhaEmUmArquivo( getArqLog(), cmd);
end;


function gravaLog(ds:TdataSet; descDataSet:String):boolean; overload;
var
  i:integer;
  cmd:String;
begin //
   gravaLog(descDataSet + ' ---------------------------------------');

   if (ds <> nil) then
   begin
      ds.First();
      while (ds.Eof = false) do
      begin
         cmd := '';

         cmd := ('Registro ' + intToStr(ds.RecNo)) + ' ';

         for i:=0 to ds.FieldCount -2 do
            cmd := cmd + ds.Fields[i].FieldName +':'+ ds.Fields[i].AsString + ', ';

         cmd := cmd + ds.Fields[ds.FieldCount-1].FieldName +':'+ ds.Fields[ds.FieldCount-1].AsString;

         funcoes.gravaLog(cmd);

         ds.Next();
      end;
   end
   else
      result := gravaLog('ds Vazio');
end;

function gravaLog(valorInt:integer):Boolean; overload;
begin
   result := GravaLinhaEmUmArquivo( getArqLog(), intToStr(valorInt));
end;

function gravaLog(lista:TStrings):Boolean; overload;
var
  i:integer;
  res:boolean;
begin
   res:= false;
   funcoes.gravaLog('{');

   for i:=0 to lista.Count - 1 do
      res:= funcoes.gravaLog(lista[i]);

   funcoes.gravaLog('}');


   result := res;
end;

function gravaLinhaEmUmArquivo(nomeArq, texto:string):boolean; overload
var
   arq:textfile;
begin
   if nomeArq = '' then
      nomeArq := funcoes.TempDir() +'_gravalinhaEmArquivo.txt';
   try
      assignfile(arq, nomearq);
      if fileExists(nomeArq) = false then
         rewrite(arq)
      else
         append(arq);

       writeln(arq, texto);
       closefile(arq);
       GravaLinhaEmUmArquivo:= true;
       except
       begin
          funcoes.gravaLog('Erro ao gravar arquivo: '+ nomeArq);
          GravaLinhaEmUmArquivo := false;
       end;
   end;
end;

function gravaLinhaEmUmArquivo(nomeArq:String; ds:TdataSet; descDataSet:String ):boolean; overload;
var
   cmd:String;
   i:integer;
begin
   funcoes.gravaLinhaEmUmArquivo(nomeArq, descDataSet + ' ---------------------------------------');

   ds.First();

   funcoes.gravaLinhaEmUmArquivo(nomeArq, '{');

   while (ds.Eof = false) do
   begin
      cmd := '';

      gravaLog('Registro ' + intToStr(ds.RecNo));

      cmd := cmd + intToStr(ds.RecNo) + ' ';

      for i:=0 to ds.FieldCount -2 do
         cmd := cmd + ds.Fields[i].FieldName +':'+ ds.Fields[i].AsString + ', ';

      cmd := cmd + ds.Fields[ds.FieldCount-1].FieldName +':'+ ds.Fields[ds.FieldCount-1].AsString;

      funcoes.gravaLinhaEmUmArquivo(nomeArq, cmd);


      ds.Next();
   end;
      funcoes.gravaLinhaEmUmArquivo(nomeArq, '}');
   result := gravaLog('');
end;


function writeFile(nomeArq,texto:string):boolean;
begin
   result := GravaLinhaEmUmArquivo(nomeArq, texto);
end;

function remAcentos(str:String):String;
Const
   CE = '��������������������������������������������~�`''"^';
   CA = 'aaaaaeeeeiiiioooouuuucAAAAAEEEEIIIIOOOOUUUUC       ';
var
   i, j:Integer;
begin
   for i := 1 to length(Str) do
      for j:= 1 to length(CE)-1 do
         if (CE[j] = str[i]) Then
         begin
            Delete(str, i, 1);
            insert(CA[j], str, i);
         end;
   result := str;
end;

function DigCNPJCPF(Num09Digitos:String) : String;
var
  i, j, k, Soma, Digito:Integer;
  CNPJ : Boolean;
begin
  Result := Num09Digitos;
  case Length(Num09Digitos) of
     9: CNPJ := False;
     12:CNPJ := True;
  else
     Exit;
  end;

  for j := 1 to 2 do
  begin
     k := 2;
     Soma := 0;
     for i := Length(Result) downto 1 do
     begin
        Soma := Soma + (Ord(Result[i])-Ord('0'))*k;
        Inc(k);
        if (k > 9) and CNPJ then
           k := 2;
     end;
     Digito := 11 - Soma mod 11;
     if Digito >= 10 then
        Digito := 0;
     Result := Result + Chr(Digito + Ord('0'));
  end;
end;

function CalDgCNPJCPF( str:string):string;
var
   aux:string ;
begin
   aux :=DigCNPJCPF(str);
   CalDgCNPJCPF := copy(aux,length(aux)-1 ,02);
end;

function NumLinArq(Arquivo: string): String;
var
  arq:TextFile;
  l:string;
  TamArq,col:integer;
begin
   with TFileStream.Create(Arquivo, fmOpenRead or fmShareExclusive) do
      try
         TamArq := Size;
      finally
         Free;
      end;
   AssignFile(arq,arquivo);
   reset(arq);
   readln(arq,l);
   CloseFile(arq);
   col := length(l);
   NumLinArq := Inttostr( tamArq div col )
end;

function dialogAbrVariosArq(extensao, DirInicial:string):TStrings;
var
   cxDialogo:TOpenDialog;
   arqs:Tstrings;
begin

   cxDialogo := TOpenDialog.create(nil);

   if (extensao <> '') then
   	if (pos('rquivo',extensao) = 0)then
      	CxDialogo.Filter :=  'Arquivo ' + extensao +'|*.'+extensao
      else
      	CxDialogo.Filter :=  extensao;


   cxDialogo.FilterIndex:=0;

   if dirInicial <> '' then
      cxDialogo.InitialDir := DirInicial
   else
      cxDialogo.InitialDir := 'c:\';

   cxDialogo.Options:= [ofAllowMultiSelect];

   if cxDialogo.Execute then
      arqs := CxDialogo.Files
   else
      arqs := TStringlist.Create();

   result := arqs;
end;

function dialogAbrArq(tpArquivo, DirInicial:string):string;
var
   arquivos:Tstrings;
begin
   arquivos := dialogAbrVariosArq(tpArquivo, dirInicial);
   if (arquivos <> nil) and (arquivos.Count > 0) then
      result := arquivos[0]
   else
      result := '';
end;

function DialogSalvaArq(DirInicial, extensao, SugestaoNmArq:string):string;
var
   CxDialogo:TSaveDialog;
begin
   CxDialogo:= TsaveDialog.create(CxDialogo);

   if DirInicial <> '' then
      CxDialogo.InitialDir := DirInicial
   else
      CxDialogo.InitialDir := 'c:\';

   CxDialogo.DefaultExt := extensao;

   CxDialogo.Filter := 'Arquivo ' + extensao + ' |*.'+extensao;
   CxDialogo.FileName := SugestaoNmArq;

   if (CxDialogo.Execute) then
      DialogSalvaArq := CxDialogo.FileName;
end;

procedure WParRegint(folder,NomeParametro:string; valor:integer);
begin
   wParReg(folder,nomeParametro,intToStr(valor));
end;

procedure WParRegDate(folder,NomeParametro:string; valor:Tdate);
begin
   wParReg(folder,nomeParametro,dateToStr(valor));
end;

procedure WParRegBolean(folder,NomeParametro:string; valor:Boolean);
begin
   wParReg(folder,nomeParametro, sysUtils.BoolToStr(valor,true) )
end;

procedure WParReg(folder, NomeParametro,valor:string);
var
  Reg: Tregistry;
begin
  Reg := Tregistry.create;
  with Reg do
  begin
    rootkey := HKEY_CURRENT_USER;
    Openkey('Software\'+folder,true);
    writestring(NomeParametro, valor);
    closekey;
  end;
end;

Function RParReg(folder,Key:string):string;
var
  Reg: Tregistry;
  S: string;
begin
   Reg:=Tregistry.create;
   with Reg do
   begin
      rootkey := HKEY_CURRENT_USER;
      if (Openkey('SOFTWARE\'+folder+'\', true) = true) then
      begin
         S:= readString(Key);
         closekey;
      end;
   end;
   if (s <> '') then
      gravaLog('Lendo registro, chave: ' + folder + ' Parametro: ' + Key + ' Resultado: ' + s)
   else
      gravaLog('Lendo registro, chave: ' + folder + ' Parametro: ' + Key + ' Resultado: ' + 'N�o achei essa chave');
   RParReg:= s;
end;

function RParRegInt(folder,Key:string):integer;
begin
   if (RParReg(folder,key) <> '') then
      result := StrToInt(RParReg(folder,key))
   else
      result := -999;
end;

function RParRegDateTime(folder,Key:string):TdateTime;
begin
   if RParReg(folder,key) <> '' then
      result := StrToDateTime(RParReg(folder,key))
   else
      result := 0;
end;

function RParRegDate(folder,Key:string):Tdate;
begin
   if RParReg(folder,key) <> '' then
      result := StrToDate(RParReg(folder,key))
   else
      result := 0;
end;

function RParRegBool(folder,Key:string):Boolean;
var
  aux:String;
begin
   aux := RParReg(folder,key);
   if aux = 'True' then
      result := true
   else
      result := false;
end;

function PrecoSqlToStr(Str:String):string;
begin
   if pos('.',str) = 1 then
      str := '0'+str;
  insert(',',str, pos('.',str));
  delete(str, pos('.',str),01);
  result := copy(str,01, pos(',',str)+2 );
end;

function getDadosConexaoUDL(nomeArq:string):string;
var
   arq:TstringList;
begin
   if NomeArq = '' then
      nomeArq := extractFilePath(ParamStr(0)) + 'ConexaoAoWell.ini';

   arq:= tstringlist.Create();
   arq.LoadFromFile(nomeArq);

   result  := 'Provider=SQLOLEDB.1;Persist Security Info=False;' +
          arq[0]  +';'+
          arq[01] +';'+
          arq[02] +';'+
          arq[03] +';'+
          'Workstation ID='+ funcoes.getNomeDaEstacao() ;// GetNomeDoMicro();

   funcoes.gravaLog(result);

end;

function StrToPrecoSQL(Valor:real):String; overload;
var
  aux: String;
  index:integer;
begin
   aux := floattostrf(valor ,ffNumber,18,2);

//   funcoes.GravaLinhaEmUmArquivo('c:\zCredito.txt',aux);

   while pos('.', aux) > 0 do
      delete(aux, pos('.',aux), 1);

   while pos(',', aux) > 0 do
   begin
      index := pos(',', aux);
      Delete( aux, index , 1);
      insert( '.', aux, index);
   end;
   result := aux;
end;

function StrToPrecoSQL(Str:String):String;
begin
   while pos(',',str) > 0 do
   begin
      insert('.', str, pos(',',str));
      delete(str, pos(',',str), 1);
   end;
   result := str;
end;

function getNomeDaEstacao() : string;
var
   buffer : array[0..255] of char;
   size : dword;
   UserName: String;
   ComputerName: String;
begin
   size := 256;
   GetUserName(buffer, size);
   UserName := trim(buffer);

   size := MAX_COMPUTERNAME_LENGTH + 1;
   GetComputerName(buffer, size);
   ComputerName :=  trim(buffer);

   ComputerName := funcoes.soLetrasNumerosPositivos(ComputerName);
   UserName :=     funcoes.soLetrasNumerosPositivos(UserName);

   funcoes.gravaLog('funcoes.getNomeDaEstacao():'+ ComputerName +'_'+ UserName);

   Result := funcoes.tiraEspaco(ComputerName +'_'+ UserName);
end;

function getNomeDoMicro() : string;
var
   aux:String;
begin
   aux := getNomeDaEstacao();
   result := aux;
   Result :=  copy (aux, 01, pos('_', aux)-1);
end;

function horaToInt(hora: string): integer;
var
 h,m:String;
begin
   hora := trim(hora);
   h := SohNumeros(copy(hora,01, pos(':',hora) ) );
   m := SohNumeros(copy(hora,pos(':',hora)+1 ,02));
   if ( length(h) > 0) and ( length(m) > 0) then
      result := StrToInt(h) * 60 + strToInt(m)
   else
      result := 0;
end;

function intToHora(x:integer):String;
var
   sinal,aux,h, m :String;
begin
   sinal := '';
   if x < 0 then
   begin
     x:= x *-1;
     sinal := '-';
   end;
   h := inttoStr( x div 60 );
   m := IntToStr( x mod 60 );
   if length(h) < 2 then insert('0',h,1);
   if length(m) < 2 then insert('0',m,1);
   aux := h +':'+ m;

   if aux = '00:00' then
      aux := '  :  ';

    result := sinal + aux;
end;

function StrToData(Str:String):TdateTime;
begin
   try
      result := StrToDate(str);
   except
      result := StrToDate('01/01/1900');
   end;
end;

procedure imprimeArquivoPorta(NomeArq:String; nomePorta:string; isConfirmaImpr:boolean); overload;
var
  conf:boolean;
  cmd:String;
begin //
   conf := isConfirmaImpr;

   if (conf = false) then
     conf := (msgQuestion('Destino da impress�o: '+#13 + nomePorta + #13+#13 + ' Prepare a impressora imprimir. Continua ?') = mrYes);

   if (conf = true) then
   begin
     cmd := 'cmd.exe /c print /d:'+ nomePorta +' '+NomeArq;
     gravaLog(cmd);
     winexec( pchar(cmd), SW_SHOWMINIMIZED);
  end;
end;

procedure imprimeArquivoPorta(NomeArq:String; nomePorta:string); overload;
begin
   imprimeArquivoPorta(NomeArq, nomePorta, true);
end;

function ehParametroInicial(param:String):boolean;
var
   i:smallint;
begin
   ehParametroInicial := false;
   for i:=1 to 10 do
      if ParamStr(i) = param then
         ehParametroInicial := true;
end;


function getParamLnComando(nmParam:String):String;
var
   i:integer;
   res, param:String;
begin
   res := '';
   for i:=0 to ParamCount do
   begin
      param := ParamStr(i);
      if pos(nmParam, param ) > 0 then
      begin
        delete(param, pos(nmParam, param), length(nmParam));
        res := param;
        break;
      end;
   end;
   result := res;
end;


function dataToInt(data:Tdate):integer;
var
  ano,dia,mes:word;
begin
   Sysutils.DecodeDate(data, ano, mes, dia);
   result := (ano*365*3) + (mes*30*2) + dia ;
end;

function getIdxParam(parametro:String):integer;
var
  res, i:smallint;
begin
   res:= -1;
   for i:=0 to paramCount() do
      if (Parametro = ParamStr(i)) then
      begin
         res:= i;
         break;
      end;
   result := res;
end;

procedure salvaColunasDbGrid(grid: TSoftDbgrid);
var
   i:integer;
begin
   funcoes.gravaLog('--------------------' );
   for i:=0 to grid.Columns.Count-1 do
   funcoes.gravaLog(
      '   funcoes.ajGridCol(' + grid.Name +
      ', , ''' +
      grid.Fields[i].FieldName+
       ''', '+
      inttostr( grid.Columns[i].Width ) + ', '''+
      grid.Fields[i].FieldName + ''');'
   );
//   funcoes.ajGridCol(gridItens, dsItens.DataSet, 'pedido', 0,'');


//      funcoes.gravaLog(grid.Fields[i].FieldName +': '+  inttostr( grid.Columns[i].Width ));
end;

function loadStrFromFile(arq:String):String;
var
   ent:TstringList;
   i:integer;
   aux:string;
begin
   if FileExists(arq) = true then
   begin
      i:=0;
      ent := TstringList.Create();
      ent.LoadFromFile(arq);
      while i <  ent.Count do
      begin
         aux := aux + ent[i] + ' ';
         inc(i);
      end;
      ent.Destroy;
      result := aux;
   end
   else
      result :='';

end;

procedure salvaCampos(form:Tform);
var
   j,i:integer;
begin
   for i:=0 to form.ComponentCount-1 do
   begin
// edits
      if form.Components[i].InheritsFrom(TcustomEdit) or (form.Components[i].ClassName = 'TadLabelEdit') then
          funcoes.WParReg( 'ProgramasCF\'+ application.Title , form.Components[i].Name, (form.Components[i] as TcustomEdit).text);
// comboBox
      if form.Components[i].InheritsFrom(TCustomComboBox) then
         funcoes.WParReg( 'ProgramasCF\'+ application.Title , form.Components[i].Name, IntToStr((form.Components[i] as TCustomComboBox).ItemIndex) );
// datePicker ou date
      if form.Components[i].InheritsFrom(TDateTimePicker)  or (form.Components[i].ClassName = 'TfsDateTimePicker') then
         funcoes.WParReg( 'ProgramasCF\'+ application.Title , form.Components[i].Name  , dateToStr( (form.Components[i] as TDateTimePicker).date ) );
// pageControl
      if form.Components[i].ClassName = 'TPageControl'  then
         funcoes.WParReg( 'ProgramasCF\'+ application.Title , form.Components[i].Name  , intToStr( (form.Components[i] as TPageControl).tabIndex ) );

      if (form.Components[i].ClassName = 'TFlatCheckBox') then
         funcoes.WParRegBolean('ProgramasCF\'+ application.Title , form.Components[i].Name, (form.Components[i] as TFlatCheckBox).checked);

      if (form.Components[i].ClassName = 'TSoftDBGrid' ) then
      begin
          for j:=1 to (form.Components[i] as TSoftDBGrid).columns.count -1 do
             funcoes.WParRegint('ProgramasCF\'+ application.Title, form.Components[i].Name + '_C_'+intToStr(j), (form.Components[i] as TSoftDBGrid).Columns[j].Width );
      end;
   end;

  if (form.WindowState <> wsMaximized ) then
  begin
     if (form.Width > 0) then
        funcoes.WParRegint( 'ProgramasCF\'+ application.Title, form.name +'.width', form.Width );
     if (form.Top > 0) then
        funcoes.WParRegint('ProgramasCF\'+ application.Title,  form.Name +'.top', form.top );
     if ( form.Left > 0) then
        funcoes.WParRegint('ProgramasCF\'+ application.Title,  form.Name +'.left', form.left );

     if ( form.Height > 0) then
        funcoes.WParRegint('ProgramasCF\'+ application.Title,  form.Name +'.height', form.Height );
  end;
end;

procedure carregaCampos(form:Tform);
var
   i:integer;
   aux:String;
begin
   gravaLog('Carregar informa��es do registro do form:' + form.Name);
   for i:=0 to form.ComponentCount-1 do
   begin
      if form.Components[i].InheritsFrom(TcustomEdit) or (form.Components[i].ClassName = 'TadLabelEdit') then
      begin
         aux := '';
         aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
         (form.Components[i] as TcustomEdit).text := aux;
      end;

      if form.Components[i].InheritsFrom(TCustomComboBox) then
      begin
         aux := '';
         if funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name) <> '' then
         begin
            aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
            (form.Components[i] as TCustomComboBox).Itemindex := strToInt(aux);
         end;
      end;

      if form.Components[i].InheritsFrom(TDateTimePicker) then
      begin
         aux := '';
         if funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name) <> '' then
         begin
            aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
            (form.Components[i] as TDateTimePicker).date :=  strToDate(aux);
         end;
      end;

      if form.Components[i].ClassName = 'TPageControl' then
      begin
         aux := '';
         if funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name) <> '' then
         begin
            aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
            (form.Components[i] as TPageControl).TabIndex := strToInt(aux);
         end;
      end;

      if (form.Components[i].ClassName = 'TFlatCheckBox') then
      begin
         aux := '';
         begin
            aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
            (form.Components[i] as TFlatCheckBox).Checked := funcoes.RParRegBool('ProgramasCF\'+ application.Title, form.Components[i].Name);
         end;
      end;

      if (form.Components[i].ClassName = 'TFlatCheckBox') then
      begin
         aux := '';
         begin
            aux := funcoes.RParReg('ProgramasCF\'+ application.Title, form.Components[i].Name);
           (form.Components[i] as TFlatCheckBox).Checked := funcoes.RParRegBool('ProgramasCF\'+ application.Title, form.Components[i].Name);
         end;
      end;
 end;

if (form.WindowState <> wsMaximized) then
 begin
    if (funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.width') > 0 ) then
       form.Width :=  funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.width');

    if (funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.top') > 0) then
       form.top :=  funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.top');

    if ( funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.left') > 0) then
       form.left :=  funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.left');

    if ( funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.left') > 0) then
       form.left :=  funcoes.RParRegInt('ProgramasCF\'+ application.Title, form.Name +'.left');
 end;

end;

function ArredondarPreco(num:real):real;
var
  strNum, str :string;
  ultDigAtual, ultDig : string;
  index, count:integer;
begin
  strNum := floatToStrF(num, ffFixed, 18, 02);

  strNum := '0' + strNum;

  if Frac(num) <> 0 then
  begin
     strNum := floatToStrF(num, ffFixed	, 18, 02);

     if (num >0) and (num <= 4.99) then
       ultDig := '9'
     else if (num >=5 ) and (num <= 9.99) then
     begin
        ultDigAtual := copy(strNum, length(strNum)- 2+1, 2);

//        funcoes.gravaLog( 'ultdig atual:'+ ultDigAtual );

        if StrToInt(ultDigAtual) <= 50 then
           ultDig := '49'
         else
           ultDig := '99'
     end
     else
        ultDig := '99' ;

//    funcoes.gravaLog('arredondar para ' + ultDig);


     ultDigAtual := copy(strNum, length(strNum)- length(ultDig) +1, length(ultDig));
     strNum := floatToStrF(num, ffFixed, 18, 02);

     index:= length(strNum)- length(ultDig)+1;
     count := length(ultDig);

     ultDigAtual := copy(strNum, index, count );

     while (ultDigAtual <> ultDig) do
     begin
        num := num + 0.01;
        strNum:= FloatToStrF(num, ffFixed, 18, 02);
        ultDigAtual := copy(strNum, length(strNum)- length(ultDig) +1, length(ultDig) );
     end;
  end;
  str := floatToStrF(num, ffFixed, 18, 02);
  Result := strToFloat(str);
end;

function calculaReajuste(valor,percentual:Real; Arredonda:boolean):String;
var
  aux:String;
begin
   if  (arredonda = true) then
      aux :=       (floattostrf(ArredondarPreco(valor + (valor * percentual ) /100) ,ffNumber,18,2) )
   else
      aux :=  floattostrf( (valor + (valor * percentual ) /100), ffNumber,18,02);

   while pos('.',aux) >0 do
      delete(aux, pos('.',aux),01 );

   result := aux;
end;

function getCodPc(cb:TCustomComboBox):String;
begin
   result := funcoes.SohNumeros(copy(cb.Items[cb.ItemIndex],50,50));
end;

function getNomePc(cb:TCustomComboBox):String;
begin
   result := trim( copy(cb.Items[cb.ItemIndex],01,50));
end;

function getLinhasMemo(linhas:Tstrings):String;
var
  i:integer;
  aux:String;
begin
   for i:=0 to linhas.Count -1 do
      aux := aux + linhas[i];
   result :=  quotedStr(copy(aux,01,500));
end;

function dateToSQLDateInt(data:Tdate):String;
var
   str:String;
begin
   str := DateToStr(data);
   result := copy(str,07,04) + copy(str,04,02) + copy(str,02,02);
end;

function dateToSQLDateInt(data:String):String;
begin
   result := copy(data,07,04) + copy(data,04,02) + copy(data,02,02);
end;

function floatToMoney(valor:Real):String;
begin
   result :=  floatToStrF( valor, ffNumber, 18, 2);
end;

procedure limparCampoForm(nmForm:String);
var
  idform, i:integer;
begin
   idform := -1;
   for i:=0 to application.ComponentCount -1 do
      if Application.Components[i].Name = nmForm then
      begin
         idform := i;
         break;
      end;

   if (idform > -1) then
      for i:=0 to application.Components[idform].ComponentCount -1 do
      begin
         if application.Components[idform].Components[i].InheritsFrom(TcustomEdit) then
            (application.Components[idform].Components[i] as TcustomEdit).text := '';


         if application.Components[idform].Components[i].InheritsFrom(TDataSource) then
            (application.Components[idform].Components[i] as TDataSource).DataSet := nil;
      end;
end;

function TamArquivo(Arquivo: string): Integer;
var
  stream:TFileStream;
  i:integer;
begin
   stream:=  TFileStream.create(Arquivo, fmOpenRead or fmShareExclusive);
   i:= stream.Size;
   stream.Free();
   result := i;
end;

function buscaEmCombobox(str:string; cbox:TCustomComboBox):integer;
var
  i:integer;
begin
   for i:=0 to CBox.Items.count do
      if pos(str,CBox.Items[i]) > 0 then
      begin
         cbox.ItemIndex := i;
         break;
      end;
   result := i;
end;

procedure renomearArquivoUpgrade(arqNovo, arqAntigo:String);
var
   acao:boolean;
begin
   if( FileExists( extractFilePath(paramStr(0)) + 'UpgradeNovo.exe') = true ) then
   begin
      Funcoes.gravaLog('Atualiza��o do lancador: ');
      acao := deleteFile(pChar(extractFilePath(paramStr(0)) + arqAntigo));
      Funcoes.gravaLog('Deletar arquivo upgrade: ' + sysUtils.boolToStr(acao, true) );
      acao := renameFile( extractFilePath(paramStr(0)) + arqNovo,  extractFilePath(paramStr(0)) + arqAntigo );
      Funcoes.gravaLog('Renomear ' + arqNovo + ' para ' + arqAntigo +': ' + sysUtils.boolToStr(acao, true) );
   end;
end;

function getNmArParametros():String;
var
  nmArquivo :String;
begin
   nmArquivo := extractFilePath(ParamStr(0)) + extractFileName(ParamStr(0));
   delete(nmArquivo, pos(extractFileExt(ParamStr(0)), nmArquivo), 04);
   nmArquivo := nmArquivo + '.ini';
   result := nmArquivo;
end;

function gravaArqParam(sessao,parametro,valor:String):boolean;
var
   arq: TIniFile;
begin
   try
      arq := TiniFile.Create( getNmArParametros() );
      arq.WriteString(sessao, parametro, valor);
      arq.Destroy();
      result := true;
   except
      on e:exception do
      begin
         msg.msgErro('Houve um erro ao gravar o par�metro '+ parametro);
         result := false;
      end;
   end;
end;

function readArqParamStr(sessao,parametro,valor:String):String;
var
   arq: TIniFile;
begin
   try
      arq := TiniFile.Create( getNmArParametros() );
      result := arq.ReadString(sessao, parametro, valor);
   except
      on e:exception do
      begin
         msg.msgErro('Houve um erro ao ler o par�metro '+ parametro);
         result := '';
      end;
   end;
end;

function existsParam(sessao, parametro:String):boolean;
var
   arq:TiniFile;
begin
   arq := TiniFile.Create( getNmArParametros() );
   try
     result := arq.ValueExists(sessao, parametro);
     arq.Destroy();
   except
      result := false;
   end;
end;

function execFileExternal(arq:String; usaShell:boolean; showWindow:boolean):Boolean; overload;
var
  cmd:String;
begin
   cmd := arq;
   if (usaShell = true) then
      cmd := 'cmd.exe /c start ' + arq;

   // cmd /c executa e � encerrado
   //cmd /d executa e se mantem

   gravaLog('Executar acao:' + cmd);

   if (showWindow = true) then
      result := (winexec(pchar(cmd), sw_normal) > 31)
   else
      result := (winexec(pchar(cmd), sw_hide) > 31);
end;

function execFileExternal(arq:String):Boolean; overload;
begin
   result := execFileExternal(arq, true, false);
end;


function faltaLoja(cb:TadLabelComboBox):boolean;
const
   MSG_FALTA_LOJA =  ' - Escolha uma loja. ' + #13;
begin
   if (cb.itemIndex < 0) then
     msg.msgErro(MSG_FALTA_LOJA);

   result := (cb.itemIndex < 0);
end;

function getPortaImpressora: String;
var
   Driver, Device, Port : array[0..79] of char;
   Mode : THandle;
   palav: String;
   i: Integer;
   pdl :TPrintDialog;
begin
   pdl := TPrintDialog.Create(nil);
  if Printer.Printers.Count > 0 then
  begin
     if pdl.Execute then
     begin
        for i := 0 to 79 do
           Port[i] := '0';

        Printer.GetPrinter(Driver, Device, Port, Mode);
        palav := '';

        for i := 0 to 79 do
           palav := palav + Port[i];
        Result := palav;
      end
      else
         Result := '';
   end
   else
   begin
      Result := '';
      MessageDlg('N�o h� uma impressora instalada!', mtConfirmation, [mbok], 0);
   end;
end;

function getDigVerEAN13(CodS:string):string;
 var
    i,r,rd: integer;
    CodN: array[1..12] of integer;
    b: boolean;
begin
   // 1� fase: calcula suma de digitos x 1 si impar, x 3 si par
      b := false; r := 0;
      for i := 1 to length(CodS) do
      begin
           CodN[i] := 0;
           b := Not b;
           if b then
           begin
                CodN[i] := StrToInt(Copy(CodS,i,1)) * 1;
           end
           else
           begin
                CodN[i] := StrToInt(Copy(CodS,i,1)) * 3;
           end;
           r := r + CodN[i];
      end;

      rd := 0;

      // 2� fase encuentra decena superior
      for i := r to r + 10 do
           if (i / 10) = Int(i / 10) then rd := i - r;

      if (rd = 10) then rd := 0;
      result := inttostr(rd);
 end;

function isEAN13(cod:String):boolean;
var
   aux:String;
   res:boolean;
begin
   funcoes.gravaLog('IesEan13:' + cod);
   cod := sohNumeros(cod);
   res := false;
   if ( sohNumeros(cod) <> '') then
     if (length(cod) = 13) then
     begin
        aux := copy(cod, 01, 12);
        aux := aux + funcoes.getDigVerEAN13(aux);
        res:= (aux = cod);
     end;
   result := res;
end;

procedure setUoNacomboBox(cb:TComboBox; uo:String);
var
   j,i:integer;
begin

   j:=-1;
   for i:=0 to cb.Items.Count -1 do
   begin
      cb.ItemIndex := i;
      if (funcoes.getCodUO(cb) = uo) then
      begin
         j := i;
         break;
      end;
   end;
   cb.ItemIndex := j;
end;

function getNomeDoExecutavel():String;
var
   exe:String;
begin
   exe := ExtractFileName( Application.ExeName );
   result := copy( exe, 0, pos('.', exe )-1);
end;

function getIniFile():TiniFile;
begin
   result := TIniFile.Create( funcoes.getDirExe() + getNomeDoExecutavel() + '.ini');
end;

procedure setParamIni(secao, nomeParam, valor:String);
var
  ini:TiniFile;
begin
   ini := getIniFile();
   ini.WriteString(secao, nomeParam, valor);
   ini.Free();
end;

function getParamIni(secao, param:String):String;
var
  ini:TiniFile;
  res:String;
begin
   ini := getIniFile();
   res := ini.ReadString(secao, param, '');

   gravaLog('Lendo par�mentro ini, se��o:' + secao + ', chave: '+ param + ', Resultado: '+ res );

   if (res = '') then
     gravaLog('par�metro n�o encontrado !!!! par�mentro ini, se��o:' + secao + ', chave: '+ param + ', Resultado: '+ res );

   Result := res;
   ini.Free;
end;

function stringListToString(L:TstringList; quebraLinha:boolean):String;
var
   i:Integer;
   CR_FL, aux:String;
begin
  if quebraLinha = true then
     CR_FL :=  #13;

  for i:=0 to l.Count-1 do
     aux := aux + l[i] +  CR_FL;
  result := aux;
end;

procedure ajGridCol(grid:TSoftDBGrid; qr:TdataSet; col:String; width:integer; title:String);
begin
   if (width <=0) then
      grid.Columns[qr.FieldByName(col).Index ].visible := false
   else
   begin
      grid.Columns[qr.FieldByName(col).Index ].visible := true;
      grid.Columns[qr.FieldByName(col).Index ].width := width;
   end;

   if (title <> '') then
      grid.Columns[qr.FieldByName(col).Index ].Title.Caption := title;
end;

procedure ajGridCaptions(grid:TSoftDBGrid);
var
  i:smallInt;
begin
   for i:=0 to grid.FieldCount -1 do
      grid.Columns[i].Title.Font.Style := [fsBold];
end;

function isNumero(tecla:char):boolean; overload;
begin
   result := (tecla in ['0'..'9']);
end;

function isNumero(palavra:String):boolean; overload;
var
   i:integer;
   ehNum:boolean;
begin
   ehNum := true;
   for i:= 1 to length(palavra)do
      if isNumero(palavra[i])= false then
      begin
        ehNum := false;
        break;
      end;
   result := ehNum;
end;


function isLetra(tecla:char):boolean;
begin
   result := (tecla in ['a'..'z', 'A'..'Z']);
end;

procedure setaLojaLogadaNoComboBox(cb:TadLabelComboBox; uo:String );
var
   achou:boolean;
   i:integer;
begin
   achou := false;
   if ( achou = false) then
      cb.itemIndex := -1;
   for i:=0 to cb.Items.count-1 do
   begin
      cb.ItemIndex := i;
      if (funcoes.getCodUO(cb) =  uo) then
      begin
         achou := true;
         break;
      end;
   end;
   if (achou = false) then
      cb.ItemIndex := -1;
end;

function execAndWait(const FileName, Params: string;  const WindowState: Word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  { Coloca o nome do arquivo entre aspas. Isto � necess�rio devido aos espa�os contidos em nomes longos }
  CmdLine := '"' + Filename + '"' + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do
  begin
     cb := SizeOf(SUInfo);
     dwFlags := STARTF_USESHOWWINDOW;
     wShowWindow := WindowState;
  end;

  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
                          PChar(ExtractFilePath(Filename)), SUInfo, ProcInfo
                         );
  { Aguarda at� ser finalizado }
  if Result then
  begin
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles }
      CloseHandle(ProcInfo.hProcess);
     CloseHandle(ProcInfo.hThread);
  end;
end;

procedure executaScript(comandos:TstringList; mostraExecucao:boolean);
var
//  WindowState: Word;
  bat : string;
  i:integer;
  arq:TStringList;
  script:String;
begin
   screen.Cursor := crHourGlass;

   script :=   funcoes.getDirExe()+'execAndWait.bat';

// encapsular o comando em um arquivo.bat
   arq := TStringlist.Create();

   for i:= 0 to comandos.Count -1 do
   begin
      arq.Add(comandos[i]);
      funcoes.gravaLog(comandos[i]);
   end;

{   if (funcoes.getParamIni('conexao', 'showScript') = '1') then
   begin
      WindowState := sw_normal;
      arq.Add('Pause');
   end
   else
      WindowState := sw_hide;
}
   bat := funcoes.getDirExe()+'execAndWait.bat';

   deleteFile(script);
   arq.SaveToFile(bat);
   arq.Free();

   winExec(pchar('start ' + script), sw_normal);

   deleteFile(script);

   sleep(300);
   screen.Cursor := crDefault;
end;

procedure showColGridInvalid(grid:TSoftDbGrid;const Rect: TRect; field:Tfield; column:Tcolumn; State: TGridDrawState; teste:boolean);
begin
   if ( Column.FieldName = field.FieldName ) then
      if (teste = false) then
      begin
         grid.Canvas.Font.Color:= clRed;
         grid.Canvas.Font.Style := [fsBold];
         grid.DefaultDrawDataCell(Rect, field, State);
      end;
end;

function bolToStr(valor:boolean):String;
begin
   result := sohNumerosPositivos(sysUtils.boolToStr(valor));
end;

function insereGoEmComandosSQL(arq:String):TStrings;
var
   i:integer;
   ent, sai:TStringList;
begin
  ent := TStringlist.Create();
  sai := TStringlist.Create();

  ent.LoadFromFile(arq);

  for i:= 0 to ent.Count -1 do
  begin
     sai.Add('print ' + quotedStr( intToStr(i+1) +'  '+ ent[i]));
     sai.Add(ent[i]);
     sai.add('GO');
  end;
  sai.SaveToFile( sysutils.ChangeFileExt(arq, '.saida'));
  ent.Free;
  sai.free;
end;

function getFilesFromDir(mask:String):Tstrings;
var
   arqs:TStrings;
   i:integer;
   dir :String;
begin
   arqs := TStringlist.Create();

   Application.CreateForm(TfmDirDialog, fmDirDialog);
   fmDirDialog.lbArquivos.Mask := mask;

   fmDirDialog.ShowModal();

   if (fmDirDialog.ModalResult = mrOk) then
   begin
      dir := fmDirDialog.lbDiretorios.Directory;

      if (copy(dir, length(dir), 01) <> '\') then
        dir := dir + '\';

      for i:= 0 to fmDirDialog.lbArquivos.Items.Count -1 do
         arqs.Add(dir + fmDirDialog.lbArquivos.Items[i]);

   end;
   result := arqs;
   fmDirDialog := nil;
   arqs:= nil;
end;

function inverteString(s:String):String;
var
   i:integer;
   aux:String;
begin
   for i:= length(s) downto 1 do
     aux := aux + s[i];

   result := aux;
end;


function retiraCaracter(str, caractere:String):String;
begin
   while pos(Caractere, str) > 0 do
      delete(str, pos(Caractere, str), 01);
   result := str;
end;

function getSerialFromDisk(FDrive:String) :String;
Var
   Serial:DWord;
   DirLen,Flags: DWord;
   DLabel : Array[0..11] of Char;
begin
   Try GetVolumeInformation(PChar(FDrive+':\'),dLabel,12, @Serial, DirLen, Flags, nil, 0);
   Result := IntToHex(Serial,8);
   Except Result :='';
   end;
end;

function getQuant(linha:String):String;
var
  posInicio:integer;
begin
  if Pos(' ', linha) > 0 then
    posInicio:= Pos(' ', linha)
  else
    posInicio:= 999;

  Result := '0'+trim(copy(linha, posInicio, 20));
end;

function extractCdRef(linha:String):string;
var
  espaco:integer;
begin
   linha := trim(linha);

   espaco := pos(' ',linha);

   if (espaco = 0) then
      espaco := Length(linha);

   result := copy(linha, 01, espaco);
end;

function getLista(lista:TStrings):String;
var
  i:integer;
begin
   if (lista.Count > 0) then
   begin
      for i:=0 to lista.Count -1 do
      begin
        result := result + trim( copy(lista[i], 101, 20));
        if (i < lista.Count -1) then
           result :=  result + ', ';
      end;
   end
   else
      result := '';
end;

function getUos(cb:TadLabelCheckListBox):TstringList;
var
  i:integer;
  uos:TStringlist;
begin
   uos := TStringlist.Create();
   for i := 0 to cb.Items.Count - 1 do
       if cb.Checked[i] = true then
       uos.Add(funcoes.getCodUO(cb));
   result := uos;
end;

function getCamposDataSet(ds:TDataSet):Tstringlist;
var
   i:Integer;
   res:TStringlist;
begin
	res:= TSTringlist.Create();
   for i:=0+3 to ds.FieldCount-1 do
   	res.Add(ds.Fields[i].FieldName);
	result := res;
end;

function dataSetTemCampo(ds:TdataSet; campo:String):boolean;
var
	campos:TStringList;
   res:boolean;
begin
	funcoes.gravaLog('dataSetTemCampo()' + campo);
   campos := TStringList.Create;
   ds.Fields.GetFieldNames(campos);

//   funcoes.gravaLog(campos);
//
   res := (campos.IndexOf(campo) > -1);
   result := res;
   campos.Free();
end;

end.

