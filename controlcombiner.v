`timescale 1ns / 1ps
`default_nettype none


//Created by script createcontrolcombiner.py
module controlcombiner(
input wire [15:0] signal,
input wire [5:0] blockaddress,
input wire write,
input wire clk,
output reg [1023:0] combinedout
);

always @(posedge clk) begin
    if (write) begin
      case(blockaddress)
       0: combinedout[15:0] <= signal;
       1: combinedout[31:16] <= signal;
       2: combinedout[47:32] <= signal;
       3: combinedout[63:48] <= signal;
       4: combinedout[79:64] <= signal;
       5: combinedout[95:80] <= signal;
       6: combinedout[111:96] <= signal;
       7: combinedout[127:112] <= signal;
       8: combinedout[143:128] <= signal;
       9: combinedout[159:144] <= signal;
       10: combinedout[175:160] <= signal;
       11: combinedout[191:176] <= signal;
       12: combinedout[207:192] <= signal;
       13: combinedout[223:208] <= signal;
       14: combinedout[239:224] <= signal;
       15: combinedout[255:240] <= signal;
       16: combinedout[271:256] <= signal;
       17: combinedout[287:272] <= signal;
       18: combinedout[303:288] <= signal;
       19: combinedout[319:304] <= signal;
       20: combinedout[335:320] <= signal;
       21: combinedout[351:336] <= signal;
       22: combinedout[367:352] <= signal;
       23: combinedout[383:368] <= signal;
       24: combinedout[399:384] <= signal;
       25: combinedout[415:400] <= signal;
       26: combinedout[431:416] <= signal;
       27: combinedout[447:432] <= signal;
       28: combinedout[463:448] <= signal;
       29: combinedout[479:464] <= signal;
       30: combinedout[495:480] <= signal;
       31: combinedout[511:496] <= signal;
       32: combinedout[527:512] <= signal;
       33: combinedout[543:528] <= signal;
       34: combinedout[559:544] <= signal;
       35: combinedout[575:560] <= signal;
       36: combinedout[591:576] <= signal;
       37: combinedout[607:592] <= signal;
       38: combinedout[623:608] <= signal;
       39: combinedout[639:624] <= signal;
       40: combinedout[655:640] <= signal;
       41: combinedout[671:656] <= signal;
       42: combinedout[687:672] <= signal;
       43: combinedout[703:688] <= signal;
       44: combinedout[719:704] <= signal;
       45: combinedout[735:720] <= signal;
       46: combinedout[751:736] <= signal;
       47: combinedout[767:752] <= signal;
       48: combinedout[783:768] <= signal;
       49: combinedout[799:784] <= signal;
       50: combinedout[815:800] <= signal;
       51: combinedout[831:816] <= signal;
       52: combinedout[847:832] <= signal;
       53: combinedout[863:848] <= signal;
       54: combinedout[879:864] <= signal;
       55: combinedout[895:880] <= signal;
       56: combinedout[911:896] <= signal;
       57: combinedout[927:912] <= signal;
       58: combinedout[943:928] <= signal;
       59: combinedout[959:944] <= signal;
       60: combinedout[975:960] <= signal;
       61: combinedout[991:976] <= signal;
       62: combinedout[1007:992] <= signal;
       63: combinedout[1023:1008] <= signal;
       endcase
   end
end
endmodule
