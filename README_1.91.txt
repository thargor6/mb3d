V1.91 RELEASE
- New BulbTracer-module to create meshes from within MB3D. Its supports the complete workflow of creating,
  smoothing and previewing the meshes, so no additional software is required. It works fully multi-threaded,
  so it is fast, too.

  Hints:
   - to get started just press the "BTracer"-button to open the new module and press the
     "Import parameters"-button to import the current fractal
   - the sizing/positioning works the same way as in the VoxelStack-module, also
     the preview works very similar, but there are 2 new size settings for faster display
   - to get started quickly hust hit the "Generate Mesh"-button and watch what happens.
     You should get a small preview window showing the mesh if all worked right.

     If not, there is probably some problem with the OpenGL-display. In this rare case
     you can still create the meshes, but not preview them from within MB3D. You may use MeshLab instead.
   - Level of detail: Increase the "volumetric resolution" setting. Usually a value of 100...200 is a good start,
     and can 200...300 gives good results. The higher the value, the more detail, but also the more
     vertices and faces are generated, leading to larger files and more consumption of memory.
   - Smoothing: There are two different smoothing options:
       - oversampling: smoothes the mesh during creation and leads to increased creation time
       - Taubin-smooth: post-processing, usually very fast
     It depends on the fractal which works the best, some fractals work best with a combination
     of both.
   - Cancelling: you can cancel the mesh generation at any time and preview the changes
     which were made so far. This is the default behaviour. If you want just cancel,
     you can change this behaviour by chosing the option "Cancel immediately" from within
     the "Cancel type"-listbox.
   - Saving: Usually also saving is very fast and is done automatically. But if you want to try out many settings,
     you may want to turn saving temporary off. In this case, just choose "Dont save, only preview" from
     the "Save type"-listbox
   - Have fun!

- some global stability fixes