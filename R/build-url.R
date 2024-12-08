# define a function to construct a URL to a post on a user profile
build_url <- function(did, uri) {

  # did should be the author's did
  # the uri should be the uri of the post
  # from the uri we will extract the rkey and combine it
  # with the author's did to make a link to the post
  # on the author's profile
  
  base <- "https://bsky.app/profile/"
  user <- paste0(did, "/post/")
  rkey <- str_extract(uri, "[A-Za-z0-9]+(?=\\/?$)")

  paste0(
    base, user, rkey
  )

}