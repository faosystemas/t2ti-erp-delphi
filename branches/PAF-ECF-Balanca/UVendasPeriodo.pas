{*******************************************************************************
Title: T2Ti ERP
Description: Permite a emiss�o dos relat�rios do Sintegra e SPED Fiscal

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
unit UVendasPeriodo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvExControls, JvEnterTab, ComCtrls, JvComponentBase;

type
  TFVendasPeriodo = class(TForm)
    Image1: TImage;
    RadioGroup2: TRadioGroup;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    panPeriodo: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    mkeDataIni: TMaskEdit;
    mkeDataFim: TMaskEdit;
    JvEnterAsTab1: TJvEnterAsTab;
    PageControl1: TPageControl;
    PaginaSintegra: TTabSheet;
    PaginaSped: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    ComboBoxConvenio: TComboBox;
    ComboBoxNaturezaInformacoes: TComboBox;
    ComboBoxFinalidadeArquivo: TComboBox;
    Label6: TLabel;
    ComboBoxVersaoLeiauteSped: TComboBox;
    Label7: TLabel;
    ComboBoxFinalidadeArquivoSped: TComboBox;
    Label8: TLabel;
    ComboBoxPerfilSped: TComboBox;
    procedure confirma;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FVendasPeriodo: TFVendasPeriodo;

implementation

uses UCaixa, USintegra, USpedFiscal;

{$R *.dfm}

procedure TFVendasPeriodo.botaoConfirmaClick(Sender: TObject);
begin
  confirma;
end;

procedure TFVendasPeriodo.confirma;
var
  CodigoConvenio, NaturezaInformacao, FinalidadeArquivo, Versao, Perfil: Integer;
begin
  if RadioGroup2.ItemIndex = 0 then
  begin
    if Application.MessageBox('Deseja gerar o arquivo do SINTEGRA (Convenio 57/95)?', 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      {
      1 - Conv�nio 57/95 Vers�o 31/99 Alt. 30/02
      2 - Conv�nio 57/95 Vers�o 69/02 Alt. 142/02
      3 - Conv�nio 57/95 Alt. 76/03
      }
      CodigoConvenio := StrToInt(Copy(ComboBoxConvenio.Text,1,1));
      {
      1 - Interestaduais - Somente opera��es sujeitas ao regime de Substitui��o Tribut�ria
      2 - Interestaduais - Opera��es com ou sem Substitui��o Tribut�ria
      3 - Totalidade das opera��es do informante
      }
      NaturezaInformacao := StrToInt(Copy(ComboBoxNaturezaInformacoes.Text,1,1));
      {
      1 - Normal
      2 - Retifica��o total de arquivo: substitui��o total de informa��es prestadas pelo contribuinte referentes a este per�odo
      3 - Retifica��o aditiva de arquivo: acr�scimo de informa��o n�o inclu�da em arquivos j� apresentados
      5 - Desfazimento: arquivo de informa��o referente a opera��es/presta��es n�o efetivadas .
          Neste caso, o arquivo dever� conter, al�m dos registros tipo 10 e tipo 90, apenas os registros referentes as opera��es/presta��es n�o efetivadas
      }
      FinalidadeArquivo := StrToInt(Copy(ComboBoxFinalidadeArquivo.Text,1,1));
      USintegra.GerarArquivoSintegra(mkeDataIni.Text,mkeDataFim.Text, CodigoConvenio, NaturezaInformacao, FinalidadeArquivo);
    end;
  end;
  if RadioGroup2.ItemIndex = 1 then
  begin
    if Application.MessageBox('Deseja gerar o arquivo do SPED FISCAL (Ato COTEPE/ICMS 09/08)?', 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      Versao := ComboBoxVersaoLeiauteSped.ItemIndex;
      FinalidadeArquivo := ComboBoxVersaoLeiauteSped.ItemIndex;
      Perfil := ComboBoxPerfilSped.ItemIndex;
      USpedFiscal.GerarArquivoSpedFiscal(mkeDataIni.Text,mkeDataFim.Text, Versao, FinalidadeArquivo, Perfil);
    end;
  end;
end;

procedure TFVendasPeriodo.FormActivate(Sender: TObject);
begin
  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);
  mkeDataIni.Text := DateToStr(Now);
  mkeDataFim.Text := DateToStr(Now);
  mkeDataIni.SetFocus;
end;

procedure TFVendasPeriodo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFVendasPeriodo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 123 then
    confirma;
end;

procedure TFVendasPeriodo.RadioGroup2Click(Sender: TObject);
begin
  if RadioGroup2.ItemIndex = 0 then
  begin;
    PageControl1.TabIndex := 0;
  end
  else
  begin
    PageControl1.TabIndex := 1;
  end;
end;

end.
