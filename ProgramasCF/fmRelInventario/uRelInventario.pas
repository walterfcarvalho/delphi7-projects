unit uRelInventario;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, fCtrls, db, ADOdb, mxExport, adLabelEdit,
  Grids, DBGrids, uDm, SoftDBGrid, adLabelComboBox;

type
  TfmRelInventario = class(TForm)
    tbItens: TADOTable;
    tbNmArquivos: TADOTable;
    tbDirvg: TADOTable;
    Memo1: TMemo;
    Button1: TButton;
    GroupBox1: TGroupBox;
    fsBitBtn1: TfsBitBtn;
    fsBitBtn2: TfsBitBtn;
    GroupBox2: TGroupBox;
    btCarregaContagem: TfsBitBtn;
    btCalculaDivergencia: TfsBitBtn;
    cbExporta: TfsCheckBox;
    cbExportaWell: TfsCheckBox;
    GroupBox3: TGroupBox;
    fsBitBtn3: TfsBitBtn;
    edQtDigDesc: TadLabelEdit;
    tbErr: TADOTable;
    DataSource1: TDataSource;
    tb_dirvg2: TADOTable;
    gridDirv: TSoftDBGrid;
    edFxCodigo: TadLabelEdit;
    Button2: TButton;
    edCdUo: TadLabelEdit;
    GroupBox4: TGroupBox;
    fsBitBtn4: TfsBitBtn;
    cbLoja: TadLabelComboBox;
    procedure btCarregaContagemClick(Sender: TObject);
    procedure relatorioContagem(arquivos:TStrings);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

    procedure carregaTbInventario(tbIt:TADOTable; arquivos:TStrings; apagaAnterior:boolean; tbMsgErr:TADOTable);

    procedure btCalculaDivergenciaClick(Sender: TObject);
    procedure calculaDivergencia(nmCont1, nmCont2:String; tb, tbNmArquivos, tbDirvg:TADOTAble);
    procedure adicionaDivergencia(tipo, codigo, descricao, endereco, quant, pallet, msg, segundoValor:String);
    procedure exportaContagemWell(tableName:String);
    procedure Button1Click(Sender: TObject);
    procedure montaScriptWMS(arq:String);
    function tiraTraco(str:String):String;
    procedure fsBitBtn1Click(Sender: TObject);
    procedure juntarContagens(arquivos:TStrings);
    procedure fsBitBtn2Click(Sender: TObject);
    procedure fsBitBtn3Click(Sender: TObject);
    procedure loadTablesContDiverg(arquivos:TStrings; tb1, tb2:TADOtable);
    procedure insFirstCont(nomeCont:String);
    procedure insereSegContagem(tb_seg, tb_Dirv2:TADOTable);
    procedure insereItemTbdirv(nomeCont, desc, cod, qt1, qt2, linha:String);
    procedure carregaTbRel();
    procedure insereMsgErros();
    procedure addErro(err:String; tbErr:TADOTable);

    procedure geraTbDirvegencia(arquivos:TStrings; a:String = 'nada');
    procedure gridDirvCellClick(Column: TColumn);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fsBitBtn4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fmRelInventario: TfmRelInventario;

implementation

uses uMain, f, funcSQL, uCF, uEstoque, msg, uProd, uLj;

{$R *.dfm}

procedure TfmRelInventario.Button2Click(Sender: TObject);
var
  contDep, contLj:TSTrings;
  cmd, t1, t2:String;
  ds: tdataset;
begin
// n�o sei para que essa porra serve n�o

   contDep := f.dialogAbrVariosArq('txt','c:\');

   contLj := f.dialogAbrVariosArq('txt','c:\');

   carregaTbInventario(tbItens, contDep, true, tbErr);
   t1:= tbItens.TableName;

   carregaTbInventario(tbNmArquivos, contLj, true, tbErr);
   t2 := tbNmArquivos.TableName;

   cmd :=
   ' select t1.is_ref, t1.codigo, t1.descricao, sum(t1.qt) as qt from ' + t1 + ' t1'+
   ' left outer join ' + t2 + ' t2 on t1.codigo = t2.codigo' +
   ' group by t1.is_ref, t1.codigo, t1.descricao' +
   ' order by t1.codigo';

   ds:= dm.getDataSetQ(cmd);

   fmMain.imprimeRave(ds, tbNmArquivos, nil, nil, nil, 'rpInvContagem', nil );
end;


procedure TfmRelInventario.insereMsgErros();
begin
   f.gravaLog('insereMsgErros()');
   tb_dirvg2.First();

   while ( tb_dirvg2.Eof = false) do
   begin
      if (tb_dirvg2.FieldByName('q1').AsInteger <> 0) and (tb_dirvg2.FieldByName('q2').AsInteger = 0) then
      begin
         tb_dirvg2.edit();
         tb_dirvg2.FieldByName('msgErro').AsString := '(' +  tb_dirvg2.fieldByName('linha').asString +')'+'C1: ' + tb_dirvg2.FieldByName('q1').AsString + ', Falta 2� cont';
         tb_dirvg2.post();
      end
      else
      if (tb_dirvg2.FieldByName('q1').AsInteger = 0) and (tb_dirvg2.FieldByName('q2').AsInteger <> 0) then
      begin
         tb_dirvg2.edit();
         tb_dirvg2.FieldByName('msgErro').AsString :='(' +  tb_dirvg2.fieldByName('linha').asString +')'+ 'C2: ' + tb_dirvg2.FieldByName('q2').AsString + ', Falta 1� cont';
         tb_dirvg2.post();
      end
      else
      if (tb_dirvg2.FieldByName('q1').AsInteger <> tb_dirvg2.FieldByName('q2').AsInteger) then
      begin
         tb_dirvg2.edit();
         tb_dirvg2.FieldByName('msgErro').AsString := '(' +  tb_dirvg2.fieldByName('linha').asString +')'+
            'Qt divert, C1:' + tb_dirvg2.FieldByName('q1').AsString +
            ' C2: ' + tb_dirvg2.FieldByName('q2').AsString;
         tb_dirvg2.Post();
      end;


      tb_dirvg2.Next();
   end;
end;

procedure TfmRelInventario.carregaTbRel();
begin
   carregaTbInventario(tbDirvg, nil, true, tbErr);
   tb_dirvg2.First();
   while ( tb_dirvg2.Eof = false) do
   begin
      if (tb_dirvg2.FieldByName('flagOk').AsBoolean = false) then
         tbDirvg.AppendRecord([
            tb_dirvg2.fieldByName('cd_ref').asString,
            tb_dirvg2.fieldByName('ds_ref').asString,
            '',
            tb_dirvg2.fieldByName('q1').asString,
            '',
            '',
            '',
            '',
            tb_dirvg2.fieldByName('msgErro').asString,
            '',
            ''
         ]);

      tb_dirvg2.Next();
   end;

end;

procedure TfmRelInventario.loadTablesContDiverg(arquivos:TStrings; tb1, tb2:TADOtable);
var
   aux:TStringList;
begin
    aux := TStringList.create();

    aux.Add(arquivos[0]);
    carregaTbInventario(tb1, aux, true, tbErr);
    f.gravaLog('carreguei  a primeira, arquivo:' + arquivos[0]);

    aux.Clear();

    aux.Add(arquivos[1]);
    carregaTbInventario(tb2, aux, true, tbErr);
    f.gravaLog('carreguei  a segunda, arquivo:' + arquivos[1]);

    aux.Destroy();
end;

procedure marcaDivergente(tb:TADOTable; campo:String);
begin
   tb.Edit();
   tb.FieldByName(campo).asString := 'x';
   tb.post();
end;

procedure TfmRelInventario.addErro(err:String; tbErr:TADOTable);
begin
   Memo1.Lines.Add(err);
   tbErr.AppendRecord([err]);
end;

procedure TfmRelInventario.carregaTbInventario(tbIt: TADOTable; arquivos: TStrings; apagaAnterior:boolean; tbMsgErr:TADOTable);
var
   lst:TStringList;
   j,i:integer;
   dsItem:TDataSet;

   EAN_POS_INI:integer; // = 1;
   EAN_TAM:integer; // = 1; = 13;

   QT_POS_INI :integer; // = 1;= 15;
   QT_TAM :integer; // = 1;= 06;

   END_POS_INI :integer; // = 1;=22;
   END_TAM:integer; // = 1; = 12;

   PALETE_POS_INI:integer; // = 1; = 35;
   PALETE_TAM:integer; // = 1; = 4;
   qt:String;
begin
   f.gravaLog('carregaTbInventario()'  );

   if (tbIt.TableName <> '') then
     tbIt.close();

   dm.getTable(tbIt, dm.getCMD('Estoque', 'getCamposTbInvent'));
   dm.getTable(tbMsgErr, dm.getCMD('Estoque', 'getTbErrIven'));


   if (arquivos <> nil) then
   for j:=0 to arquivos.count-1 do
   begin

      if ( fileExists(arquivos[j]) = true ) then
      begin
         memo1.lines.add( intToStr(j+1) +' de '+ intToStr(arquivos.Count) +' ' + arquivos[j]);
         f.gravaLog( intToStr(j+1) +' de '+ intToStr(arquivos.Count) +' ' + arquivos[j]);

         memo1.Refresh();
         fmRelInventario.Refresh();

         lst := TStringList.create();
         lst.LoadFromFile(arquivos[j]);

         // definir que Layout � de arquivo novo ou antigo
         if length(lst[0]) < 50 then
         begin
            EAN_POS_INI:= 1;
            EAN_TAM:= 13;
            QT_POS_INI:= 15;
            QT_TAM := 06;
            END_POS_INI:= 22;
            END_TAM:= 12;
            PALETE_POS_INI:= 35;
            PALETE_TAM:= 4;
         end
         else
         begin
            EAN_POS_INI:= 1;
            EAN_TAM:= 13;
            QT_POS_INI:= 102;
            QT_TAM := 7;
            END_POS_INI:= 22;
            END_TAM:= 12;
            PALETE_POS_INI:= 35;
            PALETE_TAM:= 4;
         end;

         for i:=0 to lst.Count -1 do
         begin
            fmMain.msgStatus('item '+ intToStr(i+1) + ' de ' + intTostr(lst.count) );

            if  (copy( lst[i], QT_POS_INI, QT_TAM) <> '000000')  then
            begin
               // analisa a linha da contagem para identificaro ocodigo
               dsItem :=  uEstoque.getDadosProdFromArqInv(lst[i], EAN_POS_INI, EAN_TAM);

               if ( dsItem.IsEmpty = false) then
               begin
                  qt := copy( lst[i], QT_POS_INI, QT_TAM);
                  tbIt.AppendRecord([ dsItem.fieldByName('codigo').asString,dsItem.fieldByName('descricao').asString, copy( lst[i], END_POS_INI, END_TAM), qt, copy( lst[i], PALETE_POS_INI, PALETE_TAM), '', '', '', '', dsItem.fieldByName('ean').asString, dsItem.fieldByName('is_ref').asString, intToStr(i+1)])
               end
               else
                  addErro('N�o encontrado: ' +  lst[i] +' '+ arquivos[j] + ' item:'+ intToStr(i+1) + ' linha:'+ lst[i] , tbMsgErr);
               dsItem.Free();
            end
            else
               addErro('Qt Zero: ' +  lst[i] + arquivos[j] + ' linha:'+ intToStr(i), tbMsgErr);
         end;
      end;
   end;
//   f.gravaLog(tbIt, 'itens');
   fmMain.msgStatus('');
end;

procedure TfmRelInventario.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
    fmRelInventario := nil;
    action := caFree;
end;

procedure TfmRelInventario.calculaDivergencia(nmCont1, nmCont2:String; tb, tbNmArquivos, tbDirvg: TADOTAble);
var
   ds:TDataSet;
   cmd:String;
   nRecNo:integer;
begin
   fmMain.msgStatus('Calculando divergencias...');
   nRecNo := 1;
    tb.first();
    while (tb.eof = false) do
    begin
       inc(nRecNo);
       if (tb.FieldByName('isDirvg').asString = 'x') then
       begin
           tb.next();
           continue;
       end;

       cmd := 'select * from '+ tbNmArquivos.TableName +' where  codigo = ' + quotedStr(tb.fieldByName('codigo').AsString) + ' and endereco = ' + quotedStr(tb.fieldByName('endereco').AsString);
       ds:= dm.getDataSetQ(cmd);

       if (ds.IsEmpty = true) then
       begin
          adicionaDivergencia( 'endereco', tb.FieldByName('ean').AsString, tb.FieldByName('descricao').AsString, tb.FieldByName('endereco').AsString, tb.FieldByName('qt').AsString, tb.FieldByName('pallet').AsString, '('+ tb.fieldByName('linha').AsString +') '+ 'Item de '+ nmCont1 + ', falta a outra contagem   ', '');
       end
       else
       begin
          if (tb.FieldByName('pallet').AsString <> ds.FieldByName('pallet').AsString) then
          begin
             adicionaDivergencia( 'pallet',tb.FieldByName('ean').AsString,tb.FieldByName('descricao').AsString,tb.FieldByName('endereco').AsString,tb.FieldByName('qt').AsString,tb.FieldByName('pallet').AsString,intToStr(nRecNo)+')'+'Pallet divergente, ' + nmCont1 +' '+tb.FieldByName('pallet').AsString, nmCont2 +' '+ tb.FieldByName('pallet').AsString );
          end;

          if (tb.FieldByName('qt').AsString <> ds.FieldByName('qt').AsString) then
          begin
             adicionaDivergencia( 'qt',
                                  tb.FieldByName('ean').AsString,
                                  tb.FieldByName('descricao').AsString,
                                  tb.FieldByName('endereco').AsString,
                                  tb.FieldByName('qt').AsString,
                                  tb.FieldByName('pallet').AsString,
                                  '('+ tb.fieldByName('linha').AsString + ')'
                                  +'Qt divergente, ' + nmCont1 +': '
                                  + tb.FieldByName('qt').AsString +' '+ nmCont2+': '+ ds.FieldByName('qt').AsString
                                  + ' (' + ds.fieldByName('linha').AsString + ')'
                                  ,ds.FieldByName('qt').AsString
                               );
          end;
       end;
       ds.Free;
       tb.next();
    end;
end;


procedure TfmRelInventario.insereItemTbdirv(nomeCont, desc, cod, qt1, qt2, linha:String);
begin
{seqinv int,
contagem varchar(100),
cd_ref int,
ds_ref  varchar(100),
q1 int default 0,
q2 int default 0,
qc int,
msgErro varchar(100),
flagOk bit
linha(
seq int identity (0,1),
primary key(seq, seqInv, contagem)
}
   tb_dirvg2.AppendRecord([
      fmMain.getUoLogada(),
      ExtractFileName(nomeCont),
      cod,
      desc,
      qt1,
      qt2,
      '0',
      '',
      false,
      linha
   ]);
end;


procedure TfmRelInventario.insFirstCont(nomeCont:String);
begin
   f.gravaLog('insFirstCont(nomeCont:String)');
   tbItens.First();
   while(tbItens.Eof = false) do
   begin
      f.gravaLog('tbItens->' +tbItens.FieldByName('descricao').AsString );

       insereItemTbdirv(
          nomeCont,
          tbItens.FieldByName('descricao').AsString,
          tbItens.FieldByName('codigo').AsString,
          tbItens.FieldByName('qt').AsString,
          '0',
          tbItens.FieldByName('linha').AsString,
       );
       tbItens.Next();
   end;
end;

procedure TfmRelInventario.insereSegContagem(tb_seg, tb_Dirv2:TADOTable);
begin
   tb_seg.First();

   while ( tb_seg.Eof = false) do
   begin
      if (tb_Dirv2.Locate('cd_ref', tb_seg.fieldByName('codigo').AsString, []) = true ) then
      begin
         tb_Dirv2.Edit();
         tb_Dirv2.FieldByName('q2').AsString := tb_seg.fieldByName('qt').AsString;

         if (tb_Dirv2.FieldByName('q1').AsString = tb_seg.fieldByName('qt').AsString) then
         begin
            tb_Dirv2.FieldByName('flagOk').AsBoolean := true;
            tb_Dirv2.FieldByName('qc').AsString := tb_seg.fieldByName('qt').AsString;
         end;

         tb_Dirv2.Post();
      end
      else
      begin
         insereItemTbdirv(
            '',
            tb_seg.FieldByName('descricao').AsString,
            tb_seg.FieldByName('codigo').AsString,
            '0',
            tb_seg.FieldByName('qt').AsString,
            tb_seg.FieldByName('linha').AsString
         );
      end;
      tb_seg.Next();
   end;
end;           


procedure TfmRelInventario.geraTbDirvegencia(arquivos: TStrings; a:String = 'nada');
begin //
   f.gravaLog('geraTbDirvegencia(arquivos: TStrings; a:String - jeito novo )');

   if (tbDirvg.TableName <> '') then
      tb_dirvg2.Close();

   dm.execSQL('truncate table zcf_divergencia');
   tb_dirvg2.Connection := dm.con;
   tb_dirvg2.TableName := 'zcf_divergencia';
   tb_dirvg2.Open();

   loadTablesContDiverg(arquivos, tbItens, tbNmArquivos);

// carrega a primeira contagem
   insFirstCont(arquivos[0]);

// insere a seg contagem ja fazendo as divergencias
   insereSegContagem(tbNmArquivos, tb_dirvg2);

   insereMsgErros();

   carregaTbRel();

//   tb_dirvg2.Close();
//   tb_dirvg2.Filter := 'FlagOk = false';
//   tb_dirvg2.Filtered := true;
//   tb_dirvg2.Open();
end;

procedure TfmRelInventario.btCalculaDivergenciaClick(Sender: TObject);
var
   params:TStringList;
   arquivos : TStrings;
begin
   arquivos :=  f.dialogAbrVariosArq('txt', 'c:\');

   if (arquivos <> nil) and (arquivos.Count = 2) then
      if (arquivos[0] <> '') and (arquivos[01] <> '') and (arquivos[0] <> arquivos[1]) then
      begin

         loadTablesContDiverg(arquivos, tbItens, tbNmArquivos);
         carregaTbInventario(tbDirvg, nil, true, tbErr);
         calculaDivergencia('C1', 'C2', tbItens, tbNmArquivos, tbDirvg);
         calculaDivergencia('C2', 'C1', tbNmArquivos, tbItens, tbDirvg);


         params := TStringlist.create();
         params.add(arquivos[0]);
         params.add(arquivos[1]);

         fmMain.msgStatus('Ordenando diverg�ncias...' );
         tbDirvg.Sort := 'endereco, codigo, msg';
         f.gravaLog('terminei as divergencias');

         fmMain.msgStatus('');

         if tbDirvg.RecordCount > 0 then
            fmMain.imprimeRave(tbDirvg, nil, nil, nil, nil, 'rpInvDivergencias', params)
         else
            msg.msgWarning('Sem divergencias');
      end
      else
         msg.msgErro('Erro ao carregar arquivos.');
end;

procedure TfmRelInventario.adicionaDivergencia(tipo, codigo, descricao, endereco, quant, pallet, msg, segundoValor: String);
var
   ds:TdataSet;
   cmd:String;
begin
   f.gravaLog('adicionaDivergencia()');
   
   cmd := 'Select * from '+ tbDirvg.tablename + ' where codigo = ' + quotedStr(codigo) + 'and  isDirvg = ' + quotedStr(tipo);

   ds:= dm.getDataSetQ(cmd);

   if ( ds.IsEmpty = true) then
      tbDirvg.AppendRecord([codigo, descricao, endereco, quant, pallet, tipo, '', '', msg,'ean']);
end;



procedure TfmRelInventario.exportaContagemWell(tableName: String);
var
   ds:Tdataset;
   cmd,codLoja:String;
begin
   codLoja := dm.openSQL('Select cd_uo from zcf_tbuo where is_uo = '+ fmMain.getUoLogada(), 'cd_uo');

   codLoja :=   InputBox('',' Qual loja ?', codLoja);


   codLoja := f.preencheCampo(4, '0','E', codLoja);

   cmd :=
   'Select codigo, ean, sum (qt) as qt from ' +
   tableName +
   ' group by is_ref, codigo, ean, qt order by codigo';
   ds:= dm.getDataSetQ(cmd);

   ds.First();
   while ( ds.Eof = false) do
   begin
       f.GravaLinhaEmUmArquivo( 'c:\Contagem_'+codloja+'.txt',
       codLoja +
       f.preencheCampo(13, ' ', 'D', ds.fieldByname('codigo').AsString) +
       f.preencheCampo(05, '0', 'E', ds.fieldByname('qt').AsString)
         );
      ds.Next();
   end;
   ds.free();

   msg.msgExclamation('Exportado para: c:\Contagem_'+codloja+'.txt');
end;

procedure TfmRelInventario.montaScriptWMS(arq: String);
var
   ds:TDataSet;
   arqItensP: TstringList;
   i:integer;
   aux:String;
   cmd:String;
begin
    arqItensP := TStringlist.Create();
    cmd := 'Select codigo, ean, endereco, pallet2 as pallet, qt from zcf_inv_wms where codigo = ''00020443'' order by codigo';
    ds:= dm.getDataSetQ(cmd);


   i:=0;
   ds.First();
   while (ds.Eof = false) do
   begin
      inc(i);
      aux :=
      'INSERT INTO TITPALETE ( STR_ID_PALETE, ' +
                              'STR_ID_ITPALETE, ' +
                              'STR_SERIE_ITPALETE, ' +
                              'STR_ID_SKU,  ' +
                              'STR_ID_PESSOA_SKU, ' +
                              'FLT_QUANTIDADE_ITPALETE, ' +
                              'STR_NUMERO_DOC, ' +
                              'STR_SERIE_DOC, ' +
                              'STR_ID_PESSOA, ' +
                              'STR_IDPRODUTO_DOC, ' +
                              'DTM_ENTRADA_ITPALETE, ' +
                              'STR_FLAG_ALOCADO, ' +
                              'DTM_VALIDADE_ITPALETE, ' +
                              'STR_LOTE_ITPALETE, ' +
                              'STR_FLAG_BLOQUEIO, ' +
                              'FLT_PESO_ITPALETE, ' +
                              'STR_TIPO_DOC, ' +
                              'STR_UNIDADE_ITPALETE, ' +
                              'FLT_QTDALOCADA_ITPALETE, ' +
                              'FLT_PESOALOCADO_ITPALETE ' +
                              ') VALUES (' +

         quotedStr(tiraTraco( ds.fieldByName('pallet').AsString )) +', '+
         quotedStr( intToStr(i)  ) +', '+
         quotedStr( intToStr(i)  ) +', '+
         quotedStr( ds.fieldByName('codigo').AsString ) +', '+
         quotedStr( '7221377000110') +', '+
         ds.fieldByName('qt').AsString  +', '+
         quotedStr('00001') +', '+
         quotedStr('0') +', '+
         quotedStr( '7221377000110') +', '+
         quotedStr( '0000001') +', '+
         quotedStr( '2011-07-01 00:00:00') +', '+
         quotedStr( 'false') +', '+
         quotedStr( '2050-07-01 00:00:00') +', '+
         quotedStr('0') +', '+
         quotedStr('false') +', '+
         '0' +', '+
         quotedStr('E') +', '+
         quotedStr('MT') +', '+
         '0' +', '+
         '0' +' );';

       arqItensP.add(aux);
       ds.Next();
   end;
   arqItensP.SaveToFile('c:\Script_carga_pallet_itens.sql' );
   arqItensP.Free();
   memo1.Lines.add('itens do Pallet');
{ }
 cmd:=
    'select codigo, ean, endereco, qt, pallet from zcf_inv_wms order by codigo';

 ds:= dm.getDataSetQ(cmd);
 ds.First();
 while (ds.Eof = false) do
 begin
    f.GravaLinhaEmUmArquivo('c:\InventarioWMS.txt',
    ds.FieldByName('codigo').AsString +';'+
    ds.FieldByName('ean').AsString +';'+
    ds.FieldByName('endereco').AsString +';'+
    ds.FieldByName('qt').AsString +';'+
    ds.FieldByName('pallet').AsString +';');
    ds.Next();
 end;
end;


procedure TfmRelInventario.Button1Click(Sender: TObject);
var
  str:String;
begin
   montaScriptWMS(str);
end;

function TfmRelInventario.tiraTraco(str: String): String;
begin
   while (pos('-',str) > 0) do
      delete(str, pos('-',str), 01);
   result := str;
end;

procedure TfmRelInventario.juntarContagens(arquivos:TStrings);
var
  arqAtual, comandos:TStringlist;
  i, j:integer;
  cmd:String;
  dsItem:TdataSet;
begin
   msg.msgExclamation('Esse procedimento Junta os arquivos escolhidos na tabela zcf_juntaContLoja');


   memo1.Lines.add('Limpar a tabela zcf_juntaContLoja...');
   dm.execSQL('truncate table zcf_juntaContLoja');

   for j:=0 to arquivos.Count -1 do
   begin
      arqAtual := TStringList.Create();
      arqAtual.LoadFromFile(arquivos[j]);

      memo1.lines.add( intToStr(j+1) +' de '+ intToStr(arquivos.Count) +' '+ arquivos[j]);

      comandos := TStringlist.Create();
      for i:=0 to arqAtual.Count -1 do
      begin
         dsItem := uEstoque.getDadosProdFromArqInv(arqAtual[i], 01, 13);
         if  (dsItem.IsEmpty = false) then
         begin
            cmd := dm.getQtCMD2('estoque', 'JuntaArqParaWell', dsItem.fieldByName('codigo').AsString, copy(arqAtual[i], 15, 06));

            comandos.Add(cmd);
            if comandos.Count >=20 then
            begin
               dm.execSQLs(comandos, false);
               comandos.Clear();
            end;
         end;
         dsItem.Free();
      end;

      dm.execSQLs(comandos, false);
      comandos.Clear();

      arqAtual.Free();
   end;
end;

procedure TfmRelInventario.fsBitBtn1Click(Sender: TObject);
var
  arq:TStrings;
begin
   arq := f.dialogAbrVariosArq('txt','c:\');
   if (arq <> nil) then
   begin
      if (arq.Count > 0) then
         juntarContagens(arq);
      arq.Free();
   end;
end;

procedure TfmRelInventario.fsBitBtn2Click(Sender: TObject);
var
   ds:TdataSet;
   cmd:String;
   arq:TSTringlist;
begin
   arq := TSTRinglist.create();

//   cmd := ' insert zcf_juntaContLoja select SUBSTRING(B1_COD, 1, 13),  0, NULL from SB1 ' +
//          ' WHERE B1_COD NOT IN(select distinct ean from zcf_juntaContLoja) ';
   dm.execSQL(cmd);

   cmd := 'Select ean, sum(quant) as quant from zcf_juntaContLoja '+
          ' group by ean '+
          ' order by ean ';
   ds:= dm.getDataSetQ(cmd);

   ds.First();

   while ds.Eof = false do
   begin
      arq.Add(
         edCdUo.Text +
         f.preencheCampo(9, ' ', 'D', ds.fieldByName('ean').AsString) + ','+
         f.preencheCampo(5, '0', 'E', ds.fieldByName('quant').AsString)
      );

      ds.Next();
   end;
   cmd :=  f.getDirExe() +   'ContagemConsolidada.txt';
   arq.SaveToFile(cmd);

   msg.msgExclamation('Salvo em: ' + cmd );

   arq.free();
   memo1.lines.add('ok');
end;


procedure TfmRelInventario.fsBitBtn3Click(Sender: TObject);
var
   arq:TstringList;
   i:integer;
   cmd:String;
   qr:TADOQuery;
begin
   i:=0;
   screen.Cursor := crHourGlass;
   fmMain.msgStatus('Obtendo a rela��o dos produtos...');

   cmd := dm.getCMD1('Estoque', 'cargaColetor', edFxCodigo.Text);

   dm.getQuery(qr, cmd);

   arq:= TStringList.Create();
   qr.First;
   while (qr.Eof = false) do
   begin
      inc(i);
      if qr.fieldByName('cd_pesq').AsString <> '' then
         cmd := qr.fieldByName('cd_pesq').AsString
      else
         cmd := qr.fieldByName('cd_ref').AsString;

      arq.Add(
                f.preencheCampo(13, '0', 'E', cmd) +','+
                f.preencheCampo( strToInt(edQtDigDesc.text),' ', 'D', copy(qr.fieldByName('ds_ref').AsString, 01, strToInt(edQtDigDesc.text)))
             );

      if (i mod 1000 = 0) then
         fmMain.msgStatus('Montando o arquivo...   ' + IntToStr(i) + ' de ' +  inttoStr(qr.RecordCount) +  '  Eans ');
      qr.next;
   end;
   arq.Sort();
   arq.SaveToFile(f.getDirLogs()+ 'produtos.TXT');
   fmMain.msgStatus('Exportado ' + intToStr(i) +  ' itens para ' + f.getDirLogs()+ 'produtos.TXT' );
   qr.Free();
   screen.Cursor := crDefault;
end;

procedure TfmRelInventario.relatorioContagem(arquivos: TStrings);
var
   i:integer;
   params:TStringList;
begin
   f.gravaLog('procedure relatorioContagem()' );

   if (tbNmArquivos.TableName <> '') then
      tbNmArquivos.close();

   dm.getTable( tbNmArquivos, 'arquivos varchar(250), versao varchar(50)' );

   for i:=0 to arquivos.Count-1 do
      tbNmArquivos.AppendRecord([arquivos[i]]);

// carrega arquivos na tabela de contagem
   carregaTbInventario( tbItens, arquivos, false, tbErr );


   params := TStringList.create();
   params.add(intToStr(tbItens.RecordCount));

   if ( cbExporta.Checked = true) then
     funcsql.exportaTable(tbItens);

   if (cbExportaWell.Checked = true) then
      exportaContagemWell(tbItens.TableName);


   tbItens.Sort := 'codigo ASC'; //'arquivos ASC';

   fmMain.imprimeRave(tbItens, tbNmArquivos, tbErr, nil, nil, 'rpInvContagem', params );
   tbItens.close();
   tbNmArquivos.close();
   tbErr.Close();
end;

procedure TfmRelInventario.btCarregaContagemClick(Sender: TObject);
var
  arquivos:TStrings;
begin
    memo1.lines.clear();
    arquivos:= f.dialogAbrVariosArq('txt','c:\');

    if (arquivos <> nil  ) then
       relatorioContagem(arquivos);
end;


procedure TfmRelInventario.gridDirvCellClick(Column: TColumn);
begin
   if (tb_dirvg2.IsEmpty = false) then
      if (Column.FieldName = 'q1') or (Column.FieldName = 'q2') then
      begin
         tb_dirvg2.Edit();
         tb_dirvg2.FieldByName('qc').AsString := Column.Field.AsString;
         tb_dirvg2.post();
      end;
end;


procedure TfmRelInventario.FormCreate(Sender: TObject);
begin
   uLj.getListaLojas(cbLoja, false, false, '', '');
end;

procedure TfmRelInventario.fsBitBtn4Click(Sender: TObject);
var
   resp:String;
begin
   resp := msg.msgInput( dm.getCMD1('MSG', 'ZeraestoqueUO', f.getNomeDoCx(cbLoja)) ,  '' );
   if uppercase(resp) = 'OK' then
      uEstoque.zerarEstoque(f.getCodUO(cbLoja));
end;


end.
