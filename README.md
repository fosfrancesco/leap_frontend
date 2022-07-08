# leap_frontend
An alternative front end for the con-espressione exhibit based on processing. This was developed because the [web-based](https://github.com/IMAGINARY/con-espressione-ui) front end could be hard to set up on some systems, in particular on windows.

 
The only goal of this front end is to pick up the signal from the leap motion and send MIDI signals to the [back end](https://github.com/IMAGINARY/con-espressione).
Other things, like audio synthesis, are not supported. An external MIDI synthesizer is required.

## Setup
The following softwares/libraries are needed:
- Processing, download from the [main page](https://processing.org/).
- Processing leap motion library. You can download it from the [github page](https://github.com/nok/leap-motion-processing). But I suggest to download it from the library manager inside Processing.
- Leap motion SDK v2, download from [this](https://developer-archive.leapmotion.com/v2) page. This is an old SDK version, since the new one don't support java anymore.

If you are using windows and don't have a physical MIDI interface to do the MIDI loopback, you can install a library for virtual MIDI loopback, such as [loop midi](https://www.tobias-erichsen.de/software/loopmidi.html).
If you don't have a MIDI instrument available, you can use a virtual MIDI instrument, such as [Virtual Midi Synth](https://coolsoft.altervista.org/en/virtualmidisynth).

## Usage
1. Set the MIDI in/out MIDI ports on the con_espressione backend (con_espression.py file, lines 17-18). The output would be the MIDI instrument (or virtual instrument). The input is the MIDI loopback port.
2. Launch the con_espression backend, following the instruction at [this page](https://github.com/IMAGINARY/con-espressione), and keep it running.
3. Connect the leap motion.
3. Open the processing file and set the output MIDI port to the MIDI loopback port.
4. Launch the processing script. Press "P" to play and enjoy.



