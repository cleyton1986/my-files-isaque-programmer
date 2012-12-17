unit UGeContasAPagar;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UGrPadraoCadastro, ImgList, IBCustomDataSet, IBUpdateSQL, DB,
  Mask, DBCtrls, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids, ComCtrls,
  ToolWin, rxToolEdit, RXDBCtrl, IBTable, IBQuery;

type
  TfrmGeContasAPagar = class(TfrmGrPadraoCadastro)
    lblEmpresa: TLabel;
    dbEmpresa: TDBEdit;
    IbDtstTabelaANOLANC: TSmallintField;
    IbDtstTabelaNUMLANC: TIntegerField;
    IbDtstTabelaPARCELA: TSmallintField;
    IbDtstTabelaCODFORN: TSmallintField;
    IbDtstTabelaNOMEFORN: TIBStringField;
    IbDtstTabelaCNPJ: TIBStringField;
    IbDtstTabelaNOTFISC: TIBStringField;
    IbDtstTabelaTIPPAG: TIBStringField;
    IbDtstTabelaDTEMISS: TDateField;
    IbDtstTabelaDTVENC: TDateField;
    IbDtstTabelaVALORPAG: TIBBCDField;
    IbDtstTabelaBANCO: TSmallintField;
    IbDtstTabelaBCO_NOME: TIBStringField;
    IbDtstTabelaNUMCHQ: TIBStringField;
    IbDtstTabelaPAGO_: TIBStringField;
    IbDtstTabelaDOCBAIX: TIBStringField;
    lblData: TLabel;
    edData: TDateTimePicker;
    btbtnEfetuarPagto: TBitBtn;
    IbDtstTabelaNOMEEMP: TIBStringField;
    Bevel5: TBevel;
    GrpBxDadosValores: TGroupBox;
    lblNotaFiscal: TLabel;
    dbNotaFiscal: TDBEdit;
    lblFornecedor: TLabel;
    dbFornecedor: TRxDBComboEdit;
    lblParcela: TLabel;
    dbParcela: TDBEdit;
    dbQuitado: TDBEdit;
    lblEmissao: TLabel;
    dbEmissao: TDBEdit;
    lblVencimento: TLabel;
    dbVencimento: TDBEdit;
    lblValorAPagar: TLabel;
    dbValorAPagar: TDBEdit;
    tblEmpresa: TIBTable;
    dtsEmpresa: TDataSource;
    tblFormaPagto: TIBTable;
    dtsFormaPagto: TDataSource;
    tblCondicaoPagto: TIBTable;
    dtsCondicaoPagto: TDataSource;
    lblFormaPagto: TLabel;
    dbFormaPagto: TDBLookupComboBox;
    lblCondicaoPagto: TLabel;
    dbCondicaoPagto: TDBLookupComboBox;
    pgcMaisDados: TPageControl;
    tbsHistorico: TTabSheet;
    dbObservacao: TDBMemo;
    IbDtstTabelaHISTORIC: TMemoField;
    IbDtstTabelaFORMA_PAGTO: TSmallintField;
    IbDtstTabelaCONDICAO_PAGTO: TSmallintField;
    IbDtstTabelaQUITADO: TSmallintField;
    IbDtstTabelaDTPAG: TDateField;
    lblQuitado: TLabel;
    Bevel6: TBevel;
    dbgPagamentos: TDBGrid;
    Bevel7: TBevel;
    cdsPagamentos: TIBDataSet;
    dtsPagamentos: TDataSource;
    cdsPagamentosANOLANC: TSmallintField;
    cdsPagamentosNUMLANC: TIntegerField;
    cdsPagamentosSEQ: TSmallintField;
    cdsPagamentosHISTORICO: TMemoField;
    cdsPagamentosDATA_PAGTO: TDateField;
    cdsPagamentosFORMA_PAGTO: TSmallintField;
    cdsPagamentosFORMA_PAGTO_DESC: TIBStringField;
    cdsPagamentosVALOR_BAIXA: TIBBCDField;
    cdsPagamentosNUMERO_CHEQUE: TIBStringField;
    cdsPagamentosBANCO: TSmallintField;
    cdsPagamentosBCO_NOME: TIBStringField;
    cdsPagamentosDOCUMENTO_BAIXA: TIBStringField;
    lblTipoDespesa: TLabel;
    dbTipoDespesa: TDBLookupComboBox;
    IbDtstTabelaCODTPDESP: TSmallintField;
    dtsTpDespesa: TDataSource;
    qryTpDespesa: TIBQuery;
    lblLancamentoAberto: TLabel;
    lblCaixaCancelado: TLabel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure dbFornecedorButtonClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure IbDtstTabelaQUITADOGetText(Sender: TField; var Text: String;
      DisplayText: Boolean);
    procedure IbDtstTabelaNewRecord(DataSet: TDataSet);
    procedure btbtnEfetuarPagtoClick(Sender: TObject);
    procedure btbtnSalvarClick(Sender: TObject);
    procedure pgcGuiasChange(Sender: TObject);
    procedure btbtnAlterarClick(Sender: TObject);
    procedure btbtnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbgDadosDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgDadosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    SQL_Pagamentos : TStringList;
    procedure AbrirPagamentos(const Ano : Smallint; const Numero : Integer);
    procedure HabilitarDesabilitar_Btns;
  public
    { Public declarations }
  end;

var
  frmGeContasAPagar: TfrmGeContasAPagar;

const
  STATUS_APAGAR_PENDENTE = 0;
  STATUS_APAGAR_PAGO     = 1;

  procedure MostrarControleContasAPagar(const AOwner : TComponent);

implementation

uses UDMBusiness, UGeFornecedor, DateUtils, UGeEfetuarPagtoPAG;

{$R *.dfm}

procedure MostrarControleContasAPagar(const AOwner : TComponent);
var
  frm : TfrmGeContasAPagar;
  whr : String; 
begin
  frm := TfrmGeContasAPagar.Create(AOwner);
  try
    whr := 'cast(p.dtvenc as date) = ' + QuotedStr( FormatDateTime('yyyy-mm-dd', frm.edData.Date) );

    with frm, IbDtstTabela do
    begin
      Close;
      SelectSQL.Add('where ' + whr);
      SelectSQL.Add('order by ' + CampoOrdenacao);
      Open;
    end;

    frm.ShowModal;
  finally
    frm.Destroy;
  end;
end;

procedure TfrmGeContasAPagar.FormCreate(Sender: TObject);
begin
  IbDtstTabela.GeneratorField.Generator := 'GEN_CONTAPAG_NUM_' + FormatFloat('0000', YearOf(Date));

  inherited;

  SQL_Pagamentos := TStringList.Create;
  SQL_Pagamentos.AddStrings( cdsPagamentos.SelectSQL );

  edData.Date      := Date;
  ControlFirstEdit := dbFornecedor;

  tblEmpresa.Open;
  tblFormaPagto.Open;
  tblCondicaoPagto.Open;
  qryTpDespesa.Open;

  DisplayFormatCodigo := '###0000000';
  NomeTabela     := 'TBCONTPAG';
  CampoCodigo    := 'numlanc';
  CampoDescricao := 'NomeForn';
  CampoOrdenacao := 'p.dtvenc, f.NomeForn';

  UpdateGenerator( 'where anolanc = ' + FormatFloat('0000', YearOf(Date)) );

  UpdateGenerator;
end;

procedure TfrmGeContasAPagar.dbFornecedorButtonClick(Sender: TObject);
var
  iCodigo : Integer;
  sCNPJ   ,
  sNome   : String;
begin
  if ( IbDtstTabela.State in [dsEdit, dsInsert] ) then
    if ( SelecionarFornecedor(Self, iCodigo, sCNPJ, sNome) ) then
    begin
      IbDtstTabelaCODFORN.AsInteger := iCodigo;
      IbDtstTabelaCNPJ.AsString     := sCNPJ;
      IbDtstTabelaNOMEFORN.AsString := sNome;
    end;
end;

procedure TfrmGeContasAPagar.btnFiltrarClick(Sender: TObject);
begin
  WhereAdditional := 'cast(p.dtvenc as date) = ' + QuotedStr( FormatDateTime('yyyy-mm-dd', edData.Date) );
  inherited;
end;

procedure TfrmGeContasAPagar.IbDtstTabelaQUITADOGetText(Sender: TField;
  var Text: String; DisplayText: Boolean);
begin
  if ( Sender.IsNull ) then
    Exit;
    
  Case Sender.AsInteger of
    STATUS_APAGAR_PENDENTE : Text := 'A Pagar';
    STATUS_APAGAR_PAGO     : Text := 'Pago';
    else
      Text := Sender.AsString;
  end;
end;

procedure TfrmGeContasAPagar.IbDtstTabelaNewRecord(DataSet: TDataSet);
begin
  inherited;
  IbDtstTabelaANOLANC.Value := YearOf(Date);
  IbDtstTabelaNOMEEMP.Value := GetEmpresaNomeDefault;
  IbDtstTabelaPARCELA.Value := 0;
  IbDtstTabelaDTEMISS.Value := Date;
  IbDtstTabelaQUITADO.Value := STATUS_APAGAR_PENDENTE;
  IbDtstTabelaFORMA_PAGTO.Value    := GetFormaPagtoIDDefault;
  IbDtstTabelaCONDICAO_PAGTO.Value := GetCondicaoPagtoIDDefault;
end;

procedure TfrmGeContasAPagar.btbtnEfetuarPagtoClick(Sender: TObject);
var
  sSenha   : String;
  iNumero  ,
  CxAno    ,
  CxNumero ,
  CxContaCorrente : Integer;
  DataPagto : TDateTime;
begin
  if ( IbDtstTabela.IsEmpty ) then
    Exit;

  CxAno    := 0;
  CxNumero := 0;
  CxContaCorrente := 0;

  if ( tblCondicaoPagto.Locate('COND_COD', IbDtstTabelaCONDICAO_PAGTO.AsInteger, []) ) then
    if ( tblCondicaoPagto.FieldByName('COND_PRAZO').AsInteger = 0 ) then
      if ( not CaixaAberto(GetUserApp, GetDateDB, IbDtstTabelaFORMA_PAGTO.AsInteger, CxAno, CxNumero, CxContaCorrente) ) then
      begin
        ShowWarning('N�o existe caixa aberto para o usu�rio na forma de pagamento deste movimento.');
        Exit;
      end;

{  sSenha := InputBox('Favor informar a senha de autoriza��o', 'Senha de Autoriza��o:', '');

  if ( Trim(sSenha) = EmptyStr ) then
    Exit;

  if ( sSenha <> GetSenhaAutorizacao ) then
  begin
    ShowWarning('Senha de autoriza��o inv�lida');
    Exit;
  end;
 }
  if PagamentoConfirmado(Self, IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger, IbDtstTabelaFORMA_PAGTO.AsInteger, IbDtstTabelaNOMEFORN.AsString, DataPagto) then
  begin
    iNumero := IbDtstTabelaNUMLANC.AsInteger;

    IbDtstTabela.Close;
    IbDtstTabela.Open;

    IbDtstTabela.Locate('NUMLANC', iNumero, []);

    AbrirPagamentos( IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger );

    if ( CxContaCorrente > 0 ) then
      GerarSaldoContaCorrente(CxContaCorrente, DataPagto);
  end;
end;

procedure TfrmGeContasAPagar.HabilitarDesabilitar_Btns;
begin
  if ( pgcGuias.ActivePage = tbsCadastro ) then
    btbtnEfetuarPagto.Enabled := (IbDtstTabelaQUITADO.AsInteger = STATUS_APAGAR_PENDENTE) and (not IbDtstTabela.IsEmpty)
  else
    btbtnEfetuarPagto.Enabled := False;
end;

procedure TfrmGeContasAPagar.btbtnSalvarClick(Sender: TObject);
begin
  inherited;
  HabilitarDesabilitar_Btns;
end;

procedure TfrmGeContasAPagar.pgcGuiasChange(Sender: TObject);
begin
  inherited;
  AbrirPagamentos( IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger );
end;

procedure TfrmGeContasAPagar.AbrirPagamentos(const Ano: Smallint;
  const Numero: Integer);
begin
  cdsPagamentos.Close;

  with cdsPagamentos, SelectSQL do
  begin
    Clear;
    AddStrings( SQL_Pagamentos );
    Add('where p.Anolanc = ' + IntToStr(Ano));
    Add('  and p.Numlanc = ' + IntToStr(Numero));
    Add('order by p.seq');
  end;

  cdsPagamentos.Open;

  HabilitarDesabilitar_Btns;
end;

procedure TfrmGeContasAPagar.btbtnAlterarClick(Sender: TObject);
begin
  if ( IbDtstTabelaQUITADO.AsInteger = STATUS_APAGAR_PAGO ) then
  begin
    ShowWarning('O Lan�amento n�o poder� ser alterado pois este j� est� quitado!');
    Abort;
  end
  else
  begin
    inherited;
    if ( not OcorreuErro ) then
    begin
      if ( Trim(IbDtstTabelaNOMEEMP.AsString) = EmptyStr ) then
        IbDtstTabelaNOMEEMP.Value := GetEmpresaNomeDefault;
        
      AbrirPagamentos( IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger );
    end;
  end;
end;

procedure TfrmGeContasAPagar.btbtnExcluirClick(Sender: TObject);
begin
  if ( IbDtstTabelaQUITADO.AsInteger = STATUS_APAGAR_PAGO ) then
  begin
    ShowWarning('O Lan�amento n�o poder� ser exclu�do pois este j� est� quitado!');
    Abort;
  end
  else
  begin
    inherited;
    if ( not OcorreuErro ) then
      AbrirPagamentos( IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger );
  end;
end;

procedure TfrmGeContasAPagar.FormShow(Sender: TObject);
begin
  inherited;
  qryTpDespesa.Prior;
  qryTpDespesa.Last;
end;

procedure TfrmGeContasAPagar.dbgDadosDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
begin
  inherited;
  if ( Sender = dbgDados ) then
  begin
    // Destacar Caixas Abertos
    if ( IbDtstTabelaQUITADO.AsInteger = STATUS_APAGAR_PENDENTE ) then
      dbgDados.Canvas.Font.Color := lblLancamentoAberto.Font.Color;

    dbgDados.DefaultDrawDataCell(Rect, dbgDados.Columns[DataCol].Field, State);
  end
//  else
//  // Destacar produtos em Promocao
//  if ( Sender = dbgProdutos ) then
//  begin
//    if ( cdsTabelaItensPUNIT_PROMOCAO.AsCurrency > 0 ) then
//      dbgProdutos.Canvas.Font.Color := lblProdutoPromocao.Font.Color;
//
//    dbgProdutos.DefaultDrawDataCell(Rect, dbgProdutos.Columns[DataCol].Field, State);
//  end;
end;

procedure TfrmGeContasAPagar.dbgDadosKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  CxAno    ,
  CxNumero ,
  CxContaCorrente,
  MovAno    ,
  MovNumero : Integer;
  DataPagto : TDateTime;
begin
  if (Shift = [ssCtrl]) and (Key = 46) Then
  begin
    // Diretoria, Gerente Financeiro, Gerente ADM, Masterdados

    if (not (DMBusiness.ibdtstUsersCODFUNCAO.AsInteger in [1, 3, 5, 12])) then
      Exit;

    if ( not cdsPagamentos.IsEmpty ) then
    begin
      CxAno    := 0;
      CxNumero := 0;
      CxContaCorrente := 0;

      if ( tblFormaPagto.Locate('cod', IbDtstTabelaFORMA_PAGTO.AsInteger, []) ) then
        if ( tblFormaPagto.FieldByName('Conta_corrente').AsInteger > 0 ) then
          if ( not CaixaAberto(GetUserApp, GetDateDB, IbDtstTabelaFORMA_PAGTO.AsInteger, CxAno, CxNumero, CxContaCorrente) ) then
          begin
            ShowWarning('N�o existe caixa aberto para o usu�rio na forma de pagamento deste movimento.');
            Exit;
          end;

      MovAno    := IbDtstTabelaANOLANC.AsInteger;
      MovNumero := IbDtstTabelaNUMLANC.AsInteger;
      DataPagto := cdsPagamentosDATA_PAGTO.AsDateTime;

      if ShowConfirm('Confirma a exclus�o do(s) registro(s) de pagamento(s)?') then
      begin

        with DMBusiness, qryBusca do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Delete from TBCONTPAG_BAIXA');
          SQL.Add('where ANOLANC = ' + cdsPagamentosANOLANC.AsString);
          SQL.Add('  and NUMLANC = ' + cdsPagamentosNUMLANC.AsString);
          ExecSQL;

          CommitTransaction;
        end;

        with DMBusiness, qryBusca do
        begin
          Close;
          SQL.Clear;
          SQL.Add('Update TBCONTPAG Set Quitado = 0, Historic = '''', Dtpag = null, Docbaix = null, Tippag = null, Numchq = null, Banco = null');
          SQL.Add('where ANOLANC = ' + cdsPagamentosANOLANC.AsString);
          SQL.Add('  and NUMLANC = ' + cdsPagamentosNUMLANC.AsString);
          ExecSQL;

          CommitTransaction;
        end;

        IbDtstTabela.Close;
        IbDtstTabela.Open;

        IbDtstTabela.Locate('ANOLANC,NUMLANC', VarArrayOf([MovAno, MovNumero]), []);

        AbrirPagamentos( IbDtstTabelaANOLANC.AsInteger, IbDtstTabelaNUMLANC.AsInteger );

        if ( CxContaCorrente > 0 ) then
          GerarSaldoContaCorrente(CxContaCorrente, DataPagto);
      end;
    end;
  end;
end;

end.
