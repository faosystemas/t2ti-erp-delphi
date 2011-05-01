{*******************************************************************************
Title: T2Ti ERP
Description: Janela para controle de login do gerente/supervisor.

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
unit ULoginGerenteSupervisor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, DB, MovimentoVO, FMTBcd, Provider, DBClient, SqlExpr,
  JvExControls, JvEnterTab, Biblioteca;

type
  TFLoginGerenteSupervisor = class(TForm)
    Image1: TImage;
    botaoConfirma: TJvBitBtn;
    botaoCancela: TJvImgBtn;
    JvEnterAsTab1: TJvEnterAsTab;
    GroupBox1: TGroupBox;
    editLoginGerente: TLabeledEdit;
    editSenhaGerente: TLabeledEdit;
    ComboCargo: TComboBox;
    procedure confirma;
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoConfirmaClick(Sender: TObject);
  private
    FLoginOK : Boolean;
    FGerenteOuSupervisor: String;
    { Private declarations }
  public
    property GerenteOuSupervisor: String read FGerenteOuSupervisor write FGerenteOuSupervisor;
    property LoginOK: Boolean read FLoginOK write FLoginOK;
    { Public declarations }
  end;

var
  FLoginGerenteSupervisor: TFLoginGerenteSupervisor;
  Movimento: TMovimentoVO;

implementation

uses UDataModule, CaixaController, OperadorController, OperadorVO,
  MovimentoController, SuprimentoVO, UCaixa;

{$R *.dfm}

procedure TFLoginGerenteSupervisor.FormActivate(Sender: TObject);
begin
  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);
end;

procedure TFLoginGerenteSupervisor.botaoConfirmaClick(Sender: TObject);
begin
  confirma;
end;

procedure TFLoginGerenteSupervisor.confirma;
var
  Operador: TOperadorVO;
begin
  try
    try
      // verifica se senha do gerente/supervisor esta correta
      Operador := TOperadorController.ConsultaUsuario(editLoginGerente.Text,editSenhaGerente.Text);
      if Operador.Id <> 0 then
      begin
        if ComboCargo.ItemIndex = 0 then
          GerenteOuSupervisor := 'G'
        else if ComboCargo.ItemIndex = 1 then
          GerenteOuSupervisor := 'S';

        //verifica nivel de acesso do gerente/supervisor
        if Operador.Nivel = GerenteOuSupervisor then
          LoginOK := True
        else
          LoginOK := False;
      end
    except
    end;
  finally
  end;
end;

procedure TFLoginGerenteSupervisor.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 123 then
    botaoConfirma.Click;
end;

end.
