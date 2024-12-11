### What is this?
Instead of "What's hot right now?" I prefer to think of this as "Show me the most socially active posts right now." The main objective is to have the simplest function possible in order to quickly see `rstats` posts from Bluesky in your R console.

### Where will it happen?
Running `bs()` will show you the desired Bluesky posts in your R console.

### What determines how socially active a post is?
Posts are scored on what I call sociality, which values reposts and likes. Reposts are valued much more than likes. Also, recency is valued more than age. A decay function is used to exponentially reduce the sociallity score of older posts. The result is that you see the most socially active recent posts before older or less active posts.

### How do I use this?

1. Clone this repo
2. Install the Christopher Kenny's `bskyr` package and follow its instructions for authenticating with Bluesky
3. Source the `R/post.R` file
4. Run `bs()` in your console.

The defaults are fine. However, there are arguments for changing the query and number of posts retrieved. The default query is "rstats". Use the `query` argument if you want to retrieve posts with other words.

See the [bskyr](https://christophertkenny.com/bskyr/) package site for how to authenticate with Bluesky. `bskyr` was created by [Christopher T. Kenny](https://github.com/christopherkenny).
