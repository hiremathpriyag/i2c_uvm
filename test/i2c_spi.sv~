interface i2c_if(input logic sclk,reset);
  
  logic i2c_scl;
  logic i2c_sda;
  logic [7:0] i2c_data;
  logic [6:0] i2c_address;
  logic i2c_ack;
  logic s_resetn;

  
  
  
  //master_drv_cb
  
  clocking master_drv_cb@(posedge sclk);
    default input #1 output #0;
    output i2c_scl;
    output  i2c_sda;
    output  i2c_address;
    output s_resetn;
  //  output reset;
  endclocking
    
  //master_mon_cb
  clocking master_mon_cb@(posedge sclk);
    default input #1 output #0;
    input i2c_scl;
    input  i2c_sda;
    input  i2c_address;
    input s_resetn;
    
   // input sclk;
  endclocking
       
  
  
  
   
  modport MDRV_MP(clocking master_drv_cb);
  modport MMON_MP(clocking master_mon_cb);
   
   
      
      
   endinterface:i2c_if     
 
     
  
 import uvm_pkg::*;
 `include "uvm_macros.svh"
    
    
 ////////////////master_transaction/////////////////////   
        
    
class master_trans extends uvm_sequence_item;

   rand bit[7:0] i2c_data;
     rand  bit[6:0] i2c_address;
  rand bit r_w;
  bit i2c_ack;
   
  `uvm_object_utils_begin(master_trans)
  `uvm_field_int(i2c_data,UVM_ALL_ON)
  `uvm_field_int(i2c_address,UVM_ALL_ON)
  `uvm_field_int(r_w,UVM_ALL_ON)
  `uvm_object_utils_end
  
  master_trans trans;
    
  extern function new(string name="master_trans");
      
 endclass

  
  function master_trans::new(string name="master_trans");
    super.new(name);
  
  endfunction
  
  
    
 
 ///////////////master_sequence//////////////////////////   
 class master_seq extends uvm_sequence #(master_trans);
        
   `uvm_object_utils(master_seq) 
   
   extern function new(string name="master_seq");
   extern task body();
       
 endclass
     
 function master_seq::new(string name="master_seq");
    super.new(name);
 endfunction
     
 task master_seq::body();
   
   req=master_trans::type_id::create("req");
   wait_for_grant();
   assert(req.randomize());
   send_request(req);
   wait_for_item_done();
        
 endtask
     
     
     
  class master_write_seq extends master_seq;
     
   `uvm_object_utils(master_write_seq)
   
    extern function new(string name="master_write_seq");
   extern task body();
       
 endclass
     
 function master_write_seq::new(string name="master_write_seq");
    super.new(name);
 endfunction
     
 task master_write_seq::body();
  
   `uvm_do_with(req,{req.i2c_data==8'b10101011;})
   //`uvm_info("INFO",$sformatf("Value of cpol=%d \t cpha=%d \t miso=%b",req.cpol,req.cpha,req.miso),UVM_LOW)
   `uvm_info("INFO",$sformatf("Value of i2c_data=%b",req.i2c_data),UVM_LOW)
   
   
 endtask
     
       
 /////////////////master_sequencer/////////////////////////
   
 class master_seqr extends uvm_sequencer #(master_trans);
    
   `uvm_component_utils(master_seqr) 
  
   extern function new(string name="master_seqr",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
     
 endclass
     
     function master_seqr::new(string name="master_seqr",uvm_component parent);
   super.new(name,parent);
 endfunction
 
  function void master_seqr::build_phase(uvm_phase phase);
     super.build_phase(phase);
  endfunction
     
     
 
     
 /////////////////master_drv/////////////////////////////////
     
 class master_drv extends uvm_driver #(master_trans);
       
 `uvm_component_utils(master_drv) 
  virtual i2c_if vif;
     
   
   extern function new(string name="master_drv",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);    
     extern task send_to_dut(master_trans req);
  // extern task drive();
               
 endclass
 
   
 function master_drv::new(string name="master_drv",uvm_component parent);
   super.new(name,parent);
 endfunction
     
     function void master_drv::build_phase(uvm_phase phase);
       super.build_phase(phase);
       if(!uvm_config_db #(virtual i2c_if)::get(this,"","vif",vif))
       begin
          `uvm_fatal(get_type_name(),"interface in master driver not found")
       end
     endfunction
     
     function void master_drv::connect_phase(uvm_phase phase);
       super.connect_phase(phase);
     endfunction


     
     task master_drv::run_phase(uvm_phase phase);
    
       @(vif.master_drv_cb);
	 	vif.master_drv_cb.s_resetn<=1'b0;
       @(vif.master_drv_cb);
		vif.master_drv_cb.s_resetn<=1'b1;	
	
	
	forever 
		begin
		     seq_item_port.get_next_item(req);
		     send_to_dut(req);
		     seq_item_port.item_done();

		end

endtask

task master_drv::send_to_dut(master_trans req);

	req=master_trans::type_id::create("req");

       
           
                     fork 

            begin
          vif.master_drv_cb.i2c_scl<=1 ;
	      vif.master_drv_cb.i2c_sda<=0;
              if(req.i2c_data<=8'b00010001)
	      vif.master_drv_cb.i2c_sda<=req.i2c_data;
              $display("start of i2c frame %d", req.i2c_data);

            end
            
         
       begin
              vif.master_drv_cb.i2c_scl<=1 ;
	      vif.master_drv_cb.i2c_sda<=1;
	      vif.master_drv_cb.i2c_sda<=req.i2c_data;
         $display("stop of i2c frame %d",req.i2c_data);



       end
          join



	//m_cfg.drv_data_sent_cnt++;

  $display("print the write transaction %d", req.i2c_data);	


             
     
      
    endtask 
  /////////////////master_drv/////////////////////////////////

 
///////////////////////master_mon///////////////////////////////////////

class master_mon extends uvm_monitor;
       
  `uvm_component_utils(master_mon)
  virtual i2c_if vif;
  
  uvm_analysis_port #(master_trans) m_mon2sb;
  
  master_trans m_trans; //master_transaction
  
  
  
   extern function new(string name="master_mon",uvm_component parent); 
   extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);
   extern task run_phase(uvm_phase phase);   
   extern task collect_data();  
  
 endclass
 
     
 function master_mon::new(string name="master_mon",uvm_component parent);
   super.new(name,parent);
   m_mon2sb=new("m_mon2sb",this);
   
 endfunction
     
 function void master_mon::build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_trans=master_trans::type_id::create("m_trans");
       
   if(!uvm_config_db #(virtual i2c_if)::get(this,"","vif",vif))
       begin
         `uvm_fatal(get_type_name(),"interface in master monitor not found")
       end   
  endfunction
     
  function void master_mon::connect_phase(uvm_phase phase);
     super.connect_phase(phase);
  endfunction
     
  task master_mon::run_phase(uvm_phase phase);
     super.run_phase(phase);
    
    
    //process to add here for taking the signal values fro interface and putting onto packet
  forever
    begin
       @(vif.master_mon_cb);
      if(!vif.master_mon_cb.s_resetn) begin
        `uvm_info(get_type_name(),"RESET IN MONITOR",UVM_LOW)
                
      end
     else begin
       collect_data();
     end
    end
  endtask
     
     task master_mon::collect_data();
       master_trans req;
	     	req=master_trans::type_id::create("req");


       forever begin
        @(posedge vif.i2c_scl);
         repeat(8)
        req.i2c_data=vif.master_mon_cb.i2c_sda;
         $display("monitor collecting data %d", req.i2c_data);
	
       
        end
  endtask
     
///////////////////master_mon///////////////////////////////////////
     
     
//////////////////////////////////master_agent_cfg///////////////////////////////////////////
     
 class master_agent_cfg extends uvm_object;
    
  `uvm_object_utils(master_agent_cfg)
  
  virtual i2c_if vif;
  
  uvm_active_passive_enum is_active=UVM_ACTIVE;
  
  bit has_functional_coverage=0;
  
  
   extern function new(string name="master_agent_cfg");
    // extern function void build_phase(); //its object,so no build_phase  
  
endclass
    
     function master_agent_cfg::new(string name="master_agent_cfg");
       super.new(name);
    endfunction
    

    
    
  ///////////////////////////master_agent_cfg////////////////////////////////////////////////      
     
     
     
///////////////////master_agent///////////////////////////////////////

 typedef class master_env_cfg;    
class master_agent extends uvm_agent;

  `uvm_component_utils(master_agent)
   
  
  //agent handles
  master_seqr m_seqr;
  master_drv m_drv;
  master_mon m_mon;
  

  //declaring m_cfg handle
 // master_agent_cfg m_cfg;
  
 master_agent_cfg m_cfg[]; //tried with above,but not getting as config needs to be dynamic
  
  master_env_cfg e_cfg;
  
  
  int i=0;
  
  
  extern function new(string name="s_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
 // extern task run_phase(uvm_phase phase);
    
endclass
      
    
function master_agent::new(string name="s_agent",uvm_component parent);
  super.new(name,parent);
endfunction
    
 
 function void master_agent::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   if(!uvm_config_db #(master_env_cfg)::get(this,"","e_cfg",e_cfg))
   begin
   
     `uvm_fatal(get_type_name(),"not getting env cfg hanlde in agent")
   end
   
   //
   i=e_cfg.no_of_s_agent;
  
    
// get the config handle
   m_cfg=new[i];
   
   foreach(m_cfg[i])
   
  // for(int j=0;j<i;j++)  
   begin
     if(!uvm_config_db #(master_agent_cfg)::get(this,"","master_agent_cfg",e_cfg.m_cfg[i]))
   begin
   
     `uvm_fatal(get_type_name(),"not getting cfg hanlde in agent")
   end
     m_cfg[i]=master_agent_cfg::type_id::create($sformatf("master_agent_cfg[%0d]",i));  
  // m_cfg[1]=master_agent_cfg::type_id::create("master_agent_cfg[1]");  
   
  //  else
  //    $display("m_cfg=%0d",i);
       
       
    m_mon=master_mon::type_id::create("m_mon",this);    
  end
  
   
    foreach(m_cfg[i])
     begin
     if(m_cfg[i].is_active==UVM_ACTIVE)
    begin
      m_drv=master_drv::type_id::create("m_drv",this);
     m_seqr=master_seqr::type_id::create("m_seqr",this);
   end
     end
   
 endfunction
    
    
 function void master_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   m_drv.seq_item_port.connect(m_seqr.seq_item_export);
 endfunction
  
  
  
///////////////////master_agent///////////////////////////////////////  
  
    
////////////////////////////////master_agent_top//////////////////////////////////////
    
typedef class master_env_cfg;
    
class master_agent_top extends uvm_component;
  
  `uvm_component_utils(master_agent_top)
  
 // master_agent m_agent[]; //dynamic array of agent instances
 
  master_agent m_agent[];
  master_env_cfg e_cfg;
  
  int i=1;
  
  extern function new(string name="master_agent_top",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
      
endclass
  
  
    function master_agent_top:: new(string name="master_agent_top",uvm_component parent);
      super.new(name,parent);
    endfunction

    function void master_agent_top::build_phase(uvm_phase phase);   
      super.build_phase(phase);
   //master_env_cfg e_cfg;
      
      if(!uvm_config_db #(master_env_cfg)::get(this,"","e_cfg",e_cfg))
        //do not use virtual keyword here in config_db,this is not an interface,keep a note of it
        begin
      //  `uvm_fatal(get_type_name(),"unable to get e_cfg handle from test in master_agent_top")
          `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"}); 
          
        end
      
   //****this is additional code,if foreach doesnot execute   
     // int i=0;
      i=e_cfg.no_of_s_agent;
      m_agent=new[i]; //there is diff betwn ,new[] and new ().For dynamic array ,we got to define the size here  
      
   //   foreach(m_agent[e_cfg.no_of_m_agent])
      foreach(m_agent[i])
        begin
        
        
          uvm_config_db #(master_agent_cfg)::set(this,$sformatf("m_agent[%0d]",i),"master_agent_cfg",e_cfg.m_cfg[i]);
        
   //check with setting of this handle once,coz we are using master_agent_cfg in master_agent_top.
   //so better have a clearity on this.
    
          m_agent[i]=master_agent::type_id::create($sformatf("m_agent[%0d]",i),this);    
        
        
        end
 
    endfunction
        
 
    
///////////////////master_scoreboard///////////////////////////////////////  
    
class master_sb extends uvm_scoreboard;   

  `uvm_component_utils(master_sb)
  
//  uvm_analysis_imp #(master_trans,master_sb) sb2mon;
  
  
  //external function
  extern function new(string name="master_sb",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
  //extern write function
 //   extern function void write (master_trans m_trans); 
  
 endclass
  
 
     
function master_sb::new(string name="master_sb",uvm_component parent);
  super.new(name,parent);
 // sb2mon=new("sb2mon",this);
endfunction
    
 
 function void master_sb::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
 endfunction
    
    
 function void master_sb::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  
 endfunction
   
     
 task master_sb::run_phase(uvm_phase phase);
    super.run_phase(phase);
  
 endtask
    

    
///////////////////////////master_env_cfg///////////////////////////////
       
    
class master_env_cfg extends uvm_object;
  
  `uvm_object_utils(master_env_cfg)
  
  
  bit has_scoreboard=1;
  bit has_m_agent=1;
  bit has_s_agent=1;
  bit has_m_top=1;
  bit has_s_top=1;
  
  
  bit has_virtual_sequencer=1;
  master_agent_cfg m_cfg[]; //config_object is dynamic,as config for particular agent miht change
//  master_agent_cfg m_cfg;
  
  
  //These are the flexible parameters,when declared can be reused accordingly
  int no_of_scoreboard=1;
  int no_of_m_agent=1;
  int no_of_s_agent=1;
  int no_of_m_top=1;
  int no_of_s_top=1;


  extern function new(string name="master_env_cfg");
 
 endclass
    
    
 function master_env_cfg::new(string name="master_env_cfg");
   super.new(name);
  endfunction
    
   
    
    ///////////////////master_env///////////////////////////////////////
    
 typedef class virtual_sequencer;   
    
 class master_env extends uvm_env;

   `uvm_component_utils(master_env)
   
   master_agent_top mtop;
   slave_agent_top stop;
  // master_agent m_ag;
   master_sb m_sb;
   
   virtual_sequencer v_seqr;
   master_env_cfg e_cfg;
   
   
  extern function new(string name="master_env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
    
 endclass 
   
  
  function master_env::new(string name="master_env",uvm_component parent);
  super.new(name,parent);
  endfunction
    
 
 function void master_env::build_phase(uvm_phase phase);
   super.build_phase(phase);
   
   
   if(!uvm_config_db #(master_env_cfg)::get(this,"","e_cfg",e_cfg))
      begin
      `uvm_fatal(get_type_name(),"unable to get e_cfg in virtual_seq")
      end
   
   
   
   
   if(e_cfg.has_m_top==1)
     mtop=master_agent_top::type_id::create("mtop",this);
if(e_cfg.has_s_top==1)
   stop=slave_agent_top::type_id::create("s_ag_top",this);

  // m_ag=master_agent::type_id::create("m_ag",this);
   
   if(e_cfg.has_scoreboard==1)
     m_sb=master_sb::type_id::create("m_sb",this);
   
   if(e_cfg.has_virtual_sequencer==1)
     v_seqr=virtual_sequencer::type_id::create("v_seqr",this);
   
   
 endfunction
    
    
 function void master_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
   
  //need to add for master also 
   
   if(e_cfg.has_virtual_sequencer)
     begin
       if(e_cfg.has_m_top)
         begin
           for(int i=0;i<e_cfg.no_of_m_agent;i++)
             begin
   
               v_seqr.m_seqr=mtop.m_agent[i].m_seqr;
  
             end
         end
     end

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

     
 task master_env::run_phase(uvm_phase phase);
    super.run_phase(phase);
  
 endtask
    
    
///////////////////master_test///////////////////////////////////////    
    
typedef class virtual_sequence;    
    
class master_test extends uvm_test;

 `uvm_component_utils(master_test)
  
//  master_write_seq mw_seq;
  master_env m_env;
 
  
  master_env_cfg e_cfg; //to set the handle
  
  
  virtual_sequence v_seq;
  
  extern function new(string name="master_test",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
  extern function void end_of_elaboration();  
  extern task run_phase(uvm_phase phase);
    
 endclass 
   
  
  function master_test::new(string name="master_test",uvm_component parent);
  super.new(name,parent);
  endfunction
    
 
 function void master_test::build_phase(uvm_phase phase);
   super.build_phase(phase);
//   mw_seq=master_write_seq::type_id::create("m_seq");
   m_env=master_env::type_id::create("m_env",this);
   e_cfg=master_env_cfg::type_id::create("e_cfg",this);
   
   v_seq=virtual_sequence::type_id::create("v_seq");
   
   uvm_config_db #(master_env_cfg)::set(this,"*","e_cfg",e_cfg);
   
 endfunction
    
    
 function void master_test::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  
 endfunction

 function void master_test::end_of_elaboration();
     uvm_top.print_topology();
 endfunction   
    
     
 task master_test::run_phase(uvm_phase phase);
  // super.run_phase(phase);
   $display("before objection");
  phase.raise_objection(this);
   $display("afetr raising");
  // m_seq.start(m_env.mtop.m_agent[0].m_seqr);
  
   v_seq.start(m_env.v_seqr);
   phase.drop_objection(this);
   $display("after dropping");
 
 
   phase.phase_done.set_drain_time(this,50);
 endtask
  
 
    
 
/////////////////////////virtual_sequence/////////////////////////////////

typedef class virtual_sequencer;
typedef class master_seqr;
    

class base_sequence extends uvm_sequence;
  
  `uvm_object_utils(base_sequence)
  
   virtual_sequencer v_seqr;
  
   master_seqr m_seqr;
    slave_seqr s_seqr;

  
   master_env_cfg e_cfg; 
  
    
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
   
   m_seqr=v_seqr.m_seqr;
    s_seqr=v_seqr.s_seqr;

    endtask
   
   
    
    
typedef class master_write_seq;  
    
class virtual_sequence extends base_sequence;
  
  
  `uvm_object_utils(virtual_sequence);
  
 
   master_write_seq sw_seq;
     slave_write_seq sw_seq;
  

  
  master_env_cfg e_cfg;
  
  
  extern function new(string name="v_sequence");
    
  extern task body();    
    
endclass
    
    
 function virtual_sequence::new(string name="v_sequence");   
   super.new(name);
 endfunction   
    
 task virtual_sequence::body();
  
   super.body; 
   
   mw_seq=master_write_seq::type_id::create("mw_seq");
   
   
   mw_seq.start(m_seqr);

   sw_seq=slave_write_seq::type_id::create("sw_seq");
   
   
   sw_seq.start(s_seqr);



 endtask
   

    
 ////////////////////////////////virtual_sequencer////////////////////////////////////

class virtual_sequencer extends uvm_sequencer;
  
  `uvm_component_utils(virtual_sequencer)
  
  master_seqr m_seqr;  
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
    
   /* module wrapper_b2b(s_if,vif);
  i2c_if m_if;
  slave_if s_if;
         
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
    module master_wrapper(input [7:0] miso,output sclk,reset,ss_n,reg [7:0] mosi);
      always@(posedge sclk)
        begin
          mosi <= miso;
          $display("********SLAVE_WRAPPER******** %b",mosi);
        end
    endmodule*/
    
    ///////////////////////top///////////////////////////    
    
module tb_top();

  bit sclk;
  bit reset;
  
 // master_if m_if();
  //master_if s_if(sclk,reset);
  i2c_if vif(sclk,reset);
  //wrapper_b2b w_obj(s_if,vif);
  
  /*master_wrapper s_wrapper( //.sclk(s_if.sclk),
                          //.reset(s_if.reset),
                         // .mosi(s_if.mosi),
                         // .ss_n(s_if.ss_n),
                          .miso(s_if.miso));
  */
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
      uvm_config_db #(virtual i2c_if)::set(null,"*","vif",vif);
      uvm_config_db #(virtual slave_if)::set(null,"*","vif",vif);

         
      run_test("master_test");
  
    end
  
  
  initial
    begin
      $dumpfile("dump.vcd");
      $dumpvars();
    end
   
endmodule  

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
        
 

