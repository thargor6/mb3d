Even if I stopped active development of MB3D a while ago ( http://www.fractalforums.com/mandelbulb-3d/active-mb3d-develoment-stopped-from-my-side/ ),
I made some additions from time to time. Currently there are 5 skipped (unreleased) minor versions.
Because I'm not sure if I will find the time to add more stuff for a longer time from now, I just decided to release the current state.
There will be no time to polish it. So, if you expect polished software, just skip this update.
It is just meant as a gift to a few people who may care, please do not contact me to tell me about further features you are
missing. I will also not process bug-requests etc. In fact, I will not have the time to process any requests.

COMPLETE CHANGES:
 - ANIMATION-EDITOR:
   - new "m3p"-output-option in the animation editor. I.e. the output of the animation-module may be now a sequence of params
     for further processing (e.g. creation of meshes)

 - MESH-GENERATOR:
    - Optional mesh simplification using Quadric Mesh Simplification ( http://cseweb.ucsd.edu/~ravir/190/2016/garland97.pdf )
    - May also load params from harddrive (rather than only importing the current param from main)
    - Support for generating mesh-sequences (by loading *.mp3-sequences, for example those generated with the animation editor)
    - Additional function to generate only the currently displayed mesh in sequence-mode
    - new lwo2 (Lightwave3D 6.0)-output format for generated meshes (much smaller than *.obj)
    - improved the speed of the mesh-merging-process
    - new "Unprocessed raw mesh"-output option in the mesh-generator allowing the creating of larger meshes because the
      mesh-refinement is done in an external app
 - EXTERNAL MERSH-MERGING-TOOL (64 BIT):
    - can load and merge/reduce/smooth the mesh parts genererated by MB3D

 - HEIGHTMAP-GENERATOR:
    - new module to generate heightmaps from arbitrary meshes
    - OpenGL preview for realtime positioning of the mesh
    - WaveFront OBJ format for loading of meshes is supported, only triangles and quadtrangles are imported
      (so if your mesh contains polygons with more than 4 corners you must convert them to triangles first,
      probably each 3D software will support this)
    - Two types of maps are supported:
        - 8 Bit PNG
        - 16 Bit PGM (PGM because Delphi seems not able to generate 16 Bit PNG's)
    - The map can be saved as image or directly saved as the next new slot to the maps folder
    - Please note that this module needs a decent graphics card, tested only with GTX 980
    - Please note that most graphics software, including Photoshop, does not handle well PGM-files.
      But it doesn't matter that much as MB3D can read those files

 - JIT-FORMULAS:
    - a cool JIT-formula-pack made by Alef at the forums ( http://www.fractalforums.com/mandelbulb-3d/em-formulas-for-mandelbulb3d/msg102153/#msg102153 )

 - MISC:
    - changed the system and library-language to English, all dialogs etc. should now be English
    - removed the "Report a bug"-function (the site for bug-reporting isn't maintained any more)
    - cancelled the mb3d.org-domain used by the bug-tracker (did only const money)

Cheers!

Andreas