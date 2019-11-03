program BTracer2x64;

uses
  Vcl.Forms,
  BTracer2Main in 'BTracer2Main.pas' {BTracer2Frm},
  MeshSimplifier in 'MeshSimplifier.pas',
  ObjectScanner2x64 in 'ObjectScanner2x64.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Glossy');
  Application.CreateForm(TBTracer2Frm, BTracer2Frm);
  Application.Run;
end.
