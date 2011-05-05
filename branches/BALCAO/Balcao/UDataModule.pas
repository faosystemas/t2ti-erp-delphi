{*******************************************************************************
Title: T2Ti ERP
Description: M�dulo de dados.

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
unit UDataModule;

interface

uses
  SysUtils, Classes, DB, DBClient, Provider, WideStrings, FMTBcd, SqlExpr,
  DBXMySql, DBXMsSQL;

type
  TFDataModule = class(TDataModule)
    Conexao: TSQLConnection;
    CDSDAV: TClientDataSet;
    DSDAV: TDataSource;
    CDSPV: TClientDataSet;
    DSPV: TDataSource;
    procedure CDSPVBeforePost(DataSet: TDataSet);
    procedure CDSDAVBeforePost(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FDataModule: TFDataModule;

implementation

uses UDAV, UPreVenda, ConexaoBD;

{$R *.dfm}

procedure TFDataModule.CDSDAVBeforePost(DataSet: TDataSet);
begin
  FDAV.GridItens.Columns[3].ReadOnly := False;
  CDSDAV.FieldByName('VALOR_TOTAL').AsFloat := CDSDAV.FieldByName('VALOR_UNITARIO').AsFloat * CDSDAV.FieldByName('QUANTIDADE').AsFloat;
  FDAV.GridItens.Columns[3].ReadOnly := True;
  FDAV.Soma;
end;

procedure TFDataModule.CDSPVBeforePost(DataSet: TDataSet);
begin
  FPreVenda.GridItens.Columns[3].ReadOnly := False;
  CDSPV.FieldByName('VALOR_TOTAL').AsFloat := CDSPV.FieldByName('VALOR_UNITARIO').AsFloat * CDSPV.FieldByName('QUANTIDADE').AsFloat;
  FPreVenda.GridItens.Columns[3].ReadOnly := True;
  FPreVenda.Soma;
end;

procedure TFDataModule.DataModuleCreate(Sender: TObject);
begin
  TDBExpress.Conectar('MySQL');
  Conexao := TDBExpress.getConexao;
end;

procedure TFDataModule.DataModuleDestroy(Sender: TObject);
begin
 TDBExpress.Desconectar;
end;

end.
