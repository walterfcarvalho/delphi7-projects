unit uHash3F;

interface

uses Classes, f, sysUtils;

type
   THash3f = class

   public
      index: TSTringList;
      index2: TSTringList;

      valor: TSTringList;
      Valor2:Tstringlist;

      constructor Create;
      destructor Destroy;

      function add(id, id2:String; val:real):boolean;
      procedure getValor(idx:integer; var v1, v2:Real);
      function indexOf(idx, idx2:String):integer;
      function somaAoValor(idx:integer; vl,v2:real):boolean;

      procedure Free();
      procedure saveParams();
   end;

implementation

function THash3F.add(id, id2:String; val:real): boolean;
begin
   index.add(id);
   index2.add(id2);
   valor.Add(floatToStr(val));
   Valor2.Add(floatToStr(val));
end;

constructor THash3F.Create;
begin
   index := Tstringlist.Create();
   index2 := Tstringlist.Create();
   valor := Tstringlist.Create();
   valor2 := Tstringlist.Create();   
end;


destructor THash3F.Destroy;
begin
//  if Self <> nil then
    self.Destroy;
end;

procedure THash3F.Free;
begin
//   if Self <> nil then
     self.Free;
end;

function THash3F.somaAoValor(idx:integer; vl, v2: real): boolean;
var
   aux, aux2:real;
   va1, va2:real;
begin
   if ( idx >= 0 ) and (idx <= index.Count -1) then
   begin
      getValor(idx, va1, va2);


      aux := vl + va1;
      aux2 := v2 + va2;

      valor[idx] := floatToStr(aux);
      Valor2[idx] := floatToStr(aux2);

      result := true;
   end
   else
      result := false;
end;

procedure THash3F.getValor(idx:integer; var v1, v2:Real);
begin
   if (idx >= 0 )then
   begin
      v1 :=  strToFloat(valor[idx]);
      v2 :=  strToFloat(Valor2[idx]);
   end
   else
   begin
      v1 := 0;
      v2 := 0;
   end;
end;

function THash3F.indexOf(idx, idx2:String):integer;
var
   indice, i:integer;
begin
   indice:= -1;
   for i:=0 to index.Count-1 do
      if (index[i] = idx) and (index2[i] = idx2) then
      begin
         indice := i;
         break;
      end;
   result := indice;
end;


procedure THash3F.saveParams();
var
  i:integer;
begin
   f.gravaLog('');
   f.gravaLog('---------');
   if (index <> nil) then
      for i:=0 to index.Count - 1 do
        f.gravaLog(index[i] + '|'+ index2[i] + ':'+ valor[i]+', '+Valor2[i]);
   f.gravaLog('---------');
end;


end.
