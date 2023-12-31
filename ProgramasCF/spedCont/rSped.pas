unit rSped;

interface


uses
  classes, Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms,
  Dialogs, StdCtrls, fCtrls, Buttons, adLabelEdit, IniFiles, DB, ComCtrls, math,
  ExtCtrls, adLabelNumericEdit;


    function ajCfoItensNFEntrada(fl:TstringList):TStringList;
    function ajIsrefFromcdref(fl:TstringList):TStringlist;
    function AjReg_C190_490(Fl:TStringlist): TStringlist;
    function ajustaValoresECF(fl:TstringList;cbAjustaDia:boolean; data:Tdate; ecf:String):TStringlist;
    function ajRegC100(fl:Tstringlist):TstringList;
    function ajustaValoresECF_PisCofins(fl:TstringList; ajustaDia:boolean; data:Tdate; ecf:String):TStringlist;
    function ajustaValoresReducao(ds: TdataSet; fl:TstringList):TStringlist;
    function ajustaValoresReducao_pisCofins(ds: TdataSet; fl:TstringList):TStringlist;
    function ajValorTotalNfEnt(fl:TstringList):TStringList;
    function ajVlTotTribEcf(fl:TstringList): TStringList;
    function cpToDate(numCampo:integer; linha:String):Tdate;
    function getC190Nf(idxC100:integer; fl:TstringList):Tstringlist;
    function getC490(idxC405:integer; fl:TstringList):Tstringlist;
    function getCfoNf(idx:integer; fl:TstringList):String;
    function getCp(numCampo:integer; linha:String):String;
    function getCpInt(indice:integer; str:String):integer;
    function getIdx_c400(fl:TstringList; serie:String):integer;
    function getIdx_c405(fl:TstringList; idx_c400:integer; data:Tdate):integer;
    function getIdx_fim_c481_C485(fl:TstringList; tpReg:String; inicio:integer):integer;
    function getIdxC490_cfo():integer;
    function getIdxItemMaiorValor(var fl:TstringList; idxItemIni, idxItemFim:integer; codCampo:String):integer;
    function getIdxReg(arq: TStringList; idRegistro: String): integer;
    function getIndexReg(arq: TStringList; idRegistro: String; idxI, idxF:integer): integer; overload;
    function getIsRef(linha:String):String;
    function getItensFaturados(arq:TstringList):TStringList;
    function getItensReg0200(arq:TStringList):TStringList;
    function getNumNota(str:String):integer;
    function getNumReg(linha:String):String;
    function contarRegistro(fl: Tstringlist; idxCampo: integer; valor: String): integer;
    function contarRegistroBloco(fl: Tstringlist; valor: String): integer;
    function getNumRegDuplo(linha:String):String;
    function getPosInicio(idCampo:integer; linha:String):integer;
    function getVlCampo(numCampo:integer; linha:String):Real;
    function somaIntervalo(fl:Tstringlist; i,count, campo:integer):real;
    function updateCampo(linha:String; idCampo:integer; novoValor:String):String;
    function updateCampoArq(var arq:TStringlist; idRegistro:String; idCampo:integer; novoValor:String):boolean;
    function updateCampoItensPisCofins(linha:String; diF:Real):String;

    function getIdxCpDuplo(arq:Tstringlist; idxCampo1:integer; vlCampo1:String; idxCampo2:integer; vlCampo2:String):integer;
    function rem_C425_duplicado(Fl: TstringList):TStringList;

    procedure trocaCfoItensNf(cfoNovo:String; idx:integer; var fl:TstringList);
    procedure diminuiVlItens(var fl:TstringList; idxItemIni, idxItemFim, idxItemMaisCaro:integer; vlExcesso:real);

    function getDados(dsDados, dsParam:TdataSet; avancaReg:boolean  ):TStringList; overload;
    function getDados(dsDados, dsParam:TdataSet; avancaReg:boolean; condicao:boolean ):TStringList; overload;

    function remCaracTotvs(x: String): String;


implementation

uses  uMain, fdt, f, funcSql, cf, uFiscal, uDm, uEstoque,
      msg, ulj, uPreco, uHash, uProd, uHash3F;


function remCaracTotvs(x: String): String;
var
  i:smallint;
  aux:string;
begin
   aux:='';
   for i:=1 to length(x) do
   begin
      if (x[i] in ['!', '@', '#', '$', '%', '&', '''', ';'] = false) and (strToInt(f.getCodAsc(x[i])) < 255) then
      begin
         aux := aux + x[i];
      end;
   end;
  result :=aux;
end;

function rem_C425_duplicado(Fl: TstringList):TStringList;
var
   i, i2, i3:integer;
   c490_b1_i, c490_b1_f:integer;
   c490_b2_i, c490_b2_f:integer;

   qtRemovidos:integer;

   lst:TStringList;
   vlSegF6:real;
begin
   // remove os registros duplicados c420
   // que s�o os produtos com substitui��o tributaria

   try
      qtRemovidos := 0;
      i:= 7172;
      while (i <  fl.Count-1) do
      begin
         if (getCp(1, fl[i]) = 'C420') and (getCp(2, fl[i]) = 'F6') then
         begin
            vlSegF6 := 0;
            f.gravaLog('Registro c420, linha: ' + intToStr(i) +' ->'+ fl[i] );

            c490_b1_i := i;
            c490_b2_i := -1;
            i2:= i+1;



            while (getCp(1, fl[i2]) <> 'C490') or (i2 <= fl.Count-1) do
            begin
               if {( getCp(1,aux) = 'C490') or} ( getCp(1,fl[i2]) = 'C420') and (getCp(2,fl[i2]) <> 'F6')  then
               begin c490_b2_i := -1; break; end;

               if ( getCp(1, fl[i2]) = 'C420') and (getCp(2, fl[i2]) = 'F6') then
               begin
                  vlSegF6 := getVlCampo(3, fl[i2]);
                  f.gravaLog('-- Segundo c420: ' + intToStr(i2) + ' -->'+ fl[i2] );

                  c490_b2_i := i2 +1; c490_b2_f := i2 +1;

                  while (getCp(1, fl[c490_b2_f  +1]) = 'C425') do
                     inc(c490_b2_f);

                  inc(i2);
               end;

               if ( c490_b2_i > 0 )then
               begin
                  f.gravaLog('Itens em: ' +intToStr(c490_b2_i) + ' a ' + intToStr(c490_b2_f) );

                  lst := TStringList.Create();

                  for i3:= c490_b2_i to c490_b2_f do
                     lst.add(fl[i3]);

                  f.gravaLog(lst);

                  f.gravaLog('Deletar');
                  f.gravaLog(c490_b2_i);
                  f.gravaLog(c490_b2_f);


                  for i3:= c490_b2_i to c490_b2_f do
                  begin
                     fl[i3] := fl[i3] + '  XXXXX';
//                     fl.delete(i3);
                  end;

                  for i3:= 1 to lst.Count -1 do
                     fl.Insert(c490_b1_i +1, lst[i3]+ '<-- ' );

                  inc(qtRemovidos);
                  lst.Free();

                  c490_b2_i := -1;

               end;

               inc(i2);
            end;
         end;
            if i >= 7255 then
            break;
      
         inc(i);
      end;
      //   fl.SaveToFile('d:\teste.txt');
      result := Fl;

   except
   on e:exception do
   begin
      f.gravaLog(fl[i]);
      f.gravalog(i);
   end;
end;



end;


function ajRegC100(fl:Tstringlist):TstringList;
var
   i:integer;
   c12, c16:String;
begin
   for i:=0 to fl.Count - 1 do
   begin
      if (getCp(1, fl[i]) = 'C100') and (getCp(2, fl[i]) = '0') then
      begin
         c12 := getCp(12, fl[i] );
         c16 := getCp(16, fl[i] );

         fl[i] := updateCampo(fl[i], 12, c16);
         fl[i] := updateCampo(fl[i], 16, c12);
      end
      else if (getCp(1, fl[i]) = 'C400') then
         break;
   end;
   result := fl;
end;

function getIdxCpDuplo(arq:Tstringlist; idxCampo1:integer; vlCampo1:String; idxCampo2:integer; vlCampo2:String):integer;
var
   i:integer;
   res:integer;
begin
   res := -1;
   for i:=0 to arq.Count -1 do
   begin
      if (getCp(idxCampo1, arq[i]) = vlCampo1) and
         (getCp(idxCampo2, arq[i]) = vlCampo2) then
      begin
         res := i;
         break;
      end;
   end;
   result := res;
end;

function AjReg_C190_490(Fl:TStringlist): TStringlist;
var
	i, j:integer;
   v5, v6, v7, v11:real;
   idx9999, qt9999, qtC990 :integer;
   idxC490, qt490, qtRemC490:integer;
   idxC190, qt190, qtRemC190:integer;
   idxC990 :integer;
   vCampo:String;
   lstDeletados:Tstringlist;
begin
   lstDeletados:= TStringlist.create;

   f.gravaLog('Remove duplicados C190/C490');

   qtRemC490 := 0;
   qtRemC190 := 0;

   i:=7950;
   while i <= Fl.Count - 1 do
//	for i:=0 to fl.Count - 1 do
   begin
//         f.gravaLog(i);
//      if i = 7955 then
//         f.gravaLog('linha7955');

    	if (getCp(1, Fl[i]) = 'C190') or (getCp(1, Fl[i]) = 'C490') then
      begin
         vCampo := getCp(1, Fl[i]);
         j:= i+1;

         while (getCp(1, Fl[j]) = vCampo) do
         begin
            if (getCp(1, Fl[i]) = getCp(1, Fl[j])) and (getCp(2, Fl[i]) = getCp(2, Fl[j])) and(getCp(3, Fl[i]) = getCp(3, Fl[j])) then
            begin
               v5:= getVlCampo(5,Fl[i]) + getVlCampo(5,Fl[j]);

               v6:= getVlCampo(6,Fl[i]) + getVlCampo(6,Fl[j]);
               v7:= getVlCampo(7,Fl[i]) + getVlCampo(7,Fl[j]);
               v11:=getVlCampo(11,Fl[i]) + getVlCampo(11,Fl[j]);

               Fl[i] := updateCampo(Fl[i], 5, floatToStr(v5));
               Fl[i] := updateCampo(Fl[i], 6, floatToStr(v6));
               Fl[i] := updateCampo(Fl[i], 7, floatToStr(v7));
               Fl[i] := updateCampo(Fl[i],11, floatToStr(v11));


               if (getCp(1, Fl[i]) = 'C190') then inc(qtRemC190);

               if (getCp(1, Fl[i]) = 'C490') then inc(qtRemC490);

               Fl[j] := updateCampo(Fl[i], 1, 'Deletar');

               lstDeletados.Add( intToStr(j));
            end;
            inc(j);
         end;
      end;
      inc(i);
   end;

   // C990
   idxC990 := getIdxReg(FL, 'C990');
   qtC990 := getCpInt(2, Fl[idxC990]);
   qtC990 := qtC990 - (qtRemC490 + qtRemC190);
   fl[idxC990] := updateCampo(Fl[idxC990], 2, intToStr(qtC990));


   idxC490 := getIdxCpDuplo(Fl, 1, '9900', 2, 'C490');
   qt490 := getCpInt(3, Fl[idxC490]);
   Fl[idxC490] := updateCampo(Fl[idxC490], 3, intToStr( qt490 - qtRemC490));


   idxC190 := getIdxCpDuplo(Fl, 1, '9900', 2, 'C190');
   qt190 := getCpInt(3, Fl[idxC190]);
   Fl[idxC190] := updateCampo(Fl[idxC190], 3, intToStr( qt190 - qtRemC190) );


// pega o contador do reg 9999
   idx9999 := Fl.Count -1;
   qt9999 := getCpInt(2, Fl[idx9999]);

   Fl[idx9999] := updateCampo(Fl[idx9999], 2,  intToStr(qt9999-(qtRemC490 + qtRemC190)) );


   i:=0;
   while i< Fl.Count-1 do
   begin
      if (getCp(1, Fl[i]) = 'Deletar') then
      begin
         f.gravaLog(intToStr(i) + Fl[i]);
         Fl.Delete(i);
         dec(i);
      end;
      inc(i);
   end;
   result := Fl;
end;

function ajIsrefFromcdref(Fl:TStringlist): TStringlist;
var
	i, cpIsReF:integer;
   is_ref, cd_reF:String;
   hash : Thash;
begin
   f.gravaLog('Muda o identificador dos produtos...');
	hash:= Thash.Create();

	for i:=0 to  fl.Count - 1 do
   begin
    	cpIsRef := -1;

   	if ( getCp(1, Fl[i]) = '0200') then
      	cpIsRef := 2
      else if (getCp(1, Fl[i]) ='C170') then
	      cpIsRef := 3
      else if (getCp(1, Fl[i]) ='C425')then
	      cpIsRef := 2;

		if (cpIsRef <> -1) then
      begin
      	is_ref := getCp(cpIsRef, Fl[i]);
      	cd_ref := hash.getValor(intToStr(hash.indexOf(is_ref)));

         if (cd_ref = '') then
         begin
         	cd_ref := uProd.getCp('is_ref', is_ref, 'codigo');
            hash.add(is_ref, cd_ref);
         end
         else
         begin
	         f.gravaLog('Pego do hash');
         end;

         Fl[i] := updateCampo(Fl[i], cpIsRef, cd_ref );
         f.gravaLog('is_ref: ' + is_ref + ' cd_ref:' + cd_ref);
      end;
   end;
   result := Fl;

   f.gravaLog('Muda o identificador dos produtos... ok');
end;

function cpToDate(numCampo: integer; linha: String): Tdate;
var
  str:String;
begin
   str:= getCp(numCampo, linha);

   insert('/',str, 5);
   insert('/',str, 3);

   result := StrToDate(str);
end;

function somaIntervalo(fl:Tstringlist; i, count, campo:integer):real;
var
  soma:real;
begin
   soma := 0;

   for i:=i to count do
      soma := soma + getVlCampo(campo, fl[i]);

   result := soma;
end;


function updateCampoItensPisCofins(linha:String; diF:Real):String;
var
  imposto, aliquota, vlItem:real;
begin
   aliquota := getVlCampo(5, linha) / 100;

   vlItem := getVlCampo(2, linha);

   vlItem := vlItem + dif;

   linha := updateCampo(linha, 3, f.floatToStrFomatado(vlItem, true));
   linha := updateCampo(linha, 4, f.floatToStrFomatado(vlItem, true));

   imposto := vlItem * aliquota;

   linha := updateCampo(linha, 8, f.floatToStrFomatado(imposto, true));

   Result := linha;
end;

function getIdx_fim_c481_C485(fl:TstringList; tpReg:String; inicio:integer):integer;
var
   i:integer;
begin
  // retorna o index no arquivo do ultimo regstro do campo c481 ou c485
   result := -1;
   for i:= inicio to fl.Count -1 do
      if ( getCp(1, fl[i]) = tpReg) then
         Result := i
      else
         break;
end;

function getIdx_c405(fl:TstringList; idx_c400:integer; data:Tdate):integer;
var
   c405, i:integer;
   sData:String;
begin
   sData := fdt.dateToDDMMAAA(data);

   c405 := -1;
   for i:= idx_c400 to fl.Count -1 do
      if ( getCp(1, fl[i]) = 'C405') and (getCp(2, fl[i]) =  sData ) then
      begin
         c405 := i;
         break;
      end;
   result := C405;
end;

function getIdx_c400(fl:TstringList; serie:String):integer;
var
   i, lC400:integer;
begin
   { // procurar o registro c400  da impressora.}
   lC400 := -1;
   for i:=0 to fl.Count - 1 do
      if ( getCp(1, fl[i]) = 'C400') and (getCp(4, fl[i]) = serie) then
      begin
         lC400 := i;
         break;
      end;
   result := lC400;
end;

function getCp(numCampo:integer; linha:String): String;
var
   posInicio, tamanho:integer;
begin
   // retorna o conte�do do campo
   // o primeiro campo � o indice 1

   tamanho := 1;

   posInicio := getPosInicio(numCampo, linha);

   while ((tamanho+posInicio) <= length(linha)) and (copy(linha, (posInicio+tamanho), 01) <> '|' ) do
      inc(tamanho);

   result := copy(linha, posInicio+1, tamanho-1);
end;

function getC490(idxC405:integer; fl:TstringList):Tstringlist;
var
  i:integer;
  res:TStringlist;
begin
//   retorna as linhas dos registros c490 de uma impressora por dia;

   res := TStringlist.Create();
   for i:= (idxC405 +1) to fl.Count -1 do
   begin
      if (getCp(1, fl[i]) = 'C490') then
         res.Add( intToStr(i) );

      if (getCp(1, fl[i]) = 'C400') or
         (getCp(1, fl[i]) = 'C405') or
         (getCp(1, fl[i]) = 'C990') then
         break;
   end;
   result := res
end;


function getC190Nf(idxC100:integer; fl:TstringList):Tstringlist;
var
   c190:TstringList;
begin
   c190:= TstringList.Create();

   inc(idxC100);
   while (idxC100 < fl.Count-1) do
   begin
      if (getCp(1, fl[idxc100]) = 'C190') then
         c190.Add(intToStr(idxC100));

     if (getCp(1, fl[idxc100]) = 'C100') or (getCp(1, fl[idxc100]) = 'C400') then
        break;
      inc(idxC100);
   end;
   result := c190;
end;

function ajCfoItensNFEntrada(fl:TstringList):TStringList;
var
   i:integer;
   cfo:String;
begin
   f.gravaLog('ajCfoItensNFEntrada()');
   f.gravaLog('ajusta cfo de itens da nf entrada');

   for i:=0 to fl.Count - 1 do
   begin
      if ( getCp(1, fl[i]) = 'C100' ) and (getCp(2, fl[i]) = '0') then
      begin
         cfo := getCfoNf(i,fl);
         if ( cfo <> '') then
           trocaCfoItensNf(cfo, i, fl);
      end;
   end;

   result := fl;
end;

function getIdxItemMaiorValor(var fl:TstringList; idxItemIni, idxItemFim:integer; codCampo:String): integer;
var
   j, idxMaiorItem:integer;
begin
   idxMaiorItem := idxItemIni;
   for j:= idxItemIni to idxItemFim do
      if (getNumReg(fl[j]) = codCampo) then
         if (getVlCampo(5, fl[j]) >  getVlCampo(5, fl[idxMaiorItem]) ) then
            idxMaiorItem := j;

   f.gravaLog(codCampo+': ' + intToStr(idxMaiorItem +1) {indice do item de maior valor] } );
   result := idxMaiorItem;
end;


function getVlCampo(numCampo: integer; linha: String): Real;
var
  res:Real;
  aux: String;
begin
   try
      // retorna o conteudo da chave
      // os campos comecam a partir de 1
      aux := getCp(numCampo, linha);
      if (aux = '') then
      begin
         f.gravaLog('Campo Vazio, campo: ' + intToStr(numCampo) + ', linha:'+ linha);
         res := 0;
      end
      else
      begin
         res := strToFloat(aux);
      end;
   except
      res := 0;
      f.gravaLog('Campo: ' + intToStr(numCampo));
      f.gravaLog('Erro na linha:' + linha)
   end;
   result := res;
end;

function updateCampo(linha:String; idCampo: integer; novoValor: String): String;
var
   lengthLinha, posInicio:integer;
begin
{   f.gravaLog('updateCampo() linha:' + linha +#13 +
      'campo: ' + intToStr(idCampo) +   ' Valor antigo: ' +
        getCp(idCampo, linha) +  '         Novo valor: '+ novoValor);
}
   posInicio := getPosInicio(idCampo, linha)+1;
   lengthLinha := length(linha);

   while  (copy(linha, posInicio, 01) <> '|') and (posInicio <= lengthLinha   )  do
      delete(linha, posInicio, 01);

   insert(novoValor, linha, posInicio);

   result := linha;
end;

function ajustaValoresReducao_pisCofins(ds: TdataSet; Fl:TStringlist):TStringlist;
var
  lC400, lC405:integer;

  c481i, c481f, cDif481:integer;
  c485i, c485f, cDif485:integer;

  dif, vlMaiorItem, difVlCont, vlAux:real;
begin
   c481i := -1;
   c481f := -1;

   f.gravaLog('ajustaValoresReducao_pisCofins()' + ds.fieldByName('dt_mov').asString);
   f.gravalog('Loja:' + ds.FieldByName('ds_uo').AsString +
           ' EcF:' + ds.FieldByName('nr_ecf').AsString +
           ' S�rie:' + ds.FieldByName('ser_fab').AsString
   );

// pegando o registro inicial da impressora
   lC400 := getIdx_c400(fl, ds.fieldByName('ser_fab').AsString);

   if (lC400 > -1) then
   begin
      // pegando os dados da redu��o, por dia
      lC405 := getIdx_c405(fl, lC400, ds.fieldByName('dt_mov').AsDateTime);

      if (lC405 > -1) then
      begin
         // pegar os indices inicio e fim do c481 e c485;
         if (getCp(1, fl[lC405+1]) = 'C481') then
         begin
            c481i := lC405 + 1;
            c481f := getIdx_fim_c481_C485(fl,'C481', c481i);
         end
         else
            c481i := -1;

         if (getCp(1, fl[c481f+1]) = 'C485') then
         begin
            c485i := c481f +1;
            c485f := getIdx_fim_c481_C485(fl,'C485', c485i);
         end
         else
           c485i := -1;

         // calcule a diferenca entre o informado na reducao e o obtido
         dif := ds.fieldByName('vl_contabil').AsFloat - getVlCampo(7, fl[lc405]);

         if (dif > 0) then
         begin
             f.gravalog('Diferen�a:' + floatToStrFomatado(dif, false) );

            if (c481i > -1) and (c485i >-1) then
            begin
               // definir qual o item de maior valor no dia para ajustar na diferenca
               cDif481 :=  getIdxItemMaiorValor(fl, c481i, c481f, 'C481');

               cDif485 :=  getIdxItemMaiorValor(fl, c485i, c485f, 'C485');

               // atualiza o valor do  c405
               vlAux := dif + getVlCampo(7, fl[lc405]);
               fl[lC405] := updateCampo(fl[lC405], 7, f.FloatToStrFomatado(vlAux, true));

               // atualiza o valor do maior item c481
               fl[cDif481] := updateCampoItensPisCofins(fl[cDif481], dif);

               fl[cDif485] := updateCampoItensPisCofins(fl[cDif485], dif);
            end
            else
               f.gravaLog('Erro: ');
               f.gravaLog('N�o achei o registro C481, C485 para o C405');
               f.gravaLog('');
         end;
      end
      else
         msg.msgErro('Nao achei o C405 da impressora:'  +#13+
            'Data: ' + ds.fieldByName('ds_uo').AsString +#13+
            'Loja: ' + ds.fieldByName('ds_uo').AsString +#13+
            'EcF: ' + ds.fieldByName('nr_ecf').AsString + ' S�rie: ' + ds.fieldByName('ser_fab').AsString
         );
   end
   else
      msg.msgErro('Nao achei o C400 da impressora:'  +#13+
         'Data: ' + ds.fieldByName('dt_mov').AsString +#13+
         'Loja: ' + ds.fieldByName('ds_uo').AsString +#13+
         'EcF: ' + ds.fieldByName('nr_ecf').AsString + ' S�rie: ' + ds.fieldByName('ser_fab').AsString
      );
   result := fl;
end;


function ajustaValoresReducao(ds: TdataSet; fl:TstringList):TStringlist;
var
  lC400, lC405, lC420, lC425, lC425Inicio, lC425Fim, lC490, i, j:integer;
  dif, vlMaiorItem, difC425, difC490:real;
begin
   lC425 := 0;
   lC425Inicio := 0;
   lC425Fim := 0;
   i:=0;

   f.gravaLog('');
   f.gravaLog('Buscando ECF '+ ds.FieldByName('nr_ECF').AsString  +' serie: '+ ds.FieldByName('ser_fab').AsString);

{   // procurar o registro c400  da impressora.}
   lC400 := 0;
   for i:=0 to fl.Count - 1 do
      if ( getCp(1, fl[i]) = 'C400') and (getCp(4, fl[i]) = ds.FieldByName('ser_fab').AsString ) then
      begin
         lC400 := i;
         break;
      end;

   // definir o numero da linha do registro c405 do dia
   lC405 := 0;
   if (lC400 > 0) then
      for i:= lC400 +1 to fl.Count - 1 do
         if (getCp(2, fl[i]) = f.SohNumeros(ds.FieldByName('dt_mov').AsString) ) then
         begin
            lC405 := i;
            break;
         end
         else if (getCp(1, fl[i]) = 'C400') then
         begin
           f.gravaLog('Nao achei C405 do ecF:' + ds.FieldByName('nr_ECF').AsString);
           break;
         end;

         // definir a linha do registro c420 tributado
   lC420 := 0;
   for i:= lC405 to fl.Count - 1 do
      if ( getCp(1, fl[i]) = 'C420') and ( getCp(2, fl[i]) = '01T1700' ) then
      begin
         lC420 := i;
         break;
      end;

   if (lC400 <> 0)  and (lC405 <> 0) then
   begin
      f.gravaLog('C400: '+ intToStr(lC400 +1));
      f.gravaLog('C405: '+ intToStr(lC405 +1));
      f.gravaLog('C420: '+ intToStr(lC420 +1));

      // ajusta a marca da impressora
      fl[lC400] := updateCampo(fl[lC400], 3, 'Daruma' );


      if (getVlCampo(7, fl[lC405]) <> ds.FieldByName('vl_contabil').AsFloat ) then
      begin
         dif := getVlCampo(7, fl[lC405]) - ds.FieldByName('vl_contabil').AsFloat ;


         f.gravaLog(' ECF: ' + ds.FieldByName('nr_ecf').AsString  + ' Corrigir.' );

         f.gravaLog('divergencia do valor da venda para a redu��o, Valor no Arquivo:' + getCp(7, fl[lC405]) +  ' vl_contabil:' + ds.FieldByName('vl_contabil').AsString);

         // definir o indice inicial do c425
         for j:= lC420 to fl.Count -1 do
            if getCp(1, fl[j]) = 'C425' then
            begin
               lC425Inicio := j;
               break;
            end;

         // definir o indice final do c425
         for j:= lC425Inicio to fl.Count -1 do
            if (getCp(1, fl[j]) = 'C425') and (getCp(1, fl[j+1]) = 'C490')  then
            begin
               lC425Fim := j;
               break;
            end;
         f.gravaLog('Itens C425: '+ intToStr(lC425Inicio+1) + ':'+ intToStr(lC425Fim +1) );


         // pegar o item com maior valor agregado
         lC425 := getIdxItemMaiorValor(fl, lC425Inicio, lC425Fim, 'C425');

         lC490 := lC425Fim +1;

         f.gravaLog('C490: ' + intToStr(lC490 +1));


         fl[lC405] :=  updateCampo(fl[lC405], 7,  ds.FieldByName('vl_contabil').AsString );

         // pegar a diferenca no valor contabil para ratear nos itens
         difC425 := 0;
         difC425 := ds.FieldByName('base').AsFloat - getVlCampo( 3, fl[lC420]);


         // atualiza o campo do item

        if (getVlCampo(7, fl[lC405]) < ds.FieldByName('vl_contabil').AsFloat ) then
        begin
           // se o valor da reducao for maior que o do sistema

           // adicione a diferenca ao item com maior valor agregado
           difC425 :=  difC425 +   getVlCampo( 5, fl[lC425]);

           f.gravaLog('Atualizar o valor do item: de:' + getCp(5, fl[lc425]) + ' para:'+ f.FloatToStrFomatado(difC425, true)   );
           fl[lC425] := updateCampo( fl[lC425], 5,  f.FloatToStrFomatado(difC425, true) );
        end
        else
        begin
            f.gravaLog('Valor venda maior que a redu��o, diferen�a de : ' + floatToStr(dif)  );

            diminuiVlItens( fl, lC425Inicio, lC425Fim, 0, dif );
        end;

         // atualiza o campo  c420
         fl[lC420] := updateCampo(fl[lC420], 3, ds.FieldByName('Base').AsString );

         // atualiza o campo c490
         difC490 := ds.FieldByName('Base').AsFloat;

         fl[lC490] := updateCampo(fl[lC490], 5, f.FloatToStrFomatado(difC490, true) );
         fl[lC490] := updateCampo(fl[lC490], 6, f.FloatToStrFomatado(difC490, true) );
         fl[lC490] := updateCampo(fl[lC490], 7, f.FloatToStrFomatado(difC490 * 0.17, true) );
      end;

   end
   else
      f.gravaLog('N�o achei os registros ' +  ds.FieldByName('ser_fab').AsString + ' de: '+ ds.FieldByName('dt_mov').AsString);

   result := fl;
end;

function ajustaValoresECF_PisCofins(fl:TstringList; ajustaDia:boolean; data:Tdate; ecf:String):TStringlist;
var
   di, dF:Tdate;
   ds:TdataSet;
   serieECF:String;
begin
   try
      if (ajustaDia = true) then
      begin
         di:= data;
         dF:= data;
      end
      else
      begin
         di:=  fdt.dataDDMMAAAtoDate( getCp(6, fl[0]) );
         dF:=  fdt.dataDDMMAAAtoDate( getCp(7, fl[0]) );
      end;

      if (ECF <> '') then
        serieECF := eCF;

      f.gravaLog('Dados do arquivo:' +#13+ dateToStr(di) + '  ' + dateToStr(df) );

      while (di <= df) do
      begin
         // lista as reducoes
         ds:= uFiscal.getDadosReducao('', di, di, serieECF, 'PFM');
         f.gravaLog(' Data: ' + DateToStr(di));
         f.gravaLog('-------------------------------------------------------------------');
         f.gravaLog('');
         f.gravaLog('');

         if (ds.IsEmpty = false) then
         begin
            ds.First();
            while ( ds.Eof = false ) do
            begin

               fl:= ajustaValoresReducao_pisCofins(ds, fl);
               ds.Next();
            end;
         end;
         ds.free();
         di := di+1;

         f.gravaLog('-------------------------------------------------------------------');
      end;
      result := fl;
   except
      on e:Exception do
      begin
         msg.msgErro('Erro em ajustaValoresECF() na linha');
         result := fl;
      end;
  end;
end;


function ajustaValoresECF(fl:TstringList;cbAjustaDia:boolean; data:Tdate; ecf:String):TStringlist;
var
   di, dF:Tdate;
   ds:TdataSet;
   uo, serieECF:String;
begin
   try
      f.gravaLog('ajustaValoresECF()' + #13);
      f.gravaLog('ajustaValoresECF()' + #13);

      uo := uLj.getIsUoFromCGF(getCp(10, fl[0]) );

      if (cbAjustaDia = true) then
      begin
         di:= data;
         dF:= data;
      end
      else
      begin
         di:=  fdt.dataDDMMAAAtoDate( getCp(4, fl[0]) );
         dF:=  fdt.dataDDMMAAAtoDate( getCp(5, fl[0]) );
      end;

      if (ECF <> '') then
        serieECF := ECF;

      f.gravaLog('Dados do arquivo, is_uo:' + uo +#13+ getCp(4, fl[0]) + '  ' + getCp(5, fl[0]));

      while (di <= df) do
      begin
         // lista as reducoes
         ds:= uFiscal.getDadosReducao(uo, di, di, serieECF);

         f.gravaLog('Dia: ' +dateToStr(di));
         f.gravaLog('-------------------------------------------------------------------');

         if (ds.IsEmpty = false) then
         begin
            f.gravaLog('Dia: ' +ds.FieldByName('dt_mov').AsString);

            ds.First();
            while ( ds.Eof = false ) do
            begin
               Fl:= ajustaValoresReducao(ds, fl);
               ds.Next();
            end;
         end;
         ds.free();
         di := di+1;
      end;
      result := fl;
   except
      on e:Exception do
      begin
         msg.msgErro('Erro em ajustaValoresECF() na linha');
         result := fl;
      end;
  end;
end;


function getIsRef(linha: String): String;
begin
   if ( getNumReg(linha) = 'C170')  then
      result := getCp(3, linha)
   else if (getNumReg(linha) = 'C425') or (getNumReg(linha) = 'H010')  then
      result := getCp(2, linha)
   else
      result := '';
end;

function getNumNota(str: String): integer;
begin
   if (getCp(8, str) <> '') then
      result := strToInt( getCp(8, str) )
   else
      result := 0;
end;

function getItensFaturados(arq: TstringList): TStringList;
var
   prodNotas :TStringList;
   i:integer;
   item:String;
begin //
   prodNotas := TStringList.Create();
   for i:=0 to arq.Count -1 do
   begin
      item := getIsRef(arq[i]);
      if (item <> '') then
         if ( prodNotas.IndexOf(item) = -1) then
            prodNotas.Add(item);
//      end;
   end;
   prodNotas.SaveToFile('c:\produtos.txt');
   result := prodNotas;
end;

function getPosInicio(idCampo:integer; linha:String):integer;
var
  campoAtual, posInicio:integer;
begin
   posInicio := 0;
   campoAtual := 1;
   while ( (posInicio <= Length(linha)) and (campoAtual <= idCampo) ) do
   begin
      inc(posInicio);
      if copy(linha, posInicio,01) = '|' then
         inc(campoAtual);
   end;
   result := posInicio;
end;

function getIndexReg(arq: TStringList; idRegistro: String; idxI, idxF:integer): integer;
var
   idx, i:integer;
begin
  // retorna o numero da linha de um registro.
   idx := -1;
   for i:=idxI to idxF do
      if  ( getNumReg(arq[i]) = idRegistro) then
      begin
         idx := i;
         break;
      end;
   result := idx;
end;

function getIdxReg(arq: TStringList; idRegistro: String): integer;
begin
   result := getIndexReg(arq, idRegistro, 0, arq.Count-1);
end;

function updateCampoArq(var arq:TStringlist; idRegistro:String; idCampo:integer; novoValor:String):boolean;
var
  i:integer;
begin
   f.gravaLog('Atualizando registro '  + idRegistro +' campo: ' + IntToStr(idCampo) );

   if length(idRegistro) = 4 then
   begin
      for i:=0 to arq.Count-1 do
         if ( getNumReg(arq[i]) = idRegistro ) then
            arq[i] :=   updateCampo(arq[i], idCampo, novoValor);
   end
   else
   begin
      for i:=0 to arq.Count-1 do
         if ( getNumRegDuplo(arq[i]) = idRegistro ) then
            arq[i] :=   updateCampo(arq[i], idCampo, novoValor);
   end;
   result := true;
end;

function getNumRegDuplo(linha:String):String;
begin
   result := copy(linha, 02, 09 );
end;

function getNumReg(linha:String):String;
begin
   result := copy(linha, 02, 04 );
end;

function getCpInt(indice: integer; str: String): integer;
begin
   result := strToInt(getCp(indice, str));
end;

procedure Log(str: String);
begin
   f.gravaLog(str);
   f.gravaLog(str);
end;








function getItensReg0200(arq:TStringList): TStringList;
var
   itens:Tstringlist;
   i:integer;
begin
   itens := TStringlist.create();
   for i := 0 to arq.Count -1 do
      if  ( getNumReg(arq[i]) = '0200') then
         itens.Add( getCp(2, arq[i]) );
   itens.SaveToFile('c:\itensReg200.txt');
   result := itens;
end;



function getCfoNf(idx: integer; fl:TstringList): String;
  var
     i:integer;
begin

  for i:= idx +1 to fl.Count-1 do
  begin
     if ( getCp(1,fl[i]) = 'C100') then
     begin
        result :=  '';
        break;
     end;

     if ( getCp(1,fl[i]) = 'C190') then
     begin
        result := getCp(3, fl[i]);
        break;
     end;

  end;
end;


function ajValorTotalNfEnt(fl:TstringList):TStringList;
var
   idOpr, i, i2:integer;
   vlOp, vlIPI, vlProd, vlNota, vlDesc:real;
   c170I, c170f:integer;
   idx190, c190f:integer;
   vCfoCst: THash3f;
begin
// Ajusta o valor total da nota de entrada acertando o valor total da nota para  (valor produtos + ipi - desconto);

   f.gravaLog('ajValorTotalNfEnt()');
   f.gravaLog('ajusta Totais de NF de entrada');

   for i:=0 to fl.Count - 1 do
   begin
      if (getCp(1, fl[i]) = 'C100' )and( getCp(2, fl[i]) = '0')and(getCp(3, fl[i])='1')then
      begin
         f.gravaLog(getCp(8, fl[i]));

// definir onde comeca e onde termina os registros C170
         if (getCp(1, fl[i+1]) = 'C170') then
         begin
            c170I := i+1;
            c170f := i+1;
         end;

         while (getCp(1, fl[c170f+1]) = 'C170') do
            inc(c170f);

         f.gravaLog('linhas c17o inicio e fim');
         f.gravaLog(c170I);
         f.gravaLog(c170f);

         vCfoCst := THash3f.Create();

         for i2:= c170I to c170f do
         begin
            vlIPI :=getVlCampo(24, fl[i2]);
            vlOp := getVlCampo(7, fl[i2]) - getVlCampo(8, fl[i2]) + vlIPI;


            idOpr := vCfoCst.indexOf( getCp(10, fl[i2]), getCp(11, fl[i2])   );

            if idOpr < 0 then
               vCfoCst.add(getCp(10, fl[i2]), getCp(11, fl[i2]), vlOp)
            else
               vCfoCst.somaAoValor(idOpr, vlOp, vlIPI);
         end;
//       07 - 08 + 24
         vCfoCst.saveParams();

         // ajustar
         i2:= c170f +1;
         while (getCp(1, fl[i2]) = 'C190') do
         begin
            idx190 := vCfoCst.indexOf( getCp(2, fl[i2]), getCp(3, fl[i2]));

            if (idx190 >= 0) then
            begin
               vCfoCst.getValor(idx190, vlOp, vlIPI);

               fl[i2] := updateCampo(fl[i2],  5, f.FloatToStrFomatado(vlOp, true));
               fl[i2] := updateCampo(fl[i2], 11, f.FloatToStrFomatado(vlIPI, true));
            end;
            inc(i2);
         end;


      end; // teste c100
   end;
     result := fl;
end;

function ajVlTotTribEcf(Fl:TStringlist): TStringList;
var
   i:integer;
begin

   for i:= 1 to fl.Count -1 do
   begin
     if (getCp(1, fl[i])= 'C405') then
     begin
       f.gravaLog('');
       f.gravaLog(fl[i]);
       f.gravaLog(getC490(i, fl)   );
     end;

     if (getCp(1, fl[i])= 'C990') then
        break;

     result := fl;
   end;
end;

function getIdxC490_cfo():integer;
begin
{   idxErr := -1;
   for i:= idxI to idxF  do
      if getCp(1, fl[i]) = 'C490') and getCp(2, fl[i]) = '5403');
      begin
         idxErr := i;
      end;
}
end;

procedure trocaCfoItensNf(cfoNovo:String; idx:integer; var fl:TstringList);
var
  i:integer;
begin
   inc(idx);
   while ( idx <= fl.Count-1) do
   begin
      if(getCp(1, fl[idx]) = 'C170') then
      begin
        fl[idx] := updateCampo(fl[idx], 11, cfoNovo );
//        memo.Lines.Add(intToStr(idx));
//        memo.Lines.Add(fl[idx] ) ;
      end;


      if (getCp(1, fl[idx]) = 'C100') or (getCp(1, fl[idx]) = 'C190') or (getCp(1, fl[idx]) = 'C400') then
           break;

      inc(idx);
   end;
end;


procedure diminuiVlItens(var fl:TstringList; idxItemIni, idxItemFim, idxItemMaisCaro:integer; vlExcesso:real);
var
   is_reF:String;
   quant, vlCusto:real;
begin
   while (vlExcesso > 0) do
   begin
      f.gravaLog('Excesso a remover dos itens:' + floatToStr(vlExcesso) );

      is_ref := getCp(2, fl[idxItemIni]);

      vlCusto := strToFloat( uPreco.getPcProd(fmMain.getUOCD(), '', is_ref, '1'));
      vlCusto := vlCusto * 1.1;

      quant :=  strToFloat( getCp(3, fl[idxItemIni]));

      vlCusto := vlCusto * quant;

      if (vlExcesso > vlCusto) then
      begin
         fl[idxItemIni] :=  updateCampo(fl[idxItemIni], 05,  f.floatToStrFomatado(vlCusto, true));
         vlExcesso := vlExcesso - vlCusto;

         inc(idxItemIni);
      end
      else
      begin
         fl[idxItemIni] :=  updateCampo(fl[idxItemIni], 05,  f.floatToStrFomatado(({vlCusto - }vlExcesso), true));
         f.gravaLog('Justei :' + f.floatToStrFomatado(({vlCusto - }vlExcesso), true)) ;
         vlExcesso := 0;
      end;
   end;
end;

function getDados(dsDados, dsParam:TdataSet; avancaReg:boolean ):TStringList;
var
   a:Tstringlist;
   aux:String;
   i:integer;
   continua:boolean;
begin
   screen.Cursor := crHourglass;
   try
//      f.gravaLog('function getDados(dsDados, dsParam:TdataSet ):TStringList;');
//      f.gravaLog(dsParam, 'parametros');
//      f.gravaLog(dsDados,'Dados');

      a:= TStringlist.create();

      if (avancaReg = true) then
         dsDados.First();


      continua := false;
      while( continua = false )do
      begin
         aux := '';
         dsParam.first();
         while (dsParam.eof = false) do
         begin
            if trim(dsParam.fieldByName('vlDefault').asString) <> '' then
               aux := aux + '|' + dsParam.fieldByName('vlDefault').asString
            else
            begin
               if       ( dsParam.fieldByName('tpFormato').asString = '$') then  // � um  $
                  aux := aux + '|' +  trim(f.valorSql(dsDados.fieldByName(dsParam.fieldByName('vl').asString).AsString))
               else if  ( dsParam.fieldByName('tpFormato').asString = '@') then// � um @
                  aux := aux + '|' +  trim(remCaracTotvs(dsDados.fieldByName(dsParam.fieldByName('vl').asString).AsString))
               else if  ( dsParam.fieldByName('tpFormato').asString = '*') then// � um @
                  aux := aux + '|' +  ''
               else if  ( dsParam.fieldByName('tpFormato').asString = 'M') then  // � um  $
                  aux := aux + '|' + f.floatToStrFomatado (dsDados.fieldByName(dsParam.fieldByName('vl').asString).asFloat, true)
               else
                  aux := aux + '|' + trim(dsDados.fieldByName(dsParam.fieldByName('vl').asString).AsString);
            end;
            dsParam.Next();
         end;

         aux := aux + '|';

         a.Add(aux);

         if (avancaReg = false) then
            Break
         else
         begin
            dsDados.Next();
            continua := dsDados.Eof;
         end;
      end;
   except
      on e:exception do
      begin
         f.gravaLog('linha: ' + intToStr(dsDados.RecNo));
         f.gravaLog('linha: ' + intToStr(dsDados.RecNo));
         f.gravaLog('aux:'  + aux);
         f.gravaLog('Param' + intToStr(dsParam.RecNo) );
         f.gravaLog('Erro: '+ e.Message  );

      end;
   end;
{   f.gravaLog('Resultado-----------');
   f.gravaLog(a);
}   result := a;
end;

function getDados(dsDados, dsParam:TdataSet; avancaReg:boolean; condicao:boolean ):TStringList; overload;
begin
   if (condicao = true) then
      result := getDados(dsDados, dsParam, avancaReg)
   else
      result := nil;
end;

function contarRegistro(fl: Tstringlist; idxCampo: integer; valor: String): integer;
var
   i:integer;
   contador:integer;
begin
   contador:= 0 ;
   for i:=0 to fl.Count -1 do
      if (rSped.getCp(1, fl[i]) = valor) then
         inc(contador);
   result := contador;
end;

function contarRegistroBloco(fl: Tstringlist; valor: String): integer;
var
   i:integer;
   contador:integer;
begin
   contador:= 0 ;
   for i:=0 to fl.Count -1 do
      if ( copy(rSped.getCp(1, fl[i]), 1, 1) = valor) then
         inc(contador);
   result := contador;
end;

end.

