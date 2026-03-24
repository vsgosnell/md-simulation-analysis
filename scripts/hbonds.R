library(ggplot2)
library(readr)
library(dplyr)

# Example dataset (included)
hb_files <- list(
	"Example Complex" = "data/hbonds.csv"
)

hb_data <- bind_rows(
  lapply(names(hb_files), function(label) {
    file <- hb_files[[label]]
    
    # Read, skipping header
    df <- tryCatch({
      read_csv(file, skip = 1, col_names = c("Time_ps", "HBonds"), show_col_types = FALSE)
    }, error = function(e) {
      read_table(file, skip = 1, col_names = c("Time_ps", "HBonds"))
    })
    
    df$Run <- label
    df
  })
)



hb_data <- hb_data %>%
  mutate(Time_ns = Time_ps / 1000)



p <- ggplot(hb_data, aes(x = Time_ns, y = HBonds)) +
  geom_line(alpha = 0.2, linewidth = 0.6, color = "purple") +
  geom_smooth(se = FALSE, method = "loess", linewidth = 1.3, color = "purple") +
  labs(
    x = "Time (ns)",
    y = "Number of Intramolecular H-bonds"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "none"
  )

ggsave("plots/hbond_example_plot.png", plot = p, width = 6, height = 4, dpi = 300)
