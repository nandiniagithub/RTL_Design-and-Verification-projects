//spi reg block class
class spi_apb_reg_block extends uvm_reg_block;


//Factory registration
	`uvm_object_utils(spi_apb_reg_block)

//Properties
	uvm_reg_map spi_reg_map;

	rand spi_cr1 cr1;
	rand spi_cr2 cr2;
	rand spi_br br;
	rand spi_dr dr;
	rand spi_sr sr;

//Function new constructor
	function new(string name="spi_apb_reg_block");
		super.new(name,build_coverage(UVM_CVR_ALL));
	endfunction

//Build function
	function void build();
		cr1 = spi_cr1::type_id::create("cr1");
		cr2 = spi_cr2::type_id::create("cr2");
		dr = spi_dr::type_id::create("dr");
		br = spi_br::type_id::create("br");
		sr = spi_sr::type_id::create("sr");


		cr1.configure(this,null,"");
		cr2.configure(this,null,"");
		dr.configure(this,null,"");
		br.configure(this,null,"");
		sr.configure(this,null,"");
		cr1.build();
		cr2.build();
		dr.build();
		br.build();
		sr.build();

		add_hdl_path("top.dut", "RTL");

		cr1.add_hdl_path_slice("M1.SPI_CR_1",0,8);
		cr2.add_hdl_path_slice("M1.SPI_CR_2",0,8);
		br.add_hdl_path_slice("M1.SPI_BR",0,8);
		sr.add_hdl_path_slice("M1.SPI_SR",0,8);
		dr.add_hdl_path_slice("M1.SPI_DR",0,8);

		spi_reg_map = create_map("spi_reg_map","h0",1,UVM_LITTLE_ENDIAN,0);

		spi_reg_map.add_reg(cr1,8'h0,"RW");
		spi_reg_map.add_reg(cr2,8'h1,"RW");
		spi_reg_map.add_reg(br,8'h2,"RW");
		spi_reg_map.add_reg(sr,8'h3,"RO");
		spi_reg_map.add_reg(dr,8'h5,"RW");
		lock_model();	
	endfunction
endclass

