//Scoreboard class
class spi_apb_scoreboard extends uvm_scoreboard;

//Factory registration
	`uvm_component_utils(spi_apb_scoreboard)
	env_cfg e_cfg;

//Analysis fifo
	uvm_tlm_analysis_fifo #(apb_xtn) apb_fifo[];
	uvm_tlm_analysis_fifo #(spi_xtn) spi_fifo[];
	bit [7:0] data;
	
	uvm_status_e status;
	
	spi_apb_reg_block reg_block;
	
	apb_xtn apb_xtnh;
	spi_xtn spi_xtnh;
	apb_xtn apb_cov_data;
	spi_xtn spi_cov_data;
	
	static int data_verified_cnt = 0;
	
	bit reset_case;
	bit [1:0]low_pwr_mode;
	bit [7:0] cr1,cr2,br,sr,dr; 

        covergroup apb_cg;
        option.per_instance=1;
        RESET:coverpoint apb_cov_data.PRESET_n{bins rst={0,1};}//1
        ADDR:coverpoint apb_cov_data.PADDR{bins addr[]={0,1,2,3,5};}//paddr to write/read register//5
        SELX:coverpoint apb_cov_data.PSEL{bins sel={0,1};}//apb master slave select//1
        ENABLE:coverpoint apb_cov_data.PENABLE{bins enb={0,1};}//apb enable 1
        WRITE:coverpoint apb_cov_data.PWRITE{bins write ={0,1};}//indicates write or read//1
        READY:coverpoint apb_cov_data.PREADY{bins ready={0,1};}//pready signal 1
        ERROR:coverpoint apb_cov_data.PSLVERR{bins err={0,1};}//perror signal 1
        WDATA:coverpoint apb_cov_data.PWDATA{bins low={[8'h00:8'hff]};
                                                                              }//write data
        RDATA:coverpoint apb_cov_data.PRDATA{bins low={[8'h00:8'hff]};
                                                                      }//read data
        selx_enable:cross SELX,ENABLE;
        sel_enable_read:cross SELX,ENABLE,READY;
        endgroup

        covergroup spi_cg;
        option.per_instance=1;
        SLAVE_SELECT:coverpoint spi_cov_data.ss{bins ss1={0,1};}
        miso_DATA   :coverpoint spi_cov_data.miso{bins low={[8'h00:8'hff]};
                                                                   		}
        mosi_DATA   :coverpoint spi_cov_data.mosi{bins low={[8'h00:8'hff]};
                                                                                    }
        SPI_INTER_REQ:coverpoint spi_cov_data.spi_interrupt_request{bins inpt ={0,1};}
        endgroup



//Function new constructor
	function new(string name="spi_apb_scoreboard", uvm_component parent);
		super.new(name,parent);
		spi_cg = new();
		apb_cg = new();
	endfunction

//Build phase method
	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(env_cfg)::get(this,"","env_cfg",e_cfg))
			`uvm_fatal(get_type_name(),"Error in getting configuration");

		apb_fifo = new[e_cfg.no_of_agents];
		spi_fifo = new[e_cfg.no_of_agents];
		
		foreach(apb_fifo[i]) 
		begin
			apb_fifo[i] = new($sformatf("apb_fifo[%0d]",i),this);
		end
	
		foreach(spi_fifo[i]) 
		begin
			spi_fifo[i] = new($sformatf("spi_fifo[%0d]",i),this);
		end
	
	endfunction

//Connect phase method
	virtual	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		reg_block = e_cfg.reg_block;
	endfunction

//Compare data task
	//MOSI and PWDATA comparision
	task compare_data(apb_xtn xtnh);
		wait(spi_xtnh != null);
		wait(apb_xtnh != null);
		if(apb_xtnh.PWRITE && apb_xtnh.PADDR == 3'b101) 
		begin
			$display("==================SCOREBOARD REPORT===================");
			if(apb_xtnh.PWDATA == spi_xtnh.mosi)
				`uvm_info(get_type_name(),"mosi data succesfull verification", UVM_LOW)
			else
				`uvm_info(get_type_name(),"mosi data Unsuccessfull verification", UVM_LOW)
		end
	endtask

//Compare data task
task compare_data1(apb_xtn a_xtn);
        /*comparision logic to verify
                1.MISO data and PRDATA
                2.register in reset condition
                3.low power mode*/
              if(!uvm_config_db#(bit)::get(this,"","bit",reset_case)) 
		begin
			reset_case = 1'b0;
                        `uvm_info(get_type_name(),"not a reset case",UVM_LOW)
		end

	 if(reset_case)
                        begin
                                this.reg_block.cr1.read(status,cr1,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                this.reg_block.cr2.read(status,cr2,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                this.reg_block.br.read(status,br,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                this.reg_block.sr.read(status,sr,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                this.reg_block.dr.read(status,dr,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                
			if((cr1==8'b0000_0100) && (cr2==8'b0000_0000) && (br==8'b0000_0000) && (sr==8'b0010_0000) && (dr==8'b0000_0000))//reset values 04,00,00,20,00
                                        `uvm_info(get_type_name(),"reset comparision is successfull",UVM_LOW)
                        else
                                        `uvm_error(get_type_name(),"reset comparision is failed")
                                `uvm_info(get_type_name(),$sformatf("the reset values of register are: cr1=%0b,cr2=%0b,br=%0b,sr=%0b,dr=%0b",cr1,cr2,br,sr,dr),UVM_LOW)

			data_verified_cnt ++;
			end
	 if(low_pwr_mode==2'b01)
                        begin
                                if((!a_xtn.PWRITE) && (a_xtn.PADDR==3'b101))
                                        begin
                                                this.reg_block.dr.read(status,dr,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                             
                                                if(a_xtn.PRDATA == dr)
                                                        `uvm_info(get_type_name(),"low_pwr_mode  comparision is successfull ",UVM_LOW )
                                                else
                                                        `uvm_error(get_type_name(),"low_pwr_mode  comparision is failed")
					end
                        end
	
	else
                        begin
                               	wait(spi_xtnh!=null);
                                	if((!a_xtn.PWRITE) && (a_xtn.PADDR==3'b101)) 
					begin
						if(a_xtn.PRDATA == spi_xtnh.miso)
							`uvm_info(get_type_name(),"Comparison is succesfull",UVM_LOW)
						else
							`uvm_info(get_type_name(),"Unsuccesfull comparison",UVM_LOW)
					if(spi_xtnh.spi_interrupt_request)
                                              begin 
                                                          this.reg_block.sr.read(status,sr,.path(UVM_BACKDOOR),.map(reg_block.spi_reg_map));
                                                	`uvm_info(get_type_name(),$sformatf("the value of status reg is \n,the reason for interrupt is spif=%0b,sptef=%0b and modf=%0b",sr,sr[7],sr[4]),UVM_LOW)
                                              end
                                                                
                                        data_verified_cnt++;

					end
                        end

endtask
endclass


