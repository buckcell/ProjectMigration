unit MyUtils;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants,
  Arrays;

type

  TUtils = class
  public
    class function Iff(Cond: boolean; v1, v2: variant): variant;
    class function ArrayToStr(StrArray: TStringDynArray; Separator: string = ' - '; StrFinal: string = ';'): string;

  end;

implementation

class function TUtils.Iff(Cond: boolean; V1, V2: variant): variant;
begin
  if Cond then
  begin
    Result := V1;
  end
  else
  begin
    Result := V2;
  end;
end;

class function TUtils.ArrayToStr(StrArray: TStringDynArray; Separator: string = ' - '; StrFinal: string = ';'): string;
var
  Cont: integer;
begin
  Result := '';
  for Cont := 0 to Length(StrArray) - 1 do
  begin
    if Cont = Length(StrArray) - 1 then
    begin
      Result := Result + StrArray[Cont] + StrFinal;
    end
    else
    begin
      Result := Result + StrArray[Cont] + Separator;
    end;
  end;
end;

end.
