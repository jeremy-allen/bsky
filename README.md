Running `rb()` will show you the desired Bluesky posts in your R console. The posts are scored on what I call sociality, which values reposts and likes. Reposts are valued much more than likes.

A decay function is used to exponentially reduce the sociallity score of older posts. The result is that you see recent posts more than old posts.

There are arguments for changing the query and number of posts retrieved. The default query is "rstats". However, the main objective is to have the simplest function possible in order to quickly see rstats posts from Bluesky in your R console.

See the [bskyr](https://christophertkenny.com/bskyr/) package site for how to authenticate with Bluesky. `bskyr` was created by [Christopher T. Kenny](https://github.com/christopherkenny).
