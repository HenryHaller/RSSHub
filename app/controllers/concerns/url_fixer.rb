module UrlFixer
  def follow_redirect(url)
    response = HTTP.head(url)
    if response.status == 301
      return response.headers["Location"]
    elsif response.status == 200
      return url
    else
      raise BadUrl
    end
  end

  def soundcloud?(url)
    uri = URI(url)
    uri.host == "soundcloud.com"
  end

  def adapt_soundcloud_url(url)
    body = HTTP.get(url).body
    id = body.to_s.match(/users:(\d+)"/).captures[0]
    "http://feeds.soundcloud.com/users/soundcloud:users:#{id}/sounds.rss"
  end
end