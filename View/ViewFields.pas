unit ViewFields;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Grids, Vcl.StdCtrls, Vcl.Buttons, Data.DB, Vcl.DBGrids,
  System.ImageList, Vcl.ImgList, System.Actions, Vcl.ActnList, DAO, MyUtils, ViewDados, shlObj;

type
  TWindowFields = class(TForm)
    LblTitle1: TLabel;
    GridFields: TStringGrid;
    LblTable: TLabel;
    LblTitle2: TLabel;
    LblTotFields: TLabel;
    Actions: TActionList;
    Images: TImageList;
    BtnExport: TSpeedButton;
    ActExport: TAction;
    BtnImport: TSpeedButton;
    ActImport: TAction;
    SaveFile: TFileSaveDialog;
    OpenFile: TFileOpenDialog;
    ActOrdFields: TAction;
    BtnOrdFields: TSpeedButton;
    BtnClearFields: TSpeedButton;
    ActClearFields: TAction;
    procedure FormActivate(Sender: TObject);
    procedure ActExportExecute(Sender: TObject);
    procedure ActImportExecute(Sender: TObject);
    procedure ActOrdFieldsExecute(Sender: TObject);
    procedure ActClearFieldsExecute(Sender: TObject);

  private
    procedure GridTitles;

  public
    function GetOrder: TIntegerArray;
    function GetDefauts: TStringArray;

  end;

var
  WindowFields: TWindowFields;

implementation

{$R *.dfm}

procedure TWindowFields.ActClearFieldsExecute(Sender: TObject);
begin
  GridFields.Cols[3].Clear;
  GridFields.Cells[3, 0] := 'N� Campo Dataflex';
end;

procedure TWindowFields.ActExportExecute(Sender: TObject);
var
  Arq: TextFile;
  Cont: integer;
begin
  if SaveFile.Execute then
  begin
    AssignFile(Arq, SaveFile.FileName);
    Rewrite(Arq);
    for Cont := 1 to GridFields.RowCount - 1 do
    begin
      Writeln(Arq, GridFields.Cells[3, Cont]);
    end;
    CloseFile(Arq);
  end;
end;

procedure TWindowFields.ActImportExecute(Sender: TObject);
var
  Rows: TStringList;
  Cont: integer;
begin
  Rows := TStringList.Create;
  try
    if OpenFile.Execute then
    begin
      Rows.LoadFromFile(OpenFile.FileName);
      GridFields.Cols[3].Clear;
      GridFields.Cells[3, 0] := 'N� Campo Dataflex';
      for  Cont := 0 to TUtils.Iff(Rows.Count > GridFields.RowCount, GridFields.RowCount, Rows.Count) - 1 do
      begin
        GridFields.Cells[3, Cont + 1] := Rows[Cont];
      end;
    end;
  finally
    FreeAndNil(Rows);
  end;
end;

procedure TWindowFields.ActOrdFieldsExecute(Sender: TObject);
var
  Cont: integer;
begin
  for Cont := 0 to GridFields.RowCount - 1 do
  begin
    GridFields.Cells[3, Cont + 1] := IntToStr(Cont + 1);
  end;
end;

procedure TWindowFields.FormActivate(Sender: TObject);
var
  Cont: integer;
  Fields, Types: TStringArray;
  NotNulls: TIntegerArray;
begin
  try
    GridFields.ColWidths[1] := 100;
    GridFields.ColWidths[2] := 50;
    GridFields.ColWidths[3] := 100;
    GridFields.ColWidths[4] := 100;
    GridFields.Cells[0, 0] := 'Campo Firebird';
    GridFields.Cells[1, 0] := 'Tipo Do Campo';
    GridFields.Cells[2, 0] := 'Not Nulls';
    GridFields.Cells[3, 0] := 'N� Campo Dataflex';
    GridFields.Cells[4, 0] := 'Valor Padr�o';

    //Limpando Tabela
    {
    LblTable.Caption := '';
    GridFields.RowCount := 2;
    GridFields.Cells[0, 1] := '';
    GridFields.Cells[1, 1] := '';
    GridFields.Cells[2, 1] := '';
    GridFields.Cells[3, 1] := '';
    }
    //Limpando Tabela

    if TDAO.Count <> 0 then
    begin
      LblTable.Caption := TDAO.Table;
      SetLength(Fields, TDAO.Count);
      Fields := TDAO.GetFieldsNames;
      SetLength(Types, TDAO.Count);
      Types := TDAO.GetFieldsTypes;
      SetLength(NotNulls, TDAO.Count);
      NotNulls := TDAO.GetFieldsNotNulls;
      GridFields.RowCount := TDAO.Count + 1;
      for Cont := 0 to TDAO.Count - 1 do
      begin
        GridFields.Cells[0, Cont + 1] := Fields[Cont];
        GridFields.Cells[1, Cont + 1] := Types[Cont];
        GridFields.Cells[2, Cont + 1] := TUtils.Iff(NotNulls[Cont] = 1, 'Not Null', '');
      end;
    end
    else
    begin
      ShowMessage('Selecione uma tabela!');
    end;
  finally
    LblTotFields.Caption := 'Total Campos Firebird: ' + TDAO.Count.ToString;
  end;
end;

function TWindowFields.GetOrder: TIntegerArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to TDAO.Count - 1 do
  begin
    if (GridFields.Cells[3, Cont + 1].IsEmpty) or (StrToInt(GridFields.Cells[3, Cont + 1]) <= 0) then
    begin
      Result[Cont] := -1;
    end
    else
    begin
      Result[Cont] := GridFields.Cells[3, Cont + 1].ToInteger;
    end;
  end;
end;

procedure TWindowFields.GridTitles;
begin
  GridFields.Cells[0, 0] := 'Campo Firebird';
  GridFields.Cells[1, 0] := 'Tipo Do Campo';
  GridFields.Cells[2, 0] := 'Not Nulls';
  GridFields.Cells[3, 0] := 'N� Campo Dataflex';
  GridFields.Cells[4, 0] := 'Valor Padr�o';
end;

function TWindowFields.GetDefauts: TStringArray;
var
  Cont: integer;
begin
  GridFields.RowCount := TDAO.Count + 1;
  SetLength(Result, TDAO.Count);
  for Cont := 0 to TDAO.Count do
  begin
    if GridFields.Cells[4, Cont + 1].IsEmpty then
    begin
      Result[Cont] := null;
    end
    else
    begin
      Result[Cont] := GridFields.Cells[4, Cont + 1];
    end;
  end;
end;

end.
