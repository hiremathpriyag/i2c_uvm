class slave_i2c_driver extends uvm_driver #(slave_i2c_txn);

`uvm_component_utils(slave_i2c_driver)

virtual i2c_interface.MDRV vif;

slave_i2c_agent_config s_cfg;

extern function new(string name="slave_i2c_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(slave_i2c_txn txn);
extern function void report_phase(uvm_phase phase);
endclass


function slave_i2c_driver:: new(string name="slave_i2c_driver",uvm_component parent);
	super.new(name,parent);
endfunction


function void slave_i2c_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(slave_i2c_agent_config)::get(this,"","slave_i2c_agent_config",s_cfg))
	`uvm_fatal("WR_DRV","Cannot get the config db of s_cfg")
endfunction


function void slave_i2c_driver::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task slave_i2c_driver::run_phase(uvm_phase phase);

	@(vif.sdrv_cb);
	 	vif.mdrv_cb.s_resetn<=1'b0;
	@(vif.sdrv_cb);
		vif.sdrv_cb.s_resetn<=1'b1;	
	
	
	forever 
		begin
		     seq_item_port.get_next_item(req);
		     send_to_dut(req);
		     seq_item_port.item_done();
		end
endtask


task slave_i2c_driver::send_to_dut(slave_i2c_txn txn);

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
	
	m_cfg.drv_data_sent_cnt++;

	*/

endtask	


function void slave_i2c_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(),$sformatf("REPORT: Driver sent %0d transaction",s_cfg.drv_data_sent_cnt),UVM_LOW)
endfunction	
