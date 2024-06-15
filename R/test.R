
library("dplyr")
library("tidyr")

source("./R/get_hierarchy.R")

sample <- read.csv("./data/sample_data.csv",
                   header = TRUE,
                   stringsAsFactors = FALSE,
                   na.strings = c(""))

hierarchy_data <- sample %>%
  rowwise() %>%
  mutate(hierarchy = list(get_hierarchy(sample, associate))) %>%
  unnest(hierarchy, names_sep = "_")

hierarchy_data <- hierarchy_data %>%
  group_by(associate) %>%
  mutate(max_layer = max(hierarchy_layer)) %>%
  ungroup() %>%
  mutate(hierarchy_layer = max_layer - hierarchy_layer + 1) %>%
  select(-max_layer)

max_layer <- max(hierarchy_data$hierarchy_layer)

hierarchy_data <- hierarchy_data %>%
  pivot_wider(names_from = hierarchy_layer, values_from = hierarchy_manager, names_prefix = "mgr_level_") %>%
  select(associate, title, center, starts_with("mgr_level_")) %>%
  arrange(associate)
