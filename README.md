# leap_frontend
An alternative front end for the con-espressione exhibit based on processing. This was developed because the [web-based](https://github.com/IMAGINARY/con-espressione-ui) front end could be hard to set up on some systems, in particular on windows.

 
The only goal of this front end is to pick up the signal from the leap motion and send MIDI signals to the [back end](https://github.com/IMAGINARY/con-espressione).
Other things, like audio synthesis, are not supported. An external MIDI synthesizer is required.

## Setup
The following softwares/libraries are needed:
- Processing, download from the [main page](https://processing.org/).
- Processing leap motion library. You can download it from the [github page](https://github.com/nok/leap-motion-processing). But I suggest to download it from the library manager inside Processing.
- Leap motion SDK v2, download from [this](https://developer-archive.leapmotion.com/v2) page. This is an old SDK version, since the new one don't support java anymore. Look at the README on how to install the SDK and how to run it. [This link](https://developer-archive.leapmotion.com/documentation/java/devguide/Leap_Processing.html) provides you with the details on how to integrate it into Processing.

If you are using windows and don't have a physical MIDI interface to do the MIDI loopback, you can install a library for virtual MIDI loopback, such as [loop midi](https://www.tobias-erichsen.de/software/loopmidi.html).

If you don't have a MIDI instrument available, you can use a virtual MIDI instrument, such as [Virtual Midi Synth](https://coolsoft.altervista.org/en/virtualmidisynth).

If you are using Linux (Ubuntu honestly), you need to create virtual ports via `sudo modprobe snd-virmidi`.

## Usage
1. Set the MIDI in/out MIDI ports on the con_espressione backend (con_espression.py file, lines 17-18). Use `mido.get_output_names()` and `mido.get_input_names()` to get the specific name in python.
- Windows:
	 The input and output is the MIDI loopback port created by LoopMIDI .
- Ubuntu:
	You need to choose any of the ports created by the `modprobe` command and query how they are called on the Mido side. 
2. Launch the con_espression backend, following the instruction at [this page](https://github.com/IMAGINARY/con-espressione), and keep it running.
3. Connect the leap motion and run the Leap Motion process in the background (see Setup).
3. Open the processing file and set the piano (or virtual instrument) MIDI OUT port, the virtual device (MIDI IN and OUT, corresponding to the one set in the python backend server) and the MIDI NanoKey IN. If you run the Processing script, it will list all ports before it exits on failure to connect to ports. Be aware that the names are a bit different here from the ones listed by Mido, but they appear in the same order. 
- Ubuntu:
	You need to choose any of the ports created by the `modprobe` command and query how they are called on the Processing side.  
4. Launch the processing script. Press "P" to play and enjoy (or don't, that is up to you, actually).



