Running post.R will show you the desired Bluesky posts in your console. The posts are scored on what I call sociality, which values reposts and likes. Reposts are valued much more than likes.

A decay function is used to exponentially reduce the sociallity score of older posts. The result is that you see recent posts more than old posts.

Edit the following variables before running:

- `n_posts`
- `query`

See the [bskyr]("https://christophertkenny.com/bskyr/") package site for how to authenticate with Bluesky. `bskyr` was created by [Christopher T. Kenny]("https://github.com/christopherkenny").
