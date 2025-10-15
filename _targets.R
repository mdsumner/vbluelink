## Load your packages, e.g. library(targets).
source("./packages.R")
## Load your R files
tar_source()
# facilitate this working in parallel
controller <- crew_controller_local(
  name = "my_controller",
  workers = 16, #parallelly::availableCores()-1,
  seconds_idle = 3
)

tar_option_set(
  controller = controller
)
## tar_plan supports drake-style targets and also tar_target()
tar_plan(

  files =  read_parquet("https://github.com/mdsumner/dryrun/releases/download/latest/BRAN-netcdf-2023-netcdf.parquet"),
  files0 = files |> dplyr::filter(stringr::str_detect(.data$url, ".*daily.*temp.*\\.nc$")),
  url_netcdf = files0$url,
  tar_target(dillbytes, vfun(url_netcdf), pattern = map(url_netcdf))


)
