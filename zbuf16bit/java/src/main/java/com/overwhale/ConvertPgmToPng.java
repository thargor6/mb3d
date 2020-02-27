package com.overwhale;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.color.ColorSpace;
import java.awt.image.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.StringTokenizer;

public class ConvertPgmToPng {
  private class ImageData {
    int width;
    int height;
    short[] pixels;

    public ImageData() {
    }

    public ImageData(int width, int height, short[] pixels) {
      this.width = width;
      this.height = height;
      this.pixels = pixels;
    }
  }

  private BufferedImage get16bitImage(ImageData imageData) {
    ColorModel colorModel = new ComponentColorModel(
            ColorSpace.getInstance(ColorSpace.CS_GRAY),
            new int[]{16},
            false,
            false,
            Transparency.OPAQUE,
            DataBuffer.TYPE_USHORT);
    DataBufferUShort db = new DataBufferUShort(imageData.pixels, imageData.pixels.length);
    WritableRaster raster = Raster.createInterleavedRaster(
            db,
            imageData.width,
            imageData.height,
            imageData.width,
            1,
            new int[1],
            null);
    return new BufferedImage(colorModel, raster, false, null);
  }

  private ImageData genPgmImage(String filename) {
    int width = 640;
    int height = 480;
    short[] pixels = new short[width * height];
    for(int y=0;y<height;y++) {
      for(int x=0;x<width;x++) {
        char color = (char)((double)x / (double)(width-1) * (double) (Character.MAX_VALUE-1));
        pixels[y*width+x] = (short) color;
      }
    }
    return new ImageData(width, height, pixels);
  }

  private ImageData readPgmImage(String filename) {
    try (BufferedReader br = new BufferedReader(new FileReader(filename))) {
      String line;
      boolean hasHeader = false;
      boolean hasSize = false;
      boolean hasDepth = false;
      int width=0, height = 0, maxVal = 0;

      while (!(hasHeader && hasSize && hasDepth) && (line = br.readLine()) != null) {
        if(line.charAt(0)!='#') {
          if(!hasHeader) {
            if(!"P2".equals(line)) {
              throw new RuntimeException("Wrong file format");
            }
            hasHeader = true;
          }
          else if(!hasSize) {
            int p=line.indexOf(' ');
            if(!(p>0 && p<line.length()-1)) {
              throw new RuntimeException("Wrong size specification");
            }
            width = Integer.parseInt(line.substring(0, p));
            height = Integer.parseInt(line.substring(p+1, line.length()));
            hasSize = true;
          }
          else if(!hasDepth) {
            maxVal = Integer.parseInt(line);
            hasDepth = true;
          }
        }
      }

      if(!(hasHeader && hasSize && hasDepth)) {
        throw new RuntimeException("Invalid header");
      }
      if(width<1 || height<1 || maxVal<=0) {
        throw new RuntimeException("Corrupt header values");
      }

      short[] pixels = new short[width * height];
      int y=0;
      while ((line = br.readLine()) != null) {
        StringTokenizer t=new StringTokenizer(line, " ");
        int x=0;
        while(t.hasMoreElements()) {
          char color = (char)((double)Integer.parseInt((String) t.nextElement()) / (double)maxVal * Character.MAX_VALUE);
          pixels[y*width+x] = (short) color;
          x++;
        }
        if(x!=width) {
          throw new RuntimeException("Wrong number of lines ("+x+" != "+width+") in line "+y);
        }

        y++;
      }
      if(y!=height) {
        throw new RuntimeException("Wrong number of lines ("+y+" != "+height+")");
      }


      return new ImageData(width, height, pixels);

    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  public void doConvert(String filename) {
    ImageData imageData = readPgmImage(filename);
    BufferedImage img = get16bitImage(imageData);
    try {
      String pngFilename = makePngFilename(filename);
      ImageIO.write(img, "png", new File( pngFilename  ) );
    } catch (IOException e) {
      e.printStackTrace();
    }
  }

  private String makePngFilename(String filename) {
    File file = new File(filename);
    String name = file.getName();
    int p=name.lastIndexOf(".");
    if(p>=0) {
      return new File(file.getParent(), name.substring(0, p)+".png").getAbsolutePath();
    }
    else {
      return new File(file.getParent(), name+".png").getAbsolutePath();
    }
  }

  public static void main(String args[]) {
    if(args.length!=1) {
      throw new RuntimeException("Usage: ConvertPgmToPng <filename>");
    }
    new ConvertPgmToPng().doConvert(args[0]);
  }
}
