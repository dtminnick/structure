
get_hierarchy <- function(source, associate) {

  hierarchy <- data.frame()

  current_associate <- associate

  layer <- 1

  while(TRUE) {

    mgr <- source %>%
      filter(associate == !!current_associate) %>%
      pull(manager) %>%
      as.character()

    if (length(mgr) == 0 || is.na(mgr) || mgr == "") break

    hierarchy <- rbind(hierarchy, data.frame(associate = associate,
                                             layer = layer,
                                             manager = mgr))

    current_associate <- mgr

    layer <- layer + 1

  }

  return(hierarchy)

}
