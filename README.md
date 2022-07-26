
# updateSraTable

<!-- badges: start -->
<!-- badges: end -->

The goal of updateSraTable is to update table

## Installation

You can install the development version of updateSraTable like so:

``` r
# FILL THIS IN! HOW CAN PEOPLE INSTALL YOUR DEV PACKAGE?
devtools::install_github("xiayh17/updateSraTable")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(updateSraTable)
## basic example code
update_download_state(
cells_table = "version3/WGS_metadata.cells_v3.txt",
accessions_table = "version3/WGS_metadata.accessions_v3.txt",
check_vdb = "H:/xiayonghe/check_vdb_mini.log",
datasetid = "SRA056303",
data_location_dir = "/storage/douyanmeiLab/dingyihang/SRA056303/"
)
```

