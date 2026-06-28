class spi_cfg extends uvm_object;

	`uvm_object_utils(spi_cfg)

	virtual spi_if vif;
	uvm_active_passive_enum is_active = UVM_ACTIVE ;

	function new(string name="spi_cfg");
		super.new(name);
	endfunction
endclass


