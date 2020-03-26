README
=========================================================================================================
This version comes with a new module called "ZBuf16Bit" which allows you to create high-quality 
depth-maps/z-buffers.

Those maps can be used in MB3D itself, of course – but are also suited to create very interesting effects 
in other 3D-packages like Octane Render (e.g. as displacement maps).

Some hints:
 - first render your fractal, then hit the "Refresh"-button in the ZBuf16Bit-window to display a preview of the
   depth-maps
 - press the "guess params"-button if you see nothing or the image is off
 - the preview is only 8Bit, while the heightmap internally is computed using 16Bit
 - adjust the depth-map using the "Z offset", "Z scale" and "Invert ZBuffer" controls
 - antialiasing (by changing the view-resolution) of the 16Bit depth-maps is supported
 
- technical note: because the Delphi-PNG'component is (very) buggy, it does not support 16bit images. 
  So saving of depth-maps uses a workaround to get out a 16bit image:
     - Mandelbulb3D.exe does only write a PGM-file (which is a valid 16Bit gray image, but is only supported 
       by a few programs)
     - a java-based PGM-to-PNG-converter is invoked under the hood. 
   So, you will need a valid java installation to get out a 16Bit PNG-image. 
   But, it is not mandatory, you can also convert the PGM-images manually, e.g. using an online-converter.
   (The converter is inside the file PNG16Util-1.0-SNAPSHOT.jar, and is not some dubious 3rd-party-library, 
    but written by myself, so you can also see the sourcecode at GitHub.)


See the file CHANGES.txt for a list of changes. 


UPDATE
=========================================================================================================
Update-suggestion: just manually copy/overwrite the following files to your existing installation:
  - Mandelbulb3D.exe
  - PNG16Util-1.0-SNAPSHOT.jar
  - README_1.99sr32.txt
  - CHANGES.txt

When you have further questions, feel free to contact me at thargor6@googlemail.com.


WEBSITE
=========================================================================================================
Official site: http://www.andreas-maschke.com/?page_id=4607
Download-page to check for updates: http://www.andreas-maschke.com/?page_id=5049


If you like this software, please consider a donation to support further development.

To make a donation, please visit my blog at:
http://www.andreas-maschke.com/?page_id=1401

(To avoid confusion: this donation page was initially created to enable donations for my other free 
fractal-related software JWildfire, so you will probably see some terms related to JWildfire).

Cheers!

