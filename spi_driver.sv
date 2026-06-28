//SPI driver class
class spi_driver extends uvm_driver#(spi_xtn);

//Factory registration
	`uvm_component_utils(spi_driver)
	spi_cfg s_cfg;
	virtual spi_if.SPI_DRV_MP vif;
	bit [7:0]ctrl;
	bit cphase;
	bit cpol;
	bit lsbfe;

//Function new constructor
	function new(string name="spi_driver", uvm_component parent);
		super.new(name,parent);
	endfunction

//Build phase method
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
		   begin
			seq_item_port.get_next_item(req);
			send_to_dut(req);
			seq_item_port.item_done();
		   end
	endtask

//send to dut task
	task send_to_dut(spi_xtn xtnh);
		if(!uvm_config_db#(bit[7:0])::get(this,"","bit[7:0]",ctrl))
		        `uvm_fatal(get_type_name(),"get the fatal")
      			  `uvm_info(get_type_name(),$sformatf("the drive data is %0b",ctrl),UVM_LOW)
    			 cphase=ctrl[2];
       			 cpol=ctrl[3];
        		 lsbfe=ctrl[0];

		wait(!vif.spi_drv_cb.ss)
		begin
			if(lsbfe) 
			begin
				if( (!cpol) && (!cphase)) 
				begin
					vif.spi_drv_cb.miso <= xtnh.miso[0];
					for(int i=1; i<=7; i++) 
					begin
						@(negedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end
			
				else if ((!cphase) && (cpol)) 
				begin	
					vif.spi_drv_cb.miso <= xtnh.miso[0];
					for(int i=1; i<=7; i++) 
					begin
						@(posedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end
				
				else if( (cphase) && (!cpol)) 
				begin	
					for(int i=0; i<=7; i++) 
					begin
						@(posedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end

				else if( cpol && cphase) 
				begin	
					for(int i=0; i<=7; i++) 
					begin
						@(negedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end
			end
			else begin
				
				if( (!cpol) && (!cphase)) 
				begin
					vif.spi_drv_cb.miso <= xtnh.miso[7];
					for(int i=6; i>=0; i--) 
					begin
						@(negedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end

				else if ( (!cphase) && (cpol)) 
				begin	
					vif.spi_drv_cb.miso <= xtnh.miso[7];
					for(int i=6; i>=0; i--) 
					begin
						@(posedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end

				else if ( (!cpol) && (cphase)) 
				begin
					for(int i=7; i>=0; i--) 
					begin
						@(posedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end

				else if( cpol && cphase) 
				begin
					for(int i=7; i>=0; i--) 
					begin
						@(negedge vif.spi_drv_cb.sclk);
						vif.spi_drv_cb.miso <= xtnh.miso[i];
					end
				end
			end
		end
		`uvm_info(get_type_name(),$sformatf("Printing from SPI driver %s", xtnh.sprint()),UVM_LOW)
	endtask

endclass

