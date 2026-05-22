# disease_risk_viz.R
library(ggplot2)

generate_disease_risk_chart <- function(crop_name, disease_data) {
  # disease_data should be a data frame with columns: disease_name, risk_percentage
  
  # Add color mapping logic
  disease_data$color_group <- ifelse(disease_data$risk_percentage > 60, "High Risk",
                                     ifelse(disease_data$risk_percentage > 30, "Medium Risk", "Low Risk"))
  
  p <- ggplot(disease_data, aes(x = reorder(disease_name, risk_percentage), y = risk_percentage, fill = color_group)) +
    geom_bar(stat="identity") +
    coord_flip() +
    geom_text(aes(label=paste0(round(risk_percentage, 1), "%")), hjust=-0.2, size=3.5) +
    scale_fill_manual(values=c("High Risk"="red", "Medium Risk"="#FF8F00", "Low Risk"="#4CAF50")) +
    scale_y_continuous(limits=c(0, 110)) + # leave space for labels
    theme_minimal() +
    theme(
      plot.background = element_rect(fill="white", color=NA),
      legend.position = "bottom",
      plot.title = element_text(face="bold", size=14)
    ) +
    labs(
      title = paste("Disease Risk Analysis —", crop_name),
      x = "",
      y = "Risk Percentage",
      fill = "Risk Level"
    )
  
  output_path <- paste0("output/disease_risk_", gsub(" ", "_", crop_name), ".png")
  ggsave(output_path, plot=p, width=8, height=5, dpi=300)
  return(output_path)
}
