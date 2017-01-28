program Project28;

uses
  Vcl.Forms,
  Unit37 in 'Unit37.pas' {Form37},
  DataSetExports in 'DataSetExports.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm37, Form37);
  Application.Run;
end.
