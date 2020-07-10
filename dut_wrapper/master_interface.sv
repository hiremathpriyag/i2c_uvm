interface master_interface(input bit clk);

      logic s_resetn;
      logic i2c_scl;
      logic i2c_sda;


     clocking mdrv@(posedge clk);
	     default input #1 output #0;
	     output s_resetn;
	    output i2c_scl;
	    output i2c_sda;
     endclocking



    clocking mmon@(posedge clk);
	     default input #1 output #0;

         input i2c_scl;
	 input i2c_sda;
    endclocking

 modport MDRV (clocking mdrv);
  modport MMON (clocking mmon);
endinterface
