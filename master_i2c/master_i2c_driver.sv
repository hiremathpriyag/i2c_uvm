class master_i2c_driver extends uvm_driver #(master_i2c_txn);

`uvm_component_utils(master_i2c_driver)

virtual i2c_interface.MDRV vif;

master_i2c_agent_config m_cfg;

extern function new(string name="master_i2c_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_i2c_txn txn);
extern function void report_phase(uvm_phase phase);
endclass


function master_i2c_driver:: new(string name="master_i2c_driver",uvm_component parent);
	super.new(name,parent);
endfunction


function void master_i2c_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(master_i2c_agent_config)::get(this,"","master_i2c_agent_config",m_cfg))
	`uvm_fatal("WR_DRV","Cannot get the config db of m_cfg")
endfunction


function void master_i2c_driver::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task master_i2c_driver::run_phase(uvm_phase phase);

	@(vif.mdrv);
	 	vif.mdrv.s_resetn<=1'b0;
	@(vif.mdrv);
		vif.mdrv.s_resetn<=1'b1;	
	
	
	forever 
		begin
		     seq_item_port.get_next_item(req);
		     send_to_dut(req);
		     seq_item_port.item_done();
		end
endtask


task master_i2c_driver::send_to_dut(master_i2c_txn txn);

	txn=master_i2c_txn::type_id::create("txn");

/*	`uvm_info("DRV",$sformatf("printing from Driver %s",xtn.sprint()),UVM_LOW)

	@(vif.drv_cb);
 	vif.drv_cb.wb_dat_i<=xtn.data_i;
 	vif.drv_cb.wb_addr_i<=xtn.addr_i;
 	vif.drv_cb.wb_we_i<=xtn.we_i;

 	vif.drv_cb.wb_sel_i<=4'b0001;
 	vif.drv_cb.wb_stb_i<=1'b1;
 	vif.drv_cb.wb_cyc_i<=1'b1;
	

wait(vif.drv_cb.wb_ack_o)
	vif.drv_cb.wb_stb_i<=1'b0;
 	vif.drv_cb.wb_cyc_i<=1'b0;

	@(vif.drv_cb);

if(xtn.addr_i==3'd2 && xtn.we_i==0)
  begin
	 wait(vif.drv_cb.int_o)
	@(vif.drv_cb);
		xtn.iir=vif.drv_cb.wb_dat_o; 
		seq_item_port.put_response(req);
		$display("Put Response IIR: %b",xtn.iir);
		
  end
	*/
      

          fork 

            begin
              vif.mdrv.i2c_scl<=1 ;
	      vif.mdrv.i2c_sda<=0;
	      vif.mdrv.i2c_sda<=txn.i2c_sda;
	      $display("start of i2c frame");

            end
            
           begin 
	   vif.mdrv.i2c_sda<=1;
               for(txn.count=6; txn.count>0 ; txn.count--  )
	     vif.mdrv.i2c_sda<=txn.i2c_addr[txn.count];
           end

          begin
           vif.mdrv.i2c_sda<=1;
	   txn.r_w<=0; 
		  vif.mdrv.i2c_sda<=txn.ack;
                  
          end

         begin
            vif.mdrv.i2c_sda<=1;
	   for(txn.count=8; txn.count>0; txn.count--)
	   vif.mdrv.i2c_sda<=txn.i2c_data[txn.count];

	   if(txn.count==0)
		   vif.mdrv.i2c_sda<=txn.ack;
                   

         end

       begin
              vif.mdrv.i2c_scl<=1 ;
	      vif.mdrv.i2c_sda<=1;
	      vif.mdrv.i2c_sda<=txn.i2c_sda;
	      $display("stop of i2c frame");



       end
          join



	m_cfg.drv_data_sent_cnt++;

            $display("print the write transaction %d", txn. i2c_addr);	

endtask	


function void master_i2c_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),$sformatf("REPORT: Driver sent %0d transaction",m_cfg.drv_data_sent_cnt),UVM_LOW)
endfunction	
