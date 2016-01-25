program Mandelbulb3D;

{$RTTI EXPLICIT METHODS([]) FIELDS([]) PROPERTIES([])}
{$WeakLinkRTTI ON}

uses
  Forms,
  Mand in 'Mand.pas' {Mand3DForm},
  LightAdjust in 'LightAdjust.pas' {LightAdjustForm},
  CalcThread in 'CalcThread.pas',
  AmbShadowCalcThreadN in 'AmbShadowCalcThreadN.pas',
  DivUtils in 'DivUtils.pas',
  formulas in 'formulas.pas',
  PaintThread in 'PaintThread.pas',
  FileHandling in 'FileHandling.pas',
  ImageProcess in 'ImageProcess.pas',
  Navigator in 'Navigator.pas' {FNavigator},
  NaviCalcThread in 'NaviCalcThread.pas',
  Math3D in 'Math3D.pas',
  CalcThread2D in 'CalcThread2D.pas',
  CustomFormulas in 'CustomFormulas.pas',
  Animation in 'Animation.pas' {AnimationForm},
  Calc in 'Calc.pas',
  AniPreviewWindow in 'AniPreviewWindow.pas' {AniPreviewForm},
  HeaderTrafos in 'HeaderTrafos.pas',
  TypeDefinitions in 'TypeDefinitions.pas',
  AniProcess in 'AniProcess.pas' {AniProcessForm},
  MapSequencesGUI in 'maps\MapSequencesGUI.pas' {MapSequencesFrm},
  FormulaGUI in 'formula\FormulaGUI.pas' {FormulaGUIForm},
  DOF in 'DOF.pas',
  ColorPick in 'ColorPick.pas' {ColorForm},
  Paint in 'Paint.pas',
  CalcAmbShadowDE in 'CalcAmbShadowDE.pas',
  Interpolation in 'Interpolation.pas',
  CalcHardShadow in 'CalcHardShadow.pas',
  AmbHiQ in 'AmbHiQ.pas',
  BatchForm in 'BatchForm.pas' {BatchForm1},
  Undo in 'Undo.pas',
  CalcSR in 'CalcSR.pas',
  CalcPart in 'CalcPart.pas',
  MeshExportUI in 'export\MeshExportUI.pas' {MeshExportFrm},
  CalcVoxelSliceThread in 'CalcVoxelSliceThread.pas',
  calcBlocky in 'calcBlocky.pas',
  FormulaParser in 'FormulaParser.pas' {FormulaEditor},
  CalcMonteCarlo in 'CalcMonteCarlo.pas',
  Tiling in 'Tiling.pas' {TilingForm},
  MonteCarloForm in 'MonteCarloForm.pas' {MCForm},
  TextBox in 'TextBox.pas' {FTextBox},
  BRInfoWindow in 'BRInfoWindow.pas' {BRInfoForm},
  FFT in 'FFT.pas',
  RegisterM3Pgraphic in 'RegisterM3Pgraphic.pas',
  ColorSSAO in 'ColorSSAO.pas',
  ThreadUtils in 'ThreadUtils.pas',
  Maps in 'maps\Maps.pas',
  PostProcessForm in 'PostProcessForm.pas' {PostProForm},
  ColorOptionForm in 'ColorOptionForm.pas' {FColorOptions},
  uMapCalcWindow in 'uMapCalcWindow.pas' {MapCalcWindow},
  FormulaCompiler in 'formula\FormulaCompiler.pas',
  PreviewRenderer in 'render\PreviewRenderer.pas',
  MB3DFacade in 'facade\MB3DFacade.pas',
  MutaGenGUI in 'mutagen\MutaGenGUI.pas' {MutaGenFrm},
  MutaGen in 'mutagen\MutaGen.pas',
  FormulaNames in 'formula\FormulaNames.pas',
  MapSequences in 'maps\MapSequences.pas',
  Vcl.Themes,
  Vcl.Styles,
  IniDirsForm in 'prefs\IniDirsForm.pas' {IniDirForm},
  VisualThemesGUI in 'prefs\VisualThemesGUI.pas' {VisualThemesFrm},
  JITFormulaEditGUI in 'formula\JITFormulaEditGUI.pas' {JITFormulaEditorForm},
  JITFormulas in 'formula\JITFormulas.pas',
  ParamValueEditGUI in 'formula\ParamValueEditGUI.pas' {ParamValueEditFrm},
  PointCloudExport in 'export\PointCloudExport.pas',
  VoxelExport in 'VoxelExport.pas' {FVoxelExport};

{$R *.res}

{$SetPEFlags $20}  //{$SetPEFlags IMAGE_FILE_LARGE_ADDRESS_AWARE}

begin
  SetMinimumBlockAlignment(mba16Byte);
  Application.Initialize;
  Application.Title := 'Mandelbulb 3D';
  Application.CreateForm(TMand3DForm, Mand3DForm);
  Application.CreateForm(TLightAdjustForm, LightAdjustForm);
  Application.CreateForm(TFNavigator, FNavigator);
  Application.CreateForm(TAnimationForm, AnimationForm);
  Application.CreateForm(TAniPreviewForm, AniPreviewForm);
  Application.CreateForm(TAniProcessForm, AniProcessForm);
  Application.CreateForm(TMapSequencesFrm, MapSequencesFrm);
  Application.CreateForm(TFormulaGUIForm, FormulaGUIForm);
  Application.CreateForm(TColorForm, ColorForm);
  Application.CreateForm(TBatchForm1, BatchForm1);
  Application.CreateForm(TMeshExportFrm, MeshExportFrm);
  Application.CreateForm(TFormulaEditor, FormulaEditor);
  Application.CreateForm(TTilingForm, TilingForm);
  Application.CreateForm(TMCForm, MCForm);
  Application.CreateForm(TFTextBox, FTextBox);
  Application.CreateForm(TBRInfoForm, BRInfoForm);
  Application.CreateForm(TPostProForm, PostProForm);
  Application.CreateForm(TFColorOptions, FColorOptions);
  Application.CreateForm(TMapCalcWindow, MapCalcWindow);
  Application.CreateForm(TMutaGenFrm, MutaGenFrm);
  Application.CreateForm(TIniDirForm, IniDirForm);
  Application.CreateForm(TVisualThemesFrm, VisualThemesFrm);
  Application.CreateForm(TJITFormulaEditorForm, JITFormulaEditorForm);
  Application.CreateForm(TParamValueEditFrm, ParamValueEditFrm);
  Application.CreateForm(TFVoxelExport, FVoxelExport);
  //SuppressMessageBoxes := True;
  Application.Run;
end.
