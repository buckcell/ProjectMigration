unit DataFlex;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.StrUtils, Vcl.Forms,
  Arrays;

type

  TDataFlex = class
  private
    StrList: TStringList;
    Separator: string;
    Rows: integer;
    Cols: integer;
    function Cut(Text: string): TStringArray;

  public
    constructor Create(StrList: TStringList; Separator: string);

    function GetRows: integer;
    function GetCols: integer;

    function ToMatrix: TStringMatrix;
  end;

implementation

//Cria o objeto e define os atributos
constructor TDataFlex.Create(StrList: TStringList; Separator: string);
begin
  self.StrList := StrList;
  self.Separator := Separator;
  self.Rows := StrList.Count;
  self.Cols := Length(Cut(StrList[0]));
end;

//Retorna a quantidade de linhas
function TDataFlex.GetRows: integer;
begin
  Result := self.Rows;
end;

//Retorna a quantidade de colunas
function TDataFlex.GetCols: integer;
begin
  Result := self.Cols;
end;

//Retorna uma matrix com os dados
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

//Passa uma string para array baseando-se no separador
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
