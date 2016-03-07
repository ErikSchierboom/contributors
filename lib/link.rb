class Link
  # This doesn't even remotely deal with RFC 5988 (HTTP Link headers).
  # It just assumes a very, very simple linking scheme from GitHub.
  def self.parse(s)
    rgx = Regexp.new('<(.*)>; rel="(.*)"')
    segments = s.split(", ")
    segments.each_with_object({}) {|segment, links|
      m = rgx.match(segment)
      link = Link.new(m[1], m[2])
      links[link.rel] = link
    }
  end

  attr_reader :url, :rel
  def initialize(url, rel)
    @url = url
    @rel = rel
  end

  # We don't care about the rel.
  # If the GitHub header returns two equal links, then we're done.
  def ==(other)
    url == other.url
  end
end
