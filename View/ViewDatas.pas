unit ViewDatas;

interface

uses
  System.SysUtils, System.Classes, System.Types, Winapi.Windows, Winapi.Messages, System.Variants, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Actions, Vcl.ActnList,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, Vcl.ExtCtrls,
  ViewFields, Arrays, MyUtils, Configs, DataFlex;

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
    ActAlter: TAction;
    ActAddCell: TAction;
    ActAddRow: TAction;
    ActAddCol: TAction;
    ActDelCell: TAction;
    ActDelRow: TAction;
    ActDelCol: TAction;
    BtnActCell: TSpeedButton;
    BtnDelCell: TSpeedButton;
    BtnAddRow: TSpeedButton;
    BtnDelRow: TSpeedButton;
    BtnAddCol: TSpeedButton;
    BtnDelCol: TSpeedButton;
    BtnCancel: TSpeedButton;
    ActCancel: TAction;
    BtnSave: TSpeedButton;
    ActSave: TAction;
    ActSaveAs: TAction;
    BtnSaveAs: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ActOpenFileExecute(Sender: TObject);
    procedure ActConfigFieldsExecute(Sender: TObject);
    procedure ActSelectExecute(Sender: TObject);
    procedure TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ActAlterExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActCancelExecute(Sender: TObject);
    procedure ActAddCellExecute(Sender: TObject);
    procedure ActAddRowExecute(Sender: TObject);
    procedure ActAddColExecute(Sender: TObject);
    procedure ActDelCellExecute(Sender: TObject);
    procedure ActDelRowExecute(Sender: TObject);
    procedure ActDelColExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);

  private
    procedure FillGrid;
    procedure CleanGrid;
    procedure EnableButtons;
    procedure DisableButtons;
    function GridToStrList: TStringList;
  end;

var
  WindowDatas: TWindowDatas;

implementation

{$R *.dfm}

//Quando a janela � aberta
procedure TWindowDatas.FormActivate(Sender: TObject);
begin
  if TConfigs.GetConfig('TEMP', 'FilePath').Trim <> '' then
  begin
    LblFileName.Caption := 'Arquivo Dataflex: ' + TConfigs.GetConfig('TEMP', 'FilePath');
    ActOpenFile.ImageIndex := 2;
    BtnOpenFile.Action := ActOpenFile;
    EnableButtons;
  end;
end;

//Quando a janela � fechada
procedure TWindowDatas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WindowFields.Close;
end;

//Abre o arquivo Dataflex
procedure TWindowDatas.ActOpenFileExecute(Sender: TObject);
begin
  if OpenFile.Execute then
  begin
    TConfigs.SetConfig('TEMP', 'FilePath', OpenFile.FileName);
    ActOpenFile.ImageIndex := 2;
    BtnOpenFile.Action := ActOpenFile;
    LblFileName.Caption := 'Arquivo Dataflex: ' + TConfigs.GetConfig('TEMP', 'FilePath');
    CleanGrid;
    EnableButtons;
  end;
end;

//Abre a configura��o de campos
procedure TWindowDatas.ActConfigFieldsExecute(Sender: TObject);
begin
  WindowFields.Show;
end;

//Verifica se h� arquivo selecionado e chama o FillGrid
procedure TWindowDatas.ActSelectExecute(Sender: TObject);
begin
  if TConfigs.GetConfig('TEMP', 'FilePath') = '' then
  begin
    ShowMessage('Selecione um arquivo!');
  end
  else
  begin
    FillGrid;
  end;
end;

//Quando o enter � pressionado no TxtRowsLimit
procedure TWindowDatas.TxtRowsLimitKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key.ToString = '13' then
  begin
    ActSelectExecute(BtnSelect);
  end;
end;

//Ativa o modo de edi��o da Grid
procedure TWindowDatas.ActAlterExecute(Sender: TObject);
begin
  GridDatas.Options := GridDatas.Options + [goEditing];
  ActAlter.Enabled := false;
  ActSave.Enabled := true;
  ActCancel.Enabled := true;
end;

procedure TWindowDatas.ActSaveExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActSaveAsExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActCancelExecute(Sender: TObject);
begin
  GridDatas.Options := GridDatas.Options - [goEditing];
  ActCancel.Enabled := false;
  ActSave.Enabled := false;
  ActAlter.Enabled := true;
  GridDatas.Row := 1;
  GridDatas.Col := 1;
  FillGrid;
end;

procedure TWindowDatas.ActAddCellExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActDelCellExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActAddRowExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActDelRowExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActAddColExecute(Sender: TObject);
begin
  //
end;

procedure TWindowDatas.ActDelColExecute(Sender: TObject);
begin
  //
end;

//Insere os dados do arquivo Dataflex na Grid
procedure TWindowDatas.FillGrid;
var
  Rows: TStringList;
  DataFlex: TDataFlex;
  Datas: TStringMatrix;
  ContRow, ContCol, TotRows: integer;
begin
  Rows := TStringList.Create;
  Rows.LoadFromFile(TConfigs.GetConfig('TEMP', 'FilePath'));
  DataFlex := TDataFlex.Create(Rows, ';');
  SetLength(Datas, DataFlex.GetRows, DataFlex.GetCols);
  Datas := DataFlex.ToMatrix;

  if Trim(TxtRowsLimit.Text) = '' then
  begin
    TotRows := 0;
  end
  else
  begin
    TotRows := StrToInt(TxtRowsLimit.Text);
  end;

  if (TotRows > DataFlex.GetRows) or (TotRows = 0) then
  begin
    TotRows := DataFlex.GetRows;
    TxtRowsLimit.Text := DataFlex.GetRows.ToString;
  end;

  GridDatas.RowCount := TotRows + 1;
  GridDatas.ColCount := DataFlex.GetCols + 1;
  LblTotRows.Caption := 'Dados: ' + DataFlex.GetRows.ToString;
  LblTotCols.Caption := 'Campos: ' + DataFlex.GetCols.ToString;

  for ContRow := 1 to TotRows do
  begin
    GridDatas.Cells[0, ContRow] := 'Dado ' + ContRow.ToString;
  end;

  for ContCol := 1 to DataFlex.GetCols do
  begin
    GridDatas.Cells[ContCol, 0] := 'Campo ' + ContCol.ToString;
  end;

  for ContRow := 1 to TotRows do
  begin
    for ContCol := 1 to DataFlex.GetCols do
    begin
      GridDatas.Cells[ContCol, ContRow] := Datas[ContRow - 1, ContCol - 1];
    end;
  end;
end;

//Limpa os dados da Grid
procedure TWindowDatas.CleanGrid;
begin
  GridDatas.RowCount := 2;
  GridDatas.ColCount := 2;
  GridDatas.Rows[0].Clear;
  GridDatas.Cols[0].Clear;
  GridDatas.Cols[1].Clear;
end;

procedure TWindowDatas.EnableButtons;
begin
  ActSelect.Enabled := true;
  ActAlter.Enabled := true;
  ActSaveAs.Enabled := true;
end;

procedure TWindowDatas.DisableButtons;
begin
  ActSelect.Enabled := false;
  ActAlter.Enabled := false;
  ActSave.Enabled := false;
  ActSaveAs.Enabled := false;
  ActCancel.Enabled := false;
  ActAddCell.Enabled := false;
  ActDelCell.Enabled := false;
  ActAddRow.Enabled := false;
  ActDelRow.Enabled := false;
  ActAddCol.Enabled := false;
  ActDelCol.Enabled := false;
end;

//Retorna os dados da Grid em linhas numa StringList
function TWindowDatas.GridToStrList: TStringList;
var
  Cont: integer;
begin
  Result := TStringList.Create;
  for Cont := 1 to GridDatas.RowCount - 1 do
  begin
    Result.Add(TUtils.ArrayToStr(GridDatas.Rows[Cont].ToStringArray, 1, ';', ''));
  end;
end;

end.