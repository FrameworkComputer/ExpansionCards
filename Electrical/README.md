# Expansion Card Electrical CAD

## License

Expansion Cards © 2021 by Framework Computer Inc is licensed under CC BY 4.0.
To view a copy of this license, visit http://creativecommons.org/licenses/by/4.0/

## Files

 - KiCad_templates - These are templates with the PCB outline and some basic components
   to let you get started with a card design quickly.  The Expansion_Card template
   is designed to be used with the 3D printable enclosures in the Mechanical folder.
   The Expansion_Card_Retrofit template is smaller and designed to fit into the existing
   Expansion Card enclosures like the DP Expansion Card's.  You can copy the folders to
   the default template directory: https://docs.kicad.org/5.0/en/kicad/kicad.html#template_locations
 - Microcontroller - A reference project using a SAMD21 Microcontroller with some pin
   headers broken out.  **Note:** We've built and done basic validation on an older version
   of this design, but the version currently in this repository is untested.
   ![image](https://user-images.githubusercontent.com/28994301/118582864-f2903f00-b748-11eb-9ee0-a20ade45479a.png)

   
## Fabrication and Assembly

The templates and reference designs currently in this repository are basic, 2-layer, USB 2.0 designs.
This means the requirements around fabrication and assembly are pretty minimal.  Most PCB makers
and assemblers will be able to handle this.  We've listed a few popular ones below for reference.
Note that these are not necessarily vetted by Framework.

Note that there are pads next to the USB-C plug for manual soldering for additional strength.
You'll have to specify that to your assembler or hand solder that yourself.

PCB Only
 - OSHPark (https://oshpark.com/)

PCB+Assembly
 - Seeed (https://www.seeedstudio.com/fusion_pcb.html)
 - PCBWay (https://www.pcbway.com/pcb-assembly.html)
 - Macrofab (https://macrofab.com/)
 - Circuithub (https://circuithub.com/)
