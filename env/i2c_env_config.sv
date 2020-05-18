class i2c_env_config extends uvm_object;

`uvm_object_utils(i2c_env_config)

bit has_scoreboard=1;
bit has_functional_coverage=1;
bit has_agent_top=2;
int no_of_agents=2;
bit has_virtual_sequencer=1;

master_i2c_agent_config m_agt_cfg[];
slave_i2c_agent_config s_agt_cfg[];




extern function new(string name="i2c_env_config");
endclass


function uart_env_config::new(string name="i2c_env_config");
	super.new(name);
endfunction

