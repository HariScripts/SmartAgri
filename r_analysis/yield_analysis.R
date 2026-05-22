# yield_analysis.R
library(ggplot2)
library(dplyr)

generate_yield_pie_chart <- function(crop_history, farm_name) {
  p <- ggplot(crop_history, aes(x="", y=yield_percentage, fill=crop_name)) +
    geom_bar(stat="identity", width=1, color="white") +
    coord_polar("y", start=0) +
    scale_fill_brewer(palette="Greens") +
    theme_void() +
    theme(
      plot.background = element_rect(fill="white", color=NA),
      plot.title = element_text(face="bold", hjust=0.5, size=16),
      legend.title = element_blank()
    ) +
    labs(title="Yield Distribution by Crop")
    
  output_path <- paste0("output/yield_pie_", gsub(" ", "_", farm_name), ".png")
  ggsave(output_path, plot=p, width=7, height=7, dpi=300)
  return(output_path)
}

generate_yield_bar_chart <- function(crop_history, farm_name) {
  # Highlight the highest yield
  max_yield <- max(crop_history$yield_percentage)
  crop_history$highlight <- ifelse(crop_history$yield_percentage == max_yield, "Highest", "Normal")
  
  p <- ggplot(crop_history, aes(x=reorder(crop_name, -yield_percentage), y=yield_percentage, fill=highlight)) +
    geom_bar(stat="identity") +
    scale_fill_manual(values=c("Highest"="#FF8F00", "Normal"="#4CAF50")) +
    geom_text(aes(label=paste0(yield_percentage, "%")), vjust=-0.5) +
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="white", color=NA),
      plot.title = element_text(face="bold", size=16),
      legend.position = "none"
    ) +
    labs(
      title = "Crop Yield Comparison",
      x = "Crop",
      y = "Yield Percentage"
    )
    
  output_path <- paste0("output/yield_bar_", gsub(" ", "_", farm_name), ".png")
  ggsave(output_path, plot=p, width=8, height=6, dpi=300)
  return(output_path)
}
