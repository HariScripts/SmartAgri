# crop_health_viz.R
library(ggplot2)
library(dplyr)
library(scales)
library(lubridate)

generate_health_chart <- function(health_data, crop_name, farm_name) {
  # Add Day index for plotting
  health_data$Day <- 1:nrow(health_data)
  
  p <- ggplot(health_data, aes(x = Day, y = health_percentage)) +
    geom_ribbon(aes(ymin=0, ymax=health_percentage), fill="#4CAF50", alpha=0.2) +
    geom_line(color="#4CAF50", size=1.2) +
    geom_hline(aes(yintercept=70, linetype="Healthy threshold"), color="#FF8F00") +
    geom_hline(aes(yintercept=40, linetype="Critical threshold"), color="red") +
    scale_linetype_manual(name="Thresholds", values=c("Healthy threshold"=2, "Critical threshold"=2)) +
    scale_y_continuous(limits=c(0, 100), breaks=seq(0, 100, 25), labels=function(x) paste0(x, "%")) +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="white", color=NA),
      panel.background = element_rect(fill="white", color=NA),
      plot.title = element_text(face="bold", size=16),
      plot.subtitle = element_text(color="gray50", size=12)
    ) +
    labs(
      title = paste("Crop Health History —", crop_name),
      subtitle = farm_name,
      x = "Days",
      y = "Health Percentage"
    )
  
  output_path <- paste0("output/health_chart_", gsub(" ", "_", crop_name), "_", gsub(" ", "_", farm_name), ".png")
  ggsave(output_path, plot=p, width=10, height=6, dpi=300)
  return(output_path)
}
