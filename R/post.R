library(bskyr)
library(tidyverse)
source("R/auth.R")
source("R/build-url.R")
source("R/score.R")

auth_bsky()

# experiement with different values for n_posts
n_posts <- 2000
query <- "rstats"

# search for posts
rstats_posts_raw <- bs_search_posts(
  query = query,
  limit = n_posts,
  sort = "latest"
) |> 
  arrange(desc(like_count))

# score degree of sociality of all posts
posts_all <- rstats_posts_raw |> 
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
  calculate_post_scores()

all_date_span <- as.integer(difftime(max(posts_all$date, na.rm = TRUE), 
  min(posts_all$date, na.rm = TRUE), units = "days") + 1)

# just the n most engaged
n <- 100
posts <- posts_all |> 
  arrange(desc(score)) |> 
  mutate(order = row_number()) |> 
  slice(1:n) |> 
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
  "\n", "These top ", n, " posts occurred over the course of ", top_date_span, " days",
  "\n", "The total set of ", n_posts, " posts occurred over the course of ", all_date_span, " days", "\n\n",
  sep = ""
)

if (all_date_span == 1) {
  message("All posts are in a single day, so the decay function has no effect here")
}
