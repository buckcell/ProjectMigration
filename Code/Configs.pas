unit Configs;

interface

uses
  System.SysUtils, System.Classes, System.Types, System.Variants, Vcl.Forms, IniFiles;

type

  TConfigs = class
  strict private
    class function Source: string;

  public
    class function GetConfig(const Section, Name: string): string;
    class procedure SetConfig(const Section, Name, Value: string);

  end;

implementation

class function TConfigs.Source: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'Config\Config.ini';
end;

class function TConfigs.GetConfig(const Section, Name: string): string;
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(Source);
  try
    Result := Arq.ReadString(Section, Name, '');
  finally
    FreeAndNil(Arq);
  end;
end;

class procedure TConfigs.SetConfig(const Section, Name, Value: string);
var
  Arq: TIniFile;
begin
  Arq := TIniFile.Create(Source);
  try
    Arq.WriteString(Section, Name, Value);
  finally
    FreeAndNil(Arq);
  end;
end;

end.