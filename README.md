# seven_segments
 Verilog code for a six digit 7 segment display on an FPGA

This is a short bit of Verilog code for displaying a 6 digit wide hex number on a group of 7-segment displays.  I think the test code is actually longer than the code it's testing.  :-)

This is a good beginner project and a nice piece of code to have when you're using a dev board that has six 7 segment displays, such as the [Terasic DE10-Lite board](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1021).  Adding this module to other (larger) designs can be a useful aid for debugging.  Outside of the I/O mapping, nothing is really specific to this particular board, and the code can be easily adapted to other hardware.

See more detail on my website at www.ganslermike.com/?page_id=1643

<p align="center">
   <img src="images/seven seg top level schem.PNG" height="400"?
</p>
        
<p align="center">
   <img src="images/seven segs coffee.jpg" height="500" align="center">
</p>
