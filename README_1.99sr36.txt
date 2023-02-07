README
=========================================================================================================
Changes:  
  - added support for network rendering in the "M.C. batch render"-sub-module: 
    There is a new checkbox "Support network rendering". When this checkbox is activated, then rendering 
    status is tracked across the file system so that multiple instances can render the same sequence 
    of files without overwriting the work of the other nodes.
    So you can easily setup network rendering by running multiple instances of MB3D which are using the same
    (network) file location to load/save files. Just load the same sequence of parameters and the several
    instances will distribute rendering automatically. This will also support adding/removing nodes during
    the rendering.
   

See the file CHANGES.txt for a complete list of all changes. 
See other README_xxx.txt files for other useful information.


UPDATE-HINTS
=========================================================================================================
Update-suggestion: just manually copy/overwrite the following files to your existing installation:
  - Mandelbulb3D.exe
  - README_1.99sr34.txt
  - CHANGES.txt

When you have further questions, feel free to contact me at thargor6@googlemail.com.


WEBSITE
=========================================================================================================
Visit the official site at: https://mb3d.overwhale.com/

If you like this software, please consider a donation to support further development.

Cheers!

