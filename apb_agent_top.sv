//APB agent top class
class apb_agent_top extends uvm_env;

//Factory registration
	`uvm_component_utils(apb_agent_top)

//APB agent and env_cfg handle
	apb_agent agenth[];
	env_cfg e_cfg;
		
//Function new constructor
	function new(string name="apb_agent_top", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal(get_type_name(), "Check the connections brother");

		if(e_cfg.has_apb_agent) 
		begin
			agenth = new[e_cfg.no_of_agents];

			foreach(agenth[i]) 
			begin
				uvm_config_db #(apb_cfg)::set(this,$sformatf("agenth[%0d]*",i),"apb_cfg",e_cfg.a_cfg[i]);
				agenth[i] = apb_agent::type_id::create($sformatf("agenth[%0d]",i),this);
			end
		end
		super.build_phase(phase);
	endfunction
endclass

