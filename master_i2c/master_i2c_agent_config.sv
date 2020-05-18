/  ############################################################################
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
// Class: environment
// Description of the class :
// This class acts like a container
//-----------------------------------------------------------------------------

`ifndef master_i2c_agent_config
`define master_i2c_agent_config

class master_i2c_agent_config extends uvm_object;

`uvm_object_utils(master_i2c_agent_config)

virtual i2c_interface vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

static int mon_rcvd_xtn_cnt=0;

static int drv_data_sent_cnt=0;


//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------


extern function new(string name="master_i2c_agent_config");
endclass


//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the environment class object
//
// Parameters:
//  name   - instance name of the environment
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------



function master_i2c_agent_config::new(string name="master_i2c_agent_config");
	super.new(name);
endfunction







`endif

