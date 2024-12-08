# plot the age_factor, i.e., how fast a post's score decays
p <- posts_all |> 
  ggplot(aes(x = age_days, y = age_factor)) +
  geom_point(size = 2) +
  labs(title = "How quickly the score decays based on age") +
  theme_minimal()

print(p)