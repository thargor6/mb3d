README
=========================================================================================================
Changes:  
  - added support for generating z-buffers in the "M.C. render": 
    - This was not so easy becasue the internal data structures did not support this additional z-buffer-information. 
      So, this mode requires additional data which makes it incompatible with previous versions. 
      Therefore, MC-files with this setting can not be saved/restored. 
    - To save the z-buffer just save the normal image, the z-buffer is then automatically saved as well.   
    - This works also in the "M.C. batch render"-sub-module. To generate the z-buffer for previously rendered images
      you must delete these images to re-render them. The z-buffer is then saved together with the normal
      imnages, as long as the option "With ZBuffer" is enabled. 
    - In network rendering be careful to enable the option "With ZBuffer" on all nodes

See the file CHANGES.txt for a complete list of all changes. 
See other README_xxx.txt files for other useful information.


UPDATE-HINTS
=========================================================================================================
Update-suggestion: just manually copy/overwrite the following files to your existing installation:
  - Mandelbulb3D.exe
  - README_1.99sr37.txt
  - CHANGES.txt

When you have further questions, feel free to contact me at thargor6@googlemail.com.


WEBSITE
=========================================================================================================
Visit the official site at: https://mb3d.overwhale.com/

If you like this software, please consider a donation to support further development.

Cheers!

