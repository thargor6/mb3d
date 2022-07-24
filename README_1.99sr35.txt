README
=========================================================================================================
Changes:  
  - new "M.C. batch render"-sub-module:
     - after the suggestion of Matteo, who also supported the development (Thanks, m8!)
     - renders a sequence of *.m3p-files using the M.C. render
     - rendering stops at the given "Max ray count"-parameter
       - this parameter is only a raw measure, actual finishing of the rendering may occur much later
     - images are always rendered as *.png
        - images are rendered in the same folder as the *.m3p, which makes it easier to track which
          files have already been rendered and which not
        - to re-render images, you must delete the previously images or copy the params to another location
          where was not rendered
        - this is intended to make the workflow clear: "M.C. batch render" does not delete or overwrite images,
          any batch-delete/copy must be done outside of MB3D
     - how to start:
        - create a small animation
        - render it with the output-format *.m3p
        - open the "M.C. render"-window and click at the new "M.C. batch render"-button in the upper right
        - Click the "Open *.m3p-sequence"-button to open your *.mp3-files
        - Hit the "Start batch rendering"-button
        - You may cancel the rendering at any time using the "Cancel render"-button of the main M.C. window, so there
          is no separate "Cancel batch rendering"-button
        - you may resume the render, any previously rendered images are not touched (see above)
  - fixed a bug in the Animation-module which caused the creation of wrong *.m3p-files under certain circumstances
    (when using *.m3p as output format)

See the file CHANGES.txt for a complete list of all changes. 
See other README_xxx.txt files for other useful information.


UPDATE-HINTS
=========================================================================================================
Update-suggestion: just manually copy/overwrite the following files to your existing installation:
  - Mandelbulb3D.exe
  - README_1.99sr35.txt
  - CHANGES.txt

When you have further questions, feel free to contact me at thargor6@googlemail.com.


WEBSITE
=========================================================================================================
Visit the official site at: https://mb3d.overwhale.com/

If you like this software, please consider a donation to support further development.

Cheers!

