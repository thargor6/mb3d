unit MutaGenUI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, JvExForms,
  JvCustomItemViewer, JvImagesViewer, JvComponentBase, JvFormAnimatedIcon, MutaGen;

type
  TMutaGenFrm = class(TForm)
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
    Panel1: TPanel;
    Image1: TImage;
    RenderBtn: TButton;
    procedure RenderBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPanelList: TMutaGenPanelList;
  public
    { Public declarations }
  end;

var
  MutaGenFrm: TMutaGenFrm;

implementation

{$R *.dfm}
uses
  Mand, MB3DFacade, PreviewRenderer, TypeDefinitions, CustomFormulas, Contnrs;

const
  MUTAGEN_SIZE = 5;

procedure TMutaGenFrm.FormCreate(Sender: TObject);
begin
  FPanelList := TMutaGenPanelList.Create;
  FPanelList.AddPanel(TMutaGenPanel.Create(0, 0, Panel00, Image00));
  FPanelList.AddPanel(TMutaGenPanel.Create(0, 1, Panel01, Image01));
  FPanelList.AddPanel(TMutaGenPanel.Create(0, 2, Panel02, Image02));
  FPanelList.AddPanel(TMutaGenPanel.Create(0, 3, Panel03, Image03));
  FPanelList.AddPanel(TMutaGenPanel.Create(0, 4, Panel04, Image04));
  FPanelList.AddPanel(TMutaGenPanel.Create(1, 0, Panel10, Image10));
  FPanelList.AddPanel(TMutaGenPanel.Create(1, 1, Panel11, Image11));
  FPanelList.AddPanel(TMutaGenPanel.Create(1, 2, Panel12, Image12));
  FPanelList.AddPanel(TMutaGenPanel.Create(1, 3, Panel13, Image13));
  FPanelList.AddPanel(TMutaGenPanel.Create(1, 4, Panel14, Image14));
  FPanelList.AddPanel(TMutaGenPanel.Create(2, 0, Panel20, Image20));
  FPanelList.AddPanel(TMutaGenPanel.Create(2, 1, Panel21, Image21));
  FPanelList.AddPanel(TMutaGenPanel.Create(2, 2, Panel22, Image22));
  FPanelList.AddPanel(TMutaGenPanel.Create(2, 3, Panel23, Image23));
  FPanelList.AddPanel(TMutaGenPanel.Create(2, 4, Panel24, Image24));
  FPanelList.AddPanel(TMutaGenPanel.Create(3, 0, Panel30, Image30));
  FPanelList.AddPanel(TMutaGenPanel.Create(3, 1, Panel31, Image31));
  FPanelList.AddPanel(TMutaGenPanel.Create(3, 2, Panel32, Image32));
  FPanelList.AddPanel(TMutaGenPanel.Create(3, 3, Panel33, Image33));
  FPanelList.AddPanel(TMutaGenPanel.Create(3, 4, Panel34, Image34));
  FPanelList.AddPanel(TMutaGenPanel.Create(4, 0, Panel40, Image40));
  FPanelList.AddPanel(TMutaGenPanel.Create(4, 1, Panel41, Image41));
  FPanelList.AddPanel(TMutaGenPanel.Create(4, 2, Panel42, Image42));
  FPanelList.AddPanel(TMutaGenPanel.Create(4, 3, Panel43, Image43));
  FPanelList.AddPanel(TMutaGenPanel.Create(4, 4, Panel44, Image44));
end;

procedure TMutaGenFrm.FormDestroy(Sender: TObject);
begin
  FPanelList.Free;
end;

procedure TMutaGenFrm.RenderBtnClick(Sender: TObject);
var
  BaseParams: TMB3DParamsFacade;
  MB3DPreviewRenderer: TPreviewRenderer;
  bmp: TBitmap;
  Panel:TMutaGenPanel;
  Mutation: TMutation;
  I: Integer;

  function GetMutations: TList;
  var
    Mutation: TMutation;
  begin
    Result := TObjectList.Create;

    Mutation := TModifySingleParamMutation.Create;
    Mutation.LocalStrength := 1.0;
    Result.Add(Mutation);

    Mutation := TModifySingleParamMutation.Create;
    Mutation.LocalStrength := 2.0;
    Result.Add(Mutation);
  end;

  function CreateMutation(const Params: TMB3DParamsFacade; const GlobalStrength: Double): TMB3DParamsFacade;
  var
    I: Integer;
    Mutations: TList;
  begin
    Mutations := GetMutations;
    try
      Result := Params;
      for I := 0 to Mutations.Count-1 do begin
        Result := TMutation(Mutations[I]).CreateMutation(Result, GlobalStrength);
      end;
    finally
      Mutations.Free;
    end;
  end;

begin
  BaseParams := TMB3DParamsFacade.Create(Mand3DForm.MHeader, Mand3DForm.HAddOn);


  try

      for I := 0 to 24 do begin
        BaseParams := CreateMutation(BaseParams, 1.0);
        MB3DPreviewRenderer := TPreviewRenderer.Create(BaseParams);
        try
          bmp := TBitmap.Create;
          Panel := FPanelList.GetPanel(I);
          MB3DPreviewRenderer.RenderPreview(bmp, Panel.ImageWidth, Panel.ImageHeight);
          Panel.Image := bmp;
        finally
          MB3DPreviewRenderer.Free;
        end;
      end;




  finally
    BaseParams.Free;
  end;


end;

end.
