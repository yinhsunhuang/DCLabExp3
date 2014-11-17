
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module exp3_recorder(

	//////////// CLOCK //////////
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,

	//////////// LED //////////
	LEDG,
	LEDR,

	//////////// KEY //////////
	KEY,

	//////////// SW //////////
	SW,

	//////////// SEG7 //////////
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5,
	HEX6,
	HEX7,

	//////////// LCD //////////
	LCD_BLON,
	LCD_DATA,
	LCD_EN,
	LCD_ON,
	LCD_RS,
	LCD_RW,

	//////////// Audio //////////
	AUD_ADCDAT,
	AUD_ADCLRCK,
	AUD_BCLK,
	AUD_DACDAT,
	AUD_DACLRCK,
	AUD_XCK,

	//////////// I2C for Audio  //////////
	I2C_SCLK,
	I2C_SDAT,

	//////////// SRAM //////////
	SRAM_ADDR,
	SRAM_CE_N,
	SRAM_DQ,
	SRAM_LB_N,
	SRAM_OE_N,
	SRAM_UB_N,
	SRAM_WE_N,

	//////////// GPIO, GPIO connect to GPIO Default //////////
	GPIO 
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input 		          		CLOCK_50;
input 		          		CLOCK2_50;
input 		          		CLOCK3_50;

//////////// LED //////////
output		     [8:0]		LEDG;
output		    [17:0]		LEDR;

//////////// KEY //////////
input 		     [3:0]		KEY;

//////////// SW //////////
input 		    [17:0]		SW;

//////////// SEG7 //////////
output		     [6:0]		HEX0;
output		     [6:0]		HEX1;
output		     [6:0]		HEX2;
output		     [6:0]		HEX3;
output		     [6:0]		HEX4;
output		     [6:0]		HEX5;
output		     [6:0]		HEX6;
output		     [6:0]		HEX7;

//////////// LCD //////////
output		          		LCD_BLON;
inout 		     [7:0]		LCD_DATA;
output		          		LCD_EN;
output		          		LCD_ON;
output		          		LCD_RS;
output		          		LCD_RW;

//////////// Audio //////////
input 		          		AUD_ADCDAT;
inout 		          		AUD_ADCLRCK;
inout 		          		AUD_BCLK;
output		          		AUD_DACDAT;
inout 		          		AUD_DACLRCK;
output		          		AUD_XCK;

//////////// I2C for Audio  //////////
output		          		I2C_SCLK;
inout 		          		I2C_SDAT;

//////////// SRAM //////////
output		    [19:0]		SRAM_ADDR;
output		          		SRAM_CE_N;
inout 		    [15:0]		SRAM_DQ;
output		          		SRAM_LB_N;
output		          		SRAM_OE_N;
output		          		SRAM_UB_N;
output		          		SRAM_WE_N;

//////////// GPIO, GPIO connect to GPIO Default //////////
inout 		    [35:0]		GPIO;


//=======================================================
//	 parameter declarations
//=======================================================
parameter S_READY = 4'd0;
parameter S_SET	= 4'd1;
parameter S_WAIT	= 4'd2;
parameter S_FIN	= 4'd3;


//=======================================================
//  REG/WIRE declarations
//=======================================================
wire clk, clk_i2c;
wire reset;
reg go;
reg	[3:0]	state;
reg	[3:0]	next_state;
reg	[3:0] d_ctr, next_d_ctr;
reg	[23:0] ROM[0:10];
wire	[35:0] GPIO;


wire 		          		AUD_ADCDAT;
wire 		          		AUD_ADCLRCK;
wire 		          		AUD_BCLK;
wire 		          		AUD_DACLRCK;
wire 							AUD_DACDAT;
assign AUD_DACDAT = AUD_ADCDAT;
//=======================================================
//  Structural coding
//=======================================================
assign reset = KEY[0];
assign GPIO[0] = o_Ready;
assign GPIO[1] = clk_i2c;
assign GPIO[2] = I2C_SCLK;
assign GPIO[3] = I2C_SDAT;
assign GPIO[11] =      		AUD_ADCDAT;
assign GPIO[12] =     		AUD_ADCLRCK;
assign GPIO[13] =     		AUD_BCLK;
assign GPIO[14] =     		AUD_DACLRCK;
pll u1(
		.inclk0(CLOCK_50),
		.c0(clk),
		.c1(clk_i2c)
	);

inout_port u2(
		.GO(go),
		.clk(clk_i2c),
		.reset(reset),
		.iDATA(ROM[d_ctr]),
		.oReady(o_Ready),
		.oDATA(),
		.SCL(I2C_SCLK),
		.SDA(I2C_SDAT),
		.ACK(GPIO[4]),
		.ctr(GPIO[10:5])
);

always @(*) begin
	case(state)
		S_READY: begin
			if(KEY[1] == 0) next_state = S_SET;
			else next_state = S_READY;
			next_d_ctr = d_ctr;
			go = 0;
		end
		S_SET: begin
			go = 1;
			if(o_Ready == 0) begin
				next_state = S_WAIT;
				next_d_ctr = d_ctr;
			end
			else begin
				next_state = S_SET;
				next_d_ctr = d_ctr;
			end
		end
		S_WAIT: begin
			go = 0;
			if(o_Ready == 1) begin
				if(d_ctr < 9) begin
					next_d_ctr = d_ctr + 1;
					next_state = S_SET;
				end
				else begin
					next_state = S_FIN;
				end
			end
			else begin
				next_state = S_WAIT;
				next_d_ctr = d_ctr;
			end
		end
		S_FIN: begin
			go = 0;
			next_state = S_FIN;
			next_d_ctr = d_ctr;
		end
		
	endcase
end

always @(negedge reset or posedge clk_i2c) begin
	if(!reset)begin
		state <= S_READY;
		ROM[0]  <= 24'b0011010_0_000_0000_0_1001_0111;
		ROM[1]  <= 24'b0011010_0_000_0001_0_1001_0111;
		ROM[2]  <= 24'b0011010_0_000_0010_0_0111_1001;
		ROM[3]  <= 24'b0011010_0_000_0011_0_0111_1001;
		ROM[4]  <= 24'b0011010_0_000_0100_0_0001_0101;
		ROM[5]  <= 24'b0011010_0_000_0101_0_0000_0000;
		ROM[6]  <= 24'b0011010_0_000_0110_0_0000_0000;
		ROM[7]  <= 24'b0011010_0_000_0111_0_0100_0010;
		ROM[8]  <= 24'b0011010_0_000_1000_0_0001_1001;
		ROM[9]  <= 24'b0011010_0_000_1001_0_0000_0001;
		ROM[10] <= 24'b0011010_0_000_1111_0_0000_0000;
		d_ctr <= 0;
	end
	else begin
		state <= next_state;
		d_ctr <= next_d_ctr;
	end
end

endmodule
