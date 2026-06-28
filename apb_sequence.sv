//APB base sequence class
class apb_base_sequence extends uvm_sequence #(apb_xtn) ;

//Factory registration
	`uvm_object_utils(apb_base_sequence)

//Declare the handles of env_cfg,reg_blk
	env_cfg e_cfg;
	spi_apb_reg_block reg_block;
	uvm_status_e status;
	logic [7:0] data1,data2,data3,data4,data5;

//Function new constructor
	function new(string name="apb_base_sequence");
		super.new(name);
	endfunction

//Body task to get env_cfg
	task body();

		if(!uvm_config_db #(env_cfg)::get(null,get_full_name,"env_cfg",e_cfg))
			`uvm_fatal(get_type_name(),"Check the connections")
		
			this.reg_block = e_cfg.reg_block;
	endtask

endclass

//APB Reset sequence class
class apb_rst_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_rst_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_rst_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		
		super.body();
		repeat(1) 
		begin
			req = apb_xtn::type_id::create("req");

			start_item(req);	
			assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b000;})
			finish_item(req);


			start_item(req);	
			assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b001;})
			finish_item(req);


			start_item(req);	
			assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b010;})
			finish_item(req);


			start_item(req);	
			assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b011;})
			finish_item(req);


			start_item(req);	
			assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;})
			finish_item(req);

		end

	endtask

endclass

//cpol=1 and cpha=1
class apb_cpha1_cpol1_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_cpha1_cpol1_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_cpha1_cpol1_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl; //Master mode
			data2 = 8'b00011001; //CR2 
			data3 = 8'b00010001; //BR
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			
			//APB write to data register
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass

//APB read sequence
class apb_read_sequence extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_read_sequence)

//Function new constructor
	function new(string name="apb_read_sequence");
		super.new(name);
	endfunction

//Body task
	task body();
		repeat(1)
		  begin
			req = apb_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass

//cpol=0 and cpha=1
class apb_cpha1_cpol0_seqs extends apb_base_sequence;

//Factory registration
`uvm_object_utils(apb_cpha1_cpol0_seqs)

	bit[7:0] ctrl;

//Function new constructor
function new(string name="apb_cpha1_cpol0_seqs");
	super.new(name);
endfunction

//Body task
	task body();
		super.body();
			if(!uvm_config_db#(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
				`uvm_fatal(get_full_name(),"Check the connections")
			repeat(1)
			 begin
				req=apb_xtn::type_id::create("req");
				data1=ctrl;
				data2 = 8'b00011001; //CR2 
				data3 = 8'b00010001; //BR
				start_item(req);
				assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
				finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			
			//APB write to data register
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   	end
	endtask
endclass

//cpol=1 and cpha=0
class apb_cpha0_cpol1_seqs extends apb_base_sequence;

//Factory registration
`uvm_object_utils(apb_cpha0_cpol1_seqs)

	bit[7:0] ctrl;

//Function new constructor
function new(string name="apb_cpha0_cpol1_seqs");
	super.new(name);
endfunction

//Body task
	task body();
		super.body();
			if(!uvm_config_db#(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
				`uvm_fatal(get_full_name(),"Check the connections")
			repeat(1)
			 begin
				req=apb_xtn::type_id::create("req");
				data1=ctrl;
				data2 = 8'b00011001; //CR2 
				data3 = 8'b00010001; //BR
				start_item(req);
				assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
				finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			
			//APB write to data register
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   	end
	endtask
endclass

//cpol=0 and cpha=0
class apb_cpha0_cpol0_seqs extends apb_base_sequence;

//Factory registration
`uvm_object_utils(apb_cpha0_cpol0_seqs)

	bit[7:0] ctrl;

//Function new constructor
function new(string name="apb_cpha0_cpol0_seqs");
	super.new(name);
endfunction

//Body task
	task body();
		super.body();
			if(!uvm_config_db#(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
				`uvm_fatal(get_full_name(),"Check the connections")
			repeat(1)
			 begin
				req=apb_xtn::type_id::create("req");
				data1=ctrl;
				data2 = 8'b00011001; //CR2 
				data3 = 8'b00010001; //BR
				start_item(req);
				assert(req.randomize() with {PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
				finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			
			//APB write to data register
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   	end
	endtask
endclass

//msb cpol=1 and cpha=1
class apb_msb_cpha1_cpol1_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_msb_cpha1_cpol1_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_msb_cpha1_cpol1_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl;
			data2 = 8'b00011001;
			data3 = 8'b00010001;
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass


//msb cpol=1 and cpha=0
class apb_msb_cpha0_cpol1_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_msb_cpha0_cpol1_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_msb_cpha0_cpol1_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl;
			data2 = 8'b00011001;
			data3 = 8'b00010001;
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass
				

//msb cpol=0 and cpha=1
class apb_msb_cpha1_cpol0_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_msb_cpha1_cpol0_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_msb_cpha1_cpol0_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl;
			data2 = 8'b00011001;
			data3 = 8'b00010001;
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass
				
//msb cpol=0 and cpha=0
class apb_msb_cpha0_cpol0_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(apb_msb_cpha0_cpol0_seqs)

	bit [7:0] ctrl;

//Function new constructor
	function new(string name="apb_msb_cpha0_cpol0_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl;
			data2 = 8'b00011001;
			data3 = 8'b00010001;
			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass

//Low power sequence class
class low_pwr_seqs extends apb_base_sequence;

//Factory registration
	`uvm_object_utils(low_pwr_seqs)
	bit [7:0]ctrl;

//Function new constructor
	function new(string name="low_pwr_seqs");
		super.new(name);
	endfunction

//Body task
	task body();
		super.body();
		if(!uvm_config_db #(bit[7:0])::get(null,get_full_name(),"bit[7:0]",ctrl))
			`uvm_fatal(get_type_name(),"Check the connections")

		repeat(1) 
		  begin
			req = apb_xtn::type_id::create("req");
			data1 = ctrl;
			data2 = 8'b00011011;
			data3 = 8'b00010001;

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b0; PADDR != 3'b101;});
			finish_item(req);

			this.reg_block.cr1.write(status,data1, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.cr2.write(status,data2, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));
			this.reg_block.br.write(status,data3, .path(UVM_BACKDOOR), .map(reg_block.spi_reg_map), .parent(this));

			start_item(req);
			assert(req.randomize() with { PRESET_n == 1'b1; PWRITE == 1'b1; PADDR == 3'b101;});
			finish_item(req);
		   end
	endtask
endclass
				
				
				
				
				
					
			
	
			

