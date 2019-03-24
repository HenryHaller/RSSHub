module UrlRedirectFixer
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
end