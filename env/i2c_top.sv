//  ############################################################################
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the
//  "License"); you may not use this file except in compliance
//  with the License.  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.
//
//  ###########################################################################

//-----------------------------------------------------------------------------
// module testbench top
// Description of the module:
// top of testbench environment intantiates with rtl 
//-----------------------------------------------------------------------------
//
`timescale 1ns/1ns
module i2c_top;

import uvm_pkg::*;
import i2c_pkg::*;

bit clock;
bit reset;
always
begin
clock = 0;
forever #10 clock = ~clock;
end

initial
begin 
reset=1'b1;
#5;
reset=1'b0;
end


//dut_wrap DUT(.clk(clock),.reset(s_reset_n),.i2c_scl(i2c_scl),.i2c_sda(i2c_sda));
/*initial begin
	clock =0;
	#5;
	forever clock=~clock;
	#5;
	$display ("displayimg the clock");

end*/
i2c_interface in0(clock);
//slave_interface in1(clock);

/*
 pulpino_top
   top_i
  (
    .clk               ( clock        ),
    .rst_n             ( s_resetn     ),
    .scl_pad_i         ( scl_pad_i    ),
    .scl_pad_o         ( scl_pad_o    ),
    .scl_padoen_o      ( scl_padoen_o ),
    .sda_pad_i         ( sda_pad_i    ),
    .sda_pad_o         ( sda_pad_o    ),
    .sda_padoen_o      ( sda_padoen_o )


  );

*/
/*i2c_eeprom_model
  #(
    .ADDRESS ( 7'b1010_000 )
  )
  i2c_eeprom_model_i
  (
    .scl_io ( scl_io  ),
    .sda_io ( sda_io  ),
    .rst_ni ( s_rst_n )
  );

*/




 initial
   begin
	   
     uvm_config_db #(virtual i2c_interface) :: set (null ,"*","vif",in0);
     //uvm_config_db #(virtual master_interface) :: set (null ,"*","vif_0",in0);
     //uvm_config_db #(virtual slave_interface) :: set (null ,"*","vif_1",in1);
     run_test("test_1");
    uvm_top.print_topology();
   end
endmodule
