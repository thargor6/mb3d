I thought it may be already time for a new release, as there are some really major improvemens 
on point-cloud-export, and I'm not sure how many spare time I will find in the next weeks for further additions.

What's new:
 - Point-Cloud-export:
    - major increase of sampling-quality
    - minor speed-increase (is compensated by generating more samples)
    - jitter-option to improve sampling of round shapes, usually gives good results at high
      volumetric resulutions > 1000
    - option to generate normal vectors (is not the same as approximating the normals on the final mesh)
    - display elapsed time
 - Progressbar for the BulbTracer-preview
 - renamed the "MeshGen"-button back to "BulbTracer" (which was always the intended name)
 - updated the huge JIT-formula.pack ("EM_JIT_M3Formulas") from Alef from fractalforums.com
 - Added the missing formulas to the distribution: JosKn-KleinIFS, JosKn-ModIFS, K-TowerIFS
 
Cheers!

Andreas