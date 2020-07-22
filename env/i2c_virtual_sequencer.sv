class i2c_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

`uvm_component_utils(i2c_virtual_sequencer)

master_i2c_sequencer m_seqrh[];
//slave_i2c_sequencer  s_seqrh[];
i2c_env_config e_cfg;


extern function new(string name="i2c_virtual_sequencer",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass


function i2c_virtual_sequencer::new(string name="i2c_virtual_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction


function void i2c_virtual_sequencer::build_phase(uvm_phase phase);
	if(!uvm_config_db #(i2c_env_config)::get(this,"","i2c_env_config",e_cfg))
	`uvm_fatal("V_SEQR","Cannot get the e_cfg from the uvm_config_db")
	
	super.build_phase(phase);
	
	m_seqrh=new[e_cfg.no_of_agents];
	//s_seqrh=new[e_cfg.no_of_agents];
	
endfunction

