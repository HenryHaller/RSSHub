require 'uri'

module UrlSmarts
  extend ActiveSupport::Concern
  included do
    def looks_like_rss_feed?
      uri = URI(self.rss_url)
      if %w[http https].include? uri.scheme
        valid = true
      else
        errors.add(:doesnt_look_like_a_url, "This submission doesn't look like a valid url.")
      end
      return valid
    end
  end
end
