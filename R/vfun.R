vfun <- function(x) {
  reticulate::use_python("/workenv/bin/python3")
  virtualizarr <- reticulate::import("virtualizarr")
  dill <- reticulate::import("dill")
  obstore <- reticulate::import("obstore")
  parser <- virtualizarr$parsers$HDFParser()

  # x is insitu or thredds
  thredds <- grepl("thredds", x)
  if (thredds) {
    host <- "https://thredds.nci.org.au"
    store <- obstore$store$from_url(host)
    registry <- virtualizarr$registry$ObjectStoreRegistry(setNames(list(store), host))
  } else {
    prefix <- "/g/data/gb6/BRAN/BRAN2023/daily"
    store <- obstore$store$LocalStore(prefix = prefix)
    registry <- virtualizarr$registry$ObjectStoreRegistry(reticulate::dict("file://" = store))
  }


  alldims <- c("lat", "lon", "nv", "st_edges_ocean", "st_ocean", "sw_edges_ocean",
               "sw_ocean", "Time", "xb", "xt", "xt_ocean", "xu_ocean", "yb",
               "yt", "yt_ocean", "yu_ocean")

  ds <- try(virtualizarr$open_virtual_dataset(x, parser = parser, registry = registry,
                                    loadable_variables = alldims),
             silent = TRUE)
  if (inherits(ds, "try-error")) return(NULL)

  bytes <- dill$dumps(ds)
  blob::blob(as.raw(bytes))
}
