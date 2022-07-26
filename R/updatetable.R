#' Update data info of SRA summary tables
#'
#' @param cells_table cells_table path
#' @param accessions_table accessions_table path
#' @param check_vdb result from vdb-validate
#' @param datasetid a datasetid
#' @param data_location_dir location of data,end by '/'
#'
#' @return
#' a updated table
#' @export
#'
#' @import dplyr
#' @importFrom readr read_delim read_csv
#' @importFrom utils write.table
#'
#' @examples
#' \dontrun{
#' update_download_state(
#' cells_table = "version3/WGS_metadata.cells_v3.txt",
#' accessions_table = "version3/WGS_metadata.accessions_v3.txt",
#' check_vdb = "H:/xiayonghe/check_vdb_mini.log",
#' datasetid = "SRA056303",
#' data_location_dir = "/storage/douyanmeiLab/dingyihang/SRA056303/"
#' )
#' }
update_download_state <- function(
    cells_table = "version3/WGS_metadata.cells_v3.txt",
    accessions_table = "version3/WGS_metadata.accessions_v3.txt",
    check_vdb,
    datasetid,
    data_location_dir
) {

  # import data -----------------------------------------------------------
  ## update download state no done name
  WGS_metadata.accessions_v3 <- read_delim(cells_table,
                                           delim = "\t", escape_double = FALSE,
                                           trim_ws = TRUE)
  ##
  WGS_metadata_cells_v3 <- read_delim(accessions_table,
                                      delim = "\t", escape_double = FALSE,
                                      trim_ws = TRUE)
  ## import check info
  check_vdb <- read_csv(check_vdb,
                        col_names = FALSE, skip = 1)

  # filter_data -------------------------------------------------------------
  # parse check data
  check_vdb_consistent <- check_vdb[grepl("consistent",check_vdb$X1),]
  parttern_id = "(?<=').*(?=')"
  m_id = regexpr(parttern_id,check_vdb_consistent$X1,perl = TRUE)
  check_vdb_consistent$filename <- regmatches(check_vdb_consistent$X1,m_id)
  check_vdb_consistent$runid <- gsub("\\..*","", check_vdb_consistent$filename)
  # filter according to datasetid
  WGS_metadata_cells_v3_pro <- WGS_metadata_cells_v3[WGS_metadata_cells_v3$datasetid == datasetid,]

  # check data --------------------------------------------------------------
  # check downloaded file consistent
  check_index <- WGS_metadata_cells_v3_pro$runid %in% check_vdb_consistent$runid
  if (!all(check_index)) {
    failed_loc <- grep("FALSE",check_index)
    usethis::ui_oops("{paste0(WGS_metadata_cells_v3_pro$runid[failed_loc],collapse = ',')} failed in consistent check.")
  } else {
    usethis::ui_done("Every runid download successed.")
  }

  # update table ------------------------------------------------------------
  check_vdb_consistent$`data location` <-  paste0(data_location_dir,check_vdb_consistent$filename)
  # cells
  cells <-
    WGS_metadata_cells_v3 %>%
    rows_update(select(check_vdb_consistent,runid, `data location`), by = "runid")
  # accessions
  WGS_metadata.accessions_v3[WGS_metadata.accessions_v3$datasetid == datasetid,"download"] = "done"

  # save update
  write.table(cells,file = "version3/WGS_metadata.cells_v3.txt",quote = T,sep = "\t",row.names = FALSE)
  write.table(WGS_metadata.accessions_v3,file = "version3/WGS_metadata.accessions_v3.txt",quote = T,sep = "\t",row.names = FALSE)

}
