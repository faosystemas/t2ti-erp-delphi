{*******************************************************************************
Title: T2Ti ERP
Description: Cancela Pre-Venda.

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
unit UCancelaPreVenda;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, FMTBcd,
  Provider, DBClient, DB, SqlExpr, Math, DBCtrls,Generics.Collections;

type
  TFCancelaPreVenda = class(TForm)
    Image1: TImage;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    QMestre: TSQLQuery;
    DSMestre: TDataSource;
    CDSMestre: TClientDataSet;
    DSPMestre: TDataSetProvider;
    DSDetalhe: TDataSource;
    CDSDetalhe: TClientDataSet;
    QDetalhe: TSQLQuery;
    DSPDetalhe: TDataSetProvider;
    GroupBox2: TGroupBox;
    GridMestre: TJvDBGrid;
    GroupBox1: TGroupBox;
    GridDetalhe: TJvDBGrid;
    CDSMestreID: TIntegerField;
    CDSMestreSITUACAO: TStringField;
    CDSMestreCCF: TIntegerField;
    CDSDetalheID: TIntegerField;
    CDSDetalheID_PRODUTO: TIntegerField;
    CDSDetalheID_ECF_PRE_VENDA_CABECALHO: TIntegerField;
    CDSDetalheDESCRICAO_PDV: TStringField;
    CDSMestreVALOR: TFMTBCDField;
    CDSDetalheQUANTIDADE: TFMTBCDField;
    CDSDetalheVALOR_UNITARIO: TFMTBCDField;
    CDSDetalheVALOR_TOTAL: TFMTBCDField;
    CDSMestreDATA_PV: TDateField;
    CDSMestreHORA_PV: TStringField;
    procedure confirma;
    procedure FormActivate(Sender: TObject);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GridMestreKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FCancelaPreVenda: TFCancelaPreVenda;

implementation

Uses
UCaixa,PreVendaController,PreVendaVO,PreVendaDetalheVO, ProdutoVO,
  ProdutoController;

{$R *.dfm}

procedure TFCancelaPreVenda.botaoConfirmaClick(Sender: TObject);
begin
  confirma;
end;

procedure TFCancelaPreVenda.confirma;
var
  PVSelecionada: Integer;
begin
  if CDSMestre.RecordCount > 0 then
  begin
    PVSelecionada := CDSMestre.FieldByName('ID').AsInteger;
    if Application.MessageBox('Tem certeza que deseja cancelar a Pr�-Venda selecionada?' , 'Cancelar Pr�-Venda', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      FCaixa.labelMensagens.Caption := 'Aguarde. Cancelando Pr�-Venda!';
      CDSMestre.DisableControls;
      FCaixa.labelMensagens.Caption := 'Cancela Pr�-Venda em andamento.';
      TPreVendaController.CancelaPreVendasPendentes(PVSelecionada);
      Close;
    end;
  end
  else
    Application.MessageBox('N�o existem Pr�-Vendas dispon�veis para cancelamento?' , 'Informa��o do Sistema', Mb_Ok);
end;

procedure TFCancelaPreVenda.FormActivate(Sender: TObject);
begin
  if CDSMestre.RecordCount < 1 then
    Application.MessageBox('N�o existem Pr�-Vendas dispon�veis para cancelamento?' , 'Informa��o do Sistema', Mb_Ok);

  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);
  GridMestre.SetFocus;
end;

procedure TFCancelaPreVenda.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFCancelaPreVenda.FormCreate(Sender: TObject);
begin
  CDSMestre.Active := True;
  CDSDetalhe.Active := True;
end;

procedure TFCancelaPreVenda.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = 123 then
    confirma;
end;

procedure TFCancelaPreVenda.GridMestreKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_DELETE then
    confirma;
end;

end.
