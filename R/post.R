library(bskyr)
library(tidyverse)
source("R/auth.R")
source("R/build-url.R")
source("R/score.R")

# authenticate to bsky
auth <- bs_auth(user = bs_get_user(), pass = bs_get_pass())

bs <- function(query = "rstats", n_posts = 2000, keep = FALSE) {

  # search for posts
  rstats_posts_raw <- bs_search_posts(
    query = query,
    limit = n_posts,
    sort = "latest"
  )

  # score degree of sociality of all posts
  posts_scored <- rstats_posts_raw |> 
    select(uri, like_count, repost_count, author, record) |> 
    unnest_wider(c(author, record), names_sep = "_") |>
    distinct() |> 
    mutate (
      date = as_date(with_tz(ymd_hms(record_createdAt, tz = "UTC"),
      tzone = "America/New_York"))
    ) |> 
    select(uri, author_did, like_count, repost_count, author_displayName,
      record_text, date, author_handle) |> 
    mutate(post_url = build_url(did = author_did, uri = uri)) |> 
    # calculate and column for sociality score
    calculate_post_scores()

  all_date_span <- as.integer(difftime(max(posts_scored$date, na.rm = TRUE), 
    min(posts_scored$date, na.rm = TRUE), units = "days") + 1)
  
  n_keep <- 100

  if (n_posts < 100) {
    n_keep <- n_posts
  }

  # just the n most engaged
  posts <- posts_scored |> 
    arrange(desc(score)) |> 
    mutate(order = row_number()) |> 
    slice(1:n_keep) |> 
    arrange(score)

  top_date_span <- as.integer(difftime(max(posts$date, na.rm = TRUE), 
    min(posts$date, na.rm = TRUE), units = "days") + 1)

  # print in console
  cat(
    paste0(
      "\n", posts[["order"]], ". ", posts[["author_displayName"]], " ",
      posts[["date"]], "\n",
      "sociality score: ", posts[["score"]], " (", posts[["like_count"]], " likes, ",
      posts[["repost_count"]], " reposts)", "\n\n",
      posts[["record_text"]], "\n",
      posts[["post_url"]], "\n",
      "-----", "\n",
      sep = ""
    ),
    "\n", "These top ", n_keep, " posts occurred over the course of ", top_date_span, " days",
    "\n", "The total set of ", n_posts, " posts occurred over the course of ", all_date_span, " days", "\n\n",
    sep = ""
  )

  if (all_date_span == 1) {
    message("All posts are in a single day, so the decay function has no effect here")
  }

  if (keep == TRUE) {
    list(
      posts_raw = rstats_posts_raw,
      posts_scored = posts_scored,
      posts = posts,
      top_date_span = top_date_span,
      all_date_span = all_date_span
    )
  }

}
