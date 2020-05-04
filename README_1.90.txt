V1.90 RELEASE
- Support for animated (height)maps! They are defined in the "Map Sequences"-window in the Prefs-section
  and saved as local properties, i.e. you may use them independly of a specific set of fractal params.
   - You define an image sequence by filename, start frame, end frame, loop setting and frame increment
   - You assign this sequence to a logical map channel (any number) you wish
   - You use this channel as map number in your fractal, e.g. as color map or heightmap
   - Now you can preview the state at frame [n] by changing the frame number in the main view
     (this is just for test render, not for animating)
   - When you use this fractal in the animation window, the map will now be animated, i.e. at each frame
     of the animation the corresponding frame of the map will be calculated (accordingly to the settings
     you made) and the image-file will be loaded. If no image file is found it is asumed to be "black".

- new MutaGen-module to easily explore new combinations of formulas and settings
   - four types of mutations:
       - add, remove, exchange formulas
       - modify params of formulas
       - modify Julia-mode
       - modify iteration count
   - in the UI you may turn on/off those types individually, by specifying a weight, and you may specify an additional
     strength-parameter
   - you may browse through the already generated generations of mutations and restart on interesting results
   - you may resize the window to alter the size of the generated thumbnail images
   - you may cancel/restart the mutation-process at any time (sometimes there occur combinations of parameters
     which may lead to "endless" calculations, in such cases it is helpful to be able to just restart)
   - WARNING: some formula-combinations may SILENTLY crash the program, so please save often!
     Silently crashing means you will not see it immediately, often the UI starts to behave weird.
     We are working to improve this!
   - This is just the first version, e.g. interpolated functions are not supported yet!
   - Please note, that it is intented that this module does not create ready-to-use artworks from scratch.
     It can only happen, when you put in well made parameters (whith everything what makes a great artwork),
     that the mutation will keep many of those properties, making it a nice artwork.
     Or in short: the better your input, the better the output.

- Navigator-size may now be altered (you must expand the right toolbar to see the "Navigator size" control),
  the last setting is stored to the ini-file. Please note, that the size can only be defined in percent
  by using the arrows or listbox, but not by changing the window-size directly (this is due to some historic
  implementation details).

- Global rework of the UI, added theme-support, made "Glossy" the default theme,
  changed the captions of some buttons in order to make them more readable

- Formula-Window:
    - exchanging of formulas now works in two directions

- integrated formula-editor for creating/editing JIT-compiled formulas (see the new buttons in the formula window)
   - support for MB3D's parameters and constants, both the TIteration3D and TIteration3Dext-structs are supported
   - preprocessor to deal with the parameter-handling code
   - backed by the commercial PaxCompiler
   - included support for about 50 mathematical functions
   - watch out for formulas with the prefix "JIT" for examples!
   - Please note that dIFS-formulas are not supported yet because they are invoked differently,
     but also this will be fixed in future releases

- Many new formulas from the community at fractalforums.com

- New Info-Section at the main window, which now has a button to reach the official bug-reporting tool,
  please use the bug-reporting-tool to report bugs if possible!





