class master_i2c_agent_top extends uvm_env;

`uvm_component_utils(master_i2c_agent_top)

master_i2c_agent agnth[];

i2c_env_config e_cfg;

extern function new(string name="master_i2c_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

//new constructor
function master_i2c_agent_top::new(string name="master_i2c_agent_top",uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void master_i2c_agent_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(i2c_env_config)::get(this,"","i2c_env_config",e_cfg))
	`uvm_fatal("AGT TOP","cannot get the e_cfg from i2c_env_config DB")
	
	if(e_cfg.has_agent_top)
	agnth=new[e_cfg.no_of_agents];
	foreach(agnth[i])
	begin
		uvm_config_db #(master_i2c_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"master_i2c_agent_config",e_cfg.master_agt_cfg[i]);
		agnth[i]=master_i2c_agent::type_id::create($sformatf("agnth[%0d]",i),this);
	end

endfunction

task master_i2c_agent_top::run_phase(uvm_phase phase);
	uvm_top.print_topology();
endtask
