//`timescale 1ns/1ps

interface spi_if(input bit clock);
	logic ss;
	logic sclk;
	logic mosi;
	logic miso;
	logic spi_interrupt_request;


//SPI Driver clocking block
clocking spi_drv_cb@(posedge clock);
	default input #1 output #1;
	input ss;
	input sclk;
	input mosi;
	output miso;
	input spi_interrupt_request;
endclocking 

//SPI Monitor clocking block
clocking spi_mon_cb@(posedge clock);
	default input #1 output #1;
	input ss;
	input sclk;
	input mosi;
	input miso;
	input spi_interrupt_request;
endclocking

//Modport of driver cb and monitor cb
modport SPI_DRV_MP(clocking spi_drv_cb);
modport SPI_MON_MP(clocking spi_mon_cb);
endinterface 


