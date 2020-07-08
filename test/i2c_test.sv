class i2c_test extends uvm_test;

	`uvm_component_utils(i2c_test)

	i2c_env  env;
	i2c_env_config e_cfg;
        master_i2c_agent_config m_cfg[];
        slave_i2c_agent_config s_cfg[];

        bit has_agent_top=2;
        bit no_of_agents=2;


//---------------------------------------------
// Externally defined tasks and functions
//---------------------------------------------
extern function new (string name="i2c_test",uvm_component parent);
extern function void build_phase (uvm_phase phase);
extern function void config_i2c;

endclass

//-----------------------------------------------------------------------------
// Constructor: new
// Initializes the test class object
//
// Parameters:
//  name   - instance name of the test
//  parent - parent under which this component is created
//-----------------------------------------------------------------------------

 function i2c_test ::new(string name ="i2c_test",uvm_component parent);
	 super.new(name,parent);
 endfunction 

//-----------------------------------------------------------------------------
// Function: build_phase
// Creates components for  master_agt_top,slave_agt_top and virtual_sequencer 
//
// Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------


function void i2c_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
       e_cfg=i2c_env_config::type_id::create("e_cfg");
     

          //number of  agent creations
	  if(has_agent_top)
		  e_cfg.master_agt_cfg=new[no_of_agents];

	  if(has_agent_top)
		  e_cfg.slave_agt_cfg=new[no_of_agents];
	         
	         
	  //calling the configuration function
	    config_i2c();
       
	   //setting of the environment configuration

	   uvm_config_db #(i2c_env_config)::set(this,"*","i2c_env_config",e_cfg);

	   //create environment using factory method
      
	     env=i2c_env::type_id::create("env",this);
endfunction
 


//-----------------------------------------------------------------------------
// Function: configuartion function
// creation of masterand slave agents with gettingthe virtual interface handle
//  phase - stores the current phase 
//-----------------------------------------------------------------------------

 function void i2c_test::config_i2c();
	 if(has_agent_top)
	 begin
		  m_cfg=new[no_of_agents];
		  foreach(m_cfg[i])
	          begin
	          	m_cfg[i]=master_i2c_agent_config::type_id::create($sformatf("m_cfg[%0d]",i));	
		  if(!uvm_config_db #(virtual i2c_interface)::get(this," ",$sformatf("vif[%0d]",i),m_cfg[i].vif))
		 `uvm_fatal ("test"," cannot get the virtual interface to the master agent confiv")
		  m_cfg[i].is_active=UVM_ACTIVE;

                  e_cfg.master_agt_cfg[i]=m_cfg[i];
		  end
	 end

          if(has_agent_top)
	 begin
		  s_cfg=new[no_of_agents];
		  foreach(s_cfg[i])
	          begin
	          s_cfg[i]=slave_i2c_agent_config::type_id::create($sformatf("s_cfg[%0d]",i));
		  if(!uvm_config_db #(virtual i2c_interface)::get(this," ",$sformatf("vif[%0d]",i),s_cfg[i].vif))
		 `uvm_fatal ("test"," cannot get the virtual interface to the master agent confiv")
		  s_cfg[i].is_active=UVM_ACTIVE;

                  e_cfg.slave_agt_cfg[i]=s_cfg[i];
		  end
	 end

	 e_cfg.has_agent_top=has_agent_top;
	 e_cfg.no_of_agents=no_of_agents;

 endfunction


////////////////////////////////////////////////////////////test1/////////////////////////////////////////////////////////////////////////////
 
 class test_1 extends i2c_test;
	 `uvm_component_utils(test_1)
	 i2c_virtual_sequence seq;

	 extern function new(string name ="test_1",uvm_component parent);
	 extern function void build_phase(uvm_phase phase);
	 extern task run_phase(uvm_phase phase);

endclass
//-----------------------------------------------------------------------------
// Function: constructor new
// Creates components for  master_agt_top,slave_agt_top and virtual_sequencer 
//
// Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------


        function test_1::new(string name ="test_1",uvm_component parent);
		super.new(name,parent);
	endfunction
//-----------------------------------------------------------------------------
// Function: build_phase
// Creates components for  master_agt_top,slave_agt_top and virtual_sequencer 
//
// Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------


	function void test_1::build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction
//-----------------------------------------------------------------------------
// Function: build_phase
// Creates components for  master_agt_top,slave_agt_top and virtual_sequencer 
//
// Parameters:
//  phase - stores the current phase 
//-----------------------------------------------------------------------------


	task test_1 ::run_phase(uvm_phase phase);
		phase.raise_objection(this);
		seq=i2c_virtual_sequence::type_id::create("seq");
		seq.start(env.v_sequencer);
		#1000;
		phase.drop_objection(this);
	endtask




