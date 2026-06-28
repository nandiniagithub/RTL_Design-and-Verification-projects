//spi agent class
class spi_agent extends uvm_agent;

//Factory registration
	`uvm_component_utils(spi_agent)

	spi_driver drvh;
	spi_monitor monh;
	spi_sequencer sqrh;

	spi_cfg s_cfg;

//Function new constructor
	function new(string name="spi_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(spi_cfg)::get(this,"","spi_cfg",s_cfg))
			`uvm_fatal(get_type_name(),"Check the connections");

		monh = spi_monitor::type_id::create("monh",this);
		if(s_cfg.is_active) 
		begin
			drvh = spi_driver::type_id::create("drvh",this);
			sqrh = spi_sequencer::type_id::create("sqrh",this);
		end

		super.build_phase(phase);
	endfunction

//Connect phase method
	function void connect_phase(uvm_phase phase);
		if(s_cfg.is_active)
			drvh.seq_item_port.connect(sqrh.seq_item_export);
		super.connect_phase(phase);
	endfunction
endclass

