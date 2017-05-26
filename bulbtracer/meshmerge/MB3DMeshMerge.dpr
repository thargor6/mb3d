program MB3DMeshMerge;

uses
  Vcl.Forms,
  MB3DMeshMergeUI in 'MB3DMeshMergeUI.pas' {MB3DMeshMergeFrm},
  MeshSimplifier in '..\MeshSimplifier.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMB3DMeshMergeFrm, MB3DMeshMergeFrm);
  Application.Run;
end.
