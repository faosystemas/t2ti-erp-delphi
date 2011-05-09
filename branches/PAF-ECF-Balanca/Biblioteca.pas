{*******************************************************************************
Title: T2Ti ERP
Description: Biblioteca de fun��es.

The MIT License

Copyright: Copyright (C) 2010 T2Ti.COM

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

       The author may be contacted at:
           t2ti.com@gmail.com</p>

@author Albert Eije (T2Ti.COM)
@version 1.0
*******************************************************************************}
unit Biblioteca;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Dbtables, Inifiles, DBClient, DB, SqlExpr, DBXMySql, Grids, DBGrids,
  IdHashMessageDigest, Constantes;

Function ValidaCNPJ(xCNPJ: String):Boolean;
Function ValidaCPF( xCPF:String ):Boolean;
Function ValidaEstado(Dado : string) : boolean;
Function MixCase(InString: String): String;
Function Hora_Seg( Horas:string ):LongInt;
Function Seg_Hora( Seg:LongInt ):string;
Function Minuscula(InString: String): String;
Function StrZero(Num:Real ; Zeros,Deci:integer): string;
Function OrdenaPinta(xGrid: DBGrids.TDBGrid; Column: TColumn; cds: TClientDataSet): boolean;
Procedure ZapFiles(vMasc:String);
Procedure SetTaskBar(Visible: Boolean);
function MD5File(const fileName: string): string;
function MD5String(const texto: string): string;
Function TruncaValor(Value:Extended;Casas:Integer):Extended;
function UltimoDiaMes(Mdt: TDateTime) : String;
function FormataFloat(Tipo:String; Valor: Extended): string; //Tipo => 'Q'=Quantidade | 'V'=Valor
procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
function DevolveInteiro(Const Texto:String):String;
function DevolveConteudoDelimitado(Delimidador:string;var Linha:string):string;
function VersaoExe(exe, param : string): String;  // acrescentar

var
   InString : String;

implementation

{ Valida o CNPJ digitado }
function ValidaCNPJ(xCNPJ: String):Boolean;
Var
d1,d4,xx,nCount,fator,resto,digito1,digito2 : Integer;
Check : String;
begin
d1 := 0;
d4 := 0;
xx := 1;
for nCount := 1 to Length( xCNPJ )-2 do
    begin
    if Pos( Copy( xCNPJ, nCount, 1 ), '/-.' ) = 0 then
       begin
       if xx < 5 then
          begin
          fator := 6 - xx;
          end
       else
          begin
          fator := 14 - xx;
          end;
       d1 := d1 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
       if xx < 6 then
          begin
          fator := 7 - xx;
          end
       else
          begin
          fator := 15 - xx;
          end;
       d4 := d4 + StrToInt( Copy( xCNPJ, nCount, 1 ) ) * fator;
       xx := xx+1;
       end;
    end;
    resto := (d1 mod 11);
    if resto < 2 then
       begin
       digito1 := 0;
       end
   else
       begin
       digito1 := 11 - resto;
       end;
   d4 := d4 + 2 * digito1;
   resto := (d4 mod 11);
   if resto < 2 then
      begin
      digito2 := 0;
      end
   else
      begin
      digito2 := 11 - resto;
      end;
   Check := IntToStr(Digito1) + IntToStr(Digito2);
   if Check <> copy(xCNPJ,succ(length(xCNPJ)-2),2) then
      begin
      Result := False;
      end
   else
      begin
      Result := True;
      end;
end;

{ Valida o CPF digitado }
function ValidaCPF( xCPF:String ):Boolean;
Var
d1,d4,xx,nCount,resto,digito1,digito2 : Integer;
Check : String;
Begin
d1 := 0; d4 := 0; xx := 1;
for nCount := 1 to Length( xCPF )-2 do
    begin
    if Pos( Copy( xCPF, nCount, 1 ), '/-.' ) = 0 then
       begin
       d1 := d1 + ( 11 - xx ) * StrToInt( Copy( xCPF, nCount, 1 ) );
       d4 := d4 + ( 12 - xx ) * StrToInt( Copy( xCPF, nCount, 1 ) );
       xx := xx+1;
       end;
    end;
resto := (d1 mod 11);
if resto < 2 then
   begin
   digito1 := 0;
   end
else
   begin
   digito1 := 11 - resto;
   end;
d4 := d4 + 2 * digito1;
resto := (d4 mod 11);
if resto < 2 then
   begin
   digito2 := 0;
   end
else
   begin
   digito2 := 11 - resto;
   end;
Check := IntToStr(Digito1) + IntToStr(Digito2);
if Check <> copy(xCPF,succ(length(xCPF)-2),2) then
   begin
   Result := False;
   end
else
   begin
   Result := True;
   end;
end;

{ Valida a UF digitada }
function ValidaEstado(Dado : string) : boolean;
const
  Estados = 'SPMGRJRSSCPRESDFMTMSGOTOBASEALPBPEMARNCEPIPAAMAPFNACRRRO';
var
  Posicao : integer;
begin
Result := true;
if Dado <> '' then
   begin
   Posicao := Pos(UpperCase(Dado),Estados);
   if (Posicao = 0) or ((Posicao mod 2) = 0) then
      begin
      Result := false;
      end;
    end;
end;

{ Corrige a string que contenha caracteres maiusculos
  inseridos no meio dela para tudo minusculo e com a
  primeira letra maiuscula}
Function  MixCase(InString: String): String;
Var I: Integer;
Begin
  Result := LowerCase(InString);
  Result[1] := UpCase(Result[1]);
  For I := 1 To Length(InString) - 1 Do Begin
    If (Result[I] = ' ') Or (Result[I] = '''') Or (Result[I] = '"')
    Or (Result[I] = '-') Or (Result[I] = '.')  Or (Result[I] = '(') Then
      Result[I + 1] := UpCase(Result[I + 1]);
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
  End;
End;

{Apaga arquivos usando mascaras tipo: c:\Temp\*.zip, c:\Temp\*.*
 Obs: Requer o Path dos arquivos a serem deletados}
Procedure ZapFiles(vMasc:String);
Var Dir : TsearchRec;
    Erro: Integer;
Begin
   Erro := FindFirst(vMasc,faArchive,Dir);
   While Erro = 0 do Begin
      DeleteFile( ExtractFilePAth(vMasc)+Dir.Name );
      Erro := FindNext(Dir);
   End;
   FindClose(Dir);
End;

{Converte de hora para segundos}
function Hora_Seg( Horas:string ):LongInt;
Var Hor,Min,Seg:LongInt;
begin
   Horas[Pos(':',Horas)]:= '[';
   Horas[Pos(':',Horas)]:= ']';
   Hor := StrToInt(Copy(Horas,1,Pos('[',Horas)-1));
   Min := StrToInt(Copy(Horas,Pos('[',Horas)+1,(Pos(']',Horas)-Pos('[',Horas)-1)));
   if Pos(':',Horas) > 0 then
      Seg := StrToInt(Copy(Horas,Pos(']',Horas)+1,(Pos(':',Horas)-Pos(']',Horas)-1)))
   else
      Seg := StrToInt(Copy(Horas,Pos(']',Horas)+1,2));
   Result := Seg + (Hor*3600) + (Min*60);
end;

{Converte de segundos para hora}
function Seg_Hora( Seg:LongInt ):string;
Var Hora,Min:LongInt;
    Tmp : Double;
begin
   Tmp := Seg / 3600;
   Hora := Round(Int(Tmp));
   Seg :=  Round(Seg - (Hora*3600));
   Tmp := Seg / 60;
   Min := Round(Int(Tmp));
   Seg :=  Round(Seg - (Min*60));
   Result := StrZero(Hora,2,0)+':'+StrZero(Min,2,0)+':'+StrZero(Seg,2,0);
end;

{converte tudo para minuscula}
Function  Minuscula(InString: String): String;
Var I: Integer;
Begin
  Result := LowerCase(InString);
  For I := 1 To Length(InString) - 1 Do Begin
    If (Result[I] = ' ') Or (Result[I] = '''') Or (Result[I] = '"')
    Or (Result[I] = '-') Or (Result[I] = '.')  Or (Result[I] = '(') Then
      Result[I] := UpCase(Result[I]);
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
    if Result[I] = '�' then
      Result[I] := '�';
  End;
End;

{esconde|exibe a barra do Windows}
procedure SetTaskBar(Visible: Boolean);
var
  wndHandle : THandle;
  wndClass : array[0..50] of Char;
begin
  StrPCopy(@wndClass[0],'Shell_TrayWnd');
  wndHandle := FindWindow(@wndClass[0], nil);
  If Visible = True then
    ShowWindow(wndHandle, SW_RESTORE)
  else ShowWindow(wndHandle, SW_HIDE);
end;

function StrZero(Num:Real ; Zeros,Deci:integer): string;
var Tam,Z:integer;
    Res,Zer:string;
begin
   Str(Num:Zeros:Deci,Res);
   Res := Trim(Res);
   Tam := Length(Res);
   Zer := '';
   for z := 01 to (Zeros-Tam) do
      Zer := Zer + '0';
   Result := Zer+Res;
end;

Function OrdenaPinta(xGrid: DBGrids.TDBGrid; Column: TColumn; cds: TClientDataSet): boolean;
const
  idxDefault = 'DEFAULT_ORDER';
var
  strColumn: string;
  bolUsed: boolean;
  idOptions: TIndexOptions;
  i: integer;
  VDescendField: string;
  coluna : String;
begin

  result := False;
  if not cds.Active then
    exit;

  strColumn := idxDefault;

  // n�o faz nada caso seja um campo calculado
  if (Column.Field.FieldKind = fkCalculated) then
    exit;

  // �ndice j� est� sendo utilizado
  bolUsed := (Column.Field.FieldName = cds.IndexName);

  // seta o nome da coluna na variavel para carga de dados e pesquisa
  coluna := Column.Field.FieldName;

  // verifica a exist�ncia do �ndice e propriedades
  cds.IndexDefs.Update;
  idOptions := [];
  for i := 0 to cds.IndexDefs.Count - 1 do
  begin
    if cds.IndexDefs.Items[i].Name = Column.Field.FieldName then
    begin
      strColumn := Column.Field.FieldName;
      // determina como deve ser criado o �ndice, inverte a condi��o ixDescending
      case (ixDescending in cds.IndexDefs.Items[i].Options) of
        True:
          begin
            idOptions := [];
            VDescendField := '';
          end;
        False:
          begin
            idOptions := [ixDescending];
            VDescendField := strColumn;
          end;
      end;
    end;
  end;

  // caso n�o encontre o �ndice ou o mesmo esteja em uso
  if (strColumn = idxDefault) or bolUsed then
  begin
    if bolUsed then
      cds.DeleteIndex(Column.Field.FieldName);
    try
      cds.AddIndex(Column.Field.FieldName, Column.Field.FieldName, idOptions,
        VDescendField, '', 0);
      strColumn := Column.Field.FieldName;
    except
      // se �ndice indeterminado, seta o padr�o
      if bolUsed then
        strColumn := idxDefault;
    end;
  end;

  // pinta todas as outras colunas com a cor padr�o e a coluna clicada com a cor Azul
  for i := 0 to xGrid.Columns.Count - 1 do
  begin
    if Pos(strColumn, xGrid.Columns[i].Field.FieldName) <> 0 then
      xGrid.Columns[i].Title.Font.Color := clBlue
    else
      xGrid.Columns[i].Title.Font.Color := clWindowText;
  end;

  // tenta setar o �ndice, caso ocorra algum erro seta o padr�o
  try
    cds.IndexName := strColumn;
  except
    cds.IndexName := idxDefault;
  end;

  result := True;
end;

function MD5File(const fileName: string): string;
var
  idmd5 : TIdHashMessageDigest5;
  fs : TFileStream;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  fs := TFileStream.Create(fileName, fmOpenRead OR fmShareDenyWrite) ;
  try
    result := idmd5.HashStreamAsHex(fs);
  finally
    fs.Free;
    idmd5.Free;
  end;
end;

function MD5String(const texto: string): string;
var
  idmd5: TIdHashMessageDigest5;
begin
  idmd5 := TIdHashMessageDigest5.Create;
  try
    result := LowerCase(idmd5.HashStringAsHex(texto));
  finally
  idmd5.Free;
  end;
end;

Function TruncaValor(Value:Extended;Casas:Integer):Extended;
Var sValor:String;
    nPos:Integer;
begin
   //Transforma o valor em string
   sValor := FloatToStr(Value);

   //Verifica se possui ponto decimal
   nPos := Pos(DecimalSeparator,sValor);
   If ( nPos > 0 ) Then begin
      sValor := Copy(sValor,1,nPos+Casas);
   End;

   Result := StrToFloat(sValor);
end;

function UltimoDiaMes(Mdt: TDateTime) : String;
var
  ano, mes, dia : word;
  mDtTemp : TDateTime;
begin
  Decodedate(mDt, ano, mes, dia);
  mDtTemp := (mDt - dia) + 33;
  Decodedate(mDtTemp, ano, mes, dia);
  mDtTemp := mDtTemp - dia;
  Decodedate(mDtTemp, ano, mes, dia);
  Result := IntToStr(dia)
end;

function FormataFloat(Tipo:String; Valor: Extended): string; //Tipo => 'Q'=Quantidade | 'V'=Valor
var
  i:integer;
  Mascara:String;
begin
  Mascara := '0.';

  if Tipo = 'Q' then
  begin
    for i := 1 to Constantes.TConstantes.DECIMAIS_QUANTIDADE do
      Mascara := Mascara + '0';
  end
  else if Tipo = 'V' then
  begin
    for i := 1 to Constantes.TConstantes.DECIMAIS_VALOR do
      Mascara := Mascara + '0';
  end;

  Result := FormatFloat(Mascara, Valor);
end;

procedure Split(const Delimiter: Char; Input: string; const Strings: TStrings);
begin
  Assert(Assigned(Strings)) ;
  Strings.Clear;
  Strings.Delimiter := Delimiter;
  Strings.DelimitedText := Input;
end;

function DevolveInteiro(Const Texto:String):String;
var I: integer;
    S: string;
begin
  S := '';
  for I := 1 To Length(Texto) Do
  begin
    if (Texto[I] in ['0'..'9']) then
    begin
      S := S + Copy(Texto, I, 1);
    end;
  end;
  result := S;
end;


function DevolveConteudoDelimitado(Delimidador:string;var Linha:string):string;   // acrescentar
var
  PosBarra: integer;
begin
  PosBarra:=Pos(Delimidador,Linha);
  Result:=Copy(Linha,1,PosBarra-1);
  Delete(Linha,1,PosBarra);
end;

function VersaoExe(exe, param : string): String;   // acrescentar
type
   PFFI = ^vs_FixedFileInfo;
var
  F : PFFI;
  Handle : Dword;
  Len : Longint;
  Data : Pchar;
  Buffer : Pointer;
  Tamanho : Dword;
  Parquivo: Pchar;

begin

  Parquivo := StrAlloc(Length(Exe) + 1);
  StrPcopy(Parquivo, Exe);
  Len := GetFileVersionInfoSize(Parquivo, Handle);
  Result := '';
  if Len > 0 then
  begin
    Data:=StrAlloc(Len+1);
    if GetFileVersionInfo(Parquivo,Handle,Len,Data) then
    begin
      VerQueryValue(Data, '\',Buffer,Tamanho);
      F := PFFI(Buffer);
      if param = 'N' then
      begin
        Result := Format('%d%d%d%d',
        [HiWord(F^.dwFileVersionMs),
        LoWord(F^.dwFileVersionMs),
        HiWord(F^.dwFileVersionLs),
        Loword(F^.dwFileVersionLs)]);
      end else if param = 'V' then
      begin
        Result := Format('%d.%d.%d.%d',
        [HiWord(F^.dwFileVersionMs),
        LoWord(F^.dwFileVersionMs),
        HiWord(F^.dwFileVersionLs),
        Loword(F^.dwFileVersionLs)]);
      end
    end;
    StrDispose(Data);
  end;
  StrDispose(Parquivo);
end;


end.
