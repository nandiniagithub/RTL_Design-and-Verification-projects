//spi agent top class
class spi_agent_top extends uvm_env;

//Factory registration
	`uvm_component_utils(spi_agent_top)

	spi_agent agenth[];
	env_cfg e_cfg;

//Function new constructor
	function new(string name ="spi_agent_top", uvm_component parent);
		super.new(name,parent);
	endfunction
	
//Build phase method
	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal(get_type_name(),"Error in getting configuration");

		if(e_cfg.has_spi_agent) 
		begin
			agenth = new[e_cfg.no_of_agents];
			foreach(agenth[i]) 
			begin
				uvm_config_db #(spi_cfg)::set(this,$sformatf("agenth[%0d]*",i),"spi_cfg",e_cfg.s_cfg[i]);
				agenth[i]=spi_agent::type_id::create($sformatf("agenth[%0d]",i),this);
			end
		end
		super.build_phase(phase);
	endfunction
endclass

