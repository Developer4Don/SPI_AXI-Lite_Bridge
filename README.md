# SPI_AXI-Lite
This repository is done with a SPI Slave interface and AXI-Lite Master interface. The protocol of SPI is obey to the following:
```
struct prtocol {
  index[6:0];
  r/w_command[0];
  address[31:0];
  data[31:0];
};
```
