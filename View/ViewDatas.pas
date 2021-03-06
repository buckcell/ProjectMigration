unit ViewDatas;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls, Vcl.DBGrids,
  ViewFields, Arrays, MyUtils, MyDialogs, Config, DataFlex, Data.DB;

type
  TWindowDatas = class(TForm)
    LblFileName: TLabel;
    GridDatas: TStringGrid;
    LblTotRows: TLabel;
    LblTotCols: TLabel;
    BtnFields: TSpeedButton;
    Images: TImageList;
    Actions: TActionList;
    ActConfigFields: TAction;
    BtnSelect: TSpeedButton;
    ActSelect: TAction;
    PanelSearch: TPanel;
    TxtRowsLimit: TEdit;
    LblRowsLimit: TLabel;
    ActOpenFile: TAction;
    BtnOpenFile: TSpeedButton;
    OpenFile: TFileOpenDialog;
    BtnAlter: TSpeedButton;
    BtnActCell: TSpeedButton;
    BtnDelCell: TSpeedButton;
    BtnAddRow: TSpeedButton;
    BtnDelRow: TSpeedButton;
    BtnAddCol: TSpeedButton;
    BtnDelCol: TSpeedButton;
    BtnCancel: TSpeedButton;
    BtnSave: TSpeedButton;
    BtnSaveAs: TSpeedButton;
    SaveFile: TFileSaveDialog;
    TxtFileName: TLabel;
    CheckConsLimit: TCheckBox;
    TxtRefresh: TEdit;
    AltImages: TImageList;
    AltActions: TActionList;
    ActExport: TAction;
    ActAlter: TAction;
    ActSave: TAction;
    ActCancel: TAction;
    ActAddCell: TAction;
    ActDelCell: TAction;
    ActAddRow: TAction;
    ActDelRow: TAction;
    ActAddCol: TAction;
    ActDelCol: TAction;
    TxtTotRows: TLabel;
    TxtTotCols: TLabel;
    ActEsc: TAction;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActSelectExecute(Sender: TObject);
    procedure TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActAlterExecute(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActAddCellExecute(Sender: TObject);
    procedure ActAddRowExecute(Sender: TObject);
    procedure ActAddColExecute(Sender: TObject);
    procedure ActDelCellExecute(Sender: TObject);
    procedure ActDelRowExecute(Sender: TObject);
    procedure ActDelColExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure ActOpenFileHint(var HintStr: string; var CanShow: Boolean);
    procedure ActEscExecute(Sender: TObject);

  private
    function FillGrid(Rows: TStringList; Limit: integer = 0): integer;
    procedure CleanGrid;
    procedure SetGridTitles;
    procedure SetFileInfos(Rows: TStringList);
    procedure RefreshGrid;
    procedure DisableMode;
    procedure SelectMode;
    procedure NormalMode;
    procedure AlterMode;
    procedure HandlingMode;
    procedure Altered;
    procedure Done;
    function GetFile: TStringList;
    function GridToStrList(ConsLimit: boolean): TStringList;
    function GridIsClean: boolean;

  public
    function ShowModal(Row: integer): integer; overload;

  end;

var
  WindowDatas: TWindowDatas;
  DidChange: boolean = false;

  Mode: integer = 0;
  //0 -> Disable Mode
  //1 -> Select Mode
  //2 -> Normal Mode
  //3 -> Alter Mode
  //4 -> Error Handling Mode

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowDatas.FormActivate(Sender: TObject);
var
  FilePath: string;
begin
  FilePath := TConfig.GetConfig('TEMP', 'FilePath');
  if FilePath <> '' then
  begin
    if FilePath <> TxtFileName.Caption then
    begin
      ActOpenFile.ImageIndex := 2;
      BtnOpenFile.Action := ActOpenFile;
      CleanGrid;
      SetFileInfos(GetFile);
      SelectMode;
    end
    else
    begin
      if GridIsClean then
      begin
        SetFileInfos(GetFile);
        SelectMode;
      end
      else
      begin
        NormalMode;
      end;
    end;
  end
  else
  begin
    DisableMode;
  end;
  Done;
end;

//Quando a janela � fechada
procedure TWindowDatas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if DidChange then
  begin
    case TDialogs.YesNoCancel('Deseja salvar as altera��es?') of
    mrYes:
      ActSave.Execute;
    mrNo:
      ActCancel.Execute;
    mrCancel:
      Action := caNone;
    end;
  end;
end;

//Abre o arquivo Dataflex
procedure TWindowDatas.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    if OpenFile.FileName <> TConfig.GetConfig('TEMP', 'FilePath') then
    begin
      TConfig.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
      ActOpenFile.ImageIndex := 2;
      BtnOpenFile.Action := ActOpenFile;
      CleanGrid;
      SetFileInfos(GetFile);
      SelectMode;
      TxtRowsLimit.SetFocus;
    end;
  end;
end;

//Mostra o caminho do arquivo
procedure TWindowDatas.ActOpenFileHint(var HintStr: string; var CanShow: Boolean);
begin
  HintStr := TUtils.IfEmpty(TConfig.GetConfig('TEMP', 'FilePath'), 'Arquivo Dataflex');
end;

//Abre a configura��o de campos
procedure TWindowDatas.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.ShowModal;
end;

//Quando o enter � pressionado no TxtRowsLimit
procedure TWindowDatas.TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key.ToString = '13' then
  begin
    ActSelect.Execute;
  end;
end;

//Joga os dados Dataflex na tabela
procedure TWindowDatas.ActSelectExecute(Sender: TObject);
begin
  try
    TxtRowsLimit.Text := FillGrid(GetFile, StrToInt(TUtils.IfEmpty(TxtRowsLimit.Text, '0'))).ToString;
    NormalMode;
    Done;
    GridDatas.SetFocus;
  Except on E: Exception do
    ShowMessage('Arquivo Inv�lido: ' + E.ToString);
  end;
end;

//Quando uma Cell da Grid � editada
procedure TWindowDatas.GridDatasSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
begin
  if ARow = GridDatas.RowCount - 1 then
  begin
    ActAddRow.Execute;
  end;

  if ACol = GridDatas.ColCount - 1 then
  begin
    ActAddCol.Execute;
  end;

  Altered;
end;

//Exporta a tabela para um novo dataflex
procedure TWindowDatas.ActExportExecute(Sender: TObject);
begin
  SaveFile.FileName := 'NovoDataflex';
  if SaveFile.Execute then
  begin
    if FileExists(SaveFile.FileName) then
    begin
      if TDialogs.YesNo('Arquivo existente, deseja sobrescrev�-lo?') = mrYes then
      begin
        GridToStrList(CheckConsLimit.Checked).SaveToFile(SaveFile.FileName);
        if SaveFile.FileName = TConfig.GetConfig('TEMP', 'FilePath') then
        begin
          CleanGrid;
          SetFileInfos(GetFile);
          SelectMode;
        end;
      end;
    end
    else
    begin
      GridToStrList(CheckConsLimit.Checked).SaveToFile(SaveFile.FileName);
        if SaveFile.FileName = TConfig.GetConfig('TEMP', 'FilePath') then
        begin
          CleanGrid;
          SetFileInfos(GetFile);
          SelectMode;
        end;
    end;
  end;
end;

//Ativa o modo de edi��o da Grid
procedure TWindowDatas.ActAlterExecute(Sender: TObject);
begin
  AlterMode;
end;

//Salva as altera��es feitas no aquivo
procedure TWindowDatas.ActSaveExecute(Sender: TObject);
begin
  GridToStrList(CheckConsLimit.Checked).SaveToFile(TConfig.GetConfig('TEMP', 'FilePath'));
  SetFileInfos(GetFile);
  RefreshGrid;
  Done;
  NormalMode;
end;

//Cancela as altera��es
procedure TWindowDatas.ActCancelExecute(Sender: TObject);
begin
  if DidChange then
  begin
    case TDialogs.YesNoCancel('Deseja salvar as altera��es?') of
      mrYes:
      begin
        ActSave.Execute;
      end;
      mrNo:
      begin
        TxtRowsLimit.Text := FillGrid(GetFile, StrToInt(TUtils.IfEmpty(TxtRowsLimit.Text, '0'))).ToString;

        NormalMode;

        RefreshGrid;

        Done;
      end;
    end;
  end
  else
  begin
    NormalMode;

    RefreshGrid;

    Done;
  end;
end;

//Adiciona uma nova c�lula na Grid
procedure TWindowDatas.ActAddCellExecute(Sender: TObject);
var
  Row, Col, Cont: integer;
begin
  Row := GridDatas.Row;
  Col := GridDatas.Col;

  for Cont := GridDatas.ColCount - 1 downto Col + 1 do
  begin
    GridDatas.Cells[Cont, Row] := GridDatas.Cells[Cont - 1, Row];
  end;

  GridDatas.Cells[Col, Row] := '';

  RefreshGrid;

  Altered;
end;

//Remove a c�lula selecionada na Grid
procedure TWindowDatas.ActDelCellExecute(Sender: TObject);
var
  Row, Col, Cont: integer;
begin
  Row := GridDatas.Row;
  Col := GridDatas.Col;

  for Cont := Col to GridDatas.ColCount - 1 do
  begin
    GridDatas.Cells[Cont, Row] := GridDatas.Cells[Cont + 1, Row];
  end;

  GridDatas.Cells[GridDatas.ColCount - 1, Row] := '';

  RefreshGrid;

  Altered;
end;

//Adiona uma nova linha na Grid
procedure TWindowDatas.ActAddRowExecute(Sender: TObject);
var
  Row, Cont: integer;
begin
  Row := GridDatas.Row;

  GridDatas.RowCount := GridDatas.RowCount + 1;

  for Cont := GridDatas.RowCount - 1 downto Row + 1 do
  begin
    GridDatas.Rows[Cont] := GridDatas.Rows[Cont - 1];
  end;

  if Row <> GridDatas.RowCount - 2 then
  begin
    GridDatas.Rows[Row].Clear;
    RefreshGrid;
  end;

  SetGridTitles;

  Altered;
end;

//Remove a linha selecionada na Grid
procedure TWindowDatas.ActDelRowExecute(Sender: TObject);
var
  Row, Cont: integer;
begin
  Row := GridDatas.Row;

  if (GridDatas.RowCount > 2) and (Row <> GridDatas.RowCount - 1) then
  begin
    GridDatas.RowCount := GridDatas.RowCount - 1;

    for Cont := Row to GridDatas.RowCount - 1 do
    begin
      GridDatas.Rows[Cont] := GridDatas.Rows[Cont + 1];
    end;

    SetGridTitles;

    RefreshGrid;

    Altered;
  end;
end;

//Adiciona uma nova coluna na Grid
procedure TWindowDatas.ActAddColExecute(Sender: TObject);
var
  Col, Cont: integer;
begin
  Col := GridDatas.Col;

  GridDatas.ColCount := GridDatas.ColCount + 1;

  for Cont := GridDatas.ColCount - 1 downto Col + 1 do
  begin
    GridDatas.Cols[Cont] := GridDatas.Cols[Cont - 1];
  end;

  if Col <> GridDatas.ColCount - 2 then
  begin
    GridDatas.Cols[Col].Clear;
    RefreshGrid;
  end;

  SetGridTitles;

  Altered;
end;

//Remove a coluna selecionada na Grid
procedure TWindowDatas.ActDelColExecute(Sender: TObject);
var
  Col, Cont: integer;
begin
  Col := GridDatas.Col;

  if (GridDatas.ColCount > 2) and (Col <> GridDatas.ColCount - 1) then
  begin
    GridDatas.ColCount := GridDatas.ColCount - 1;

    for Cont := Col to GridDatas.ColCount - 1 do
    begin
      GridDatas.Cols[Cont] := GridDatas.Cols[Cont + 1];
    end;

    SetGridTitles;

    RefreshGrid;

    Altered;
  end;
end;

//Insere os dados do arquivo Dataflex na Grid
function TWindowDatas.FillGrid(Rows: TStringList; Limit: integer): integer;
var
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol: integer;
begin
  if Rows.Count = 0 then
  begin
    CleanGrid;
    SetGridTitles;
  end
  else
  begin
    DataFlex := TDataFlex.Create(Rows, ';');
    SetLength(Datas, DataFlex.GetRowCount, DataFlex.GetColCount);
    Datas := DataFlex.ToMatrix;

    try
      if (Limit > DataFlex.GetRowCount) or (Limit = 0) then
      begin
        Limit := DataFlex.GetRowCount;
      end;

      CleanGrid;

      GridDatas.RowCount := Limit + 2;
      GridDatas.ColCount := DataFlex.GetColCount + 2;

      SetGridTitles;

      for ContRow := 1 to Limit do
      begin
        for ContCol := 1 to DataFlex.GetColCount do
        begin
          GridDatas.Cells[ContCol, ContRow] := Datas[ContRow - 1, ContCol - 1];
        end;
      end;
    finally
      FreeAndNil(DataFlex);
    end;
  end;
  Result := Limit;
end;

//Limpa os dados da Grid
procedure TWindowDatas.CleanGrid;
begin
  GridDatas.RowCount := 2;
  GridDatas.ColCount := 2;
  GridDatas.Rows[0].Clear;
  GridDatas.Rows[1].Clear;
end;

//Insere os titulos das linhas e colunas fixadas na Grid
procedure TWindowDatas.SetGridTitles;
var
  Cont: integer;
begin
  for Cont := 1 to GridDatas.RowCount - 2 do
  begin
    GridDatas.Cells[0, Cont] := 'Dado ' + Cont.ToString;
  end;

  GridDatas.Rows[GridDatas.RowCount - 1].Clear;

  GridDatas.Cells[0, GridDatas.RowCount - 1] := '      +';

  for Cont := 1 to GridDatas.ColCount - 2 do
  begin
    GridDatas.Cells[Cont, 0] := 'Campo ' + Cont.ToString;
  end;

  GridDatas.Cols[GridDatas.ColCount - 1].Clear;

  GridDatas.Cells[GridDatas.ColCount - 1, 0] := '    +';
end;

//Insere as informa��es da grid nos campos acima dela
procedure TWindowDatas.SetFileInfos(Rows: TStringList);
var
  DataFlex: TDataFlex;
begin
  DataFlex := TDataFlex.Create(Rows, ';');

  try
    TxtFileName.Caption := OpenFile.FileName;
    TxtTotRows.Caption := DataFlex.GetRowCount.ToString;
    TxtTotCols.Caption := DataFlex.GetColCount.ToString;
  finally
    FreeAndNil(DataFlex);
  end;
end;

//Desfoca e foca na tabela para atualiz�-la
procedure TWindowDatas.RefreshGrid;
begin
  TxtRefresh.SetFocus;
  GridDatas.SetFocus;
end;

//Modo Buttons desabilitados
procedure TWindowDatas.DisableMode;
begin
  TxtFileName.Caption := '';
  TxtTotRows.Caption := '';
  TxtTotCols.Caption := '';
  ActOpenFile.Enabled := true;
  ActConfigFields.Enabled := true;
  TxtRowsLimit.Enabled := false;
  TxtRowsLimit.Clear;
  CheckConsLimit.Enabled := false;
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActExport.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  Mode := 0;
end;

//Modo Button Select ativado
procedure TWindowDatas.SelectMode;
begin
  //TxtFileName.Caption := '';
  //TxtTotRows.Caption := 'Dados:';
  //TxtTotCols.Caption := 'Campos:';
  ActOpenFile.Enabled := true;
  ActConfigFields.Enabled := true;
  TxtRowsLimit.Enabled := true;
  TxtRowsLimit.Clear;
  CheckConsLimit.Enabled := true;
  ActSelect.Enabled := true;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActExport.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  Mode := 1;
end;

//Modo Buttons normais
procedure TWindowDatas.NormalMode;
begin
  //TxtFileName.Caption := '';
  //TxtTotRows.Caption := 'Dados:';
  //TxtTotCols.Caption := 'Campos:';
  ActOpenFile.Enabled := true;
  ActConfigFields.Enabled := true;
  TxtRowsLimit.Enabled := true;
  //TxtRowsLimit.Clear;
  CheckConsLimit.Enabled := true;
  ActSelect.Enabled := true;
  ActAlter.Enabled := true;
  ActSave.Enabled := false;
  ActExport.Enabled := true;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options - [goEditing];
  Mode := 2;
end;

//Modo Buttons em altera��o
procedure TWindowDatas.AlterMode;
begin
  //TxtFileName.Caption := '';
  //TxtTotRows.Caption := 'Dados:';
  //TxtTotCols.Caption := 'Campos:';
  ActOpenFile.Enabled := false;
  ActConfigFields.Enabled := true;
  TxtRowsLimit.Enabled := false;
  //TxtRowsLimit.Clear;
  CheckConsLimit.Enabled := true;
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActExport.Enabled := true;
  ActCancel.Enabled := true;
  ActAddCell.Enabled := true;
  ActDelCell.Enabled := true;
  ActAddRow.Enabled := true;
  ActDelRow.Enabled := true;
  ActAddCol.Enabled := true;
  ActDelCol.Enabled := true;
  GridDatas.Options := GridDatas.Options + [goEditing];
  Mode := 3;
end;

//Modo Buttons em tratamento de erro
procedure TWindowDatas.HandlingMode;
begin
  //TxtFileName.Caption := '';
  //TxtTotRows.Caption := 'Dados:';
  //TxtTotCols.Caption := 'Campos:';
  ActOpenFile.Enabled := false;
  ActConfigFields.Enabled := false;
  TxtRowsLimit.Enabled := false;
  //TxtRowsLimit.Clear;
  CheckConsLimit.Enabled := false;
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActExport.Enabled := true;
  ActCancel.Enabled := true;
  ActAddCell.Enabled := true;
  ActDelCell.Enabled := true;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
  GridDatas.Options := GridDatas.Options + [goEditing];
  Mode := 4;
end;

//Quando a Grid � editada
procedure TWindowDatas.Altered;
begin
  DidChange := true;
  ActSave.Enabled := true;
end;

//Quando as altera��es s�o salvas ou descartadas
procedure TWindowDatas.Done;
begin
  DidChange := false;
  ActSave.Enabled := false;
end;

//Retorna o arquivo selecionado em uma StringList
function TWindowDatas.GetFile: TStringList;
begin
  Result := TStringList.Create;
  Result.LoadFromFile(TConfig.GetConfig('TEMP', 'FilePath'));
end;

//Retorna os dados da Grid em linhas numa StringList
function TWindowDatas.GridToStrList(ConsLimit: boolean): TStringList;
var
  Cont: integer;
  Rows: TStringList;
begin
  Result := TStringList.Create;

  for Cont := 1 to GridDatas.RowCount - 2 do
  begin
    Result.Add(TUtils.ArrayToStr(GridDatas.Rows[Cont].ToStringArray, ';', '', 1, 1));
  end;

  if not ConsLimit then
  begin
    Rows := GetFile;
    if Rows.Count <> 0 then
    begin
      for Cont := StrToInt(TxtRowsLimit.Text) to Rows.Count - 1 do
      begin
        Result.Add(Rows[Cont]);
      end;
    end;
  end;
end;

//Verifica se a Grid est� vazia
function TWindowDatas.GridIsClean: boolean;
begin
  Result := GridDatas.Cells[0, 1].IsEmpty and GridDatas.Cells[1, 0].IsEmpty and GridDatas.Cells[1, 1].IsEmpty;
end;

//Iniciar a janela com dados j� selecionados
function TWindowDatas.ShowModal(Row: integer): integer;
begin
  NormalMode;
  TxtRowsLimit.Text :=  FillGrid(GetFile, Row).ToString;
  GridDatas.Row := Row;
  GridDatas.Col := 1;
  inherited ShowModal;
end;

//Quando a tecla Esc � pressionada
procedure TWindowDatas.ActEscExecute(Sender: TObject);
begin
  if Mode = 3 then
  begin
    ActCancel.Execute;
  end
  else
  begin
    Close;
  end;
end;

end.
