# data_cleaning.R

clean_sensor_data <- function(df) {
  # Remove rows with NA values
  df_clean <- na.omit(df)
  
  # Outlier removal function using IQR
  remove_outliers <- function(x) {
    qnt <- quantile(x, probs=c(.25, .75), na.rm = TRUE)
    H <- 1.5 * IQR(x, na.rm = TRUE)
    x[x < (qnt[1] - H) | x > (qnt[2] + H)] <- NA
    return(x)
  }
  
  # Apply outlier removal to numeric columns
  numeric_cols <- sapply(df_clean, is.numeric)
  df_clean[numeric_cols] <- lapply(df_clean[numeric_cols], remove_outliers)
  
  # Remove NAs introduced by outlier removal
  df_clean <- na.omit(df_clean)
  
  # Convert timestamp if exists
  if("timestamp" %in% colnames(df_clean)) {
    df_clean$timestamp <- as.POSIXct(df_clean$timestamp)
  }
  
  # Round numeric columns to 2 decimal places
  df_clean[numeric_cols] <- round(df_clean[numeric_cols], 2)
  
  return(df_clean)
}

summarize_sensor_data <- function(df) {
  if(!"timestamp" %in% colnames(df)) return(df)
  
  df$date <- as.Date(df$timestamp)
  numeric_cols <- names(df)[sapply(df, is.numeric)]
  
  summary_df <- aggregate(df[numeric_cols], by=list(date=df$date), FUN=function(x) {
    c(mean=mean(x), min=min(x), max=max(x))
  })
  
  return(summary_df)
}

export_cleaned_data <- function(df, path) {
  write.csv(df, file=path, row.names=FALSE)
}
