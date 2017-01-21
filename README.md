# rem_libopenpic32
Basic opensource library for pic32 microcontrollers. WIP

* Based on https://github.com/cpresser/opensource-pic32
* Fixed for use with pic32prog 
* Converted for use with the rem buildsystem

Please be aware that this lib is in a very basic state! To build it you need the rem buildsystem: 
* https://github.com/franzflasch/REM

It can be built with the Codescape mips bare metal toolchain which is freely available: 
https://community.imgtec.com/developers/mips/tools/codescape-mips-sdk/download-codescape-mips-sdk-essentials/

No optimization limits! Also builds with -Os! ;) No need to use the microchip modified gcc, which is just utter crap.
