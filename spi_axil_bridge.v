`timescale 1ns / 1ps


module spi_axil_bridge # (
  parameter integer C_M_AXI_ADDR_WIDTH  = 32  ,
  parameter integer C_M_AXI_DATA_WIDTH  = 32
)(
// SPI
    input  wire                         sen                        ,
    input  wire                         sclk                       ,
    input  wire                         sdi                        ,
    output wire                         sdo                        ,
// M00_AXI
    input  wire                         M00_AXI_ACLK               ,
    input  wire                         M00_AXI_ARESETN            ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M00_AXI_AWADDR    ,
    output wire        [   2:0]         M00_AXI_AWPROT             ,
    output wire                         M00_AXI_AWVALID            ,
    input  wire                         M00_AXI_AWREADY            ,
    output wire        [C_M_AXI_DATA_WIDTH-1 : 0]M00_AXI_WDATA     ,
    output wire        [C_M_AXI_DATA_WIDTH/8-1 : 0]M00_AXI_WSTRB   ,
    output wire                         M00_AXI_WVALID             ,
    input  wire                         M00_AXI_WREADY             ,
    input  wire        [   1:0]         M00_AXI_BRESP              ,
    input  wire                         M00_AXI_BVALID             ,
    output wire                         M00_AXI_BREADY             ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M00_AXI_ARADDR    ,
    output wire        [   2:0]         M00_AXI_ARPROT             ,
    output wire                         M00_AXI_ARVALID            ,
    input  wire                         M00_AXI_ARREADY            ,
    input  wire        [C_M_AXI_DATA_WIDTH-1 : 0]M00_AXI_RDATA     ,
    input  wire        [   1:0]         M00_AXI_RRESP              ,
    input  wire                         M00_AXI_RVALID             ,
    output wire                         M00_AXI_RREADY             ,
// M01_AXI
    input  wire                         M01_AXI_ACLK               ,
    input  wire                         M01_AXI_ARESETN            ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M01_AXI_AWADDR    ,
    output wire        [   2:0]         M01_AXI_AWPROT             ,
    output wire                         M01_AXI_AWVALID            ,
    input  wire                         M01_AXI_AWREADY            ,
    output wire        [C_M_AXI_DATA_WIDTH-1 : 0]M01_AXI_WDATA     ,
    output wire        [C_M_AXI_DATA_WIDTH/8-1 : 0]M01_AXI_WSTRB   ,
    output wire                         M01_AXI_WVALID             ,
    input  wire                         M01_AXI_WREADY             ,
    input  wire        [   1:0]         M01_AXI_BRESP              ,
    input  wire                         M01_AXI_BVALID             ,
    output wire                         M01_AXI_BREADY             ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M01_AXI_ARADDR    ,
    output wire        [   2:0]         M01_AXI_ARPROT             ,
    output wire                         M01_AXI_ARVALID            ,
    input  wire                         M01_AXI_ARREADY            ,
    input  wire        [C_M_AXI_DATA_WIDTH-1 : 0]M01_AXI_RDATA     ,
    input  wire        [   1:0]         M01_AXI_RRESP              ,
    input  wire                         M01_AXI_RVALID             ,
    output wire                         M01_AXI_RREADY             ,
// M02_AXI
    input  wire                         M02_AXI_ACLK               ,
    input  wire                         M02_AXI_ARESETN            ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M02_AXI_AWADDR    ,
    output wire        [   2:0]         M02_AXI_AWPROT             ,
    output wire                         M02_AXI_AWVALID            ,
    input  wire                         M02_AXI_AWREADY            ,
    output wire        [C_M_AXI_DATA_WIDTH-1 : 0]M02_AXI_WDATA     ,
    output wire        [C_M_AXI_DATA_WIDTH/8-1 : 0]M02_AXI_WSTRB   ,
    output wire                         M02_AXI_WVALID             ,
    input  wire                         M02_AXI_WREADY             ,
    input  wire        [   1:0]         M02_AXI_BRESP              ,
    input  wire                         M02_AXI_BVALID             ,
    output wire                         M02_AXI_BREADY             ,
    output wire        [C_M_AXI_ADDR_WIDTH-1 : 0]M02_AXI_ARADDR    ,
    output wire        [   2:0]         M02_AXI_ARPROT             ,
    output wire                         M02_AXI_ARVALID            ,
    input  wire                         M02_AXI_ARREADY            ,
    input  wire        [C_M_AXI_DATA_WIDTH-1 : 0]M02_AXI_RDATA     ,
    input  wire        [   1:0]         M02_AXI_RRESP              ,
    input  wire                         M02_AXI_RVALID             ,
    output wire                         M02_AXI_RREADY              
);

wire                                    M00_INIT_WRITE             ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M00_W_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M00_W_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M00_W_DATA                 ;
wire                                    M00_W_RESP                 ;
wire                                    M00_INIT_READ              ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M00_R_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M00_R_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M00_R_DATA                 ;
wire                                    M00_R_RESP                 ;

wire                                    M01_INIT_WRITE             ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M01_W_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M01_W_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M01_W_DATA                 ;
wire                                    M01_W_RESP                 ;
wire                                    M01_INIT_READ              ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M01_R_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M01_R_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M01_R_DATA                 ;
wire                                    M01_R_RESP                 ;

wire                                    M02_INIT_WRITE             ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M02_W_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M02_W_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M02_W_DATA                 ;
wire                                    M02_W_RESP                 ;
wire                                    M02_INIT_READ              ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M02_R_BASE_ADDR            ;
wire        [C_M_AXI_ADDR_WIDTH-1 : 0]  M02_R_OFFT_ADDR            ;
wire        [C_M_AXI_DATA_WIDTH-1 : 0]  M02_R_DATA                 ;
wire                                    M02_R_RESP                 ;



spi_slave #(
    .C_M_AXI_ADDR_WIDTH                (C_M_AXI_ADDR_WIDTH        ),
    .C_M_AXI_DATA_WIDTH                (C_M_AXI_DATA_WIDTH        ) 
) spi_slave_inst (
// MCU SPI Interface
    .sen                               (sen                       ),
    .sclk                              (sclk                      ),
    .sdi                               (sdi                       ),
    .sdo                               (sdo                       ),

    .clk                               (M00_AXI_ACLK              ),
    .rst_n                             (M00_AXI_ARESETN           ),
// M00_AXI
    .M00_INIT_WRITE                    (M00_INIT_WRITE            ),
    .M00_W_BASE_ADDR                   (M00_W_BASE_ADDR           ),
    .M00_W_OFFT_ADDR                   (M00_W_OFFT_ADDR           ),
    .M00_W_DATA                        (M00_W_DATA                ),
    .M00_W_RESP                        (M00_W_RESP                ),
    .M00_INIT_READ                     (M00_INIT_READ             ),
    .M00_R_BASE_ADDR                   (M00_R_BASE_ADDR           ),
    .M00_R_OFFT_ADDR                   (M00_R_OFFT_ADDR           ),
    .M00_R_DATA                        (M00_R_DATA                ),
    .M00_R_RESP                        (M00_R_RESP                ),
// M01_AXI
    .M01_INIT_WRITE                    (M01_INIT_WRITE            ),
    .M01_W_BASE_ADDR                   (M01_W_BASE_ADDR           ),
    .M01_W_OFFT_ADDR                   (M01_W_OFFT_ADDR           ),
    .M01_W_DATA                        (M01_W_DATA                ),
    .M01_W_RESP                        (M01_W_RESP                ),
    .M01_INIT_READ                     (M01_INIT_READ             ),
    .M01_R_BASE_ADDR                   (M01_R_BASE_ADDR           ),
    .M01_R_OFFT_ADDR                   (M01_R_OFFT_ADDR           ),
    .M01_R_DATA                        (M01_R_DATA                ),
    .M01_R_RESP                        (M01_R_RESP                ),
// M02_AXI
    .M02_INIT_WRITE                    (M02_INIT_WRITE            ),
    .M02_W_BASE_ADDR                   (M02_W_BASE_ADDR           ),
    .M02_W_OFFT_ADDR                   (M02_W_OFFT_ADDR           ),
    .M02_W_DATA                        (M02_W_DATA                ),
    .M02_W_RESP                        (M02_W_RESP                ),
    .M02_INIT_READ                     (M02_INIT_READ             ),
    .M02_R_BASE_ADDR                   (M02_R_BASE_ADDR           ),
    .M02_R_OFFT_ADDR                   (M02_R_OFFT_ADDR           ),
    .M02_R_DATA                        (M02_R_DATA                ),
    .M02_R_RESP                        (M02_R_RESP                ) 
);


axil_master #(
    .C_M_AXI_ADDR_WIDTH                (C_M_AXI_ADDR_WIDTH        ),
    .C_M_AXI_DATA_WIDTH                (C_M_AXI_DATA_WIDTH        ) 
) axil_master_inst_0 (
    .INIT_WRITE                        (M00_INIT_WRITE            ),
    .W_BASE_ADDR                       (M00_W_BASE_ADDR           ),
    .W_OFFT_ADDR                       (M00_W_OFFT_ADDR           ),
    .W_DATA                            (M00_W_DATA                ),
    .W_RESP                            (M00_W_RESP                ),
    .INIT_READ                         (M00_INIT_READ             ),
    .R_BASE_ADDR                       (M00_R_BASE_ADDR           ),
    .R_OFFT_ADDR                       (M00_R_OFFT_ADDR           ),
    .R_DATA                            (M00_R_DATA                ),
    .R_RESP                            (M00_R_RESP                ),

    .M_AXI_ACLK                        (M00_AXI_ACLK              ),
    .M_AXI_ARESETN                     (M00_AXI_ARESETN           ),
    .M_AXI_AWADDR                      (M00_AXI_AWADDR            ),
    .M_AXI_AWPROT                      (M00_AXI_AWPROT            ),
    .M_AXI_AWVALID                     (M00_AXI_AWVALID           ),
    .M_AXI_AWREADY                     (M00_AXI_AWREADY           ),
    .M_AXI_WDATA                       (M00_AXI_WDATA             ),
    .M_AXI_WSTRB                       (M00_AXI_WSTRB             ),
    .M_AXI_WVALID                      (M00_AXI_WVALID            ),
    .M_AXI_WREADY                      (M00_AXI_WREADY            ),
    .M_AXI_BRESP                       (M00_AXI_BRESP             ),
    .M_AXI_BVALID                      (M00_AXI_BVALID            ),
    .M_AXI_BREADY                      (M00_AXI_BREADY            ),
    .M_AXI_ARADDR                      (M00_AXI_ARADDR            ),
    .M_AXI_ARPROT                      (M00_AXI_ARPROT            ),
    .M_AXI_ARVALID                     (M00_AXI_ARVALID           ),
    .M_AXI_ARREADY                     (M00_AXI_ARREADY           ),
    .M_AXI_RDATA                       (M00_AXI_RDATA             ),
    .M_AXI_RRESP                       (M00_AXI_RRESP             ),
    .M_AXI_RVALID                      (M00_AXI_RVALID            ),
    .M_AXI_RREADY                      (M00_AXI_RREADY            ) 
);


axil_master #(
    .C_M_AXI_ADDR_WIDTH                (C_M_AXI_ADDR_WIDTH        ),
    .C_M_AXI_DATA_WIDTH                (C_M_AXI_DATA_WIDTH        ) 
) axil_master_inst_1 (
    .INIT_WRITE                        (M01_INIT_WRITE            ),
    .W_BASE_ADDR                       (M01_W_BASE_ADDR           ),
    .W_OFFT_ADDR                       (M01_W_OFFT_ADDR           ),
    .W_DATA                            (M01_W_DATA                ),
    .W_RESP                            (M01_W_RESP                ),
    .INIT_READ                         (M01_INIT_READ             ),
    .R_BASE_ADDR                       (M01_R_BASE_ADDR           ),
    .R_OFFT_ADDR                       (M01_R_OFFT_ADDR           ),
    .R_DATA                            (M01_R_DATA                ),
    .R_RESP                            (M01_R_RESP                ),

    .M_AXI_ACLK                        (M01_AXI_ACLK              ),
    .M_AXI_ARESETN                     (M01_AXI_ARESETN           ),
    .M_AXI_AWADDR                      (M01_AXI_AWADDR            ),
    .M_AXI_AWPROT                      (M01_AXI_AWPROT            ),
    .M_AXI_AWVALID                     (M01_AXI_AWVALID           ),
    .M_AXI_AWREADY                     (M01_AXI_AWREADY           ),
    .M_AXI_WDATA                       (M01_AXI_WDATA             ),
    .M_AXI_WSTRB                       (M01_AXI_WSTRB             ),
    .M_AXI_WVALID                      (M01_AXI_WVALID            ),
    .M_AXI_WREADY                      (M01_AXI_WREADY            ),
    .M_AXI_BRESP                       (M01_AXI_BRESP             ),
    .M_AXI_BVALID                      (M01_AXI_BVALID            ),
    .M_AXI_BREADY                      (M01_AXI_BREADY            ),
    .M_AXI_ARADDR                      (M01_AXI_ARADDR            ),
    .M_AXI_ARPROT                      (M01_AXI_ARPROT            ),
    .M_AXI_ARVALID                     (M01_AXI_ARVALID           ),
    .M_AXI_ARREADY                     (M01_AXI_ARREADY           ),
    .M_AXI_RDATA                       (M01_AXI_RDATA             ),
    .M_AXI_RRESP                       (M01_AXI_RRESP             ),
    .M_AXI_RVALID                      (M01_AXI_RVALID            ),
    .M_AXI_RREADY                      (M01_AXI_RREADY            ) 
);


axil_master #(
    .C_M_AXI_ADDR_WIDTH                (C_M_AXI_ADDR_WIDTH        ),
    .C_M_AXI_DATA_WIDTH                (C_M_AXI_DATA_WIDTH        ) 
) axil_master_inst_2 (
    .INIT_WRITE                        (M02_INIT_WRITE            ),
    .W_BASE_ADDR                       (M02_W_BASE_ADDR           ),
    .W_OFFT_ADDR                       (M02_W_OFFT_ADDR           ),
    .W_DATA                            (M02_W_DATA                ),
    .W_RESP                            (M02_W_RESP                ),
    .INIT_READ                         (M02_INIT_READ             ),
    .R_BASE_ADDR                       (M02_R_BASE_ADDR           ),
    .R_OFFT_ADDR                       (M02_R_OFFT_ADDR           ),
    .R_DATA                            (M02_R_DATA                ),
    .R_RESP                            (M02_R_RESP                ),

    .M_AXI_ACLK                        (M02_AXI_ACLK              ),
    .M_AXI_ARESETN                     (M02_AXI_ARESETN           ),
    .M_AXI_AWADDR                      (M02_AXI_AWADDR            ),
    .M_AXI_AWPROT                      (M02_AXI_AWPROT            ),
    .M_AXI_AWVALID                     (M02_AXI_AWVALID           ),
    .M_AXI_AWREADY                     (M02_AXI_AWREADY           ),
    .M_AXI_WDATA                       (M02_AXI_WDATA             ),
    .M_AXI_WSTRB                       (M02_AXI_WSTRB             ),
    .M_AXI_WVALID                      (M02_AXI_WVALID            ),
    .M_AXI_WREADY                      (M02_AXI_WREADY            ),
    .M_AXI_BRESP                       (M02_AXI_BRESP             ),
    .M_AXI_BVALID                      (M02_AXI_BVALID            ),
    .M_AXI_BREADY                      (M02_AXI_BREADY            ),
    .M_AXI_ARADDR                      (M02_AXI_ARADDR            ),
    .M_AXI_ARPROT                      (M02_AXI_ARPROT            ),
    .M_AXI_ARVALID                     (M02_AXI_ARVALID           ),
    .M_AXI_ARREADY                     (M02_AXI_ARREADY           ),
    .M_AXI_RDATA                       (M02_AXI_RDATA             ),
    .M_AXI_RRESP                       (M02_AXI_RRESP             ),
    .M_AXI_RVALID                      (M02_AXI_RVALID            ),
    .M_AXI_RREADY                      (M02_AXI_RREADY            ) 
);



endmodule
