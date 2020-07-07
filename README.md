# Mandelbulb3D

<a name='about'></a>

## ABOUT

Mandelbulb 3D is a program designed for the Windows platform, for generating 3D views of different fractals. The rendering is based on distance estimates (DE), you might find this shortcut in some of the explanations. 

Many thanks to the people on FractalForums.com, especially to David Makin for helping with implementing DE, also to Buddhi for the fast DE method for the amazing box, msltoe for the riemannian formula, Tglad for the Amazing Box, Fracmonk for the CommQuat formula, Trafassel for the IdesFormula, Kali, Bethchen, all I forgot, for even more formulas, and of course Luca (DarkBeam) for many, many own made formulas! Not at least thanks to Daniel White, whose fast int power formulas I am using and for developing some of the first 3d bulbs together with Paul Nylander. Also to Syntopia and all the others for inspiration, helping, testing, for suggestions, and the people of Nasa and Gimp for the awesome work and the maps I generated from their work (and hopefully there is no restriction in using them this way). Also a big thanks to all who supported m3d, me and others with kind words, lightmaps, cool renderings and their parameters! 



<a name='index'></a>

## INDEX

1. [About](#about) 

2. [Installation](#Installation)

3. [Zooming and Navigating](#Zooming and Navigating)

4. [3D Navigator](#3D Navigator)

5. [Formulas](#Formulas)

   

   [**OPTION TABS:**](#Option)

6. [Calculation](#Calculation)

7. [Coloring&nbsp;-&gt; Volumetric light](#Coloring)

8. [Internal](#Internal)

9. [Cutting](#Cutting)

10. [Julia on,off](#JULIA MODE)

11. [Infos](#Infos)

12. [Camera](#Camera)

13. [Stereo](#Stereo)

    

    [**POSTPROCESSING:**](#POSTPROCESSING)

14. [Recalculate a Selection](#Recalculate a Selection)

15. [Normals on Z-Buffer](#Normals on Z-Buffer)

16. [Hard Shadows](#Hard Shadows)

17. [Ambient Shadows](#Ambient Shadows)

18. [Reflections and transparency](#Reflections and transparency)

19. [Depth of Field](#Depth of Field)

20. [Lighting](#Lighting)

21. [Drawing on the image](#Drawing on the image)

22. [Saving and loading](#Saving and loading)

23. [Animation maker](#Animation maker)

    

    [**UTILITIES:**](#UTILITIES)

24. [Big renders](#Big renders)

25. [M.C. renderer](#M.C. renderer)

    

26. [Warning and changelog](#Warning and changelog)



<a name='Installation'></a>

## INSTALLATION

An installation is not necessary, extract the whole archive to a folder of your choice and start the program by clicking on **Mandelbulb3D.exe**. If the formulas are not all available, specify the formula directory by clicking on the 'Initial directories' button in the 'INI' tab.



<a name='Zooming and Navigating'></a>

## ZOOMING AND NAVIGATING

The easiest way is to use the 3d navigator that i recommend and will explain in an extra topic later on.

The other way for navigating is to use the 2D mouse functions to step and zoom via 2D slices to different positions. You can select on the bottom left side of the programs window three options by clicking on these buttons: 

1. Button is for zooming, a double click in the image will zoom in the clicked position by a factor of 1.4 . Left-click for zooming in, Right-click for zooming out. You can also mark an area in the image to zoom into it. These zoomings are performed at the Zmid slice, the other Z values are changed relative to it and does not care about the object itself. That means that a 3d calculation could slice the object or sending parameters to the navigator can make problems like with all other 2d functions.

2. Button to shift the image in horizontal and vertical directions.

3. Button to navigate the slice in Z direction, seen from the viewport of the beholder. This is useful to get a better imagination of the location or to back in front of the object.

And you can rotate the bulb around the point that is given by the Xmid, Ymid and Zmid values by clicking on the arrow buttons below the main image window.

In the 'Position' menu: The Zstart position defines the start of rays to be calculated, Zend defines where calculation ends, if no object until then has been found. These values are relative to the Zmid and the actual view direction, so Zstart is always lower than Zend. Hints: Increase the Zend value, if parts in the background are missing, but do not choose larger values than needed. It is more recommended to use the 'farplane' value in the navigator for this purpose (use F1 and F2 for de/increasing the value). With high Zend values, use the 24bit or the DEAO ambient shadow functions to avoid banding artifacts.

'get midpoint': The midpoint can be taken directly from the object in the rendered image by clicking on this button and afterwards on the image part.

'reset': To reset the position, rotation and zoom to default start values. If the R bailout value is bigger than 500, it will be more zoomed out, so push this button after selecting the 'amazing box', for example. Hint: The zoom value is not really intended for large changes by the user, use the navigator instead to zoom into the object, the value is adjusted automatically.

In the 'Rotation' menu: You can change the rotation angles by hand, but you must press 'apply to image' to insert them to the parameters. A rotation matrix is generated from them (the internal format of rotation) and afterwards the euler angles are calculated again from this matrix and will be shown. These can differ from the original ones! On Y rotation near to 90 or -90 degrees, the euler angles can't be calculated at all from the matrix!

Calc-: Calculates a 8x8 blocky image, for example to roughly locate structures to preview with a selective recalculation in the postprocessing formular. Calculate 3D: Main rendering of the current parameters. Choose the options for hard and ambient shadows in the postprocessing formular before if you want them to be calculated automatically or to disable the automatic calculation. Formulas, Postprocess and Lighting: Brings up the specific formulars for making changes. Right click on these buttons to choose from the sticky options. 

Note: The image size is limited because a 32 bit program can use only about 2 to 3 GB of memory, dependend on the operating system and its settings. Some postprocessings need also additional memory (SSAO15, DoF), so the absolute limit would be 100 megapixel, but to use postprocessings and not run into any trouble, i suggest to go no much higher than 50 MPixel.

For huge renderings the new 'Big renders' tool is available in the 'Utilities' tab on the top-left corner of the program.



[**⬆ Back to menu**](#index)

## 3D NAVIGATOR

This feature is useful for an intuitive navigation through the fractal, like in first person games. First started, it uses the actual settings from the main program, later on you can use the 'Parameter' button to insert all main settings or 'Formula' to insert only the actual formula settings. You can also change only the light by choosing one of the user defined lightings '1' to '3' or press 'Light' to insert the current light settings. Anyways, the navigator uses a simpler lighting, so the actual light in the navigator image differs from the main programs image.

In the navi the actual zoom is calculated from the local DE value, this is the reason why sometimes the object will appear more tiny when stepping forward, because the local DE became smaller while passing a nearby structure and the programs nearplane (not a pointlike camera) becomes smaller. If you use the keyboard to navigate, all movings can be performed with the left hand and all rotations with the right hand. Use the keys that are shown beside the belonging buttons.

Additional navigating with the mouse is possible in two modes: you can move towards the object and back with the mousewheel, if you place the cursor over a part of the image, you also change to this direction when stepping forwards. The second mode is activated by leftclicking on the image, leftclick again or press the Escape button to turn back from this mode. In this mode the view direction is changed by moving the mouse, if you hold the right mousebutton down while moving, a rolling is performed instead. The mousewheel option depends of whether the option 'Fixed zoom and steps' is set. If so, then you can change the zoom-factor, else you step forward or back like in the other mode. You can rightclick in the navigator image to choose the option for changing to the second mode: by single or double click.

Click the button on the lower right side to open the option panel for specifying step sizes, rotating angles and some other options. Popup hints should appear when the mouse cursor is over the edit fields.

Fixed zoom and steps (F6): To disable the automatic zoom changing, what leeds also to stepping through the bulb.

Note: Do not start the navigator or insert parameters, when inside a bulb. Or you could try to enable the 'fixed zoom and steps' option first.

Hint: If the view disappears because of local low DE values, look at the zoom value and step towards decreasing values, and/or increase the far plane value.

Until version 1.7.0 you got some more key shortcuts, please look at the extended option panel for the F-keys options.

Use the 'fixed zoom and steps' option for navigating if you are in an 'inside rendering'.

The right adjusting panel is accessible by clicking on the arrow button on the bottom right side. Adjustments should be intuitive to handle. Beside the usage of sliders, you can also click on the values directly and input a new value.

Use the **show coords** checkbox to get the orientation of the current coordinate system in the middle of the navi image. This is useful for getting the right cutting plane for example.



[**⬆ Back to menu**](#index)

## FORMULA

Here you can specify the formulas you want to calculate, in case only a few are available, you have to set the formula directory in the **Ini** tab of the main window.

Choose a formula and calculate the 3D version to see the differences. Formulas that have a '_' (underline) character in front its name are only useful in alternating hybrids, they are not intended for standalone use.

The formulas have often additional option values that can be changed too. Please tryout.

You can choose several formulas that are calculated behind each other to give an alternating hybrid. Each formula is repeated n times by the option value that is given with 'iteration count'. Set 'iteration count' to zero to deactivate the formula or select an empty field in the formula selecting menus to remove it.
Repeat from here: &nbsp;When choosing several formulas that are calculated in a row, this option &nbsp;specifies where the next iteration starts after finishing the last formula in &nbsp;the tabs. So you can make one or more iterations with the first formula(s), &nbsp;that is(are) never used again.
R bailout: &nbsp;This gives the bailout value that indicates if the point belongs to the &nbsp;mandelset (after n iterations) or not (when R becomes greater than R stop). &nbsp;To low values results in artifacts. Minimum and maximum iteration counts: &nbsp;The formula is repeated at least the minimum iteration count and then &nbsp;iterated further until R becomes greater than the bailout value, or the &nbsp;maximum iteration count is reached.
Inside rendering: &nbsp;To show the inside of bulbs, this option is slow especially for larger &nbsp;images. The stepsizes are very small and at full iteration count, reduce &nbsp;the maximum iteration value to a value not very bigger than the average &nbsp;iteration count in the statistic tab to gain calculation speed. The **raystep multiplier** affects also the step sizes and so the calculation &nbsp;speed. 

Note: Use the 'fixed zoom and steps' option in the extended navigator panel.
3D: Formulas that have not a special analytically DE method, using the &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4 point DE method. 3Da: Formulas with an analytic DE based on an additional value (currently &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;the w variable, what can cause some interferences with 4d formulas). &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Calculation is commonly faster then the non analytically ones. 4D: Same as 3D but using also the w variable. 4Da: Like 3Da, but using another variable for the analytic calculation. Adds: Formulas that are not intended for standalone usage.
Notes: &nbsp;You can mix all formulas, but some combination may lead to &nbsp;unsatisfying results. This is because the needed DE function can not &nbsp;be obtained always. Mixing analytic formulas with nonanalytic ones &nbsp;results in a nonanalytic calculation.
 Older formulas included in previous versions of Mandelbub 3D might not work with version 1.5 or later versions and vice versa. The actual program loads only the working ones. 
Mistrust formulas that were not included in the archive, because they are containing pure machine code what causes risks.
'Interpolate' hybrid: &nbsp;In this function two formulas can be interpolated. Both formulas are &nbsp;calculated for each iteration and the results are averaged with the given &nbsp;weights that can be a floating point value.
'DEcombinate' hybrid: &nbsp;Here you can combine two formulas, in the 'min' option (shown in the first &nbsp;formula tab) the formulas are both complete, 'max' excludes both formulas, &nbsp;meaning that the combined object is only where both formulas were present. &nbsp;The **Inv max** option inverts the first formula and combines both 'maximum'. &nbsp;This can be used for cutting out the first shape (dIFS preferred) from the &nbsp;second formula (F2 to F6). &nbsp;'Min lin' and 'Min nlin' are like 'min' but got an overlap function between &nbsp;both formulas. &nbsp;'Mix1' and 'Mix2' are performing the beginning formula(s) and afterwards the &nbsp;second formula(s) are performs on the altered Z vector. The second formula &nbsp;is recommended to be a dIFS one. &nbsp;'Mix1' is using F1 as beginning formula whereas 'Mix2' is using F2-F6 to &nbsp;start with. You can vote formulas by rightclicking on them in the dropdown menus, this might help to find your formulas faster. By typing in directly into the formulas name edit field, a list of formulas fitting to the actual letters, are shown to choose from. Right clicking on the formula header tabs (F1..F6) will bring up a menu for moving and copying formulas or values. 



[**⬆ Back to menu**](#index)

# OPTION

## CALCULATION

(All of the changes to these values have only an effect when recalculating the 3D bulb or a selection.)

DE stop: This value indicates a stop condition for the search of the mandelset. When the DE (Distance Estimation) function estimates a value lower than DEstop, and the iteration count is higher than the minimum iterations value, the program assumes that the set was found.

The value for the DE is related to the width of a pixel, so a DEstop value of 1 will stop about one pixels before the set (this may vary little by the formula used, because the DE is not optimized yet for every formula). A lower value will show more details, as long as the maximum iteration count does not limit the details by giving an earlier stop condition.

Vary DEstop on FOV: By default enabled, gives it the DEstop a higher value in far areas to get a faster and more aliasing free rendering.

Raystep multiplier: (was: DE accuracy) This value scales the stepwidth in the search for the mandelset. Lower values are giving more precision to find finer details at the cost of rendering speed. To high values (bigger than 0.6) can lead to heavy overstepping.

Stepwidth limiter: If decreasing the Raystep multiplier to 0.1 and still overstepping occurs, lower this value also to 0.1 or less.

Stepcount for Binary Search: Calculates n more steps after the stop condition, to stear the location on the ray to an exact position. This is essential for calculating good normals or in case of Iteration Count Limiting to set the points all to the same (smoothed) Count.

Smooth Normals: A value greater than zero calculates the normals from the mean of several points and generates a kind of roughness value for a better anti aliasing. This is useful when the coloring looks noisy in high detailed areas. A value of 2 is mostly enough, higher values are not leading to much changes.

Normals on DE: If activated, the normals will be calculated from distance estimates. This is a good option for bulbs, as long as no artifacts occur, try out. On formulas and hybrids that uses own DE methods, the normals are always calculated from the DE's. 

First step random: This option multiplies the first raymarching step by a random number to give overstepping artifacts a random character and it can also reduce banding artifacts in the dynamic fog for example.

Raystep sub DEstop: Subtracts an amount from the DEstop from the next raystep to avoid overstepping with higher DEstop values. I recommend this with DEstop values of about 2 and higher, but also on lower values this can be helpful with dIFS.

'M' button: You can change the parameters for the presets ('preview', 'video', 'mid', 'high'). When clicked, hit one of the preset buttons to save the current values in the calculation tab plus the values for the image width and the image scale. The image height is calculated automatically to preserve the aspect ratio. If you clicked by accident, click again to cancel. 



[**⬆ Back to menu**](#index)

## COLORING

Mode for 2. color choice: Orbit trap: Based on the minimum distance to 0 while iterating. Works also with pure IFS. Last length increase: Is the last increment factor of the 3d vector length multiplied by the 'Lli multiplier'. If the color histogram between the object color start and end sliders is on the left side you can increase this value. Rout angles: Computes the arctan2 function of the components on bailout. Might be options on the Amazing box, check out on preview bulbs. Color map on input vec: Calculates x and y coordinates out of the actual position (x,y,z) for an object map. It overrides the standard color method on smoothed iterations! Map on output vector: Calculates x and y coordinates out of the iterated output vec (x,y,z) for an object map. It overrides also the standard color method.

The selected mode is computed in the main rendering and afterwards available as second coloring option in the Lighting-&gt;'Object colors' panel. Changes takes only effect on a new rendering.


The dynamic fog on iteration option will add fog/glow only if the ray goes through this iteration level (on bailout in escapetime or on minimum distance in dIFS formulas). A zero value disables this option and the d.fog is calculated on the amount of raysteps until the object reached. 

Volumetric light:

By clicking the 'Dyn. fog on it:' button you can choose the volumetric light option. Insert the light number on which this effect should be calculated. The resolution of the light map can be tuned by the up/down buttons in 20 percent steps. Avoid a to large 'Zend' value in combination with a global volumetric light, because this needs very large maps to cover the whole scene, resulting in a low map resolution. This would be very obvious in animations, when the light effect flickers.

After calculation you can use the same control as for the dynamic fog option in the lighting panel. Rightclick on the 'Dyn.fog' button to insert the color from the chosen volumetric light.



[**⬆ Back to menu**](#index)

## INTERNAL

Threadcount in Calculations: This value is set on program startup automatically, according to the number of processor cores in the computer. If the program is too fast ;-) or you need extra power for other programs, set it to a lower value. Choosing more threads than you have cores, normally does not increase the calculation speed, but can have a bad effect on stability, so this should be avoided. You can disable the automatic detection by unchecking the 'Autodetect on start' option. The program then will start with the user adjusted amount of threads for calculations.
Thread Priority: Changing to lower values gives other programs more calculation time. Setting to Idle causes the program to calculate only on free cpu time. Check 'Keep this priority' to save it in the ini and to not alter it by loading parameters or on program restart.



[**⬆ Back to menu**](#index)

## CUTTING

Enable clipping planes for 3D calculation by clicking on the right option boxes. Change the values to shift the plane in that dimension or take the values direct from the image by clicking on the specific button and after- wards on the rendered object in the main image. The side that points towards the viewer will be automatically cutted off. Caution: Transparency is currently not working well with cuttings!



[**⬆ Back to menu**](#index)

## JULIA MODE

In this mode, the vector (C) that is added to x,y,z (and w in 4d formulas), is kept the same and only the start parameters are changed. Formulas like IFS are not affected by C, and won't differ in julia mode. The shapes at the position from where the julia values are taken, will be found in the julia version as common shape.



[**⬆ Back to menu**](#index)

## INFOS

Author names might be shown here: Click on the 'Author:' button to specify your Author name, up to 16 characters long. Use 'insert' to insert your name in the mod field or in the orig field if empty. In case the 'Orig' field is not empty at file loading, it is disabled for changing.
Basic information to show: - Average DE steps - Average iterations - Maximal iterations - Main calculation time - Hard shadow calculation time - Reflections + transparency calculation time



[**⬆ Back to menu**](#index)

## CAMERA

To choose the field of view and the lense type. The rectilinear lense is keeping lines straight, but is not very useful for very high FOV's. The panoramic camera archives a fullsphere view usable also for background images. 360 degrees horizontal and 180 degrees vertical.



[**⬆ Back to menu**](#index)

## STEREO

Use real world values as parameters for calculating specific images:
A 'very left from midpos' image will use a common calculated image as 'righteye' image. So you would only have to calculate one additional image, but the outcome might be not optimal.
The 'left eye image' and the 'right eye image' calculations will make a more balanced pair of images.



[**⬆ Back to menu**](#index)

# POSTPROCESSING

Clicking on the 'Postprocess' button brings up this options formular.

## RECALCULATE A SELECTION

If you enable this function and make a selection with the mouse in the image, you can recalculate this selection with different parameters or the same for some reasons: reduce overstepping artifacts in some parts of the image, or to preview some settings before you start rendering. In case of reducing artifacts afterwards, there are several options to choose from. If you are using a lot of dynamic fog in the image, the only good choice is to keep all parameters, just enable the 'First step random' option in the calculation tab plus the 'Keep only nearer parts' and recalculate until the result looks ok. If the dynamic fog is not that important, use a 'Raystep divisor' value of 2 or higher to reduce overstepping a lot.

Note: Enable the automatic processing of the hard and ambient shadows so that they will be also calculated, but Only the DEAO ambient shadow can be calculated automatically! If you are using a different one, you have to recalculate the ambient shadow for the whole image afterwards!



[**⬆ Back to menu**](#index)

## NORMALS ON Z-BUFFER

You can try this function if the surface normals of the object seems to be wrong (noisy or very flat look). Warning: Save the rendering first as m3i file, because you have to rerender all to make this function undo!



[**⬆ Back to menu**](#index)

## HARD SHADOWS

Calculate the shadows from the light sources on the object. Choose only the lights you want to calculate or recalculate the shadow, for example if the position or the angle of the light was changed. The 'Max length calculation' value is a factor for the default length up to the hard shadow will be calculated. If shadows of distant objects are missing, try to increase the value and recalculate that shadow. If you calculate only one shadow, you can choose now an option for a more smooth shadow, that would be also nicer in animations because it fades softer in and out too. It relies on the DE, so it might not work in inside renderings or with formula combinations leading to bad DE's.



[**⬆ Back to menu**](#index)

## AMBIENT SHADOWS

This an automatically (by default) calculated shadow, and the result is obviously. The Z/R threshold limits the influence of strong depth changes, as in disconnected fore and background parts. The option 'Threshold to 0' lets the threshold decrease the shadow down to 0, so far parts are not affected by nearby parts. But this option can lead to stripes on parts inbetween. Use the 24 bit functions if banding or blocking artifacts are visible. The 'r' function reduces blockings further more by randomizing the sample positions. Some noise can be visible, this is not solved in the current version yet. The DEAO method does not relay on the Z Buffer and is therefore also very good for video animations. The dithering options must be chosen for the correct output scale of the image, else you get dithering artifacts. This function reduces spotty artifacts by varying the ray angles. The FSR (first step random) option reduces them too, but can introduce some random noise. Less noise On higher raycounts and downscales.



[**⬆ Back to menu**](#index)

## REFLECTIONS + TRANSPARENCY

Calculate direct reflections on the surface of the objects. The amount depends on the brightness of the specular colors, multiplied by the 'Amount' value. To high Spec values can lead to amplified light on the surface, so choose wisely. The 'Depth' value determines how many reflections should be calculated at maximum. So if you want to see a reflection on a already reflected object, you have to choose a value of 2. You can render a rectangular selection in the image for a fast preview: Enable the corresponding option at the bottom, make a selection on the image with the mouse and press 'Calculate now' to render the selection.

Tips: A mirror would be made of white specular color, black diffuse color, and a 'Spec' value of 1 (in the reflection settings). Use also background images with reflections. Enable 'Calculate H.S. automatically' and 'Calculate A.S automatically' if the shadows should also be calculated in the reflections.

Choose 'Calculate transparency' to calculate also inside going rays. Because inside rendering on escapetime fractals is slow, you can enable this only for dIFS formulas by checking 'Only dIFS'. The amount of transparency depends on the object transparent color and the 'Gain' value, that should be 1 if you want full transparency.

The transparency affects also the specular amount, the total light is split into refraction and reflection dependend on the incident light angle. Use white specular color with white (255) transparent color to get a full transparent object. Lowering the specular amount would be like an antirelfex coating for the surface. The diffuse color affects the absorption and the light scattering inside the material, both parameters are multiplied by the according 'Absorption' and 'Light scattering' values. 'Refraction index' specifies the material index, air is 1 (no change of light angle), water ~1.33, glass ~1.5 and diamond ~2.4.

Because for every 'Depth' of calculation, the ray is split into reflective part and refractive part, the amount of calculated rays is growing exponential with each depth. So it can be very time consuming.



[**⬆ Back to menu**](#index)

## DEPTH OF FIELD

The blurring from the optic can be simulated. Choose the distance from the beholder that should be sharp by clicking on the 'Get Z from image' button and afterwards on the specific object detail in the image. 'ClipRadius' is limiting the maximal radius when calculation. 'Aperture' specifies the blur change at the Zsharp point. It is not the aperture of the camera. You can multiply the value by a freely choosen distance from the camera to the Zsharp point and divide it by the cameras lense focal length to get the cameras aperture. For example: if you would like to have a camera aperture of 1:4 with a focal length of 100mm and the Zsharp point should be 1m in front of the camera, the 'Aperture' value must be 1/4 * 100 / 1000 = 0.025.

The DoF function is also not stored in the main buffer, so all light changes will reset this calculation. Note: Because of the new 'Reflections' function, the effect will not be automatically reset on a new calculation. You can reset it by pressing the 'Reset now' button beside the 'Caution-message', else the effect accumulates on each calculation.

Please look also at the popups that appear when the mouse is over the edit fields or buttons!



[**⬆ Back to menu**](#index)

## LIGHTING

The lighting is mainly based on the Phong Shading model, so please refer on this for more details on ambient, diffuse and specular light. Or just try it out.


You can see the object colors (indizes) histograms between the color adjustment sliders that are used for fitting the colors to the object. Press 'fine' to expand the range according to the present slider settings.

Color on 2nd choice: An additional coloring option that was calculated with the chosen option in the 'Coloring' tab (version 1.6.8 and later). If 'Col.on2ndC.' is not chosen, the colors are based on smooth iterations.

Use a map for the diffuse color: You can use maps for the diffuse object colors. The map position is derived from smooth iterations and the calculated 2nd color choice. Specular and transparent colors are still derived from the non-map option, you can uncheck the option to adjust them and re-check to get the map option again. Same for the 'Combine map Y with the diffuse colors' option, adjust the diffuse colors seperate.

Far Fog: Squares the distance for calculating the depth fog effect, leading in less fog in mid parts of the image.

The presets at the bottom of the window are changing the light and object colors, and the intensity + function of the light, but no further settings. Press 'M' and a custom preset button to store the actual setting.

All lighting adjustments can be loaded and saved as '*.m3l' files. They contain compressed data and are not editable with a text editor.

You can create also additional maps, put them in the same folder as the other ones, that is declared as 'Images for maps'. They have to be in Jpeg, Bmp or Png format and the filename must start by the number under that it will be available.

New in version 1.8 is right click on 'Depth' color button to bring up a menu to choose from all the preset background colors. You can scale the intensity of all lights including light maps and the background image now. Also a downscaled background image can be used for the ambient coloring, what might add some realism. This is intended for a spherical usage of the background image. If you use a background image, make sure the filename is not longer than 24 letters and the file is stored in the location of background images (use the 'Ini' option to specify it), the folder for maps or the pics saving folder.
And as always: Look also at popups for short explanations on Edit-fields, buttons or sliders.



[**⬆ Back to menu**](#index)

## DRAWING ON THE IMAGE


To change directly the colors on the calculated image, you have to popup the color adjustment panel by clicking on the spec or diffuse color buttons on the lighting tab. Check the 'Paint on image' option and choose a color by clicking inside the big color bar. Now you can paint in the main windows image, change the size of the pen by mousewheel and the shape by rightclick on the shape. If there is no change in the image, the sliders for the diffuse color might be outside the color range and you must set them more to the inside. Or try a color on another position.

The color changes are stored in a m3i file, but recalculations will reset them. So you can also undo drawings by recalculating a selection in the postprocessing tab. Check the Don't change the AmbShados' option before, so you need not to recalculate the ambient shadows.
The drawings don't show up in reflections and not at all in the M.C. renderer.



[**⬆ Back to menu**](#index)

## SAVING AND LOADING

The '*.m3i' files are including all calculated values from the image, also the parameter and light settings. The reflections and the DoF effect will also be stored if 'Img' is checked. It is always stored with fullsize, no matter of the current view-scaling. Animation, Voxelstack and Big-renders have own savings of their special parameters, they are not stored in a m3i file.

The '*.m3p' files are the parameters only, which include also the light adjustments. They contain compressed data and are not editable with a text editor.

Hints: The program generates a directory 'Mandelbulb3D' in the user's Local application data (AppData) folder, where some user defined presets are stored in, like the lighting presets. Save the current parameter as 'default.m3p' in the programs folder or in the initial parameters folder to load these settings on program startup automatically.

You can save and load the parameters also as text to and from the clipboard: Loading: Mark the text and press 'Ctrl + C' to copy it to the clipboard. Then press the loading button 'TXT'. Saving: Press the saving button 'TXT' and insert it with 'Ctrl + V' somewhere.

Since version 1.8 you can also drag&amp;drop textfiles or Png files with included parameters directly onto the programs main window to load them.

When saving a downscaled image in the BMP, PNG or JPEG file format, a good antialiasing filter is performed before to give a better result (for downscales of 1:2 and 1:3 only). Note that images are stored downscaled, like the current view.

You can declare the JPEGs quality in the edit field, or, with a value greater than 100, you can specify the maximum filesize in kilobyte. The maximum quality is then calculated automatically.

The '*.m3f' files are the formula files. They are in a readable and editable text file format, but the formula itself is in machine code.

And '*.m3a' files hold the animation settings. They contain compressed data and are not editable with a text editor.

On program shutdown, the last parameters are copied to the clipboard in textformat. So you can load them again immediately, if you forgot to save them, for example.

A 'History' folder is also made in the programs directory, parameters will be automatically stored in here. 



[**⬆ Back to menu**](#index)

## ANIMATION MAKER

I hope that most functions are self explaining, some hints are popping up when the cursor is over a button or an edit field.

The base function is to insert key frames from the actual parameters of the main programs window or from the navigator. The images inbetween are calculated from the interpolated values. Here you can define a smoothing factor for each keyframe, 0 leads to a linear interpolation to and from this keyframe, higher values gives a rounded, bezier like interpolation. In the newer program versions you can only choose between linear and bezier interpolation. So with bezier, the original keyframe parameters must not be reached in all cases, instead the midpoint between two keyframes are passed over. To still start with the first keyframe, duplicate the first KF (insert it towards the first and second KF) and set the first subframecount to zero. Same with ending on the last keyframe, setting the last KF's subframecount to zero. With the preview you can get a good impression of the flight path, so check this before starting the main rendering.

If you want to change specific values of a single keyframe, insert the parameters of the keyframe to the main program with the button above the keyframe, then change the parameters and insert them again with the button below the keyframe to it. 

Mostly all values, including lighting can be changed and will be interpolated.

The 'Start with index:' value is helpful, when a previous animation rendering was stopped. The rendering starts with this image index, so look what the last image index was. The 'File index:' values have to be left as they were.
Hint: The length of the Output Folder name should not exceed 255 characters, any more than that will not be saved in the '.m3a' file.



[**⬆ Back to menu**](#index)

# UTILITIES

## BIG RENDERS

Create a huge rendering by calculating tiles. The tiles are saved as images in an automatically created subfolder of the saved project file. You have to stick all tiles together with a seperate program of your choice, M3D does not have this function yet included! The functions should be mostly selfexplaining, please look at the bubble popups for more helps.



[**⬆ Back to menu**](#index)

## M.C. RENDERER

This is a more realistic renderer but it may take up to 100 times longer to render the same image as by default! Some hints on speeding up calculations in the default rendering as preview: - Render in 1:1 view, a special antialiasing is usually not needed - Increase the raystep multiplier until the first oversteppings occur and lower it only slightly. Little oversteppings are not that visible later - Hard shadows will always be calculated, switch off all lights that would give no big light amount or lies outside a room, use positional lights to light a room inside. The only way to switch off the HS calc would be to decrease the max length calcuation to 0. - When using dIFS make sure the maximum iterations value is as low as possible because it is aways calculated up to the maximum value. - The ambient and reflects rays depth values influences rendering speed of course, to low values affects the realism.
 To change parameters you can use the 'Send parameter to main' button, modify settings there and 'Import parameter' back then. The parameter will also be changed when sending, so the output of the main renderer comes closer to the MC result.
Use 'MaxL' in the postprocess DEAO settings to change the maximum calculated ambient ray length, same for 'max length calc' of hard shadows in its tab.
You can always stop the calculations and start again for continuing rendering.
Gamma, contrast and soft clipping can be changed at all time. To use the automatic file storing option, you first have to save the M3C file.
 The dynamic fog can easily destroy realism, for example when light is subtracted. An intern gamma of 2 ('I2' in the lighting tab) is also recommended.
 Not all caustics are implemented because it would take to much time to render. Light behind transparent objects is not accurate for example.
WARNING: This renderer shares maps with the main renderer, if you are using maps for lights, diffuse color, background and/or calcuations, i recommend to not touch the main renderer or you could loose maps and the MC renderer would produce crap!



[**⬆ Back to menu**](#index)

<a name='Warning and changelog'></a>

## C A U T I O N ! !

The usage of the program is at own risk, I cannot give warranties of any kind.
There are no restrictions in the usage of the program, but feel free to give a donation to fractalforums.com to keep the servers running!
The calculations are using by default all processor cores leading in a 100% CPU usage. Make sure the computer cooling system works well and be aware of a higher electricity bill.
Because of newer functions there might always be changes in the displaying and calculation of older parameter or m3i files. Have this in mind if you want to continue animations, big renderings or mc-renderings.



[**⬆ Back to menu**](#index)

## CHANGE LOG

See https://github.com/Zeyu-Li/mb3d/blob/master/CHANGELOG.txt



[**⬆ Back to menu**](#index)