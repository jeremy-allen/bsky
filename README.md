### What is this?
Instead of "What's hot right now?" I prefer to think of this as "Show me the most socially active posts right now." The main objective is to have the simplest function possible in order to quickly see `rstats` posts from Bluesky in your R console.

### Where will it happen?
Running `bs()` will show you the desired Bluesky posts in your R console.

### What determines how socially active a post is?
Posts are scored on what I call sociality, which values reposts and likes. Reposts are valued much more than likes. Also, recency is valued more than age. A decay function is used to exponentially reduce the sociallity score of older posts. The result is that you see the most socially active recent posts before older or less active posts.

### How do I use this?
For now, source the `post.R` file, then run `bs()`. The defaults are fine. However, there are arguments for changing the query and number of posts retrieved. The default query is "rstats". Use the `query` argument if you want to retrieve posts with other words.

See the [bskyr](https://christophertkenny.com/bskyr/) package site for how to authenticate with Bluesky. `bskyr` was created by [Christopher T. Kenny](https://github.com/christopherkenny).
