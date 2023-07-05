unit uHash;

interface

uses Classes, Sysutils, f, msg;

type
   THash = class

   public
      index: TSTringList;
      valor1: TSTringList;
      valor2: TSTringList;
      valor3: TSTringList;
      valor4: TSTringList;

      constructor Create;
      destructor Destroy;

      function add(idx, val:String):boolean;
      function addAll(idx, val1, val2, val3, val4:String):boolean;
      function count(): Integer;
      function getIndex(idx:integer): String;
      function getValor(idx:String):String;
      function getValor2(idx: String): String;
      function getValor3(idx: String): String;
      function getValor4(idx: String): String;
      function getVl(i:integer):String;
      function getVl2(i:integer):String;
      function getVl3(i:integer):String;
      function getVl4(i:integer):String;

      function getVlIdx(i:integer):String;
      function indexOf(valor:String):integer;

      procedure clear();
      procedure Free();
      procedure loadFromFiles(nome:String);
      procedure saveToLog();
      procedure savetoFiles(nome:String);
      procedure setValor(idx, vlr:String);
      procedure setValores(idx, vl, vl2, vl3, vl4:String);
      procedure setValorIdx(idx:integer; vlr:String);
      procedure somaValores(idx:String; valor1, valor2, valor3, valor4:real);


   end;



implementation

function THash.count(): Integer;
begin
   result := index.count;
end;

function THash.add(idx, val: String): boolean;
begin
   index.add(idx);
   valor1.Add(val);
   result := true;
end;

function THash.addAll(idx, val1, val2, val3, val4: String): boolean;
var
   tam:integer;
begin
{   tam := 8;
   if length(val1) > tam then
      msg.msgErro(val1);
   if length(val2) > tam then
      msg.msgErro(val2);
   if length(val3) > tam then
      msg.msgErro(val3);
   if length(val4) > tam then
      msg.msgErro(val4);
}
   index.add(idx);
   valor1.Add(val1);
   valor2.Add(val2);
   valor3.Add(val3);
   valor4.Add(val4);
   result := true;
end;

constructor THash.Create;
begin
   index := Tstringlist.Create();
   valor1 := Tstringlist.Create();
   valor2 := Tstringlist.Create();
   valor3 := Tstringlist.Create();
   valor4 := Tstringlist.Create();
end;

destructor THash.Destroy;
begin
  if Self <> nil then
  begin
      Free;
  end
end;

procedure THash.Free;
begin
   if Self <> nil then
   BEGIN
      index.Free;
      valor1.Free;
      valor2.Free;
      valor3.Free;
      valor4.Free;
   END;
end;

function THash.getValor(idx: String): String;
begin
   if (index.IndexOf(idx) >= 0 )then
      result :=  valor1[index.IndexOf(idx)]
   else
      result :=  '';
end;

function THash.getValor2(idx: String): String;
begin
   if (index.IndexOf(idx) >= 0 )then
      result :=  valor2[index.IndexOf(idx)]
   else
      result :=  '';
end;

function THash.getValor3(idx: String): String;
begin
   if (index.IndexOf(idx) >= 0 )then
      result :=  valor3[index.IndexOf(idx)]
   else
      result :=  '';
end;

function THash.getValor4(idx: String): String;
begin
   if (index.IndexOf(idx) >= 0 )then
      result :=  valor4[index.IndexOf(idx)]
   else
      result :=  '';
end;

function THash.getIndex(idx:integer): String;
begin
   result := index[idx];
end;

function THash.indexOf(valor: String): integer;
begin
	result := index.IndexOf(valor);
end;

procedure THash.saveToLog();
var
  i:integer;
begin
   f.gravaLog('saveParams:---------');
   if (index <> nil) then
      for i:= index.Count - 1 downto 0 do
        f.gravaLog(index[i] + ' - '+ valor1[i]+ ' - '+ valor2[i]+ ' - '+ valor3[i]+ ' - '+ valor4[i]);
   f.gravaLog('---------');
end;
        
procedure THash.setValor(idx, vlr: String);
var
   i:integer;
begin
   i:=  indexOf(idx);
   valor1[i] := vlr;
end;

procedure THash.setValores(idx, vl, vl2, vl3, vl4:String);
var
   i:integer;
begin
   i:=  indexOf(idx);
   valor1[i] := vl;
   valor2[i] := vl2;
   valor3[i] := vl3;
   valor4[i] := vl4;
end;

procedure THash.setValorIdx(idx:integer; vlr:String);
begin
   valor1[idx] := vlr;
end;

procedure THash.savetoFiles(nome:String);
begin
   index.SaveToFile(f.getDirLogs() + nome+'_'+'Index.dat');
   valor1.SaveToFile(f.getDirLogs()+ nome+'_'+'valor.dat');
   valor2.SaveToFile(f.getDirLogs()+ nome+'_'+'valor2.dat');
   valor3.SaveToFile(f.getDirLogs()+ nome+'_'+'valor3.dat');
   valor4.SaveToFile(f.getDirLogs()+ nome+'_'+'valor4.dat');
end;

procedure THash.loadFromFiles(nome:String);
begin
   index.LoadFromFile(f.getDirLogs() + nome+'_'+'Index.dat');
   valor1.LoadFromFile(f.getDirLogs()+ nome+'_'+'valor.dat');
   valor2.LoadFromFile(f.getDirLogs()+ nome+'_'+'valor2.dat');
   valor3.LoadFromFile(f.getDirLogs()+ nome+'_'+'valor3.dat');
   valor4.LoadFromFile(f.getDirLogs()+ nome+'_'+'valor4.dat');
end;

procedure THash.clear;
begin
   index.Clear;
   valor1.Clear;
   valor2.Clear;
   valor3.Clear;
   valor4.Clear;
end;

function THash.getVl(i: integer): String;
begin
   result := valor1[i];
end;

function THash.getVl2(i: integer): String;
begin
   result := valor2[i];
end;

function THash.getVl3(i: integer): String;
begin
   result := valor3[i];
end;

function THash.getVl4(i: integer): String;
begin
   result := valor4[i];
end;

function THash.getVlIdx(i: integer): String;
begin
   result := index[i];
end;

procedure THash.somaValores(idx:String; valor1, valor2, valor3, valor4:real);
var
   auxValor1:real;
   auxValor2:real;
   auxValor3:real;
   auxValor4:real;
begin
   { se o indice  do hash nao tiver ele adiciona
     se tiver ele soma ao que ja tem
   }

   if indexOf(idx) = -1 then
      addAll( idx,
              f.FloatToStrFomatado(valor1, true),
              f.FloatToStrFomatado(valor2, true),
              f.FloatToStrFomatado(valor3, true),
              f.FloatToStrFomatado(valor4, true),
              )
   else
   begin
      auxValor1 := strToFloat( getValor (idx));
      auxValor2 := strToFloat( getValor2(idx));
      auxValor3 := strToFloat( getValor3(idx));
      auxValor4 := strToFloat( getValor4(idx));

      valor1 := valor1 + auxValor1;
      valor2 := valor2 + auxValor2;
      valor3 := valor3 + auxValor3;
      valor4 := valor4 + auxValor4;

      setValores(idx,
                 f.FloatToStrFomatado(valor1, true),
                 f.FloatToStrFomatado(valor2, true),
                 f.FloatToStrFomatado(valor3, true),
                 f.FloatToStrFomatado(valor4, true)
                );
   end;
end;

end.
