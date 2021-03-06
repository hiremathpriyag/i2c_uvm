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
// module: interface
// Description of the module : interface includes all the signals provided
// with the clocking bloks and modports
// 
//-----------------------------------------------------------------------------
`timescale 1ns/1ns

interface i2c_interface(input bit clk);

      logic s_resetn;
      logic i2c_scl;
      logic i2c_sda;


     clocking mdrv@(posedge clk);
	     default input #1 output #0;
	     output s_resetn;
	    output i2c_scl;
	    output i2c_sda;
     endclocking



    clocking mmon@(posedge clk);
	     default input #1 output #0;
	     input s_resetn;
	    input i2c_scl;
	    input i2c_sda;
     endclocking



  /*  clocking sdrv@(posedge clk);
	     default input #1 output #0;

	    	    output i2c_sda;
    endclocking*/

    clocking smon@(posedge clk);
	     default input #1 output #0;

	      input i2c_sda;
    endclocking


  modport MDRV (clocking mdrv);
  modport MMON (clocking mmon);
 // modport SDRV (clocking sdrv);
  modport SMON (clocking smon);


/*	logic s_resetn;
	logic scl_pad_i;
	logic scl_pad_o;
	logic scl_padoen_o;
	logic sda_pad_i;
	logic sda_pad_o;
	logic sda_padoen_o;

clocking mdrv_cb@(posedge pclk);
	default input #1 output #1;
	output s_resetn;
	output scl_pad_i;
	input scl_pad_o;
	input scl_padoen_o;
	output sda_pad_i;
	input sda_pad_o;
	input sda_padoen_o;
endclocking


clocking mmon_cb@(posedge pclk);
	default input #1 output #1;
	input scl_pad_i;
	output scl_pad_o;
	output scl_padoen_o;
	input sda_pad_i;
	output sda_pad_o;
	output sda_padoen_o;
endclocking


clocking sdrv_cb@(posedge pclk);
	default input #1 output #1;
	input scl_pad_i;
	output scl_pad_o;
	output scl_padoen_o;
	input sda_pad_i;
	output sda_pad_o;
	output sda_padoen_o;
	output s_resetn;
endclocking


clocking smon_cb@(posedge pclk);
	default input #1 output #1;
	output scl_pad_i;
	input scl_pad_o;
	input scl_padoen_o;
	output sda_pad_i;
	input sda_pad_o;
	input sda_padoen_o;
endclocking



modport MDRV (clocking mdrv_cb);
modport MMON (clocking mmon_cb);
modport SDRV (clocking sdrv_cb);
modport SMON (clocking smon_cb);
*/
endinterface




