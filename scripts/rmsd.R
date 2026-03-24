library(ggplot2)
library(readr)
library(dplyr)

# Example dataset (included)
rmsd_files <- list(
  "Example Complex" = "data/rmsd.csv"
)

# Function to safely read RMSD file
read_rmsd_file <- function(file, label) {
  df <- read_csv(
    file,
    col_names = FALSE,
    skip = 1,
    show_col_types = FALSE
  )
  
  colnames(df) <- c("Time_ps", "RMSD_Ang")
  df$Time_ps <- as.numeric(df$Time_ps)
  df$RMSD_Ang <- as.numeric(df$RMSD_Ang)

  # Auto-detect nm vs Å
  if (max(df$RMSD_Ang, na.rm = TRUE) <= 2) {
    df$RMSD_Ang <- df$RMSD_Ang * 10
  }

  df <- df %>%
    mutate(
      Time_ns = Time_ps / 1000,
      Run = label
    )
  
  return(df)
}

# Read and combine
rmsd_data <- bind_rows(
  lapply(names(rmsd_files), function(label) {
    read_rmsd_file(rmsd_files[[label]], label)
  })
)

# Plot (clean version)
p <- ggplot(rmsd_data, aes(x = Time_ns, y = RMSD_Ang)) +
  geom_line(linewidth = 1, alpha = 0.6, color = "blue") +
  geom_smooth(se = FALSE, linewidth = 1.2, method = "loess", span = 0.15, color = "blue") +
  labs(
    x = "Time (ns)",
    y = "RMSD (Å)"
  ) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "none"
  )

# Save plot
ggsave("plots/rmsd_plot.png", plot = p, width = 6, height = 4, dpi = 300)
