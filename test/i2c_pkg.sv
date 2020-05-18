package i2c_pkg;


import uvm_pkg::*;

`include "uvm_macros.svh"

`include "master_i2c_xtn.sv"

`include "master_i2c_agent_config.sv"
`include "master_i2c_agent_config.sv"
`include "i2c_env_config.sv"


`include "master_i2c_driver.sv"
`include "master_i2c_monitor.sv"
`include "master_i2c_sequencer.sv"
`include "master_i2c_agent.sv"
`include "master_i2c_agent_top.sv"
`include "master_i2c_sequence.sv"

`include "slave_i2c_driver.sv"
`include "slave_i2c_monitor.sv"
`include "slave_i2c_sequencer.sv"
`include "slave_i2c_agent.sv"
`include "slave_i2c_agent_top.sv"
`include "slave_i2c_sequence.sv"

`include "i2c_virtual_sequencer.sv"
`include "i2c_virtual_sequence.sv"
`include "i2c_scoreboard.sv"


`include "i2c_env.sv"


`include "i2c_test.sv"

endpackage

