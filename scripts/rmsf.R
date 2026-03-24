library(ggplot2)
library(readr)
library(dplyr)
library(patchwork)

# Example dataset (included)
rmsf_files <- list(
  "Example Receptor" = "data/rmsf_receptor.csv",
  "Example Vaccine"  = "data/rmsf_vaccine.csv"
)

# Read and prepare
rmsf_data <- bind_rows(
  lapply(names(rmsf_files), function(label) {
    df <- read_csv(
      rmsf_files[[label]],
      col_names = c("Residue", "RMSF_nm"),
      show_col_types = FALSE
    ) %>%
      mutate(
        Residue = row_number(),
        RMSF_A = RMSF_nm * 10,
        Run = label
      )
  })
)

# Split datasets
vaccine_data  <- filter(rmsf_data, Run == "Example Vaccine")
receptor_data <- filter(rmsf_data, Run == "Example Receptor")

# Plot 1: Vaccine
p1 <- ggplot(vaccine_data, aes(x = Residue, y = RMSF_A)) +
  geom_line(color = "firebrick", linewidth = 0.9) +
  scale_y_continuous(
    limits = c(0, max(vaccine_data$RMSF_A, na.rm = TRUE) + 1),
    breaks = seq(0, ceiling(max(vaccine_data$RMSF_A)), by = 2)
  ) +
  labs(
    x = "Residue",
    y = "RMSF (Å)",
    title = "Example Vaccine"
  ) +
  theme_classic(base_size = 16) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

# Plot 2: Receptor
p2 <- ggplot(receptor_data, aes(x = Residue, y = RMSF_A)) +
  geom_line(color = "green", linewidth = 0.9) +
  scale_y_continuous(
    limits = c(0, max(receptor_data$RMSF_A, na.rm = TRUE) + 1),
    breaks = seq(0, ceiling(max(receptor_data$RMSF_A)), by = 2)
  ) +
  labs(
    x = "Residue",
    y = "RMSF (Å)",
    title = "Example Receptor"
  ) +
  theme_classic(base_size = 16) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold")
  )

# Combine plots
p <- p1 / p2

# Save
ggsave("plots/rmsf_example_plot.png", plot = p, width = 6, height = 8, dpi = 300)
