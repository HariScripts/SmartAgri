# ==============================================================
# SmartAgri Crop Analysis — Summary Stats, Correlations & Pair Plots
# ==============================================================

# 1. Load Required Libraries
suppressPackageStartupMessages({
  library(tidyverse)    # Data wrangling & ggplot2
  library(corrplot)     # For correlation heatmaps
  library(RColorBrewer) # For high-end color palettes
})

# Create the output directory if it doesn't exist
dir.create("r_analysis/output", recursive = TRUE, showWarnings = FALSE)

# 2. Load the Dataset
cat("Loading crop recommendation dataset...\n")
crop_data <- read_csv("data/crop/crop_recommendation.csv", show_col_types = FALSE)

# Exclude non-numeric fields for quantitative analysis
numeric_data <- crop_data %>% select(N, P, K, temperature, humidity, moisture, ph, rainfall)

# ==============================================================
# Phase 1: Summary Statistics
# ==============================================================
cat("Calculating summary statistics per crop...\n")

# Calculate statistics GROUPED by each crop type (Answers "what are the features of each crop?")
crop_grouped_stats <- crop_data %>%
  group_by(crop) %>%
  summarise(
    Mean_Nitrogen = round(mean(N), 2), SD_Nitrogen = round(sd(N), 2),
    Mean_Phosphorus = round(mean(P), 2), SD_Phosphorus = round(sd(P), 2),
    Mean_Potassium = round(mean(K), 2), SD_Potassium = round(sd(K), 2),
    Mean_Temperature = round(mean(temperature), 2),
    Mean_Humidity = round(mean(humidity), 2),
    Mean_Moisture = round(mean(moisture), 2),
    Mean_pH = round(mean(ph), 2),
    Mean_Rainfall = round(mean(rainfall), 2),
    .groups = "drop"
  )

# Save summary stats to a CSV file for Excel / Reports
write_csv(crop_grouped_stats, "r_analysis/output/08_crop_summary_statistics.csv")
cat("Saved: r_analysis/output/08_crop_summary_statistics.csv\n")

# ==============================================================
# Phase 2: Correlation Heatmaps
# ==============================================================
cat("Generating correlation matrices...\n")

# A. Feature-to-Feature Correlation (How soil variables relate to each other globally)
feature_cor <- cor(numeric_data)

png("r_analysis/output/09_overall_feature_correlation.png", width = 900, height = 900, res = 150)
corrplot(
  feature_cor,
  method = "color",
  type = "upper",
  order = "hclust",  # Hierarchical clustering groups related features together
  addCoef.col = "black", # Show numeric correlation coefficients (-1 to 1)
  tl.col = "black",
  col = colorRampPalette(c("#3b82f6", "white", "#10b981"))(100), # Sleek modern blue-white-green theme
  title = "Overall Soil & Environmental Feature Correlation",
  mar = c(0, 0, 3, 0)
)
dev.off()
cat("Saved: r_analysis/output/09_overall_feature_correlation.png\n")

# B. Crop-to-Crop Similarity Correlation (How similar are crop profiles?)
# Get the average requirements of each crop, transpose, and correlate
crop_profiles <- crop_data %>%
  group_by(crop) %>%
  summarise(across(c(N, P, K, temperature, humidity, moisture, ph, rainfall), mean), .groups = "drop") %>%
  column_to_rownames("crop")

crop_similarity <- cor(t(crop_profiles)) # Correlate transposed profiles

png("r_analysis/output/10_crop_similarity_correlation.png", width = 1600, height = 1600, res = 150)
corrplot(
  crop_similarity,
  method = "color",
  type = "full",
  order = "hclust",
  tl.col = "black",
  tl.srt = 45,       # Tilt labels at 45 degrees
  tl.cex = 0.55,     # Make text fit all crops
  col = colorRampPalette(c("#ef4444", "white", "#3b82f6"))(100), # Red (low overlap) to Blue (high overlap)
  title = "Crop Requirement Similarity Matrix",
  mar = c(0, 0, 3, 0)
)
dev.off()
cat("Saved: r_analysis/output/10_crop_similarity_correlation.png\n")

# ==============================================================
# Phase 3: Pair Plotting (Scatter Plot Matrix)
# ==============================================================
cat("Generating pair plots...\n")

# Define a set of diverse crops to display on the pairplot to ensure clarity
subset_crops <- c("Rice", "Maize", "Tomato", "Apple", "Watermelon", "Potato")
plot_subset <- crop_data %>% 
  filter(crop %in% subset_crops) %>%
  mutate(crop = as.factor(crop))

# Create subset of continuous variables for the matrix
pairs_df <- plot_subset %>% select(N, K, ph, temperature, rainfall)

png("r_analysis/output/11_crop_pairplot.png", width = 2400, height = 2400, res = 220)

# Generate a high-end color palette matching the subset of crops - modern UI aligned colors
colors <- c(
  "#3B82F6", # Rice (Blue)
  "#F59E0B", # Maize (Amber)
  "#EF4444", # Tomato (Red)
  "#10B981", # Apple (Green)
  "#06B6D4", # Watermelon (Cyan)
  "#8B5CF6"  # Potato (Purple)
)
color_mapping <- colors[as.numeric(plot_subset$crop)]

# Set margins and outer margins (oma: bottom, left, top, right) to allocate right space
par(oma = c(2, 2, 6, 16))

# Use base R pairs() which is robust, high-performance, and guaranteed to work
pairs(
  pairs_df,
  col = alpha(color_mapping, 0.8),
  pch = 19,
  cex = 1.8, # Massive dot size
  main = "Multi-Variable Crop Feature Pair Plot",
  cex.labels = 2.2, # Massive diagonal labels
  font.labels = 2,  # Bold diagonal labels
  cex.main = 2.5    # Massive title
)

# Add an elegant, clear legend in the outer right margin
par(xpd = NA)
legend(
  x = grconvertX(0.85, from = "ndc", to = "user"),
  y = grconvertY(0.5, from = "ndc", to = "user"),
  legend = levels(plot_subset$crop),
  fill = colors,
  border = "white",
  box.col = "white",
  cex = 1.8, # Massive text in legend
  xjust = 0,
  yjust = 0.5
)

dev.off()
cat("Saved: r_analysis/output/11_crop_pairplot.png\n")
cat("\n═══════════════════════════════════════════════════════\n")
cat("  SmartAgri Crop Statistical Analysis Complete!\n")
cat("═══════════════════════════════════════════════════════\n")
