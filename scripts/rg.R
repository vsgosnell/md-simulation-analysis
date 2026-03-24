library(ggplot2)
library(readr)
library(dplyr)

# Example dataset (included)
rg_files <- list(
  "Example Receptor" = "data/rg_receptor.csv",
  "Example Vaccine"  = "data/rg_vaccine.csv"
)

# Read and combine
rg_data <- bind_rows(
  lapply(names(rg_files), function(label) {
    
    df <- read_csv(
      rg_files[[label]],
      skip = 1,                 # skip "V1"
      col_names = "Rg_A",       # single column
      show_col_types = FALSE
    )
    
    df <- df %>%
      mutate(
        Frame = row_number(),
        Time_ns = Frame * 0.1,   # adjust if your timestep differs
        Rg_nm = Rg_A / 10,       # Å → nm
        Run = label
      )
    
    return(df)
  })
)

# Plot
p <- ggplot() +

  # Vaccine
  geom_line(
    data = filter(rg_data, Run == "Example Vaccine"),
    aes(x = Time_ns, y = Rg_nm),
    color = "firebrick",
    linewidth = 0.8,
    alpha = 0.4
  ) +
  geom_smooth(
    data = filter(rg_data, Run == "Example Vaccine"),
    aes(x = Time_ns, y = Rg_nm),
    method = "gam",
    formula = y ~ s(x, bs = "cs"),
    se = FALSE,
    color = "firebrick",
    linewidth = 1.2
  ) +

  # Receptor
  geom_line(
    data = filter(rg_data, Run == "Example Receptor"),
    aes(x = Time_ns, y = Rg_nm),
    color = "orange",
    linewidth = 0.8,
    alpha = 0.4
  ) +
  geom_smooth(
    data = filter(rg_data, Run == "Example Receptor"),
    aes(x = Time_ns, y = Rg_nm),
    method = "gam",
    formula = y ~ s(x, bs = "cs"),
    se = FALSE,
    color = "orange",
    linewidth = 1.2
  ) +

  # Labels
  annotate(
    "text",
    x = max(rg_data$Time_ns) * 0.8,
    y = max(rg_data$Rg_nm[rg_data$Run == "Example Vaccine"], na.rm = TRUE) + 0.05,
    label = "-Example Vaccine",
    color = "firebrick",
    fontface = "bold",
    size = 5
  ) +
  annotate(
    "text",
    x = max(rg_data$Time_ns) * 0.8,
    y = max(rg_data$Rg_nm[rg_data$Run == "Example Receptor"], na.rm = TRUE) + 0.05,
    label = "-Example Receptor",
    color = "orange",
    fontface = "bold",
    size = 5
  ) +

  labs(
    x = "Time (ns)",
    y = "Radius of Gyration (nm)"
  ) +

  scale_y_continuous(
    limits = c(1.5, 3.5),
    breaks = seq(1.5, 3.5, by = 0.5)
  ) +

  theme_classic(base_size = 16) +
  theme(
    legend.position = "none"
  )

ggsave("plots/rg_plot.png", plot = p, width = 6, height = 4, dpi = 300)
