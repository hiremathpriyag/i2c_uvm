 class slave_i2c_sequence extends uvm_sequence #(slave_i2c_txn);
`uvm_object_utils(slave_i2c_sequence)

extern function new(string name="slave_i2c_sequence");
endclass


function slave_i2c_sequence::new(string name="slave_i2c_sequence");
	super.new(name);
endfunction



/////////////////////////////////////////first_sequence////////////////////////////////////////
class s_i2c_seq1 extends slave_i2c_sequence;

`uvm_object_utils(s_i2c_seq1)

extern function new(string name="s_i2c_seq1");
extern task body();
endclass


function s_i2c_seq1::new(string name="s_i2c_seq1");
	super.new(name);
endfunction


task s_i2c_seq1::body();
	req=slave_i2c_txn::type_id::create("req");
begin
	
	start_item(req);
	assert(req.randomize() )
	`uvm_info("S_I2C_SEQ1 CPR",$sformatf("Printing from s_i2c_Seq1 %s",req.sprint()),UVM_HIGH)
	finish_item(req);

	
end
endtask



