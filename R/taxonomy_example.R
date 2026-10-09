# # library(dplyr)
# library(tidyverse)
# library(patchwork)
# # library(MultiFactor)
#
# traits_df <- list(
#     Movement   = c("🐾" = "Ground", "🪶" = "Flight", "🌊" = "Aquatic"),
#     Diet       = c("🍖" = "Meat", "🌱" = "Plants", "👾" = "Misc"),
#     Strategy   = c("🏹"  = "Hunting", "🧺" =  "Foraging"),
#     Behaviour  = c("👤" = "Solitary", "👥" = "Group")
# ) %>%
#     stack() %>%
#     mutate(emoji = row.names(.)) %>%
#     `colnames<-`(c("trait.value", "trait.name", "emoji"))
#
#
# taxonomy_plot_df <- list(
#
#     Canid = c("🐶" = "dog", "🦊" = "fox",  "🐺" = "wolf"),
#
#     Felid = c("🐱" = "cat", "🐯" = "tiger", "🦁" = "lion"),
#
#     Mammal = c("🦇" = "bat", "🐋" = "whale"),
#
#     Bird = c("🦆" = "duck", "🐓" = "chicken", "🦉" = "owl"),
#
#     Fish = c("🐟" = "mackerel", "🦈" = "shark"),
#     Arthropod = c("🐜" = "ant", "🐝" = "bee", "🕷️" = "spider", "🦀" = "crab")
# ) %>%  stack() %>%
#     `colnames<-`(c("Species", "lv_3_Clade")) %>%
#     mutate(
#         Species = factor(Species, levels = unique(Species)),
#         lv_2_Class = rep(
#             c("Mammal", "Bird", "Fish", "Arthropod"), c(8, 3, 2, 4)
#         ),
#         emoji = row.names(.)
#     ) %>%
#
#     left_join(
#         list(
#             Vertebrate = c("Mammal", "Bird", "Fish"),
#             Invertebrate = c("Arthropod")
#         ) %>%
#             stack() %>%
#             `colnames<-`(c("lv_2_Class", "lv_1_Subphylum"))
#     ) %>%
#     dplyr::select(lv_1_Subphylum, lv_2_Class, lv_3_Clade, Species, emoji) %>%
#     mutate(lv_3_Clade = if_else(lv_3_Clade == lv_2_Class, NA, lv_3_Clade))
#
# taxonomy_df <- taxonomy_plot_df %>%
#     pivot_longer(!c(Species, emoji)) %>%
#     dplyr::select(Species, value, name, emoji)
#
#
#
# species2traits <- tidyr::expand_grid(Species = taxonomy_plot_df$Species, traits_df) %>%
#     filter(
#         !(trait.value == "Flight"    & !Species %in% c("bat", "bee", "duck", "owl")),
#         !(trait.value == "Aquatic"  & !Species %in% c("whale", "duck", "mackerel", "shark", "crab")),
#         !(trait.value == "Ground"  & Species %in% c("bat", "whale", "owl", "mackerel", "shark", "crab", "bee")),
#
#         !(trait.value == "Misc"  & !Species %in% c("fox", "dog", "cat", "bat", "whale", "mackerel",  "ant", "crab")),
#         !(trait.value == "Plants"  & !Species %in% c("fox", "dog", "bat", "duck", "chicken", "ant", "bee", "crab")),
#         !(trait.value == "Meat"  & Species %in% c("whale", "duck", "chicken", "ant", "bee", "crab")),
#
#         !(trait.value == "Hunting"   & Species %in% c("whale", "duck", "chicken", "ant", "bee", "crab")),
#         !(trait.value == "Foraging"  & !Species %in% c("fox", "whale", "duck", "chicken", "ant", "bee", "crab")),
#
#         !(trait.value == "Group" & !Species %in% c("dog", "wolf", "lion", "whale", "bat", "chicken", "duck", "mackerel", "ant", "bee")),
#         !(trait.value == "Solitary" & Species %in% c("dog", "wolf", "lion", "whale", "bat", "chicken", "duck", "mackerel", "ant", "bee"))
#     )
#
#
#
# plot_df <- species2traits %>%
#     right_join(taxonomy_plot_df, by = "Species", suffix = c(".trait", ".species")) %>%
#
#     mutate(
#         y = as.integer(factor(Species)), .by = c(lv_2_Class, lv_3_Clade)
#     ) %>%
#     mutate(
#         y = if_else(
#             lv_2_Class == "Mammal" & !is.na(lv_3_Clade),
#             y + 2.3 + 3.3 * (as.integer(factor(lv_3_Clade)) -1),
#             y
#         )
#     ) %>%
#     mutate(
#         lv_2_Class = factor(lv_2_Class, levels = c("Mammal", "Bird", "Fish", "Arthropod"))
#     )
#
#
# plot_left <-
#
#     plot_df %>%
#
#     ggplot() +
#     aes(y = y) +
#     geom_label(
#         aes(label = emoji.species),
#         x = 25/100, size = 6) +
#     geom_text(
#         aes(label = Species),
#         x = 50/100, hjust = 0,
#     ) +
#     scale_y_continuous(expand = expansion(add = 1/2)) +
#
#     ggh4x::facet_nested(
#         lv_1_Subphylum + lv_2_Class ~ "Species" ,
#         scales = "free", switch = "y", space = "free", shrink = TRUE
#     ) +
#     labs(x = NULL, y = NULL) +
#
#     theme_bw() +
#     theme(
#         strip.text.y.left = element_text(angle = 0L),
#         axis.text.y.left = element_blank(),
#         axis.ticks.y.left = element_blank(),
#         panel.grid = element_blank()
#     )
#
#
#
# plot_right  <- plot_df %>%
#     mutate(
#         trait_x = as.integer(factor(trait.value)),
#         .by = c(Species, trait.name)
#     ) %>%
#
#     ggplot() +
#     aes(y = y) +
#     geom_label(
#         aes(label = emoji.trait, x = trait.value),
#         size = 6) +
#     scale_y_continuous(expand = expansion(add = 1/2)) +
#
#     ggh4x::facet_nested(
#         lv_1_Subphylum + lv_2_Class ~ trait.name ,
#         scales = "free", switch = "y", space = "free", shrink = TRUE
#     ) +
#     labs(x = NULL, y = NULL) +
#
#     theme_bw() +
#     theme(
#         strip.background.y = element_blank(),
#         strip.text.y.left = element_blank(),
#         axis.text.y.left = element_blank(),
#         axis.ticks.y.left = element_blank(),
#         panel.grid = element_blank()
#     )
#
#
#
#
#
# plot_left + plot_right +
#     plot_layout(ncol = 2L, widths = c(1, 5)) &
#     theme(text = element_text(size = 12))
#
#
#
# traits <- MultiFactor::MultiFactor(
#     tapply(
#         species2traits, ~trait.name,
#         function(x) {
#             colnames(x)[2] <- unique(as.character(x$trait.name))
#             x$trait.name <- NULL
#             MultiFactor::as.LinkMap(x)
#         }
#     )
# )
#
#
# taxonomy <- MultiFactor::MultiFactor(
#     tapply(
#         taxonomy_df, ~name,
#
#         function(x) {
#             colnames(x)[2] <- unique(as.character(x$name))
#             x <- x[!is.na(x[[2L]]), ]
#             x$name <- NULL
#             MultiFactor::as.LinkMap(x)
#         }
#     )
# )
#
#
# complex_traits <-  MultiFactor::MultiFactor(
#     MultiFactor::LinkMap(
#         data.frame(
#             Diet  = c("Meat", "Misc", "Plants"),
#             Trait = c("Omnivore")
#         )
#     )
# )
#
#
# # animal_traits <- c(traits, complex_traits)
# # animal_groups <- taxonomy
# #
# # save(animal_traits, animal_groups, file = "data/animals.rda")
#
#
#
#
# # Use stack() to add together traits from multiple categories!
#
# weave_coverage(x, Species ~ Trait)
#
