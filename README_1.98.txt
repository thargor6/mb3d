Even if I stopped active development of MB3D a while ago ( http://www.fractalforums.com/mandelbulb-3d/active-mb3d-develoment-stopped-from-my-side/ ),
I make some additions from time to time. 

Now there are enough features finished to make a new release (coming even more close to V2.00 ;-)). 

What's new:
 - Point-Cloud-export in the BulbTracer-module, which is able to generate very nice models in high resolution in a short time, 
   even with color (which is currently a limited feature).
   This mode is now the default mode in the BulbTracer, with a initial volumetric resolution of 256, which is nice to play around, 
   because it is not too slow, but often creates nice models.
   For creating a final mesh, a volumetric resolution of 2560 is not unusual, as the new mode is fast and takes not too much memory.

   To use the old way of generating mesh consiting of vertices and faces, choose "Mesh" as Mesh Type)
 - updated the huge JIT-formula.pack ("EM_JIT_M3Formulas") from Alef from fractalforums.com

Cheers!

Andreas