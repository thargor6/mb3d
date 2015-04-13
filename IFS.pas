unit IFS;

interface

uses Types;

type
  IFSitem = record     //one formula to call  .ifs?
    iName: array[0..19] of Byte; //name of item, max 20 bytes
    iType: Integer;              //types: loop, shape, transform, also another object!
    iOption1: Integer;           //loop: repeat from;  shape: Diff Color (neg=index?)
    iOption2: Integer;           //loop: loopcount;  shape: Spec Color (without transforms no loopcount needed)
    iParacount: Integer;
    iCallPointer: Integer;
    parameters: array of Single;
  end;
  TIFSobject = record  //group of formulas    .obj?
    name: array[0..19] of Byte;  //name of object, max 20 bytes
    Options: Integer;            //type of bound? (rect[xmin,xmax,ymin,ymax,zmin,zmax] or sphere[xmid,ymid,zmid,radius])
    sBound: array[0..5] of Single; //defines a bound for this group, for a fast mindistance calc (if bigger than current mindist, dont calc group)
    Itemcount: Integer;
    iCallPointer: Integer;
    IFSitems: array of IFSitem;  
  end;

  
implementation




end.
 