//APB agent class
class apb_agent extends uvm_agent;

//Factory registration
`uvm_component_utils(apb_agent)

//Declare the handles of driver,mon and seq and apb_cfg
        apb_driver drvh;
        apb_monitor monh;
        apb_sequencer sqrh;

        apb_cfg e_cfg;

//Function new constructor
        function new(string name="apb_agent", uvm_component parent);
                super.new(name,parent);
        endfunction

//Build phase method
        function void build_phase(uvm_phase phase);
                if(!uvm_config_db #(apb_cfg)::get(this,"","apb_cfg",e_cfg))
                        `uvm_fatal(get_type_name(),"Check the connections brother");

                monh = apb_monitor::type_id::create("monh",this);
                if(e_cfg.is_active) 
		begin
                        drvh = apb_driver::type_id::create("drvh",this);
                        sqrh = apb_sequencer::type_id::create("sqrh",this);
                end

                super.build_phase(phase);
        endfunction

//Connect phase method
        function void connect_phase(uvm_phase phase);
                if(e_cfg.is_active)
                        drvh.seq_item_port.connect(sqrh.seq_item_export);
                super.connect_phase(phase);
        endfunction
endclass



