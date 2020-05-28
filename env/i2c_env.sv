class i2c_env extends uvm_env;

`uvm_component_utils(i2c_env)

master_i2c_agent_top m_agt_top;
slave_i2c_agent_top s_agt_top;
i2c_env_config e_cfg;
i2c_virtual_sequencer v_sequencer;
i2c_scoreboard sb;

extern function new(string name="i2c_env",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

//new constructor
function i2c_env::new(string name="i2c_env",uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void i2c_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(i2c_env_config)::get(this,"","i2c_env_config",e_cfg))
	`uvm_fatal("ENV","cannot get the e_cfg from the i2c_env_config DB")



if(e_cfg.has_agent_top)
		e_cfg.master_agt_cfg=new[e_cfg.no_of_agents];
		
	if(e_cfg.has_agent_top)
		e_cfg.slave_agt_cfg=new[e_cfg.no_of_agents];

/*if(e_cfg.has_agent_top)
	m_agt_top=master_i2c_agent_top::type_id::create("m_agt_top",this);

if(e_cfg.has_agent_top)
	s_agt_top=master_i2c_agent_top::type_id::create("s_agt_top",this);

*/
if(e_cfg.has_virtual_sequencer)
	v_sequencer=i2c_virtual_sequencer::type_id::create("v_sequencer",this);

if(e_cfg.has_scoreboard)
	sb=i2c_scoreboard::type_id::create("sb",this);
endfunction


function void i2c_env::connect_phase(uvm_phase phase);
	if(e_cfg.has_virtual_sequencer)
	begin
	     if(e_cfg.has_agent_top)
	     begin
		  foreach(v_sequencer.m_seqrh[i])
			v_sequencer.m_seqrh[i]=m_agt_top.agnth[i].m_sequencer;
	     end

	     if(e_cfg.has_agent_top)
	     begin
		  foreach(v_sequencer.s_seqrh[i])
			v_sequencer.s_seqrh[i]=s_agt_top.agnth[i].m_sequencer;
	     end

	end

	
	if(e_cfg.has_scoreboard)
	begin
	     if(e_cfg.has_agent_top)
	     begin
		  m_agt_top.agnth[0].monh.mon_port.connect(sb.fifo_0.analysis_export);
		  s_agt_top.agnth[1].monh.mon_port.connect(sb.fifo_1.analysis_export);
	     end
	end

endfunction
	
