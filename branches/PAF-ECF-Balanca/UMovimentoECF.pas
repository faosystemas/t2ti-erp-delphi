{*******************************************************************************
Title: T2Ti ERP
Description: Tela para emiss�o do Movimento por ECF

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
unit UMovimentoECF;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvExControls, JvEnterTab, Generics.Collections,
  Windows, ImpressoraVO, ImpressoraController;

type
  TFMovimentoECF = class(TForm)
    Image1: TImage;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    panPeriodo: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mkeDataIni: TMaskEdit;
    mkeDataFim: TMaskEdit;
    JvEnterAsTab1: TJvEnterAsTab;
    ComboImpressora: TComboBox;
    procedure confirma;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FMovimentoECF: TFMovimentoECF;
  ListaImpressora: TObjectList<TImpressoraVO>;
  Impressora: TImpressoraVO;

implementation

uses UCaixa, UPAF;

{$R *.dfm}

procedure TFMovimentoECF.botaoConfirmaClick(Sender: TObject);
begin
  confirma;
end;

procedure TFMovimentoECF.confirma;
begin
  if Application.MessageBox('Deseja gerar o arquivo eletr�nico de movimento?', 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion) = IdYes then
  begin
    ListaImpressora := TImpressoraController.TabelaImpressora;
    Impressora := TImpressoraVO(ListaImpressora.Items[ComboImpressora.ItemIndex]);
    UPAF.GeraMovimentoECF(mkeDataIni.Text, mkeDataFim.Text, Impressora);
  end;
end;

procedure TFMovimentoECF.FormActivate(Sender: TObject);
begin
  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);
  mkeDataIni.Text := DateToStr(Now);
  mkeDataFim.Text := DateToStr(Now);
  ComboImpressora.SetFocus;
end;

procedure TFMovimentoECF.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFMovimentoECF.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  ListaImpressora := TImpressoraController.TabelaImpressora;
  for i := 0 to ListaImpressora.Count - 1 do
    ComboImpressora.Items.Add(TImpressoraVO(ListaImpressora.Items[i]).Identificacao);
  ComboImpressora.ItemIndex := 0;
end;

procedure TFMovimentoECF.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 123 then
    confirma;
end;

end.
