//SPI sequence class
class spi_sequence extends uvm_sequence #(spi_xtn);

//Factory registration
	`uvm_object_utils(spi_sequence)

//Function new constructor
function new(string name="spi_sequence");
	super.new(name);
endfunction

//Body task
task body();
	repeat(1) 
	begin
		req = spi_xtn::type_id::create("req");
		start_item(req);
		req.randomize();
		finish_item(req);
	end
endtask
endclass

