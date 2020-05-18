class master_i2c_sequencer extends uvm_sequencer #(master_i2c_txn);

`uvm_component_utils(master_i2c_sequencer)

extern function new(string name="master_i2c_sequencer",uvm_component parent);
endclass

function master_i2c_sequencer::new(string name="master_i2c_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
