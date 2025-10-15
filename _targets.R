## Load your packages, e.g. library(targets).
source("./packages.R")
## Load your R files
tar_source()
# facilitate this working in parallel
controller <- crew_controller_local(
  name = "my_controller",
  workers = max(c(1L, parallelly::availableCores()-4)),
  seconds_idle = 3
)

tar_option_set(
  controller = controller
)
targets <-tar_map(
  values = tidyr::expand_grid(
       data_source = c("atm_flux_diag", "ice_force", "ocean_eta_t", "ocean_force",
                  "ocean_mld", "ocean_salt", "ocean_temp", "ocean_tx_trans_int_z",
                  "ocean_ty_trans_int_z", "ocean_u", "ocean_v", "ocean_w")[1:3],
              time_chunk = c("annual", "daily", "month")[1]),

  tar_target(regexp, create_regexp(time_chunk, data_source)),
  tar_target(files, bran_files("/g/data/gb6/BRAN/BRAN2023") |> filter(str_detect(url, regexp))),
  tar_target(url_netcdf, files$url),
  tar_target(dillbytes, vfun(url_netcdf), pattern = map(url_netcdf))
)


