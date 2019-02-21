require 'uri'

module UrlSmarts
  extend ActiveSupport::Concern
  included do
    def looks_like_rss_feed?
      begin
        uri = URI(self.rss_url)
      rescue URI::InvalidURIError
        errors.add(:parsing_failure, "Parsing Failure")
        return false
      end
      if %w[http https].include? uri.scheme
        valid = true
      else
        errors.add(:doesnt_look_like_a_url, "This submission doesn't look like a valid url.")
      end
      return valid
    end
  end
end
