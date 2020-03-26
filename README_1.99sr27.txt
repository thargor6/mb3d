This version comes with another huge update to the new mesh generator (BTracer2):
  - optionally use the OpenGL-window for previewing the mesh. This is slightly slower, but gives you a much better impression of the final mesh
  - an official documentation for all BTracer2-related topics: BTracer2.pdf
  - controls for rotating the mesh
  - optional tracing ranges for better control of the result (e.g. allowing you to only create a mesh of a certain slice of the whole traced cube)
  - option to create closed meshes (along the trace-range-boarders)
  - loading/saving of all options (including fractal-params) in a new file-format (*.btrace2)
  - more efficient memory-management
  - creating BTracer2-Cache-files which can be processed using a new external 64Bit-companion-app, called BTracer2x64
      - to create meshes of any size your machine can handle
      - unlike to the feature to create meshes, MB3D can generate cache-files for any volumetric resolution (they just need some time to calculate and consume a lot of space on your hard-drive).
      - using the external app, you can create meshes from those cache-files and let them automatically reduced (optional feature)
      - please note, that you are not allowed to use the NON-COMMERCIAL-version of this application in commercial projects (see BTracer2.pdf for details)

See the file CHANGES.txt for a list of changes. 

When using BTracer2: please do read the official documentation, it will probably answer most of your questions.

When you have further questions, feel free to contact me at thargor6@googlemail.com.


Cheers!

