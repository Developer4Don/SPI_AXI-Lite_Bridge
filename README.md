# SPI_AXI-Lite

## Introduction
This repository is done with a SPI Slave interface and an AXI-Lite Master interface. The process between the bridge can be one-shot or continuous. The protocol of SPI is obey to the following structure:
```
struct prtocol {
  index[6:0];
  r/w_command[0];
  address[31:0];
  data[31:0];
};
```

## Documentation

### spi_axil_bridge module
This module is designed for connecting SPI_Slave and AXI4-Lite_Master.

### spi_slave module
This module is designed for SPI Slave protocol. There exist the following tips:
1. It depends on SPI Master's selection to use positive or negatice samples;
2. The read or write command uses one-shot mode by default.

## axil_master module
This module is designed for AXI-Lite4 protocol.
