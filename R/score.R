# define a function to score posts based on degree of *recent* sociality
calculate_post_scores <- function(df) {
  
  current_day <- today()
  date_span <- as.integer(difftime(max(df$date, na.rm = TRUE), 
    min(df$date, na.rm = TRUE), units = "days") + 1)

  # The decay constant determines how fast the decay function will reduce
  # a post's sociality score based on its age in days. 
  # Here, I choose .3, so posts in the first 30% of the date range will keep
  # more of their score. If the dates span 12 days, the constant will be 3.6.
  # A lower number will decay a score more quickly, letting more recent posts
  # retain more score while older posts' scores are quickly reduced to near 0.
  decay_constant <- round(as.double(date_span * .3), 4)

  df |> 
    mutate(
      # Value reposts more than likes because reposts have more skin
      # in the game, i.e., more risk accepted by the reposter.
      # Log transform the counts to better handle outliers.
      weighted_sum = (log10(like_count + 1) * 0.3) + (log10(repost_count + 1) * 5),
      age_days = as.numeric(difftime(current_day, date, units = "days")),
      # Because we care most about *recent* activity, we reduce the weighted
      # sum using an exponential decay function based on post age, i.e.,
      # each day of age exponentially reduces a post's sociality score.
      age_factor = exp(-age_days / decay_constant),
      score = round(weighted_sum * age_factor, 4)
    )
} 
