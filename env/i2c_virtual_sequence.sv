class i2c_virtual_sequence extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(i2c_virtual_sequence)

master_i2c_sequencer m_seqrh[];
//slave_i2c_sequencer  s_seqrh[];
i2c_virtual_sequencer v_seqrh;

i2c_env_config e_cfg;


extern function new(string name="i2c_virtual_sequence");
extern task body();
endclass


function i2c_virtual_sequence::new(string name="i2c_virtual_sequence");
	super.new(name);
endfunction


task i2c_virtual_sequence::body();
	if(!uvm_config_db #(i2c_env_config)::get(null,get_full_name(),"i2c_env_config",e_cfg))
	`uvm_fatal("V_SEQS","cannot get the e_cfg from uvm_config_db")

	m_seqrh=new[e_cfg.no_of_agents];
	//s_seqrh=new[e_cfg.no_of_agents];



	assert($cast(v_seqrh,m_sequencer))
		else
		    `uvm_error("V_SEQS","error in $casting V_Sequencer")
		
	foreach(m_seqrh[i])
		m_seqrh[i]=v_seqrh.m_seqrh[i];

        /*	foreach(s_seqrh[i])
		s_seqrh[i]=v_seqrh.s_seqrh[i];*/

endtask


			//==================================FIRST TRANSACTION======================================//

class i2c_ft_vseq extends i2c_virtual_sequence;

`uvm_object_utils(i2c_ft_vseq)

i2c_seq1 seq1; 
//s_i2c_seq1 seq2;

extern function new(string name="i2c_ft_vseq");
extern task body();
endclass


function i2c_ft_vseq::new(string name="i2c_ft_vseq");
	super.new(name);
endfunction


task i2c_ft_vseq::body();
	super.body();

	seq1=i2c_seq1::type_id::create("seq1");
	//seq2=s_i2c_seq1::type_id::create("seq2");

	
	fork
	    seq1.start(m_seqrh[0]);
	   // seq2.start(s_seqrh[1]);
	join 
endtask
	
