interface slave_if(input logic sclk,reset);
  
 logic i2c_scl;
  logic i2c_sda;
  logic [7:0] i2c_data;
  logic [6:0] i2c_address;
  logic i2c_ack;
  logic s_resetn;
  
  
  ///////////////slave_drv_cb///////////
  clocking slave_drv_cb@(posedge sclk);
    default input #1 output #0;
    
    output i2c_ack;
    output i2c_sda;
    
    
  endclocking
  
  
  //slave_mon_cb/////////////
  clocking slave_mon_cb@(posedge sclk);
    default input #1 output #0;
    input  i2c_sda;
    input  i2c_address;
   
  endclocking
  
   
   
  
 modport SDRV_MP(clocking slave_drv_cb);
 modport SMON_MP(clocking slave_mon_cb);
      
      
   endinterface    
 
   
   
  
 import uvm_pkg::*;
 `include "uvm_macros.svh"
    
    
 ////////////////slave_transaction/////////////////////   
        
    
class slave_trans extends uvm_sequence_item;

 
  rand bit[7:0] i2c_data;
     rand  bit[6:0] i2c_address;
  rand bit r_w;
  bit i2c_ack;
  
  `uvm_object_utils_begin(slave_trans)
  `uvm_field_int(i2c_data,UVM_ALL_ON)
  `uvm_field_int(i2c_address,UVM_ALL_ON)
  `uvm_field_int(r/w,UVM_ALL_ON)
  `uvm_object_utils_end
  
  slave_trans trans;
    
  extern function new(string name="slave_trans");
      
 endclass

  
  function slave_trans::new(string name="slave_trans");
    super.new(name);
  
  endfunction
  
  
    
 
 ///////////////slave_sequence//////////////////////////   
 class slave_seq extends uvm_sequence #(slave_trans);
        
   `uvm_object_utils(slave_seq) 
   
   extern function new(string name="slave_seq");
   extern task body();
       
 endclass
     
 function slave_seq::new(string name="slave_seq");
    super.new(name);
 endfunction
     
 task slave_seq::body();
   
   req=slave_trans::type_id::create("req");
   wait_for_grant();
   assert(req.randomize());
   send_request(req);
   wait_for_item_done();
        
 endtask
     
     
     
  class slave_write_seq extends slave_seq;
     
   `uvm_object_utils(slave_write_seq)
   
    extern function new(string name="slave_write_seq");
   extern task body();
       
 endclass
     
 function slave_write_seq::new(string name="slave_write_seq");
    super.new(name);
 endfunction
     
 task slave_write_seq::body();
  
  /* `uvm_do_with(req,{req.miso==8'b10101011;})//req.cpol==0;req.cpha==0;})
   //`uvm_info("INFO",$sformatf("Value of cpol=%d \t cpha=%d \t miso=%b",req.cpol,req.cpha,req.miso),UVM_LOW)
   `uvm_info("INFO",$sformatf("Value of miso=%b",req.miso),UVM_LOW)
   
   */
 endtask
     
       
 /////////////////slave_sequencer/////////////////////////
   
 class slave_seqr extends uvm_sequencer #(slave_trans);
    
   `uvm_component_utils(slave_seqr) 
  
   extern function new(string name="slave_seqr",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
     
 endclass
     
     function slave_seqr::new(string name="slave_seqr",uvm_component parent);
   super.new(name,parent);
 endfunction
 
  function void slave_seqr::build_phase(uvm_phase phase);
     super.build_phase(phase);
  endfunction
     
     
 
     
 /////////////////slave_drv/////////////////////////////////
     
 class slave_drv extends uvm_driver #(slave_trans);
       
 `uvm_component_utils(slave_drv) 
  virtual slave_if vif;
     
   
   extern function new(string name="slave_drv",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
  // extern task run_phase(uvm_phase phase);    
   //extern task drive2dut();
 
 endclass
 
   
 function slave_drv::new(string name="slave_drv",uvm_component parent);
   super.new(name,parent);
 endfunction
     
     function void slave_drv::build_phase(uvm_phase phase);
       super.build_phase(phase);
       if(!uvm_config_db #(virtual slave_if)::get(this,"","vif",vif))
       begin
          `uvm_fatal(get_type_name(),"interface in slave driver not found")
       end
     endfunction
     
     function void slave_drv::connect_phase(uvm_phase phase);
       super.connect_phase(phase);
     endfunction               
            
     
   
 /////////////////slave_drv/////////////////////////////////

 
///////////////////////slave_mon///////////////////////////////////////

class slave_mon extends uvm_monitor;
       
  `uvm_component_utils(slave_mon)
  virtual slave_if vif;
  
  uvm_analysis_port #(slave_trans) s_mon2sb;
  
  slave_trans s_trans; //slave_transaction
  
  
  
   extern function new(string name="slave_mon",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   //extern task run_phase(uvm_phase phase);   
   //extern task collect_data();  
  
 endclass
 
     
 function slave_mon::new(string name="slave_mon",uvm_component parent);
   super.new(name,parent);
   s_mon2sb=new("s_mon2sb",this);
   
 endfunction
     
 function void slave_mon::build_phase(uvm_phase phase);
    super.build_phase(phase);
    s_trans=slave_trans::type_id::create("s_trans");
       
   if(!uvm_config_db #(virtual slave_if)::get(this,"","vif",vif))
       begin
         `uvm_fatal(get_type_name(),"interface in slave monitor not found")
       end   
  endfunction
     
  function void slave_mon::connect_phase(uvm_phase phase);
     super.connect_phase(phase);
  endfunction
     
 /* task slave_mon::run_phase(uvm_phase phase);
     super.run_phase(phase);
    
    
    //process to add here for taking the signal values fro interface and putting onto packet
  forever
    begin
       @(vif.slave_mon_cb);
      if(!vif.slave_mon_cb.reset) begin
        `uvm_info(get_type_name(),"RESET IN MONITOR",UVM_LOW)
                
      end
     else begin
       collect_data();
     end
    end
  endtask
     
     task slave_mon::collect_data();
       forever begin
        @(posedge vif.sclk);
    //  `uvm_info(get_type_name(),"SLAVE MONITOR",UVM_LOW);
      if(s_trans.miso==8'b00000000)
        $display("");//, "wait for getting transaction");
      else 
       // @(posedge vif.sclk);
       $display($time,"*****MONITOR***** %b",s_trans.miso);
       s_trans.miso_data=s_trans.miso[7];
      s_trans.miso_data = vif.slave_mon_cb.miso_data;
      s_trans.miso = vif.slave_mon_cb.miso;
    
      // $display($time,"*****MONITOR***** %b",s_trans.miso);
     // s_trans.miso_data=s_trans.miso[7];
       $display($time,"*****MONITOR(BIT)***** %b",s_trans.miso_data);
      //  end
    s_mon2sb.write(s_trans); //sending the packet to sb for comparision by using analysis port
        
     // $display($time,"*****MONITOR(BIT)***** %b",s_trans.miso_data);
       
    end
  endtask*/
     
///////////////////slave_mon///////////////////////////////////////
     
     
//////////////////////////////////slave_agent_cfg///////////////////////////////////////////
     
 class slave_agent_cfg extends uvm_object;
    
  `uvm_object_utils(slave_agent_cfg)
  
  virtual slave_if vif;
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  bit has_functional_coverage=0;
  
  
   extern function new(string name="slave_agent_cfg");
    // extern function void build_phase(); //its object,so no build_phase  
  
endclass
    
     function slave_agent_cfg::new(string name="slave_agent_cfg");
       super.new(name);
    endfunction
    

    
    
  ///////////////////////////slave_agent_cfg////////////////////////////////////////////////      
     
     
     
///////////////////slave_agent///////////////////////////////////////

 typedef class slave_env_cfg;    
class slave_agent extends uvm_agent;

  `uvm_component_utils(slave_agent)
   
  
  //agent handles
  slave_seqr s_seqr;
  slave_drv s_drv;
  slave_mon s_mon;
  

  //declaring m_cfg handle
 // slave_agent_cfg m_cfg;
  
 slave_agent_cfg s_cfg[]; //tried with above,but not getting as config needs to be dynamic
  
  slave_env_cfg e_cfg;
  
  
  int i=0;
  
  
  extern function new(string name="s_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
 // extern task run_phase(uvm_phase phase);
    
endclass
      
    
function slave_agent::new(string name="s_agent",uvm_component parent);
  super.new(name,parent);
endfunction
    
 
 function void slave_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   if(!uvm_config_db #(slave_env_cfg)::get(this,"","e_cfg",e_cfg))
   begin
   
     `uvm_fatal(get_type_name(),"not getting env cfg hanlde in agent")
   end
   
   //
   i=e_cfg.no_of_s_agent;
  
 /*   //by creating m_top
 if(!uvm_config_db #(slave_agent_cfg)::get(this,"","m_cfg",e_cfg.m_cfg))
   begin
   
     `uvm_fatal(get_type_name(),"not getting cfg hanlde in agent")
   end
   
   m_cfg=slave_agent_cfg::type_id::create("slave_agent_cfg[1]"); 
   m_mon=slave_mon::type_id::create("m_mon",this);  
  
   if(m_cfg.is_active==UVM_ACTIVE)
   begin
      m_drv=slave_drv::type_id::create("m_drv",this);
      m_seqr=slave_seqr::type_id::create("m_seqr",this);
    end
   
 */  
   
   
// get the config handle
   s_cfg=new[i];
   
   foreach(s_cfg[i])
   
  // for(int j=0;j<i;j++)  
   begin
     if(!uvm_config_db #(slave_agent_cfg)::get(this,"","slave_agent_cfg",e_cfg.s_cfg[i]))
   begin
   
     `uvm_fatal(get_type_name(),"not getting cfg hanlde in agent")
   end
     s_cfg[i]=slave_agent_cfg::type_id::create($sformatf("slave_agent_cfg[%0d]",i));  
  // m_cfg[1]=slave_agent_cfg::type_id::create("slave_agent_cfg[1]");  
   
  //  else
  //    $display("m_cfg=%0d",i);
       
       
    s_mon=slave_mon::type_id::create("s_mon",this);    
  end
  
   
  //not sure about creating m_mon for each config 
  // m_mon=slave_mon::type_id::create("m_mon",this);
   
  // if(get_is_active()==UVM_ACTIVE)
   foreach(s_cfg[i])
     begin
     if(s_cfg[i].is_active==UVM_ACTIVE)
  //   if(e_cfg.m_cfg[i].is_active==UVM_ACTIVE)
 //if(m_cfg.is_active==UVM_ACTIVE)
   begin
      s_drv=slave_drv::type_id::create("s_drv",this);
     s_seqr=slave_seqr::type_id::create("s_seqr",this);
   end
     end
 // end //f_ever
  
 endfunction
    
    
 function void slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   s_drv.seq_item_port.connect(s_seqr.seq_item_export);
 endfunction
  
  
  
///////////////////slave_agent///////////////////////////////////////  
  
    
////////////////////////////////slave_agent_top//////////////////////////////////////
    
typedef class slave_env_cfg;
    
class slave_agent_top extends uvm_component;
  
  `uvm_component_utils(slave_agent_top)
  
 // slave_agent m_agent[]; //dynamic array of agent instances
 
  slave_agent s_agent[];
  slave_env_cfg e_cfg;
  
  int i=1;
  
  extern function new(string name="slave_agent_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
      
endclass
  
  
    function slave_agent_top:: new(string name="slave_agent_top",uvm_component parent);
      super.new(name,parent);
    endfunction

    function void slave_agent_top::build_phase(uvm_phase phase);   
      super.build_phase(phase);
   //slave_env_cfg e_cfg;
      
      if(!uvm_config_db #(slave_env_cfg)::get(this,"","e_cfg",e_cfg))
        //do not use virtual keyword here in config_db,this is not an interface,keep a note of it
        begin
      //  `uvm_fatal(get_type_name(),"unable to get e_cfg handle from test in slave_agent_top")
          `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"}); 
          
        end
      
  /*    
      uvm_config_db #(slave_agent_cfg)::set(this,"*","m_cfg",e_cfg.m_cfg);
          
      m_agent=slave_agent::type_id::create("m_agent",this);
      
    */  
      
   //****this is additional code,if foreach doesnot execute   
     // int i=0;
      i=e_cfg.no_of_s_agent;
      s_agent=new[i]; //there is diff betwn ,new[] and new ().For dynamic array ,we got to define the size here  
      
   //   foreach(m_agent[e_cfg.no_of_m_agent])
      foreach(s_agent[i])
        begin
        
        
          uvm_config_db #(slave_agent_cfg)::set(this,$sformatf("s_agent[%0d]",i),"slave_agent_cfg",e_cfg.s_cfg[i]);
        
   //check with setting of this handle once,coz we are using slave_agent_cfg in slave_agent_top.
   //so better have a clearity on this.
    
          s_agent[i]=slave_agent::type_id::create($sformatf("s_agent[%0d]",i),this);    
        
        
        end
 
    endfunction
        
 
    
///////////////////slave_scoreboard///////////////////////////////////////  
  /*  
class slave_sb extends uvm_scoreboard;   

  `uvm_component_utils(slave_sb)
  
//  uvm_analysis_imp #(slave_trans,slave_sb) sb2mon;
  
  
  //external function
  extern function new(string name="s_sb",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
  //extern write function
 //   extern function void write (slave_trans m_trans); 
  
 endclass
  
 
     
function slave_sb::new(string name="s_sb",uvm_component parent);
  super.new(name,parent);
 // sb2mon=new("sb2mon",this);
endfunction
    
 
 function void slave_sb::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
 endfunction
    
    
 function void slave_sb::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  
 endfunction
   
/*    
 ///add the function     
 function void slave_sb::write(slave_trans m_trans);
        
 endfunction 
  
     
 task slave_sb::run_phase(uvm_phase phase);
    super.run_phase(phase);
  
 endtask
    */

    
///////////////////////////slave_env_cfg///////////////////////////////
       
    
class slave_env_cfg extends uvm_object;
  
  `uvm_object_utils(slave_env_cfg)
  
  
  bit has_scoreboard=1;
  bit has_m_agent=1;
  bit has_s_agent=1;
  bit has_m_top=1;
  bit has_s_top=1;
  
  
  bit has_virtual_sequencer=1;
  slave_agent_cfg s_cfg[]; //config_object is dynamic,as config for particular agent might change
//  slave_agent_cfg m_cfg;
  
  
  //These are the flexible parameters,when declared can be reused accordingly
  int no_of_scoreboard=1;
  int no_of_m_agent=1;
  int no_of_s_agent=1;
  int no_of_m_top=1;
  int no_of_s_top=1;


  extern function new(string name="slave_env_cfg");
 
 endclass
    
    
 function slave_env_cfg::new(string name="slave_env_cfg");
   super.new(name);
  endfunction
    
   
    
    ///////////////////slave_env///////////////////////////////////////
    
 typedef class virtual_sequencer;   
    
 class slave_env extends uvm_env;

   `uvm_component_utils(slave_env)
   
   slave_agent_top stop;
  // slave_agent m_ag;
   slave_sb s_sb;
   
   virtual_sequencer v_seqr;
   slave_env_cfg e_cfg;
   
   
  extern function new(string name="slave_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
 endclass 
   
  
  function slave_env::new(string name="slave_env",uvm_component parent);
  super.new(name,parent);
  endfunction
    
 
 function void slave_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   
   if(!uvm_config_db #(slave_env_cfg)::get(this,"","e_cfg",e_cfg))
      begin
      `uvm_fatal(get_type_name(),"unable to get e_cfg in virtual_seq")
      end
   
   
   
   
   if(e_cfg.has_s_top==1)
   stop=slave_agent_top::type_id::create("s_ag_top",this);
  // m_ag=slave_agent::type_id::create("m_ag",this);
   
   if(e_cfg.has_scoreboard==1)
   s_sb=slave_sb::type_id::create("s_sb",this);
   
   if(e_cfg.has_virtual_sequencer==1)
     v_seqr=virtual_sequencer::type_id::create("v_seqr",this);
   
   
 endfunction
    
    
 function void slave_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   
  //need to add for slave also 
   
   if(e_cfg.has_virtual_sequencer)
     begin
       if(e_cfg.has_s_top)
         begin
           for(int i=0;i<e_cfg.no_of_s_agent;i++)
             begin
   
               v_seqr.s_seqr=stop.s_agent[i].s_seqr;
  
             end
         end
     end
 endfunction

     
 task slave_env::run_phase(uvm_phase phase);
    super.run_phase(phase);
  
 endtask
    
    
///////////////////slave_test///////////////////////////////////////    
    
typedef class virtual_sequence;    
    
class slave_test extends uvm_test;

 `uvm_component_utils(slave_test)
  
//  slave_write_seq mw_seq;
  slave_env s_env;
 
  
  slave_env_cfg e_cfg; //to set the handle
  
  
  virtual_sequence v_seq;
  
  extern function new(string name="slave_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration();  
  extern task run_phase(uvm_phase phase);
    
 endclass 
   
  
  function slave_test::new(string name="slave_test",uvm_component parent);
  super.new(name,parent);
  endfunction
    
 
 function void slave_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
//   mw_seq=slave_write_seq::type_id::create("m_seq");
   s_env=slave_env::type_id::create("s_env",this);
   e_cfg=slave_env_cfg::type_id::create("e_cfg",this);
   
   v_seq=virtual_sequence::type_id::create("v_seq");
   
   uvm_config_db #(slave_env_cfg)::set(this,"*","e_cfg",e_cfg);
   
 endfunction
    
    
 function void slave_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  
 endfunction

 function void slave_test::end_of_elaboration();
  //  super.conne(phase);
   uvm_top.print_topology();
 endfunction   
    
     
 task slave_test::run_phase(uvm_phase phase);
  // super.run_phase(phase);
   $display("before objection");
  phase.raise_objection(this);
   $display("afetr raising");
  // m_seq.start(m_env.mtop.m_agent[0].m_seqr);
  
   v_seq.start(s_env.v_seqr);
   phase.drop_objection(this);
   $display("after dropping");
 
 
   phase.phase_done.set_drain_time(this,50);
 endtask
  
 
    
 
/////////////////////////virtual_sequence/////////////////////////////////

typedef class virtual_sequencer;
typedef class slave_seqr;
    

class base_sequence extends uvm_sequence;
  
  `uvm_object_utils(base_sequence)
  
   virtual_sequencer v_seqr;
  
   slave_seqr s_seqr;
  
   slave_env_cfg e_cfg; 
  
    
  extern function new(string name="base_sequence");
   
  extern task body();  
    
endclass
    
      
 function base_sequence::new(string name="base_sequence");   
   super.new(name);
 endfunction
      
      
 task base_sequence::body();
 
   if(!$cast(v_seqr,m_sequencer))
     begin
     `uvm_fatal(get_type_name(),"virtual seqr pointer cast failed")
     end
   
   s_seqr=v_seqr.s_seqr;
   
 endtask
   
   
    
    
typedef class slave_write_seq;  
    
class virtual_sequence extends base_sequence;
  
  
  `uvm_object_utils(virtual_sequence);
  
 
   slave_write_seq sw_seq;
  
  slave_env_cfg e_cfg;
  
  
  extern function new(string name="v_sequence");
    
  extern task body();    
    
endclass
    
    
 function virtual_sequence::new(string name="v_sequence");   
   super.new(name);
 endfunction   
    
 task virtual_sequence::body();
  
   super.body; 
   
   sw_seq=slave_write_seq::type_id::create("sw_seq");
   
   
   sw_seq.start(s_seqr);

 endtask
   

    
 ////////////////////////////////virtual_sequencer////////////////////////////////////

class virtual_sequencer extends uvm_sequencer;
  
  `uvm_component_utils(virtual_sequencer)
  
  slave_seqr s_seqr;  
  
  extern function new(string name="v_seqr",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
//extern function void connect_phase(uvm_phase phase);    
  
 endclass
  
    
    function virtual_sequencer::new(string name="v_seqr",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    
    function void virtual_sequencer::build_phase(uvm_phase phase);
      super.build_phase(phase);
    
    endfunction
  

/////////////////////////////////////////////////////
  ///////////WRAPPER FOR B2B/////////////
    
    module wrapper_b2b(s_if,vif);
 // master_if m_if;
  slave_if s_if;
      slave_if vif;
      
 // assign s_if.sclk=vif.sclk;
 // assign s_if.reset=vif.reset;
  assign s_if.mosi=vif.mosi;    
      
      always@(*)
        begin
          vif.miso = s_if.miso;
          end
      initial
           begin
           $display("*********LOOPBACK MISO S_IF =********* %b",s_if.miso);
           $display("*********LOOPBACK MISO VIF =********* %b",vif.miso);
       //    $display("*********LOOPBACK MISO REQ=********* %b",req.miso);
         end
        
  
endmodule
    //////////////////////////////////////////////
    module slave_wrapper(input [7:0] miso,output sclk,reset,ss_n,reg [7:0] mosi);
      always@(posedge sclk)
        begin
          mosi <= miso;
          $display("********SLAVE_WRAPPER******** %b",mosi);
        end
    endmodule
    
    ///////////////////////top///////////////////////////    
    
module tb_top();

  bit sclk;
  bit reset;
  
 // master_if m_if();
  //slave_if s_if(sclk,reset);
  slave_if vif(sclk,reset);
 // wrapper_b2b w_obj(s_if,vif);
  
  slave_wrapper s_wrapper( //.sclk(s_if.sclk),
                          //.reset(s_if.reset),
                         // .mosi(s_if.mosi),
                         // .ss_n(s_if.ss_n),
                          .miso(s_if.miso));
  
  initial
    sclk=1'b0;
  always #5 sclk=~sclk;
  
  initial
    begin
      @(posedge sclk);
	reset=1;
	//repeat(1)
      @(posedge sclk);
	reset=0;
end
  

  
  initial
    begin
      uvm_config_db #(virtual slave_if)::set(null,"*","vif",vif);
         
      run_test("slave_test");
  
    end
  
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars();
    end
   
endmodule  
   
     
     
   
   
  
  
  
  
 
