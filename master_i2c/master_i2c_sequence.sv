class master_i2c_sequence extends uvm_sequence #(master_i2c_txn);

`uvm_object_utils(master_i2c_sequence)

extern function new(string name="master_i2c_sequence");
endclass


function master_i2c_sequence::new(string name="master_i2c_sequence");
	super.new(name);
endfunction



/////////////////////////////////////////first_sequence////////////////////////////////////////
class i2c_seq1 extends master_i2c_sequence;

`uvm_object_utils(i2c_seq1)

extern function new(string name="i2c_seq1");
extern task body();
endclass


function i2c_seq1::new(string name="i2c_seq1");
	super.new(name);
endfunction


task i2c_seq1::body();
	req=master_i2c_txn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() with {i2c_addr==7'd50; i2c_data==8'd100 ; r_w==0 ;})
	`uvm_info("I2C_SEQ1 CPR",$sformatf("Printing from i2c_Seq1 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	
end
endtask





