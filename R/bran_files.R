bran_files <- function(root = "") {
  ## ignore root we don't need for the online version
  if (nzchar(root)) {
    tibble(url = dir_ls(root, regexp = ".*nc$", recurse = TRUE))
  } else {
    read_parquet("https://github.com/mdsumner/dryrun/releases/download/latest/BRAN-netcdf-2023-netcdf.parquet")
  }
}
