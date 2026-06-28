//SPI CR1 
class spi_cr1 extends uvm_reg;

//Factory registration
	`uvm_object_utils(spi_cr1)

//Properties
	rand uvm_reg_field lsbfe;
	rand uvm_reg_field ssoe;
	rand uvm_reg_field cpha;
	rand uvm_reg_field cpol;
	rand uvm_reg_field mstr;
	rand uvm_reg_field sptie;
	rand uvm_reg_field spe;
	rand uvm_reg_field spie;

//Function new constructor
	function new(string name="spi_CR1");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

//Build function
	function void build();
		lsbfe = uvm_reg_field::type_id::create("lsbfe");
		ssoe = uvm_reg_field::type_id::create("ssoe");
		cpha = uvm_reg_field::type_id::create("cpha");
		cpol = uvm_reg_field::type_id::create("cpol");
		mstr = uvm_reg_field::type_id::create("mstr");
		sptie = uvm_reg_field::type_id::create("sptie");
		spe = uvm_reg_field::type_id::create("spe");
		spie = uvm_reg_field::type_id::create("spie");
		

		lsbfe.configure(this,1,0,"RW",0,1'b0,1,1,1);
		ssoe.configure(this,1,1,"RW",0,1'b0,1,1,1);
		cpha.configure(this,1,2,"RW",0,1'b1,1,1,1);
		cpol.configure(this,1,3,"RW",0,1'b0,1,1,1);
		mstr.configure(this,1,4,"RW",0,1'b0,1,1,1);
		sptie.configure(this,1,5,"RW",0,1'b0,1,1,1);
		spe.configure(this,1,6,"RW",0,1'b0,1,1,1);
		spie.configure(this,1,7,"RW",0,1'b0,1,1,1);
	endfunction
endclass


//SPI_CR2 class
class spi_cr2 extends uvm_reg;

//Factory registration
	`uvm_object_utils(spi_cr2)

//Properties
	 uvm_reg_field reserved1;
	 uvm_reg_field reserved2;
	rand uvm_reg_field spco;
	rand uvm_reg_field spiswai;
	rand uvm_reg_field bidiroe;
	rand uvm_reg_field modfen;

//Function new constructor
	function new(string name="spi_cr2");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

//Build method
	function void build();
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		spco = uvm_reg_field::type_id::create("spco");
		spiswai = uvm_reg_field::type_id::create("spiswai");
		bidiroe = uvm_reg_field::type_id::create("bidiroe");
		modfen = uvm_reg_field::type_id::create("modfen");

		reserved1.configure(this,1,2,"RO",0,1'b0,0,0,0);
		reserved2.configure(this,3,5,"RO",0,3'd0,0,0,0);
		spco.configure(this,1,0,"RW",0,1'b0,1,1,1);
		spiswai.configure(this,1,1,"RW",0,1'b0,1,1,1);
		bidiroe.configure(this,1,3,"RW",0,1'b0,1,1,1);
		modfen.configure(this,1,4,"RW",0,1'b0,1,1,1);
	endfunction 
endclass

//SPI_BR class
class spi_br extends uvm_reg;

//Factory registration
	`uvm_object_utils(spi_br)

//Properties
	uvm_reg_field reserved1;
	uvm_reg_field reserved2;
	rand uvm_reg_field spr;
	rand uvm_reg_field sppr;

//Function new constructor
	function new(string name="spi_br");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

//Build function
	function void build();
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		sppr = uvm_reg_field::type_id::create("sppr");
		spr = uvm_reg_field::type_id::create("spr");

		reserved1.configure(this,1,3,"RO",0,1'b0,0,0,0);
		reserved2.configure(this,1,7,"RO",0,1'b0,0,0,0);
		sppr.configure(this,3,4,"RW",0,3'd0,1,1,1);
		spr.configure(this,3,0,"RW",0,3'd0,1,1,1);
	endfunction
endclass

//SPI_SR class
class spi_sr extends uvm_reg;

//Factory registration
	`uvm_object_utils(spi_sr)

//Properties
	uvm_reg_field reserved1;
	uvm_reg_field reserved2;
	uvm_reg_field spif;
	uvm_reg_field sptef;
	uvm_reg_field modf; 

//Function new constructor
	function new(string name="spi_sr");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

//Build function
	function void build();
		reserved1 = uvm_reg_field::type_id::create("reserved1");
		reserved2 = uvm_reg_field::type_id::create("reserved2");
		modf = uvm_reg_field::type_id::create("modf");
		sptef = uvm_reg_field::type_id::create("sptef");
		spif = uvm_reg_field::type_id::create("spif");

		reserved1.configure(this,4,0,"RO",0,4'd0,0,0,0);
		reserved2.configure(this,1,6,"RO",0,1'b0,0,0,0);
		spif.configure(this,1,7,"RO",0,1'b0,0,0,0);
		sptef.configure(this,1,5,"RO",0,1'b0,0,0,0);
		modf.configure(this,1,4,"RO",0,1'b0,0,0,0);
	endfunction
endclass

//SPI_DR class
class spi_dr extends uvm_reg;

//Factory registration 
	`uvm_object_utils(spi_dr)

//Property
	rand uvm_reg_field data;

//Function new constructor
	function new(string name="spi_sr");
		super.new(name,8,UVM_CVR_ALL);
	endfunction

//Build function
	function void build();
		data = uvm_reg_field::type_id::create("data");
		data.configure(this,8,0,"RW",0,8'd0,1,1,1);
	endfunction
endclass
	



























