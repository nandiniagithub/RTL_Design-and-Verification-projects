//apb transaction class
class apb_xtn extends uvm_sequence_item;

//Factory registration
	`uvm_object_utils(apb_xtn)

	//properties
	rand bit PRESET_n;
	rand bit PWRITE;
	bit PSEL;
	bit PENABLE;
	rand bit [2:0]PADDR;
	rand bit [7:0]PWDATA;
	bit [7:0]PRDATA;
	bit PREADY;
	bit PSLVERR;

	//constraints
	
	constraint valid_address{if(!PWRITE)
					PADDR inside{[0:3],5};
				else
					PADDR inside{[0:2],5};}
	constraint valid_reset{PRESET_n dist{0:=1,1:=99};}

	extern function new(string name="apb_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
endclass

//Function new constructor
function apb_xtn::new(string name="apb_xtn");
	super.new(name);
endfunction

//do print method
function void apb_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("PWRITE",this.PWRITE,1,UVM_DEC);
	printer.print_field("PSEL",this.PSEL,1,UVM_DEC);
	printer.print_field("PENABLE",this.PENABLE,1,UVM_DEC);
	printer.print_field("PADDR",this.PADDR,3,UVM_DEC);
	printer.print_field("PWDATA",this.PWDATA,8,UVM_DEC);
	printer.print_field("PRDATA",this.PRDATA,8,UVM_DEC);
	printer.print_field("PREADY",this.PREADY,1,UVM_DEC);
	printer.print_field("PSLVERR",this.PSLVERR,1,UVM_DEC);
endfunction

//Post randomize method
function void apb_xtn::post_randomize();
	bit [7:0] cntr1_reg_mask=8'b1111_1111;
	bit [7:0] cntr2_reg_mask=8'b0001_1011;
	bit [7:0] baud_reg_mask=8'b0111_0111;
	bit [7:0] status_reg_mask=8'b0000_0000;
	bit [7:0] data_reg_mask=8'b1111_1111;
	if(PWRITE)
	begin
		case(PADDR)
			000:PWDATA=cntr1_reg_mask&PWDATA;
			001:PWDATA=cntr2_reg_mask&PWDATA;
			010:PWDATA=baud_reg_mask&PWDATA;
			011:PWDATA=status_reg_mask&PWDATA;
			101:PWDATA=data_reg_mask&PWDATA;
			default:PWDATA=data_reg_mask&PWDATA;
		endcase
	end
endfunction









	

