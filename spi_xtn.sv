class spi_xtn extends uvm_sequence_item;
        `uvm_object_utils(spi_xtn)
     
        bit ss;
        bit sclk;
        bit [7:0]mosi;
        rand bit[7:0]miso;
        bit spi_interrupt_request;


function new(string name="spi_xtn");
        super.new(name);
endfunction

function void do_print(uvm_printer printer);
        super.do_print(printer);
        printer.print_field("ss",this.ss,1,UVM_BIN);
        printer.print_field("mosi",this.mosi,8,UVM_BIN);
        printer.print_field("miso",this.miso,8,UVM_BIN);
        printer.print_field("spi_interrupt_request",this.spi_interrupt_request,1,UVM_BIN);
endfunction

endclass
		



