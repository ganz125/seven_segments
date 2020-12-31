//  ------------------------------------------------------------------------------
//
//  drive_6dig_7seg.v -- drives 6 digit 7 segment displays on DE10-Lite board
//
//  Copyright (C) 2020 Michael Gansler
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ------------------------------------------------------------------------------
//
//  Module:       drive_6dig_7seg.v
//
//  Objective:    drives 6 digit 7 segment displays on DE10-Lite board
//
//  Assumptions:  DE10-Lite board
//
//  Notes:
//
//  Displays a 24 bit value in hex on the six seven segment displays
//  on a DE10-Lite board.  Nothing really too board-specific about this,
//  other than the segments on this board are active low.  Easy to 
//  adapt to any other board.
//
//  Nomenclature for the segments on this board is:
//
//          0
//        -----
//       |     |
//      5|     | 1
//       |  6  |
//        -----
//       |     |
//      4|     | 2
//       |     |
//        ----- 
//          3
//
//  The above is used to define the ordering of the bits returned
//  by the function 'segments' below.
//
//  A bit surprisingly, the DE10-Lite's six 7 segment displays are not
//  multiplexed.  Each segment on each LED has its own dedicated FPGA
//  pin.  I guess the board designers thought that they have so many pins 
//  on the FPGA, that it wasn't worth bothering to save pins.  (The 
//  Altera Max 10 on this board does have over 300 pins.
//
//  As a result, no sequential muxing logic is necessary to strobe 
//  the displays.  This module is therefore really straightforward and
//  purely combinatorial, so it actually doesn't even need a clock.
//
//  No input data_valid trigger, so display is constantly updated
//  as disp_value is changed.  Certainly not glitch-free outputs
//  to the LEDs, but only envisioned for visual display, so saw
//  no real need to overcomplicate.  Potential improvements would be
//  to add a data_valid input to trigger an update, and output latches 
//  for the display segment bits.
//
//  Note use of a function for converting a hex nibble to the segment
//  bits.  Seemed like a good simple example of how to use a function
//  in Verilog.  Other implementations are of course possible.
//

`default_nettype none                // Require all nets to be declared before used.
                                     // --> guarantees that typo'd net names get trapped


module drive_6dig_7segs
(
   input              clk,           // actually unused high speed input clock (for future features)
   input              hex_mode,      // flag for future use once BCD implemented
   input    [23:0]    disp_value,    // value to display on digits
   
   output    [6:0]    digit5,        // segments to light on left-most digit
   output    [6:0]    digit4,        //   ...
   output    [6:0]    digit3,        //   ...
   output    [6:0]    digit2,        //   ...
   output    [6:0]    digit1,        //   ...
   output    [6:0]    digit0         // segments to light on right-most digit
);


//
// Extract each 4 bit nibble and convert to 7 bits of segment
// light/no-light bits.
//
assign digit5 = segments( disp_value[23:20] );
assign digit4 = segments( disp_value[19:16] );
assign digit3 = segments( disp_value[15:12] );
assign digit2 = segments( disp_value[11: 8] );
assign digit1 = segments( disp_value[ 7: 4] );
assign digit0 = segments( disp_value[ 3: 0] );


//
// Convert a hex nibble, i.e. 0 through F, to a 7 bit variable
// representing which segments on the 7 segment display should 
// be lit.
//
function automatic [6:0] segments ( input [3:0] i_nibble );

   begin
      
      //
      // Since DE10-Lite board 7 segment displays LEDs
      // are wired active low, the bit patterns below 
      // are negated.  
      //
      // Each 1 in the raw literal value represents 
      // a lit segment.  
      //
      // 'default' case not necessary since list is exhaustive,
      // but good practice to include to ensure avoiding unintentional
      // inferred latch.  Note that this is _combinational_ logic.
      //
      
      case (i_nibble)         // 654 3210 <----- Bit positions based on
         4'h0   : segments = ~7'b011_1111;   //  numbering in comments at
         4'h1   : segments = ~7'b000_0110;   //  top of this module.
         4'h2   : segments = ~7'b101_1011;
         4'h3   : segments = ~7'b100_1111;
         4'h4   : segments = ~7'b110_0110;
         4'h5   : segments = ~7'b110_1101;
         4'h6   : segments = ~7'b111_1101;
         4'h7   : segments = ~7'b000_0111;
         4'h8   : segments = ~7'b111_1111;
         4'h9   : segments = ~7'b110_1111;
         4'hA   : segments = ~7'b111_0111;
         4'hB   : segments = ~7'b111_1100;
         4'hC   : segments = ~7'b011_1001;
         4'hD   : segments = ~7'b101_1110;
         4'hE   : segments = ~7'b111_1001;
         4'hF   : segments = ~7'b111_0001;
         default: segments = ~7'b100_0000;
      endcase
      
   end

endfunction


endmodule

