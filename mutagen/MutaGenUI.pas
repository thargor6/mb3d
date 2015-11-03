unit MutaGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvExForms,
  JvCustomItemViewer, JvImagesViewer, JvComponentBase, JvFormAnimatedIcon;

type
  TMutaGenFrm = class(TForm)
    Image1: TImage;
    RenderBtn: TButton;
    GridPanel1: TGridPanel;
    Panel01: TPanel;
    Image01: TImage;
    Panel00: TPanel;
    Image00: TImage;
    Panel02: TPanel;
    Image02: TImage;
    Panel03: TPanel;
    Image03: TImage;
    Panel04: TPanel;
    Image04: TImage;
    Panel10: TPanel;
    Image10: TImage;
    Panel11: TPanel;
    Image11: TImage;
    Panel12: TPanel;
    Image12: TImage;
    Panel13: TPanel;
    Image13: TImage;
    Panel14: TPanel;
    Image14: TImage;
    Panel20: TPanel;
    Image20: TImage;
    Panel21: TPanel;
    Image21: TImage;
    Panel22: TPanel;
    Image22: TImage;
    Panel23: TPanel;
    Image23: TImage;
    Panel24: TPanel;
    Image24: TImage;
    Panel30: TPanel;
    Image30: TImage;
    Panel31: TPanel;
    Image31: TImage;
    Panel32: TPanel;
    Image32: TImage;
    Panel33: TPanel;
    Image33: TImage;
    Panel34: TPanel;
    Image34: TImage;
    Panel40: TPanel;
    Image40: TImage;
    Panel41: TPanel;
    Image41: TImage;
    Panel42: TPanel;
    Image42: TImage;
    Panel43: TPanel;
    Image43: TImage;
    Panel44: TPanel;
    Image44: TImage;
    procedure RenderBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MutaGenFrm: TMutaGenFrm;

implementation

{$R *.dfm}
uses
  Mand, MB3DFacade, PreviewRenderer, TypeDefinitions, CustomFormulas;


procedure TMutaGenFrm.RenderBtnClick(Sender: TObject);
var
  MB3DParamsFacade: TMB3DParamsFacade;
  MB3DPreviewRenderer: TPreviewRenderer;
  bmp, oldBitmap: TBitmap;
begin
  MB3DParamsFacade := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);
  try
    MB3DPreviewRenderer := TPreviewRenderer.Create( MB3DParamsFacade );
    try
      MB3DParamsFacade.Formulas[0].ParamValues[0]:=3;
      bmp := TBitmap.Create;
      MB3DPreviewRenderer.RenderPreview(bmp, Image00.Width, Image00.Height);
//      oldBitmap := Image3.Picture.Bitmap;
 Image00.Picture.Bitmap := nil;
      Image00.Picture.Bitmap := bmp;
      // TODO free shit
//      if Assigned(oldBitmap) then
//        FreeAndNil(oldBitmap);
    finally
      MB3DPreviewRenderer.Free;
    end;


  finally
    MB3DParamsFacade.Free;
  end;


end;

end.
