`timescale 1ns / 1ps


module spi_slave #(
    parameter integer                   C_M_AXI_ADDR_WIDTH    = 32 ,
    parameter integer                   C_M_AXI_DATA_WIDTH    = 32
)(
    input  wire                         clk                        ,
    input  wire                         rst_n                      ,
    input  wire                         sen                        ,
    input  wire                         sclk                       ,
    input  wire                         sdi                        ,
    output wire                         sdo                        ,
// M00_AXI
    output wire                         M00_INIT_WRITE             ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M00_W_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M00_W_OFFT_ADDR            ,
    output wire [C_M_AXI_DATA_WIDTH-1:0]M00_W_DATA                 ,
    input  wire                         M00_W_RESP                 ,
    output wire                         M00_INIT_READ              ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M00_R_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M00_R_OFFT_ADDR            ,
    input  wire [C_M_AXI_DATA_WIDTH-1:0]M00_R_DATA                 ,
    input  wire                         M00_R_RESP                 ,
// M01_AXI
    output wire                         M01_INIT_WRITE             ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M01_W_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M01_W_OFFT_ADDR            ,
    output wire [C_M_AXI_DATA_WIDTH-1:0]M01_W_DATA                 ,
    input  wire                         M01_W_RESP                 ,
    output wire                         M01_INIT_READ              ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M01_R_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M01_R_OFFT_ADDR            ,
    input  wire [C_M_AXI_DATA_WIDTH-1:0]M01_R_DATA                 ,
    input  wire                         M01_R_RESP                 ,
// M02_AXI
    output wire                         M02_INIT_WRITE             ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M02_W_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M02_W_OFFT_ADDR            ,
    output wire [C_M_AXI_DATA_WIDTH-1:0]M02_W_DATA                 ,
    input  wire                         M02_W_RESP                 ,
    output wire                         M02_INIT_READ              ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M02_R_BASE_ADDR            ,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]M02_R_OFFT_ADDR            ,
    input  wire [C_M_AXI_DATA_WIDTH-1:0]M02_R_DATA                 ,
    input  wire                         M02_R_RESP                 
);


reg                    [   7:0]         spi_cmd_shift_di    = 8'd0 ;
reg                    [   7:0]         spi_cmd_shift_cnt   = 8'd1 ;
reg                    [  31:0]         spi_data_shift_di   =32'd0 ;
reg                    [  31:0]         spi_data_shift_cnt  =32'd1 ;

reg                                     rSdo                = 1'b0 ;

reg                                     rSpiCmdFlag         = 1'b0 ;

reg                                     rSpiAddrFlag        = 1'b0 ;
reg                                     rSpiDataFlag        = 1'b0 ;

reg                                     _rSpiAddrFlag       = 1'b0 ;
reg                                     _rSpiDataFlag       = 1'b0 ;
reg                                     __rSpiAddrFlag      = 1'b0 ;
reg                                     __rSpiDataFlag      = 1'b0 ;
reg                                     ___rSpiAddrFlag     = 1'b0 ;
reg                                     ___rSpiDataFlag     = 1'b0 ;

reg                    [   6:0]         rSpiSlaveIndex      = 7'd0 ;
reg                                     rSpiOperation       = 1'b0 ;// Write:1, Read: 0

reg                    [  31:0]         rSpiWAddr           = 32'd0;
reg                    [  31:0]         rSpiRAddr           = 32'd0;


reg                    [  31:0]         rSpiRData           = 32'd0;
reg                    [  31:0]         rSpiWData           = 32'd0;

reg                                     rAxiInit            = 1'b0 ;
reg                                     _rAxiInit           = 1'b0 ;

reg                                     rAxiInitWrite       = 1'b0 ;
reg           [C_M_AXI_ADDR_WIDTH-1 : 0]rAxiWBaseAddr       = {C_M_AXI_ADDR_WIDTH{1'b0}};
reg           [C_M_AXI_ADDR_WIDTH-1 : 0]rAxiWOfftAddr       = {C_M_AXI_ADDR_WIDTH{1'b0}};

reg                                     rAxiInitRead        = 1'b0 ;
reg           [C_M_AXI_ADDR_WIDTH-1 : 0]rAxiRBaseAddr       = {C_M_AXI_ADDR_WIDTH{1'b0}};
reg           [C_M_AXI_ADDR_WIDTH-1 : 0]rAxiROfftAddr       = {C_M_AXI_ADDR_WIDTH{1'b0}};



wire                                    wAxiInitWork               ;

wire                                    wMRResp                    ;
wire          [C_M_AXI_DATA_WIDTH-1 : 0]wMRData                    ;


assign sdo              = ( sen ) ? 1'bZ: {(rSpiOperation) ? 1'b0 : rSdo }                  ;


assign wAxiInitWork     = rAxiInit && (~_rAxiInit)                                          ;



// < M00_AXI
assign M00_INIT_WRITE   = (rSpiSlaveIndex == 0) ? rAxiInitWrite : 1'b0                      ;
assign M00_W_BASE_ADDR  = rAxiWBaseAddr                                                     ;
assign M00_W_OFFT_ADDR  = (rSpiSlaveIndex == 0) ? rAxiWOfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
assign M00_W_DATA       = (rSpiSlaveIndex == 0) ? rSpiWData : {C_M_AXI_DATA_WIDTH{1'b0}}    ;

assign M00_INIT_READ    = (rSpiSlaveIndex == 0) ? rAxiInitRead : 1'b0                       ;
assign M00_R_BASE_ADDR  = rAxiRBaseAddr                                                     ;
assign M00_R_OFFT_ADDR  = (rSpiSlaveIndex == 0) ? rAxiROfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
//   M00_AXI >


// < M01_AXI
assign M01_INIT_WRITE   = (rSpiSlaveIndex == 1) ? rAxiInitWrite : 1'b0                      ;
assign M01_W_BASE_ADDR  = rAxiWBaseAddr                                                     ;
assign M01_W_OFFT_ADDR  = (rSpiSlaveIndex == 1) ? rAxiWOfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
assign M01_W_DATA       = (rSpiSlaveIndex == 1) ? rSpiWData : {C_M_AXI_DATA_WIDTH{1'b0}}    ;

assign M01_INIT_READ    = (rSpiSlaveIndex == 1) ? rAxiInitRead : 1'b0                       ;
assign M01_R_BASE_ADDR  = rAxiRBaseAddr                                                     ;
assign M01_R_OFFT_ADDR  = (rSpiSlaveIndex == 1) ? rAxiROfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
//   M01_AXI


// < M02_AXI
assign M02_INIT_WRITE   = (rSpiSlaveIndex == 2) ? rAxiInitWrite : 1'b0                      ;
assign M02_W_BASE_ADDR  = rAxiWBaseAddr                                                     ;
assign M02_W_OFFT_ADDR  = (rSpiSlaveIndex == 2) ? rAxiWOfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
assign M02_W_DATA       = (rSpiSlaveIndex == 2) ? rSpiWData : {C_M_AXI_DATA_WIDTH{1'b0}}    ;

assign M02_INIT_READ    = (rSpiSlaveIndex == 2) ? rAxiInitRead : 1'b0                       ;
assign M02_R_BASE_ADDR  = rAxiRBaseAddr                                                     ;
assign M02_R_OFFT_ADDR  = (rSpiSlaveIndex == 2) ? rAxiROfftAddr : {C_M_AXI_ADDR_WIDTH{1'b0}};
//   M02_AXI



assign wMRResp          = M00_R_RESP || M01_R_RESP || M02_R_RESP                            ;
assign wMRData          = M00_R_RESP ? (M00_R_DATA) :
                        ( M01_R_RESP ? (M01_R_DATA) :
                         (M02_R_RESP ? (M02_R_DATA) :
                          {C_M_AXI_DATA_WIDTH{1'b0}})
                        ) ;



//---------------------------------------------------------------
// SPI Slave Interface 
//---------------------------------------------------------------

always @(posedge sclk or posedge sen) begin
  if ( sen ) begin
    spi_cmd_shift_di  <= 8'd0 ;
    spi_cmd_shift_cnt <= 8'b1 ;
  end
  else if ( ~rSpiCmdFlag ) begin
    spi_cmd_shift_di  <= {spi_cmd_shift_di[6:0], sdi}                     ;
    spi_cmd_shift_cnt <= {spi_cmd_shift_cnt[6:0], spi_cmd_shift_cnt[7]}   ;
  end
end


always @(posedge sclk or posedge sen) begin
  if ( sen ) begin
    spi_data_shift_di  <= 32'd0 ;
    spi_data_shift_cnt <= 32'b1 ;
  end
  else if ( rSpiCmdFlag ) begin
    spi_data_shift_di  <= {spi_data_shift_di[30:0],  sdi}                     ;
    spi_data_shift_cnt <= {spi_data_shift_cnt[30:0], spi_data_shift_cnt[31]}  ;
  end
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiCmdFlag <= 1'b0      ;
  else if ( spi_cmd_shift_cnt[7] )
    rSpiCmdFlag <= 1'b1      ;
  else
    rSpiCmdFlag <= rSpiCmdFlag  ;
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiSlaveIndex <= 7'b0;
  else if ( spi_cmd_shift_cnt[7] && (~rSpiCmdFlag) )
    rSpiSlaveIndex <= spi_cmd_shift_di[6:0];
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiOperation <= 1'b0  ;
  else if ( spi_cmd_shift_cnt[7] && (~rSpiCmdFlag) )
    rSpiOperation <= sdi   ;
  else
    rSpiOperation <= rSpiOperation  ;
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiAddrFlag <= 1'b0      ;
  else if ( spi_data_shift_cnt[31] & rSpiCmdFlag )
    rSpiAddrFlag <= 1'b1      ;
  else
    rSpiAddrFlag <= rSpiAddrFlag  ;
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiRAddr <= 32'd0 ;
  else if ( spi_data_shift_cnt[31] )
    if ( rSpiCmdFlag && (~rSpiAddrFlag) )
      rSpiRAddr <= {spi_data_shift_di[30:0],sdi};
    else if ( rSpiCmdFlag && rSpiAddrFlag )
      rSpiRAddr <= rSpiRAddr + 32'd4 ;
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiWAddr <= 32'd0 ;
  else if ( spi_data_shift_cnt[31] )
    if ( rSpiCmdFlag && (~rSpiAddrFlag) )
      rSpiWAddr <= {spi_data_shift_di[30:0],sdi};
    else if ( rSpiCmdFlag && rSpiAddrFlag && rSpiDataFlag )
      rSpiWAddr <= rSpiWAddr + 32'd4 ;
end


always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiDataFlag <= 1'b0   ;
  else if ( spi_data_shift_cnt[31] && rSpiCmdFlag && rSpiAddrFlag )
    rSpiDataFlag <= 1'b1   ;
  else
    rSpiDataFlag <= rSpiDataFlag  ;
end


// < Write Operation
always @(posedge sclk or posedge sen) begin
  if ( sen )
    rSpiWData <= 32'd0  ;
  else if ( rSpiOperation && spi_data_shift_cnt[31] )  // Write Operation
    if ( rSpiCmdFlag && rSpiAddrFlag )
      rSpiWData <= {spi_data_shift_di[30:0],sdi} ;
end
//   Write Operation >



// < Read Operation
always @(negedge sclk or posedge sen) begin
  if ( sen )
    rSdo <= 1'b0  ;
  else
    case(spi_data_shift_cnt)
      32'h1:            rSdo <= rSpiRData[31]   ;
      32'h2:            rSdo <= rSpiRData[30]   ;
      32'h4:            rSdo <= rSpiRData[29]   ;
      32'h8:            rSdo <= rSpiRData[28]   ;
      32'h10:           rSdo <= rSpiRData[27]   ;
      32'h20:           rSdo <= rSpiRData[26]   ;
      32'h40:           rSdo <= rSpiRData[25]   ;
      32'h80:           rSdo <= rSpiRData[24]   ;
      32'h100:          rSdo <= rSpiRData[23]   ;
      32'h200:          rSdo <= rSpiRData[22]   ;
      32'h400:          rSdo <= rSpiRData[21]   ;
      32'h800:          rSdo <= rSpiRData[20]   ;
      32'h1000:         rSdo <= rSpiRData[19]   ;
      32'h2000:         rSdo <= rSpiRData[18]   ;
      32'h4000:         rSdo <= rSpiRData[17]   ;
      32'h8000:         rSdo <= rSpiRData[16]   ;
      32'h10000:        rSdo <= rSpiRData[15]   ;
      32'h20000:        rSdo <= rSpiRData[14]   ;
      32'h40000:        rSdo <= rSpiRData[13]   ;
      32'h80000:        rSdo <= rSpiRData[12]   ;
      32'h100000:       rSdo <= rSpiRData[11]   ;
      32'h200000:       rSdo <= rSpiRData[10]   ;
      32'h400000:       rSdo <= rSpiRData[9]    ;
      32'h800000:       rSdo <= rSpiRData[8]    ;
      32'h1000000:      rSdo <= rSpiRData[7]    ;
      32'h2000000:      rSdo <= rSpiRData[6]    ;
      32'h4000000:      rSdo <= rSpiRData[5]    ;
      32'h8000000:      rSdo <= rSpiRData[4]    ;
      32'h10000000:     rSdo <= rSpiRData[3]    ;
      32'h20000000:     rSdo <= rSpiRData[2]    ;
      32'h40000000:     rSdo <= rSpiRData[1]    ;
      32'h80000000:     rSdo <= rSpiRData[0]    ;
    endcase
end
//   Read Operation >




//---------------------------------------------------------------
// AXI-Lite Master Interface
//---------------------------------------------------------------

always @(posedge clk) begin
  if ( ~rst_n ) begin
    rAxiInit  <= 1'b0   ;
    _rAxiInit <= 1'b0   ;
  end
  else if ( sen ) begin
    rAxiInit  <= 1'b0   ;
    _rAxiInit <= 1'b0   ;
  end
  else begin
    rAxiInit  <= spi_data_shift_cnt[0] ;
    _rAxiInit <= rAxiInit     ;
  end
end


always @(posedge clk) begin
  if ( ~rst_n ) begin
    _rSpiAddrFlag <= 1'b0         ;
    _rSpiDataFlag <= 1'b0         ;
  end
  else if ( sen ) begin
    _rSpiAddrFlag <= 1'b0         ;
    _rSpiDataFlag <= 1'b0         ;
  end
  else begin
    _rSpiAddrFlag <= rSpiAddrFlag ;
    _rSpiDataFlag <= rSpiDataFlag ;
  end
end

always @(posedge clk) begin
  if ( ~rst_n ) begin
    __rSpiAddrFlag <= 1'b0          ;
    __rSpiDataFlag <= 1'b0          ;
  end
  else if ( sen ) begin
    __rSpiAddrFlag <= 1'b0          ;
    __rSpiDataFlag <= 1'b0          ;
  end
  else begin
    __rSpiAddrFlag <= _rSpiAddrFlag ;
    __rSpiDataFlag <= _rSpiDataFlag ;
  end
end

always @(posedge clk) begin
  if ( ~rst_n ) begin
    ___rSpiAddrFlag <= 1'b0           ;
    ___rSpiDataFlag <= 1'b0           ;
  end
  else if ( sen ) begin
    ___rSpiAddrFlag <= 1'b0           ;
    ___rSpiDataFlag <= 1'b0           ;
  end
  else begin
    ___rSpiAddrFlag <= __rSpiAddrFlag ;
    ___rSpiDataFlag <= __rSpiDataFlag ;
  end
end


// < This is a one-single write and read process
always @(posedge clk) begin
  if ( ~rst_n ) begin
    rAxiInitWrite  <= 1'b0                          ;
    rAxiWOfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
  end
  else if ( sen ) begin
    rAxiInitWrite  <= 1'b0                          ;
    rAxiWOfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
  end
  else if ( rSpiOperation && wAxiInitWork && rSpiDataFlag && (~___rSpiDataFlag) ) begin
    rAxiInitWrite  <= 1'b1                          ;
    rAxiWOfftAddr  <= rSpiWAddr                     ;
  end
  else begin
    rAxiInitWrite  <= 1'b0                          ;
    rAxiWOfftAddr  <= rSpiWAddr                     ;
  end
end


always @(posedge clk) begin
  if ( ~rst_n ) begin
    rAxiInitRead   <= 1'b0                          ;
    rAxiROfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
  end
  else if ( sen ) begin
    rAxiInitRead   <= 1'b0                          ;
    rAxiROfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
  end
  else if ( (~rSpiOperation) && wAxiInitWork && rSpiAddrFlag && (~___rSpiAddrFlag)) begin
    rAxiInitRead   <= 1'b1                          ;
    rAxiROfftAddr  <= rSpiRAddr                     ;
  end
  else begin
    rAxiInitRead   <= 1'b0                          ;
    rAxiROfftAddr  <= rSpiRAddr                     ;
  end
end

//   This is a one-single write and read process >


// < This is a continued write and read process

// always @(posedge clk) begin
//   if ( ~rst_n ) begin
//     rAxiInitWrite  <= 1'b0                          ;
//     rAxiWOfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
//   end
//   else if ( sen ) begin
//     rAxiInitWrite  <= 1'b0                          ;
//     rAxiWOfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
//   end
//   else if ( rSpiOperation && wAxiInitWork && rSpiDataFlag ) begin
//     rAxiInitWrite  <= 1'b1                          ;
//     rAxiWOfftAddr  <= rSpiWAddr                     ;
//   end
//   else begin
//     rAxiInitWrite  <= 1'b0                          ;
//     rAxiWOfftAddr  <= rSpiWAddr                     ;
//   end
// end


// always @(posedge clk) begin
//   if ( ~rst_n ) begin
//     rAxiInitRead   <= 1'b0                          ;
//     rAxiROfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
//   end
//   else if ( sen ) begin
//     rAxiInitRead   <= 1'b0                          ;
//     rAxiROfftAddr  <= {C_M_AXI_ADDR_WIDTH{1'b0}}    ;
//   end
//   else if ( (~rSpiOperation) && wAxiInitWork && rSpiAddrFlag ) begin
//     rAxiInitRead   <= 1'b1                          ;
//     rAxiROfftAddr  <= rSpiRAddr                     ;
//   end
//   else begin
//     rAxiInitRead   <= 1'b0                          ;
//     rAxiROfftAddr  <= rSpiRAddr                     ;
//   end
// end

//   This is a continued write and read process >


always @(posedge clk) begin
  if ( ~rst_n )
    rSpiRData <= 32'd0        ;
  else if ( sen )
    rSpiRData <= 32'd0        ;
  else if ( ~rSpiOperation ) begin
    if ( wMRResp )
      rSpiRData <= wMRData    ;
  end
end


endmodule
