//SPI monitor class
class spi_monitor extends uvm_monitor;

//Factory registration
	`uvm_component_utils(spi_monitor)
	
	uvm_analysis_port #(spi_xtn) spi_ap;
	
	spi_cfg s_cfg;
	
	virtual spi_if.SPI_MON_MP vif;

	bit [7:0]ctrl;
	bit cphase;
	bit cpol;
	bit lsbfe;

//Function new constructor	
	function new(string name="spi_monitor", uvm_component parent);
		super.new(name,parent);
		spi_ap = new("spi_ap",this);
	endfunction

//Buil phase method
	 function void build_phase(uvm_phase phase);
                if(!uvm_config_db #(spi_cfg)::get(this,"","spi_cfg",s_cfg))
                        `uvm_fatal(get_type_name(),"Check the connections brother")

        endfunction

//Connect phase method
        function void connect_phase(uvm_phase phase);
                vif = s_cfg.vif;
        endfunction

//Run phase task
	task run_phase(uvm_phase phase);
		forever
			collect_data();
	endtask

//collect data task
	task collect_data();
		spi_xtn xtnh;
		xtnh = spi_xtn::type_id::create("xtnh");
		if(!uvm_config_db #(bit[7:0])::get(this,"","bit[7:0]",ctrl)) begin
                        `uvm_fatal(get_type_name(),"get the fatal")
		end
                          `uvm_info(get_type_name(),$sformatf("the drive data is %0b",ctrl),UVM_LOW)
                         cphase=ctrl[2];
                         cpol=ctrl[3];
                         lsbfe=ctrl[0];

		@(vif.spi_mon_cb);
		begin
			if(lsbfe) begin
				
				for(int i=0; i<=7; i++) 
				begin
					if( ((!cpol) && (!cphase)) || ((cpol) && (cphase)))
					begin
						@(posedge vif.spi_mon_cb.sclk)
						begin
							xtnh.miso[i] = vif.spi_mon_cb.miso;
							xtnh.mosi[i] = vif.spi_mon_cb.mosi;
							xtnh.ss = vif.spi_mon_cb.ss;
							xtnh.spi_interrupt_request = vif.spi_mon_cb.spi_interrupt_request;
						end
					end

					else begin
						
						@(negedge vif.spi_mon_cb.sclk)
						begin
							xtnh.miso[i] = vif.spi_mon_cb.miso;
							xtnh.mosi[i] = vif.spi_mon_cb.mosi;
							xtnh.ss = vif.spi_mon_cb.ss;
							xtnh.spi_interrupt_request = vif.spi_mon_cb.spi_interrupt_request;
						end
					end
				end
			end

			else begin
				
				for(int i=7; i>=0; i--) 
				begin
					if( ((!cpol) && (!cphase)) || ((cpol) && (cphase)))
					begin
						@(posedge vif.spi_mon_cb.sclk)
						begin
							xtnh.miso[i] = vif.spi_mon_cb.miso;
							xtnh.mosi[i] = vif.spi_mon_cb.mosi;
							xtnh.ss = vif.spi_mon_cb.ss;
							xtnh.spi_interrupt_request = vif.spi_mon_cb.spi_interrupt_request;
						end
					end

					else begin
						
						@(negedge vif.spi_mon_cb.sclk)
						begin
							xtnh.miso[i] = vif.spi_mon_cb.miso;
							xtnh.mosi[i] = vif.spi_mon_cb.mosi;
							xtnh.ss = vif.spi_mon_cb.ss;
							xtnh.spi_interrupt_request = vif.spi_mon_cb.spi_interrupt_request;
						end
					end
				end
			end
		end
		`uvm_info(get_type_name(),$sformatf("Printing from spi monitor %s",xtnh.sprint()),UVM_LOW)
		spi_ap.write(xtnh);
	endtask
endclass

