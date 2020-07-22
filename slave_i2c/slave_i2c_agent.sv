class slave_i2c_agent extends uvm_agent;

`uvm_component_utils(slave_i2c_agent)

//slave_i2c_driver drvh;
slave_i2c_monitor monh;
//slave_i2c_sequencer m_sequencer;
slave_i2c_agent_config s_cfg;

extern function new(string name="slave_i2c_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern function void connect_phase(uvm_phase phase);
endclass

//new constructor
function slave_i2c_agent::new(string name="slave_i2c_agent",uvm_component parent);
	super.new(name,parent);
endfunction

//build phase
function void slave_i2c_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
		if(!uvm_config_db #(slave_i2c_agent_config)::get(this,"","slave_i2c_agent_config",s_cfg))
		`uvm_fatal("slave_agent","cannot get the m_cfg from slave_i2c_agent_config DB")
	monh=slave_i2c_monitor::type_id::create("monh",this);
	
/*	if(s_cfg.is_active==UVM_ACTIVE)
		begin
		     drvh=slave_i2c_driver::type_id::create("drvh",this);
		     m_sequencer=slave_i2c_sequencer::type_id::create("m_sequencer",this);
		end*/
endfunction

//connect phase
/*function void slave_i2c_agent::connect_phase(uvm_phase phase);
	if(s_cfg.is_active==UVM_ACTIVE)
	begin
		drvh.seq_item_port.connect(m_sequencer.seq_item_export);
	end
endfunction*/
