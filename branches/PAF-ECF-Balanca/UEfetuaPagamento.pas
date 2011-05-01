{*******************************************************************************
Title: T2Ti ERP
Description: Ao finalizar a venda, deve-se informar os meios de pagamento
utilizados.

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

{*******************************************************************************
  Opera��es TEF Discado:

	ATV		Verifica se o Gerenciador Padr�o est� ativo
	ADM		Permite o acionamento da Solu��o TEF Discado para execu��o das fun��es administrativas
	CHQ		Pedido de autoriza��o para transa��o por meio de cheque
	CRT		Pedido de autoriza��o para transa��o por meio de cart�o
	CNC		Cancelamento de venda efetuada por qualquer meio de pagamento
	CNF		Confirma��o da venda e impress�o de cupom
	NCN		N�o confirma��o da venda e/ou da impress�o.
*******************************************************************************}

unit UEfetuaPagamento;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, JvExDBGrids, JvDBGrid, StdCtrls, JvExStdCtrls,
  JvButton, JvCtrls, Buttons, JvExButtons, JvBitBtn, pngimage, ExtCtrls, Mask,
  JvEdit, JvValidateEdit, JvExForms, JvScrollBox, Generics.Collections, Biblioteca,
  JvExControls, JvEnterTab, DB, DBClient, UECF, ACBrTEFD, ACBrTEFDClass,
  TotalTipoPagamentoVO, TipoPagamentoVO, JvCombobox, JvExMask, JvToolEdit, Constantes,
  ACBrDevice, ACBrBase, ACBrECF, ACBrUtil, dateutils;

type
  TFEfetuaPagamento = class(TForm)
    Image1: TImage;
    GroupBox1: TGroupBox;
    JvScrollBox1: TJvScrollBox;
    botaoConfirma: TJvBitBtn;
    GroupBox2: TGroupBox;
    labelDescricaoTotalVenda: TLabel;
    labelTotalVenda: TLabel;
    Bevel1: TBevel;
    labelDescricaoDesconto: TLabel;
    Bevel2: TBevel;
    labelDesconto: TLabel;
    labelDescricaoAcrescimo: TLabel;
    Bevel3: TBevel;
    labelAcrescimo: TLabel;
    labelTotalReceber: TLabel;
    Bevel4: TBevel;
    labelDescricaoTotalReceber: TLabel;
    labelTotalRecebido: TLabel;
    Bevel5: TBevel;
    labelDescricaoTotalRecebido: TLabel;
    labelTroco: TLabel;
    Bevel6: TBevel;
    labelDescricaoTroco: TLabel;
    PanelConfirmaValores: TPanel;
    LabelConfirmaValores: TLabel;
    botaoNao: TBitBtn;
    botaoSim: TBitBtn;
    JvEnterAsTab1: TJvEnterAsTab;
    GridValores: TJvDBGrid;
    CDSValores: TClientDataSet;
    DSValores: TDataSource;
    GroupBox3: TGroupBox;
    ComboTipoPagamento: TComboBox;
    EditValorPago: TJvValidateEdit;
    BotaoCancela: TJvBitBtn;
    labelDescricaoAindaFalta: TLabel;
    labelAindaFalta: TLabel;
    Bevel7: TBevel;
    Label1: TLabel;
    ACBrTEFD: TACBrTEFD;
    Label2: TLabel;
    procedure FechamentoRapido;
    procedure TelaPadrao;
    procedure FechaVendaComProblemas;
    procedure OrdenaLista;
    procedure GravaR06;
    procedure SubTotalizaCupom;
    procedure FormActivate(Sender: TObject);
    procedure botaoConfirmaClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure botaoSimClick(Sender: TObject);
    procedure botaoNaoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditValorPagoExit(Sender: TObject);
    procedure VerificaSaldoRestante;
    procedure FinalizaVenda;
    procedure AtualizaLabelsValores;
    procedure CancelaOperacao;
    procedure BotaoCancelaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure GridValoresKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
    procedure ACBrTEFDAguardaResp(Arquivo: string; SegundosTimeOut: Integer;  var Interromper: Boolean);
    procedure ACBrTEFDAntesCancelarTransacao(RespostaPendente: TACBrTEFDResp);
    procedure ACBrTEFDAntesFinalizarRequisicao(Req: TACBrTEFDReq);
    procedure ACBrTEFDBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
    procedure ACBrTEFDComandaECF(Operacao: TACBrTEFDOperacaoECF;  Resp: TACBrTEFDResp; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer; ImagemComprovante: TStringList; var RetornoECF: Integer);
    procedure ACBrTEFDComandaECFPagamento(IndiceECF: string; Valor: Double; var RetornoECF: Integer);
    procedure ACBrTEFDExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
    procedure ACBrTEFDInfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
    procedure ACBrTEFDRestauraFocoAplicacao(var Tratado: Boolean);
  private
    { Private declarations }
  public
    IdVenda: Integer;
    { Public declarations }
  end;

var
  FEfetuaPagamento: TFEfetuaPagamento;
  ListaTipoPagamento: TObjectList<TTipoPagamentoVO>;
  ListaTotalTipoPagamento: TObjectList<TTotalTipoPagamentoVO>;
  SaldoRestante, TotalVenda, Desconto, Acrescimo, TotalReceber, TotalRecebido, ValorDinheiro, Troco: Extended;
  StatusPagamento: Integer; // 0-em andamento | 1-finalizado
  TransacaoComTef, ImpressaoOK, CupomCancelado, PodeFechar, StatusTransacao: Boolean;
  IndiceTransacaoTef: Integer;

implementation

uses UDataModule, TipoPagamentoController, UCaixa,  TotalTipoPagamentoController, R06VO, RegistroRController;
{$R *.dfm}

procedure TFEfetuaPagamento.FormActivate(Sender: TObject);
begin
  TotalVenda := 0;
  Desconto := 0;
  Acrescimo := 0;
  TotalReceber := 0;
  TotalRecebido := 0;
  ValorDinheiro := 0;
  Troco := 0;
  StatusPagamento := 0;

  Color := StringToColor(UCaixa.Configuracao.CorJanelasInternas);

  if UCaixa.VendaCabecalho.TaxaAcrescimo > 0 then
    UCaixa.VendaCabecalho.Acrescimo := TruncaValor(UCaixa.VendaCabecalho.TaxaAcrescimo/100*UCaixa.VendaCabecalho.ValorVenda,Constantes.TConstantes.DECIMAIS_VALOR);
  if UCaixa.VendaCabecalho.TaxaDesconto > 0 then
    UCaixa.VendaCabecalho.Desconto := TruncaValor(UCaixa.VendaCabecalho.TaxaDesconto/100*UCaixa.VendaCabecalho.ValorVenda,Constantes.TConstantes.DECIMAIS_VALOR);

  //preenche valores nas variaveis
  TotalVenda := UCaixa.VendaCabecalho.ValorVenda;
  Acrescimo := UCaixa.VendaCabecalho.Acrescimo;
  Desconto := UCaixa.VendaCabecalho.Desconto;
  TotalReceber := TruncaValor(TotalVenda + Acrescimo - Desconto,Constantes.TConstantes.DECIMAIS_VALOR);

  SaldoRestante := TotalReceber;
  TransacaoComTef := False;
  CupomCancelado := False;
  PodeFechar := True;
  IndiceTransacaoTef := -1;

  AtualizaLabelsValores;
  EditValorPago.Text := FormatFloat('0.00',SaldoRestante);

  IdVenda := UCaixa.VendaCabecalho.Id;
  ComboTipoPagamento.SetFocus;

  //lista que vai acumular os meios de pagamento
  ListaTotalTipoPagamento := TObjectList<TTotalTipoPagamentoVO>.Create(True);

  //tela padr�o
  TelaPadrao;
end;

procedure TFEfetuaPagamento.AtualizaLabelsValores;
begin
  labelTotalVenda.Caption := FormatFloat('#,###,###,##0.00', TotalVenda);
  labelAcrescimo.Caption := FormatFloat('#,###,###,##0.00', Acrescimo);
  labelDesconto.Caption := FormatFloat('#,###,###,##0.00', Desconto);
  labelTotalReceber.Caption :=  FormatFloat('#,###,###,##0.00', TotalReceber);
  labelTotalRecebido.Caption :=  FormatFloat('#,###,###,##0.00', TotalRecebido);
  if SaldoRestante > 0 then
    labelAindaFalta.Caption :=  FormatFloat('#,###,###,##0.00', SaldoRestante)
  else
    labelAindaFalta.Caption :=  FormatFloat('#,###,###,##0.00', 0);
  labelTroco.Caption :=  FormatFloat('#,###,###,##0.00', Troco);
end;

procedure TFEfetuaPagamento.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CDSValores.Close;
  Action := caFree;
end;

procedure TFEfetuaPagamento.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := PodeFechar;
end;

procedure TFEfetuaPagamento.TelaPadrao;
var
  i: Integer;
begin
  ListaTipoPagamento := TTipoPagamentoController.TabelaTipoPagamento;
  for i := 0 to ListaTipoPagamento.Count - 1 do
    ComboTipoPagamento.Items.Add(TTipoPagamentoVO(ListaTipoPagamento.Items[i]).Descricao);
  ComboTipoPagamento.ItemIndex := 0;

  //configura ClientDataset
  CDSValores.Close;
  CDSValores.FieldDefs.Clear;

  CDSValores.FieldDefs.add('DESCRICAO', ftString, 20);
  CDSValores.FieldDefs.add('VALOR', ftFloat);
  CDSValores.FieldDefs.add('ID', ftInteger);
  //os campos abaixo ser�o utilizados caso seja necessario cancelar uma transacao TEF
  CDSValores.FieldDefs.add('TEF', ftString, 1);
  CDSValores.FieldDefs.add('NSU', ftString, 50);
  CDSValores.FieldDefs.add('REDE', ftString, 50);
  CDSValores.FieldDefs.add('DATA_HORA_TRANSACAO', ftString, 50);
  CDSValores.FieldDefs.add('INDICE_TRANSACAO', ftInteger);
  CDSValores.FieldDefs.add('INDICE_LISTA', ftInteger);
  CDSValores.FieldDefs.add('FINALIZACAO', ftString, 30);
  CDSValores.CreateDataSet;
  TFloatField(CDSValores.FieldByName('VALOR')).displayFormat:='#,###,###,##0.00';
  //definimos os cabe�alhos da Grid
  GridValores.Columns[0].Title.Caption := 'Descri��o';
  GridValores.Columns[0].Width := 130;
  GridValores.Columns[1].Title.Caption := 'Valor';
  //nao exibe as colunas abaixo
  GridValores.Columns.Items[2].Visible := False;
  GridValores.Columns.Items[3].Visible := False;
  GridValores.Columns.Items[4].Visible := False;
  GridValores.Columns.Items[5].Visible := False;
  GridValores.Columns.Items[6].Visible := False;
  GridValores.Columns.Items[7].Visible := False;
  GridValores.Columns.Items[8].Visible := False;
  GridValores.Columns.Items[9].Visible := False;
end;

procedure TFEfetuaPagamento.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if key = 113 then
  begin
    if CDSValores.RecordCount = 0 then
    begin
      if Application.MessageBox('Confirma valores e encerra venda por fechamento r�pido?', 'Finalizar venda', Mb_YesNo + Mb_IconQuestion) = IdYes then
      begin
        FechamentoRapido;
      end;
    end
    else
    begin
      Application.MessageBox('J� existem valores informados. Imposs�vel utilizar Fechamento R�pido.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
    end;
  end;

  if key = 123 then
    botaoConfirma.Click;

  if key = 27 then
    BotaoCancela.Click;

  if key = 116 then
  begin
    if CDSValores.RecordCount > 0 then
      GridValores.SetFocus
    else
    begin
      Application.MessageBox('N�o existem valores informados para serem removidos.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
      ComboTipoPagamento.SetFocus;
    end;
  end;
end;

procedure TFEfetuaPagamento.FechamentoRapido;
begin
  StatusTransacao := True;
  botaoSim.Click;
  if StatusTransacao then
    FinalizaVenda;
end;

//controle das teclas digitadas na Grid
procedure TFEfetuaPagamento.GridValoresKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_DELETE then
  begin
    if CDSValores.FieldByName('TEF').AsString = 'S' then
      Application.MessageBox('Opera��o n�o permitida.', 'Informa��o do Sistema', Mb_OK + MB_ICONINFORMATION)
    else
    begin
      if Application.MessageBox('Deseja remover o valor selecionado?', 'Remover ', Mb_YesNo + Mb_IconQuestion) = IdYes then
      begin
        TotalRecebido := TruncaValor(TotalRecebido - CDSValores.FieldByName('VALOR').AsFloat,Constantes.TConstantes.DECIMAIS_VALOR);
        Troco := TruncaValor(TotalRecebido - TotalReceber,Constantes.TConstantes.DECIMAIS_VALOR);
        if Troco < 0 then
          Troco := 0;

        ListaTotalTipoPagamento.Delete(CDSValores.FieldByName('INDICE_LISTA').AsInteger);

        CDSValores.Delete;
        VerificaSaldoRestante;
        EditValorPago.Text := FormatFloat('0.00',SaldoRestante);
      end;
      ComboTipoPagamento.SetFocus;
    end;
  end;

  if key = 13 then
    ComboTipoPagamento.SetFocus;
end;

procedure TFEfetuaPagamento.BotaoCancelaClick(Sender: TObject);
begin
  CancelaOperacao;
end;

procedure TFEfetuaPagamento.botaoConfirmaClick(Sender: TObject);
begin
  VerificaSaldoRestante;
  //se n�o houver mais saldo no ECF � porque j� devemos finalizar a venda
  if SaldoRestante <= 0 then
  begin
    if Application.MessageBox('Deseja finalizar a venda?', 'Finalizar venda', Mb_YesNo + Mb_IconQuestion) = IdYes then
    begin
      FinalizaVenda;
    end
  end
  else
  begin
    Application.MessageBox('Valores informados n�o s�o suficientes para finalizar a venda.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
  end;
end;

procedure TFEfetuaPagamento.EditValorPagoExit(Sender: TObject);
begin
  if EditValorPago.Value > 0 then
  begin
    VerificaSaldoRestante;
    //se ainda tem saldo no ECF para pagamento
    if SaldoRestante > 0 then
    begin
      PanelConfirmaValores.Visible := True;
      PanelConfirmaValores.BringToFront;
      LabelConfirmaValores.Caption := 'Confirma forma de pagamento e valor?';
      BotaoSim.SetFocus;
    end
    else
      Application.MessageBox('Todos os valores j� foram recebidos. Finalize a venda.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
  end
  else
  begin
    Application.MessageBox('Valor n�o pode ser menor ou igual a zero.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
  end;
end;

procedure TFEfetuaPagamento.VerificaSaldoRestante;
var
  RecebidoAteAgora: Extended;
begin
  RecebidoAteAgora := 0;

  CDSValores.DisableControls;
  CDSValores.First;
  while Not CDSValores.Eof do
  begin
    RecebidoAteAgora := TruncaValor(RecebidoAteAgora + CDSValores.FieldByName('VALOR').AsFloat, Constantes.TConstantes.DECIMAIS_VALOR);
    CDSValores.Next;
  end;
  CDSValores.EnableControls;

  SaldoRestante := TruncaValor(TotalReceber - RecebidoAteAgora, Constantes.TConstantes.DECIMAIS_VALOR);

  AtualizaLabelsValores;
end;

procedure TFEfetuaPagamento.botaoNaoClick(Sender: TObject);
var
  i:integer;
begin
  PanelConfirmaValores.Visible := False;
  ComboTipoPagamento.SetFocus;
end;

procedure TFEfetuaPagamento.botaoSimClick(Sender: TObject);
Var
  TipoPagamento : TTipoPagamentoVO;
  TotalTipoPagamento: TTotalTipoPagamentoVO;
  TotalTipoPagamentoControl: TTotalTipoPagamentoController;
  ValorInformado: Extended;
begin
  TipoPagamento := TTipoPagamentoVO(ListaTipoPagamento.Items[ComboTipoPagamento.ItemIndex]);
  ValorInformado := TruncaValor(EditValorPago.Value,Constantes.TConstantes.DECIMAIS_VALOR);

  TotalTipoPagamento := TTotalTipoPagamentoVO.Create;

  if ((TipoPagamento.TEF = 'S') or (TipoPagamento.PermiteTroco = 'N')) and (ValorInformado > SaldoRestante) then
  begin
    Application.MessageBox('Forma de pagamento selecionada n�o permite troco.', 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
  end
  else
  begin

    StatusTransacao := True;
    if TipoPagamento.TEF = 'S' then
    begin
      try
        ACBrTEFD.Inicializar(TACBrTEFDTipo(1));
        StatusTransacao := ACBrTEFD.CRT( ValorInformado, TipoPagamento.Codigo, FDataModule.ACBrECF.NumCOO);

        if StatusTransacao then
        begin
          Inc(IndiceTransacaoTef);
          TotalTipoPagamento.NSU := ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].NSU;
          TotalTipoPagamento.Rede := ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].Rede;
          TotalTipoPagamento.DataHoraTransacao := DateTimeToStr(ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].DataHoraTransacaoHost);
          TotalTipoPagamento.Finalizacao := ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].Finalizacao;

          if (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao >= 10)
            and (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao <= 12) then
              TotalTipoPagamento.CartaoDebitoOuCredito := 'C';
          if (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao >= 20)
            and (ACBrTEFD.RespostasPendentes[IndiceTransacaoTef].TipoTransacao <= 25) then
              TotalTipoPagamento.CartaoDebitoOuCredito := 'D';

          TransacaoComTef := True;
          PodeFechar := False;
        end;
      except
      end;
    end;

    if StatusTransacao then
    begin

      CDSValores.Append;
      CDSValores.Fields[0].AsString := ComboTipoPagamento.Text;
      CDSValores.Fields[1].AsString := EditValorPago.Text;
      if TipoPagamento.TEF = 'S' then
      begin
        CDSValores.Fields[3].AsString := 'S';
        CDSValores.Fields[4].AsString := TotalTipoPagamento.NSU;
        CDSValores.Fields[5].AsString := TotalTipoPagamento.Rede;
        CDSValores.Fields[6].AsString := TotalTipoPagamento.DataHoraTransacao;
        CDSValores.Fields[7].AsInteger := IndiceTransacaoTef;
        CDSValores.Fields[9].AsString := TotalTipoPagamento.Finalizacao;
      end;
      CDSValores.Post;

      TotalRecebido := TruncaValor(TotalRecebido + StrToFloat(EditValorPago.Value),Constantes.TConstantes.DECIMAIS_VALOR);
      Troco := TruncaValor(TotalRecebido - TotalReceber,Constantes.TConstantes.DECIMAIS_VALOR);
      if Troco < 0 then
        Troco := 0;
      VerificaSaldoRestante;

      TotalTipoPagamento.IdVenda := IdVenda;
      TotalTipoPagamento.IdTipoPagamento := TipoPagamento.Id;
      TotalTipoPagamento.Valor := TruncaValor(StrToFloat(EditValorPago.Text),Constantes.TConstantes.DECIMAIS_VALOR);
      TotalTipoPagamento.CodigoPagamento := TipoPagamento.Codigo;
      TotalTipoPagamento.Estorno := 'N';
      TotalTipoPagamento.TemTEF := TipoPagamento.TEF;

      ListaTotalTipoPagamento.Add(TotalTipoPagamento);

      //guarda o �ndice da lista
      CDSValores.Edit;
      CDSValores.Fields[8].AsInteger := ListaTotalTipoPagamento.Count-1;
      CDSValores.Post;
    end;
    PanelConfirmaValores.Visible := False;
    PanelConfirmaValores.SendToBack;
    ComboTipoPagamento.SetFocus;
    EditValorPago.Text := FormatFloat('0.00',SaldoRestante);
  end;
end;

procedure TFEfetuaPagamento.FinalizaVenda;
var
  i:Integer;
  TotalTipoPagamento:TTotalTipoPagamentoVO;
begin
  ImpressaoOK := True;

  //subtotaliza o cupom
  SubTotalizaCupom;

  //manda os pagamentos para o ECF
  if TransacaoComTef then
    OrdenaLista;

  TotalTipoPagamento := TTotalTipoPagamentoVO.Create;
  for i := 0 to ListaTotalTipoPagamento.Count - 1 do
  begin
    TotalTipoPagamento := ListaTotalTipoPagamento.Items[i];
    FDataModule.ACBrECF.EfetuaPagamento(TotalTipoPagamento.CodigoPagamento, TotalTipoPagamento.Valor);
  end;

  //finaliza o cupom
  ACBrTEFD.FinalizarCupom;

  //imprime as transacoes pendentes - comprovantes nao fiscais vinculados
  ACBrTEFD.ImprimirTransacoesPendentes;

  if ImpressaoOK then
  begin
    //grava os pagamentos no banco de dados
    TTotalTipoPagamentoController.GravaTotaisVenda(ListaTotalTipoPagamento);

    //conclui o encerramento da venda - grava dados de cabecalho no banco
    UCaixa.VendaCabecalho.ValorFinal := TotalReceber;
    UCaixa.VendaCabecalho.ValorRecebido := TotalRecebido;
    UCaixa.VendaCabecalho.Troco := Troco;
    UCaixa.VendaCabecalho.StatusVenda := 'F';
    UCaixa.StatusCaixa := 0;
    FCaixa.ConcluiEncerramentoVenda;
    StatusPagamento := 1;

    FDataModule.ACBrECF.AbreGaveta;

    PodeFechar := True;
    Close;
  end
  else
  begin
    Application.MessageBox('Problemas no ECF. Pagamentos cancelados.', 'Informa��o do Sistema', Mb_OK + MB_ICONINFORMATION);
    if CupomCancelado then
    {
      ocorreu problema na impressao do comprovante do TEF. ECF Desligado.
      Sistema pergunta ao usu�rio se o mesmo quer tentar novamente. Usu�rio responde N�o.
      ECF agora est� ligado e o sistema consegue cancelar o cupom.
    }
    begin
      Application.MessageBox('Cupom fiscal cancelado. Ser� aberto novo cupom e deve-se informar novamente os pagamentos.', 'Informa��o do Sistema', Mb_OK + MB_ICONINFORMATION);
      UCaixa.ProblemaNoPagamento := True;
      UCaixa.VendaCabecalho.CupomFoiCancelado := 'S';
      UCaixa.StatusCaixa := 0;
      FechaVendaComProblemas;
      PodeFechar := True;
      Close;
    end
    else

    {
      ocorreu problema na impressao do comprovante do TEF. ECF Desligado.
      Sistema pergunta ao usu�rio se o mesmo quer tentar novamente. Usu�rio responde N�o.
      ECF continua desligado e o sistema n�o consegue cancelar o cupom.
    }
    begin
      Application.MessageBox('Problemas no ECF. Aplica��o funcionar� apenas para consulta com uma venda pendente.', 'Informa��o do Sistema', Mb_OK + MB_ICONINFORMATION);
      UCaixa.StatusCaixa := 3;
      FechaVendaComProblemas;
      PodeFechar := True;
      Close;
    end;
  end;
end;

procedure TFEfetuaPagamento.FechaVendaComProblemas;
var
  i:Integer;
begin
  //altera o status da venda para P e fecha a aplica��o
  UCaixa.VendaCabecalho.StatusVenda := 'P';
  FCaixa.ConcluiEncerramentoVenda;

  //grava os pagamentos no banco de dados com o indicador de estorno
  for i := 0 to ListaTotalTipoPagamento.Count - 1 do
    TTotalTipoPagamentoVO(ListaTotalTipoPagamento.Items[i]).Estorno := 'S';
  TTotalTipoPagamentoController.GravaTotaisVenda(ListaTotalTipoPagamento);
end;

procedure TFEfetuaPagamento.CancelaOperacao;
begin
  if TransacaoComTef then
  begin
    Application.MessageBox('Pagamento com cart�o j� confirmado.'+#13+#13+'N�o � poss�vel adicionar mais itens.', 'Informa��o do Sistema', Mb_OK + MB_ICONINFORMATION);
    ComboTipoPagamento.SetFocus;
  end
  else
    Close;
end;

procedure TFEfetuaPagamento.SubTotalizaCupom;
begin
  if VendaCabecalho.Desconto > 0 then
    UECF.SubTotalizaCupom(VendaCabecalho.Desconto * -1)
  else if VendaCabecalho.Acrescimo > 0 then
    UECF.SubTotalizaCupom(VendaCabecalho.Acrescimo)
  else
    UECF.SubTotalizaCupom(0);
end;

procedure TFEfetuaPagamento.GravaR06;
var
  R06: TR06VO;
begin
  R06 := TR06VO.Create;
  R06.IdCaixa := UCaixa.Movimento.IdCaixa;
  R06.IdOperador := UCaixa.Movimento.IdOperador;
  R06.IdImpressora := UCaixa.Movimento.IdImpressora;
  R06.COO := StrToInt(FDataModule.ACBrECF.NumCOO);
  R06.GNF := StrToInt(FDataModule.ACBrECF.NumGNF);
  R06.CDC := StrToInt(FDataModule.ACBrECF.NumCDC);
  R06.Denominacao := 'CC';
  R06.DataEmissao := FormatDateTime('yyyy-mm-dd', FDataModule.ACBrECF.DataHora);
  R06.HoraEmissao := FormatDateTime('hh:nn:ss', FDataModule.ACBrECF.DataHora);
  TRegistroRController.GravaR06(R06);
end;

//pode ser muito melhorado
//verificar o m�todo Sort de Generics.Collections juntamente com utiliza��o de TComparer
procedure TFEfetuaPagamento.OrdenaLista;
var
  i:Integer;
  ListaTotalTipoPagamentoLocal: TObjectList<TTotalTipoPagamentoVO>;
begin
  ListaTotalTipoPagamentoLocal := ListaTotalTipoPagamento;
  ListaTotalTipoPagamento := TObjectList<TTotalTipoPagamentoVO>.Create(True);

  //no primeiro la�o insere na lista s� quem nao tem TEF
  for i := 0 to ListaTotalTipoPagamentoLocal.Count - 1 do
  begin
    if TTotalTipoPagamentoVO(ListaTotalTipoPagamentoLocal.Items[i]).TemTEF = 'N' then
      ListaTotalTipoPagamento.Add(TTotalTipoPagamentoVO(ListaTotalTipoPagamentoLocal.Items[i]));
  end;

  //no segundo la�o insere os pagamentos que tem tef
  for i := 0 to ListaTotalTipoPagamentoLocal.Count - 1 do
    if TTotalTipoPagamentoVO(ListaTotalTipoPagamentoLocal.Items[i]).TemTEF = 'S' then
      ListaTotalTipoPagamento.Add(TTotalTipoPagamentoVO(ListaTotalTipoPagamentoLocal.Items[i]));
end;




////////////////////////////////////////////////////////////////////////////////
///  M�todos do Componente ACBrTEFD
////////////////////////////////////////////////////////////////////////////////

procedure TFEfetuaPagamento.ACBrTEFDAguardaResp(Arquivo: string; SegundosTimeOut: Integer; var Interromper: Boolean);
var
  Msg : String ;
begin
  Msg := '' ;
  if (ACBrTEFD.GPAtual in [gpCliSiTef, gpVeSPague]) then //� TEF dedicado?
  begin
    if Arquivo = '23' then  //Est� aguardando Pin-Pad ?
    begin
      if ACBrTEFD.TecladoBloqueado then
      begin
        ACBrTEFD.BloquearMouseTeclado(False);  //Desbloqueia o Teclado
      end ;
      Msg := 'Tecle "ESC" para cancelar.';
     end;
   end
  else
     Msg := 'Aguardando: '+Arquivo+' '+IntToStr(SegundosTimeOut) ;

  if Msg <> '' then
     FCaixa.labelMensagens.Caption := Msg;
  Application.ProcessMessages;
end;

procedure TFEfetuaPagamento.ACBrTEFDAntesCancelarTransacao(RespostaPendente: TACBrTEFDResp);
var
   Est: TACBrECFEstado;
begin
  Est := FDataModule.ACBrECF.Estado;
  case Est of
    estVenda, estPagamento :
    UECF.CancelaCupom;
    estRelatorio: FDataModule.ACBrECF.FechaRelatorio;
  else
  if not (Est in [estLivre, estDesconhecido, estNaoInicializada] ) then
    FDataModule.ACBrECF.CorrigeEstadoErro(False);
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDAntesFinalizarRequisicao(Req: TACBrTEFDReq);
begin
  if Req.Header = 'CRT' then
    Req.GravaInformacao(777,777,'REDECARD');
end;

procedure TFEfetuaPagamento.ACBrTEFDBloqueiaMouseTeclado(Bloqueia: Boolean; var Tratado: Boolean);
begin
  FCaixa.Enabled := not Bloqueia;
  Tratado := False ;  { Se "False" --> Deixa executar o c�digo de Bloqueio do ACBrTEFD }
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECF(Operacao: TACBrTEFDOperacaoECF; Resp: TACBrTEFDResp; var RetornoECF: Integer);
var
  Mensagem: String;
begin
  Mensagem := '';

  try
    case Operacao of
      opeAbreGerencial:
        FDataModule.ACBrECF.AbreRelatorioGerencial ;

      opeCancelaCupom:
        begin
          ImpressaoOK := False;
          try
            UECF.CancelaCupom;
            CupomCancelado := True;
          except
            CupomCancelado := False;
          end;
        end;

      opeFechaCupom:
        begin
          if UCaixa.VendaCabecalho.IdPreVenda > 0 then
            Mensagem := 'PV' + StringOfChar('0',10-Length(IntToStr(UCaixa.VendaCabecalho.IdPreVenda))) + IntToStr(UCaixa.VendaCabecalho.IdPreVenda);
          if UCaixa.VendaCabecalho.IdDAV > 0 then
            Mensagem := Mensagem + 'DAV' + StringOfChar('0',10-Length(IntToStr(UCaixa.VendaCabecalho.IdDAV))) + IntToStr(UCaixa.VendaCabecalho.IdDAV);
          Mensagem := Mensagem + #13 + #10 + UCaixa.MD5 + #13 + #10;
          UECF.FechaCupom(Mensagem + UCaixa.Configuracao.MensagemCupom);
        end;

      opeSubTotalizaCupom:
        FDataModule.ACBrECF.SubtotalizaCupom(0);

      opeFechaGerencial, opeFechaVinculado:
        begin
          FDataModule.ACBrECF.FechaRelatorio;
          GravaR06;
        end;

      opePulaLinhas:
        begin
          FDataModule.ACBrECF.PulaLinhas(FDataModule.ACBrECF.LinhasEntreCupons);
          FDataModule.ACBrECF.CortaPapel(True);
          Sleep(200);
        end;
    end;

    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFAbreVinculado(COO, IndiceECF: string; Valor: Double; var RetornoECF: Integer);
begin
  try
    FDataModule.ACBrECF.AbreCupomVinculado(COO, IndiceECF, Valor);
    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFImprimeVia(TipoRelatorio: TACBrTEFDTipoRelatorio; Via: Integer;ImagemComprovante: TStringList; var RetornoECF: Integer);
begin
  { *** Se estiver usando ACBrECF... Lembre-se de configurar ***
    ACBrECF1.MaxLinhasBuffer   := 3; // Os homologadores permitem no m�ximo
                                     // Impressao de 3 em 3 linhas
    ACBrECF1.LinhasEntreCupons := 7; // (ajuste conforme o seu ECF)
    NOTA: ACBrECF nao possui comando para imprimir a 2a via do CCD }
  try
    case TipoRelatorio of
     trGerencial :
       FDataModule.ACBrECF.LinhaRelatorioGerencial(ImagemComprovante.Text) ;
     trVinculado :
       FDataModule.ACBrECF.LinhaCupomVinculado(ImagemComprovante.Text)
    end;

    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDComandaECFPagamento(IndiceECF: string; Valor: Double; var RetornoECF: Integer);
begin
  try
    FDataModule.ACBrECF.EfetuaPagamento(IndiceECF, Valor);
    RetornoECF := 1 ;
  except
    RetornoECF := 0 ;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDExibeMsg(Operacao: TACBrTEFDOperacaoMensagem; Mensagem: string; var AModalResult: TModalResult);
var
  Fim : TDateTime;
  OldMensagem : String;
begin
  case Operacao of
    opmOK :
      AModalResult := Application.MessageBox(PChar(Mensagem), 'Informa��o do Sistema', MB_OK + MB_ICONINFORMATION);

    opmYesNo :
      AModalResult := Application.MessageBox(PChar(Mensagem), 'Pergunta do Sistema', Mb_YesNo + Mb_IconQuestion);

    opmExibirMsgOperador, opmRemoverMsgOperador :
      FCaixa.labelMensagens.Caption := Mensagem;

    opmExibirMsgCliente, opmRemoverMsgCliente :
      FCaixa.labelMensagens.Caption := Mensagem;

    opmDestaqueVia :
      begin
        OldMensagem := FCaixa.labelMensagens.Caption;
        try
          FCaixa.labelMensagens.Caption := Mensagem ;

          { Aguardando 3 segundos }
          Fim := IncSecond( now, 3)  ;
          repeat
            sleep(200) ;
            FCaixa.labelMensagens.Caption := Mensagem + ' ' + IntToStr(SecondsBetween(Fim,now));
            Application.ProcessMessages;
          until (now > Fim) ;

         finally
           FCaixa.labelMensagens.Caption := OldMensagem ;
         end;
       end;
  end;

  Application.ProcessMessages;
end;


procedure TFEfetuaPagamento.ACBrTEFDInfoECF(Operacao: TACBrTEFDInfoECF; var RetornoECF: string);
begin
  case Operacao of
    ineSubTotal:
      RetornoECF := FormatFloat('0.00',FDataModule.ACBrECF.Subtotal-FDataModule.ACBrECF.TotalPago);

    ineEstadoECF :
      begin
        Case FDataModule.ACBrECF.Estado of
          estLivre     : RetornoECF := 'L' ;
          estVenda     : RetornoECF := 'V' ;
          estPagamento : RetornoECF := 'P' ;
          estRelatorio : RetornoECF := 'R' ;
        else
          RetornoECF := 'O' ;
        end;
      end;
  end;
end;

procedure TFEfetuaPagamento.ACBrTEFDRestauraFocoAplicacao(var Tratado: Boolean);
begin
  Application.BringToFront;
  Tratado := False ;  { Deixa executar o c�digo de Foco do ACBrTEFD }
end;

end.
