class slave_i2c_sequencer extends uvm_sequencer #(slave_i2c_txn);

`uvm_component_utils(slave_i2c_sequencer)

extern function new(string name="slave_i2c_sequencer",uvm_component parent);
endclass

function slave_i2c_sequencer::new(string name="slave_i2c_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
