//APB agent configuration classi
class apb_cfg extends uvm_object;

//Factory registration
`uvm_object_utils(apb_cfg)

//setting the config
	uvm_active_passive_enum is_active = UVM_ACTIVE;

//Declare virtual interface handle
	virtual apb_if vif;

//Function new constructor
	function new(string name="apb_cfg");
		super.new(name);
	endfunction
endclass
