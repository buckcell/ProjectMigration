unit DataFlex;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.StrUtils, Vcl.Forms,
  Arrays;

type

  TDataFlex = class
  private
    //Atributos
    StrList: TStringList;
    Separator: string;
    Rows: integer;
    Cols: integer;
    //De String -> Array, separa os campos
    function Cut(Text: string): TStringArray;

  public
    //Constutor
    constructor Create(StrList: TStringList; Separator: string);

    //Gets
    function GetRows: integer;
    function GetCols: integer;

    //Transforma a stringlist em uma matriz
    function ToMatrix: TStringMatrix;
  end;

implementation

constructor TDataFlex.Create(StrList: TStringList; Separator: string);
begin
  self.StrList := StrList;
  self.Separator := Separator;
  self.Rows := StrList.Count;
  self.Cols := Length(Cut(StrList[0]));
end;

function TDataFlex.GetRows: integer;
begin
  Result := self.Rows;
end;

function TDataFlex.GetCols: integer;
begin
  Result := self.Cols;
end;

function TDataFlex.ToMatrix: TStringMatrix;
var
  Cont: integer;
begin
  SetLength(Result, self.Rows, self.Cols);
  for Cont := 0 to Rows - 1 do
  begin
    Result[Cont] := Cut(StrList[Cont]);
  end;
end;

function TDataFlex.Cut(Text: string): TStringArray;
var
  StrArray: TStringDynArray;
  Cont: integer;
begin
  SetLength(StrArray, Length(SplitString(Text, self.Separator)));
  StrArray := SplitString(Text, self.Separator);
  SetLength(Result, Length(StrArray));
  for Cont := 0 to Length(StrArray) - 1 do
  begin
    Result[Cont] := StrArray[Cont];
  end;
end;

end.
