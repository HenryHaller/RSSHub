module EpisodeAccessModule
  def from_newest_to_oldest_episodes(limit = nil)
    episodes = self.episodes.order(pub_date: :desc)
    episodes = episodes.slice(0, limit) if limit.class == Integer && limit <= episodes.length
    episodes
  end
end
