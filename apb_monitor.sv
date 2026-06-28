//APB monitor class
class apb_monitor extends uvm_monitor;

//Factory registration
	`uvm_component_utils(apb_monitor)

//Uvm analysis port and apb_cfg handle	
	uvm_analysis_port #(apb_xtn) apb_ap;
	
	apb_cfg a_cfg;

//Virtual interface handle
	virtual apb_if.APB_MON_MP vif;

//Function new constructor
	function new(string name="apb_monitor", uvm_component parent);
		super.new(name,parent);
		apb_ap = new("apb_ap",this);
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
		forever 
			collect_data();
	endtask

//Collect data task
	task collect_data();
		apb_xtn xtnh;
		xtnh = apb_xtn::type_id::create("xtnh");
		@(vif.apb_mon_cb);
		wait(vif.apb_mon_cb.PENABLE && vif.apb_mon_cb.PREADY)
		xtnh.PSEL = vif.apb_mon_cb.PSEL;
		xtnh.PRESET_n = vif.apb_mon_cb.PRESET_n;
		xtnh.PENABLE = vif.apb_mon_cb.PENABLE;
		xtnh.PADDR = vif.apb_mon_cb.PADDR;
		xtnh.PWRITE = vif.apb_mon_cb.PWRITE;
		if(vif.apb_mon_cb.PWRITE)
			xtnh.PWDATA = vif.apb_mon_cb.PWDATA;
		else
			xtnh.PRDATA = vif.apb_mon_cb.PRDATA;
		xtnh.PREADY = vif.apb_mon_cb.PREADY;
		xtnh.PSLVERR = vif.apb_mon_cb.PSLVERR;
	
		`uvm_info(get_type_name(),$sformatf("Printing from APB monitor %s",xtnh.sprint()),UVM_LOW)
		apb_ap.write(xtnh);
	endtask
endclass
	




