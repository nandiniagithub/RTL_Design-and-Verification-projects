//APB driver class
class apb_driver extends uvm_driver#(apb_xtn);
	
//Factory registration
	`uvm_component_utils(apb_driver)

//Virtual interface handle & apb_cfg handle	
	virtual apb_if.APB_DRV_MP vif;
	
	apb_cfg a_cfg;
	
//Function new constructor
	function new(string name="apb_driver", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method	
	function void build_phase(uvm_phase phase);
		
		if(!uvm_config_db #(apb_cfg)::get(this,"","apb_cfg",a_cfg))
			`uvm_fatal(get_type_name(),"Check the connections")

	endfunction

//Connect phase method
	function void connect_phase(uvm_phase phase);
		vif = a_cfg.vif;
	endfunction

//Run phase task
	task run_phase(uvm_phase phase);

		@(vif.apb_drv_cb);
		vif.apb_drv_cb.PRESET_n <= 1'b0;
		repeat(3)
			@(vif.apb_drv_cb);
			vif.apb_drv_cb.PRESET_n <= 1'b1;

		forever
		  begin
			seq_item_port.get_next_item(req);
			`uvm_info(get_type_name(),$sformatf("Printing from apb driver %s",req.sprint()),UVM_LOW)
			send_to_dut(req);
			seq_item_port.item_done();
		  end
	endtask

//Send to dut task
	task send_to_dut(apb_xtn xtnh);
		@(vif.apb_drv_cb);
		vif.apb_drv_cb.PRESET_n <= 1'b1;
		vif.apb_drv_cb.PADDR <= xtnh.PADDR;
		vif.apb_drv_cb.PWRITE <= xtnh.PWRITE;
		vif.apb_drv_cb.PSEL <= 1'b1;
		vif.apb_drv_cb.PENABLE <= 1'b0;//setup phase

		if(xtnh.PWRITE)
			vif.apb_drv_cb.PWDATA <= xtnh.PWDATA;

		@(vif.apb_drv_cb);
		vif.apb_drv_cb.PENABLE <= 1'b1;//enable phase
		wait(vif.apb_drv_cb.PREADY)

		if(xtnh.PWRITE == 1'b0)
		xtnh.PRDATA = vif.apb_drv_cb.PRDATA;
		`uvm_info(get_type_name(),$sformatf("Printing from apb driver %s",xtnh.sprint()),UVM_LOW)
		vif.apb_drv_cb.PSEL <= 1'b0;
		vif.apb_drv_cb.PENABLE <= 1'b0;
	endtask
			

endclass	 





	







