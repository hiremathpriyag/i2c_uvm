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
`timescale 1ns/1ps

interface i2c_interface(input pclk);

	logic s_resetn;
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

endinterface




