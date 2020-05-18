class i2c_scoreboard extends uvm_scoreboard;

`uvm_component_utils(i2c_scoreboard)

uvm_tlm_analysis_fifo #(i2c_xtn) fifo_0;
uvm_tlm_analysis_fifo #(i2c_xtn) fifo_1;

static int i2c_xtn_0,i2c_xtn_1,xtns_compared,xtns_dropped;


i2c_env_config e_cfg;

master_i2c_txn i2c_data_0;
slave_i2c_txn i2c_data_1;

extern function new(string name="i2c_scoreboard",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
//extern function void check_phase(uvm_phase phase);
//extern function void report_phase(uvm_phase phase);
endclass


function i2c_scoreboard::new(string name="i2c_scoreboard",uvm_component parent);
	super.new(name,parent);
	fifo_0=new("fifo_0",this);
	fifo_1=new("fifo_1",this);
endfunction


function void i2c_scoreboard::build_phase(uvm_phase phase);
	i2c_data_0=i2c_xtn::type_id::create("i2c_data_0");
	i2c_data_1=i2c_xtn::type_id::create("i2c_data_1");
endfunction


task i2c_scoreboard::run_phase(uvm_phase phase);
/*fork
    forever
	   begin
		fifo_0.get(i2c_data_0);
		i2c_xtn_0 ++;
		fifo_1.get(i2c_data_1);
		i2c_xtn_1 ++;


		`uvm_info("SB",$sformatf("Data from UART_1 to SB:",i2c_data_0.sprint()),UVM_LOW)
		
		`uvm_info("SB",$sformatf("Data from UART_2 to SB:",i2c_data_1.sprint()),UVM_LOW)

		if(i2c_data_0.thr==i2c_data_1.rx_buf) 
		   begin 
		     $display("DATA MATCHES");
	             xtns_compared ++;
		   end
		else
		   begin
		    	$display("DATA MIS-MATCH");
			xtns_dropped ++;
		   end



		if(i2c_data_1.thr==i2c_data_0.rx_buf)
		   begin 
		     $display("DATA MATCHES");
	             xtns_compared ++;
		   end
		else
		   begin
		    	$display("DATA MIS-MATCH");
			xtns_dropped ++;
		   end

		if(i2c_data_1.lsr[2]==1'b1 || i2c_data_0.lsr[2]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ PARITY ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		if(i2c_data_1.lsr[1]==1'b1 || i2c_data_0.lsr[1]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ OVER_RUN ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end


		if(i2c_data_1.lsr[3]==1'b1 || i2c_data_0.lsr[3]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ FRAMING ERROR /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end
		
		
		if(i2c_data_1.lsr[4]==1'b1 || i2c_data_0.lsr[4]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ BREAK INTERRUPT /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		
		if(i2c_data_1.iir[3:1]==3'b110 || i2c_data_0.iir[3:1]==3'b110)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TIME_OUT INDICATION /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		if(i2c_data_1.iir[3:1]==3'b001 || i2c_data_0.iir[3:1]==3'b001)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER HOLDING REGISTER EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
			$stop;
		end
		
		if(i2c_data_1.lsr[5]==1'b1 || i2c_data_0.lsr[5]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER FIFO EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end

		
		if(i2c_data_1.lsr[6]==1'b1 || i2c_data_0.lsr[6]==1'b1)
		begin
		     $display("/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ TRANSMITTER FIFO & SHIFT REGISTER EMPTY /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/");
		end



	   end
join*/
endtask


