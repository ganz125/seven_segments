//  ------------------------------------------------------------------------------
//
//  test_seven_segments.v -- test module for drive_6_7segs.v
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
//  Module:       test_seven_segments.v
//
//  Objective:    test module for drive_6_7segs.v
//
//  Assumptions:  50 MHz input clock
//                DE10-Lite board
//
//  Notes:
//
//    This is a lot like a test bench, but this is intended for testing on 
//    actual h/w, so it is synthesizable, and easily interfaces with switches 
//    and the six 7 segment displays on a Terasic DE10-Lite board.
// 
//    Counter value is displayed on the six 7 segment displays in hex.
//
//    Four slide switches set rate at which the counter is incremented.  
//    The 16 possible speeds can be set from 1 Hz to 100 KHz, logarithmically spaced.
//    This allows for a quick test over the full range of values, testing all 6
//    digits quickly, and it was amusing, so why not.
//
//    This could have been done as a testbench and run in simulation, but it was 
//    easier to verify the shapes of all the letters/numbers on the actual 
//    hardware displays.
//
//
    
    
`default_nettype none                        // Require all nets to be declared before used.
                                             // --> guarantees that typo'd net names get trapped

module test_seven_segments
(
   input             clk,                    // high speed clock from PLL, 50 MHz
   
   input             count_en,               // allow/inhibit counting
   input    [3:0]    switches,               // 4 slide switches to set display value increment rate
   
   output   [6:0]    digit5,                 // active low bits for 7 segments of digit 5 (left-most digit) 
   output   [6:0]    digit4,                 // active low bits for 7 segments of digit 4
   output   [6:0]    digit3,                 // active low bits for 7 segments of digit 3 
   output   [6:0]    digit2,                 // active low bits for 7 segments of digit 2  
   output   [6:0]    digit1,                 // active low bits for 7 segments of digit 1 
   output   [6:0]    digit0                  // active low bits for 7 segments of digit 0 (right-most digit) 
);


reg        [27:0]    ctr      = 1;           // high speed counter, counts at clk freq

reg        [27:0]    thresh   = 50_000_000;  // thresh for reseting high speed counter, in clk cycles
  
reg        [23:0]    test_val = 24'hab_cdef; // value that is incremented and sent to the six digit 7 segment display


drive_6dig_7segs drive_6dig_7segs_inst1      // instantiate DUT (Device Under Test)
(
   .clk              ( clk ),
   .hex_mode         ( 1'b1 ),
   .disp_value       ( test_val ),
   
   .digit5           ( digit5 ),
   .digit4           ( digit4 ),
   .digit3           ( digit3 ),
   .digit2           ( digit2 ),
   .digit1           ( digit1 ),
   .digit0           ( digit0 )
);


//
// Increment test_val sent to 7 segment displays at user-selectable frequency.
//
// Threshold sets number of clk cycles between increments of test_val.
//
always @(posedge clk) begin

   if (count_en) begin
   
      if (ctr<thresh) begin
      
         ctr <= ctr + 28'd1;
         
      end else begin
      
         ctr <= 28'd0;
         
         test_val <= test_val + 24'd1;   // increment value sent to display.
      
      end
      
   end
      
end


//
// Select counting frequency via 4 slide switches.
//
// Assumption - 50 MHz input clk
//
// Logarithmically spaced threshold values allows counting at
// frequencies between 1 Hz and 100 KHz.  
//
// thresh is in clk cycles, e.g. 
//
//   50,000,000 --> 1 Hz
//   10,000,000 --> 5 Hz
//           .
//           .
//           .
//        1,000 -->  50 KHz
//          500 --> 100 KHz
//
// 'default' case not necessary since list is exhaustive,
// but good practice to include to ensure avoiding unintentional
// inferred latch.  Note that this 'always' block is 
// _combinational_ logic.
//
always @(*) begin

   case (switches)
      4'h0   : thresh = 50_000_000;
      4'h1   : thresh = 25_000_000;
      4'h2   : thresh = 10_000_000;
      4'h3   : thresh =  5_000_000;
      4'h4   : thresh =  2_500_000;
      4'h5   : thresh =  1_000_000;
      4'h6   : thresh =    500_000;
      4'h7   : thresh =    250_000;
      4'h8   : thresh =    100_000;
      4'h9   : thresh =     50_000;
      4'hA   : thresh =     25_000;
      4'hB   : thresh =     10_000;
      4'hC   : thresh =      5_000;
      4'hD   : thresh =      2_500;
      4'hE   : thresh =      1_000;
      4'hF   : thresh =        500;
      default: thresh = 50_000_000;
   endcase
   
end


endmodule
