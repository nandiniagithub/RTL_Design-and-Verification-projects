//spi virtual sequence class	
class spi_apb_virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);

//Factory registration
	`uvm_object_utils(spi_apb_virtual_sequence_base)

	env_cfg e_cfg;

	apb_sequencer a_sqrh[];
	spi_sequencer s_sqrh[];

	spi_apb_virtual_sequencer vsqrh;

	//uvm_status_e status;

//Function new constructor
	function new(string name="spi_apb_virtual_sequence_base");
		super.new(name);
	endfunction

//Body task
	task body();

		if(!uvm_config_db #(env_cfg)::get(null,get_full_name(),"env_cfg",e_cfg))
			`uvm_fatal(get_type_name(),"Error in getting configuration")


		a_sqrh = new[e_cfg.no_of_agents];
		s_sqrh = new[e_cfg.no_of_agents];

		assert($cast(vsqrh,m_sequencer))
		else
			`uvm_error(get_type_name(),"Error in casting")


		foreach(a_sqrh[i]) 
		begin
			a_sqrh[i] = vsqrh.a_sqrh[i];
		end

		foreach(s_sqrh[i]) 
		begin
			s_sqrh[i] = vsqrh.s_sqrh[i];
		end
	endtask
endclass

//Reset virtual sequence class
class reset_virtual_sequence extends spi_apb_virtual_sequence_base;

 	`uvm_object_utils(reset_virtual_sequence)

	apb_rst_seqs apb_seqs;

//Function new constructor
	function new(string name="reset_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_seqs = apb_rst_seqs::type_id::create("apb_seqs");
		apb_seqs.start(a_sqrh[0]);
	endtask
endclass

//cpol=1 and cpha=1
class cpol1_cphase1_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(cpol1_cphase1_virtual_sequence)

	apb_cpha1_cpol1_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="cpol1_cphase1_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_cpha1_cpol1_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//Read virtual sequence class
class read_virtual_seqs extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(read_virtual_seqs)

	apb_read_sequence apb_rd_seqs;

//Function new constructor
	function new(string name="read_virtual_seqs");
		super.new(name);
	endfunction	

//Body task
	task body();
		super.body();
		apb_rd_seqs = apb_read_sequence::type_id::create("apb_rd_seqs");
		apb_rd_seqs.start(a_sqrh[0]);	
	endtask
endclass

//cpol=0 and cpha=1
class cpol0_cphase1_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(cpol0_cphase1_virtual_sequence)

	apb_cpha1_cpol0_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="cpol0_cphase1_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_cpha1_cpol0_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//cpol=1 and cpha=0
class cpol1_cphase0_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(cpol1_cphase0_virtual_sequence)

	apb_cpha0_cpol1_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="cpol1_cphase0_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_cpha0_cpol1_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//cpol=0 and cpha=0
class cpol0_cphase0_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(cpol0_cphase0_virtual_sequence)

	apb_cpha0_cpol0_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="cpol0_cphase0_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_cpha0_cpol0_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//msb cpol=1 and cpha=1
class msb_cpol1_cphase1_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(msb_cpol1_cphase1_virtual_sequence)

	apb_msb_cpha1_cpol1_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="msb_cpol1_cphase1_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_msb_cpha1_cpol1_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass


//msb cpol=1 and cpha=0
class msb_cpol1_cphase0_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(msb_cpol1_cphase0_virtual_sequence)

	apb_msb_cpha0_cpol1_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="msb_cpol1_cphase0_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_msb_cpha0_cpol1_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass


//msb cpol=0 and cpha=1
class msb_cpol0_cphase1_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(msb_cpol0_cphase1_virtual_sequence)

	apb_msb_cpha1_cpol0_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="msb_cpol0_cphase1_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_msb_cpha1_cpol0_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//msb cpol=0 and cpha=0
class msb_cpol0_cphase0_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(msb_cpol0_cphase0_virtual_sequence)

	apb_msb_cpha0_cpol0_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="msb_cpol0_cphase0_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = apb_msb_cpha0_cpol0_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask
endclass

//Low power virtual sequence class
class low_pwr_virtual_sequence extends spi_apb_virtual_sequence_base;

//Factory registration
	`uvm_object_utils(low_pwr_virtual_sequence)

	low_pwr_seqs apb_wr_seqs;
	spi_sequence spi_seqs;

//Function new constructor
	function new(string name="low_pwr_virtual_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		apb_wr_seqs = low_pwr_seqs::type_id::create("apb_wr_seqs");
		spi_seqs = spi_sequence::type_id::create("spi_seqs");
		apb_wr_seqs.start(a_sqrh[0]);
		spi_seqs.start(s_sqrh[0]);
	endtask

endclass




