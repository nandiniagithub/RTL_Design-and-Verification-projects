//`timescale 1ns/1ps

interface apb_if(input bit clock);
	bit PCLK;
	logic PRESET_n;
	logic PWRITE;
	logic PSEL;
	logic PENABLE;
	logic[2:0]PADDR;
	logic[7:0]PWDATA;
	logic [7:0]PRDATA;
	logic PREADY;
	logic PSLVERR;
assign PCLK=clock;//connects TB clock to APB protocol signal.In APB,TB owns the clock so need to assign 

//APB Driver clocking block
clocking apb_drv_cb@(posedge clock);
	default input #1 output #1;
	output PRESET_n;
	output PWRITE;
	output PSEL;
	output PENABLE;
	output PADDR;
	output PWDATA;
	input PRDATA;
	input PREADY;
	input PSLVERR;
endclocking 

//APB Monitor clocking block
clocking apb_mon_cb@(posedge clock);
	default input #1 output #1;
	input PRESET_n;
	input PWRITE;
	input PSEL;
	input PENABLE;
	input PADDR;
	input PWDATA;
	input PRDATA;
	input PREADY;
	input PSLVERR;
endclocking

//Modport of driver cb and monitor cb
modport APB_DRV_MP(clocking apb_drv_cb);
modport APB_MON_MP(clocking apb_mon_cb);


//Assertions 
//signal stable
property signal_stable;
	@(posedge clock) $rose(PSEL)|->($stable(PWRITE) && $stable(PADDR) && $stable(PWDATA)) until PREADY[->1];
endproperty

//penable stable
property penable_stable;
	@(posedge clock) $rose(PENABLE)|->($stable(PSEL) && $stable(PENABLE)) until PREADY[->1];
endproperty

//psel to pready
property psel_to_pready;
	@(posedge clock) (PSEL && PENABLE)|-> ##[0:$]PREADY; //PREADY signal can go high within 0 to any number of cycles
endproperty

//address reserved
property address_reserved;
	@(posedge clock) PSEL |-> ((PADDR!=3'b100) || (PADDR!=3'b110) || (PADDR!=3'b111)); //reserved address 4,6,7
endproperty

//penable deassert
property penable_deassert;
	@(posedge clock) (!PSEL) |-> (!PENABLE);
endproperty

//write data transfer
property valid_write_data_transfer;
	@(posedge clock) (PSEL && PENABLE && PWRITE) |-> (PWDATA!==`hx); //PWDATA should contain some amount of data it should not be empty
endproperty

//read data transfer
property valid_read_data_transfer;
	@(posedge clock) (PSEL && PENABLE && (!PWRITE)) |-> (PRDATA!==`hx); //PRDATA should contain data
endproperty

//pready low at start
property pready_low_at_start;
	@(posedge clock) ((PSEL) && (!PENABLE)) |-> (!PREADY);
endproperty

//pready deassert
property pready_deassert;
	@(posedge clock) (!PSEL) |-> (!PREADY);
endproperty

signals_stable1:assert property(signals_stable)
	$info("signal is stable");
	else
	   $error("signal is not stable");

penable_stable1:assert property(penable_stable)
	$info("penable is stable");
	else
           $error("penable is not stable");

psel_to_pready1:assert property(psel_to_pready)
	$info("PREADY went high");
	else
	  $error("PREADY issue");

address_reserved1:assert property(address_reserved)
	$info("address bits are reserved");
	else
	  $error("address bits are not reserved");

penable_deassert1:assert property(penable_deassert)
	$info("penable deasserted");
	else
	  $error("penable deassertion problem");

valid_write_data_transfer1:assert property(valid_write_data_transfer)
	$info("data transfer is working,data is not unknown");
	else
	  $error("data is not available");

valid_read_data_transfer1:assert property(valid_read_data_transfer)
	$info("read data transfer successful");
	else
	  $error("read data is empty");

pready_low_at_start1:assert property(pready_low_at_start)
	$info("success");
	else
	  $error("failed");

pready_deassert1:assert property(pready_deassert)
	$info("pready deasserted");
	else
	   $error("pready deasserted failed");*/

endinterface
	


