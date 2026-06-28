//test class
class spi_apb_base_test extends uvm_test;

//Factory registration
	`uvm_component_utils(spi_apb_base_test)

	env_cfg e_cfg;
	spi_cfg s_cfg[];
	apb_cfg a_cfg[];
	spi_apb_env envh;

	int no_of_agents = 1;
	bit has_scoreboard = 1;
	bit has_virtual_sequencer = 1;
	bit has_apb_agent = 1;
	bit has_spi_agent = 1;
	spi_apb_reg_block reg_block;

//Function new constructor
	function new(string name = "spi_apb_base_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
	
		e_cfg = env_cfg::type_id::create("e_cfg",this);
		if(has_apb_agent) 
		begin
			e_cfg.a_cfg = new[no_of_agents] ;
			a_cfg = new[no_of_agents];
			foreach(a_cfg[i]) 
			begin
				a_cfg[i] = apb_cfg::type_id::create($sformatf("a_cfg[%0d]",i));
		 		a_cfg[i].is_active = UVM_ACTIVE;
				if(!uvm_config_db #(virtual apb_if)::get(this,"","apb_if",a_cfg[i].vif))
					`uvm_fatal(get_type_name(),"Check the connections");
				e_cfg.a_cfg[i] = a_cfg[i];
			end
				
		end

		if(has_spi_agent) 
		begin
			e_cfg.s_cfg = new[no_of_agents];
			s_cfg = new[no_of_agents];

			foreach(s_cfg[i]) 
			begin
				s_cfg[i] = spi_cfg::type_id::create($sformatf("s_cfg[%0d]",i));
				s_cfg[i].is_active = UVM_ACTIVE;
				if(!uvm_config_db #(virtual spi_if)::get(this,"","spi_if",s_cfg[i].vif))
					`uvm_fatal(get_type_name(),"Error in getting spi virtual interface");

					e_cfg.s_cfg[i] = s_cfg[i];
			end
		end
		reg_block = spi_apb_reg_block::type_id::create("reg_block");
		reg_block.build();
		e_cfg.reg_block = reg_block;
		e_cfg.no_of_agents = no_of_agents;
		e_cfg.has_scoreboard = has_scoreboard;
		e_cfg.has_virtual_sequencer = has_virtual_sequencer;
		e_cfg.has_apb_agent = has_apb_agent;
		e_cfg.has_spi_agent = has_spi_agent;
		uvm_config_db#(env_cfg)::set(this,"*","env_cfg",e_cfg);
		envh = spi_apb_env::type_id::create("envh",this);
		super.build_phase(phase);
	endfunction
endclass


//reset test class
class reset_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(reset_test)


	reset_virtual_sequence seqs;
	bit reset_test;
	bit [7:0]ctrl = 8'b11111111;

//Function new constructor
	function new(string name="reset_test",uvm_component parent=null);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);

		phase.raise_objection(this);
			reset_test=1'b1;
		        uvm_config_db#(bit)::set(this,"*","bit",reset_test);
			seqs = reset_virtual_sequence::type_id::create("seqs");
			seqs.start(envh.vsqrh);
		phase.drop_objection(this);
	endtask
endclass

//cpol=1 and cpha=1
class cpol1_cpha1_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(cpol1_cpha1_test)

	cpol1_cphase1_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11111111;

//Function new constructor
	function new(string name="cpol1_cpha1_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = cpol1_cphase1_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);

	endtask
endclass

//cpol=0 and cpha=1
class cpol0_cpha1_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(cpol0_cpha1_test)

	cpol0_cphase1_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11110111;

//Function new constructor
	function new(string name="cpol0_cpha1_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = cpol0_cphase1_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);
	endtask
endclass

//cpol=1 and cpha=0
class cpol1_cpha0_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(cpol1_cpha0_test)

	cpol1_cphase0_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11110111;

//Function new constructor
	function new(string name="cpol1_cpha0_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = cpol1_cphase0_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);
	endtask
endclass

//cpol=0 and cpha=0
class cpol0_cpha0_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(cpol0_cpha0_test)

	cpol0_cphase0_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11110111;

//Function new constructor
	function new(string name="cpol0_cpha0_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = cpol0_cphase0_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);
	endtask
endclass		

//msb cpol=1 and cpha=1				
class msb_cpol1_cpha1_test extends spi_apb_base_test;

//Factory registration 
	`uvm_component_utils(msb_cpol1_cpha1_test)

	msb_cpol1_cphase1_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11111110;

//Function new constructor
	function new(string name="msb_cpol1_cpha1_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = msb_cpol1_cphase1_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);

	endtask
endclass	
		
	
//msb cpol=1 and cpha=0				
class msb_cpol1_cpha0_test extends spi_apb_base_test;

//Factory registration 
	`uvm_component_utils(msb_cpol1_cpha0_test)

	msb_cpol1_cphase0_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11111110;

//Function new constructor
	function new(string name="msb_cpol1_cpha0_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = msb_cpol1_cphase0_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);

	endtask
endclass	


//msb cpol=0 and cpha=1				
class msb_cpol0_cpha1_test extends spi_apb_base_test;

//Factory registration 
	`uvm_component_utils(msb_cpol0_cpha1_test)

	msb_cpol0_cphase1_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11111110;

//Function new constructor
	function new(string name="msb_cpol0_cpha1_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = msb_cpol0_cphase1_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);

	endtask
endclass	


//msb cpol=0 and cpha=0				
class msb_cpol0_cpha0_test extends spi_apb_base_test;

//Factory registration 
	`uvm_component_utils(msb_cpol0_cpha0_test)

	msb_cpol0_cphase0_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b11111110;

//Function new constructor
	function new(string name="msb_cpol0_cpha0_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);

			wr_seqs = msb_cpol0_cphase0_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);

	endtask
endclass

//Low power test class
class low_pwr_test extends spi_apb_base_test;

//Factory registration
	`uvm_component_utils(low_pwr_test)

	low_pwr_virtual_sequence wr_seqs;
	read_virtual_seqs rd_seqs;
	bit [7:0]ctrl = 8'b00011101;
	bit [1:0]low_pwr_mode = 2'b01; //wait mode 

//Function new constructor
	function new(string name="low_pwr_test", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		uvm_config_db #(bit[7:0])::set(this,"*","bit[7:0]",ctrl);
		uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",low_pwr_mode);
	endfunction

//Run phase task	
	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			wr_seqs = low_pwr_virtual_sequence::type_id::create("wr_seqs");
			rd_seqs = read_virtual_seqs::type_id::create("rd_seqs");

			wr_seqs.start(envh.vsqrh);
			#400;
			rd_seqs.start(envh.vsqrh);
			#100;
		phase.drop_objection(this);
	endtask
endclass

	

