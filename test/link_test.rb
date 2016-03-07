gem 'minitest', '~>5.8'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/link'

class LinkTest < Minitest::Test
  def test_equality
    link1 = Link.new("http://example.com?page=2", "next")
    assert_equal "http://example.com?page=2", link1.url
    assert_equal "next", link1.rel

    link2 = Link.new("http://example.com?page=3", "next")
    assert_equal "http://example.com?page=3", link2.url
    assert_equal "next", link2.rel

    refute_equal link1, link2

    link3 = Link.new("http://example.com?page=2", "last")
    assert_equal "http://example.com?page=2", link3.url
    assert_equal "last", link3.rel

    assert_equal link1, link3
  end

  def test_parse_first
    s = "<http://example.com?page=2>; rel=\"next\", <http://example.com?page=3>; rel=\"last\""
    links = Link.parse(s)

    assert_equal 2, links.size

    link1, link2 = links.values
    assert_equal "http://example.com?page=2", link1.url
    assert_equal "next", link1.rel

    assert_equal "http://example.com?page=3", link2.url
    assert_equal "last", link2.rel
  end

  def test_parse_middle
    s = "<https://api.github.com/organizations/5624255/repos?page=3>; rel=\"next\", <https://api.github.com/organizations/5624255/repos?page=3>; rel=\"last\", <https://api.github.com/organizations/5624255/repos?page=1>; rel=\"first\", <https://api.github.com/organizations/5624255/repos?page=1>; rel=\"prev\""
    links = Link.parse(s)

    assert_equal 4, links.size

    rels = links.values.map {|link| link.rel}.sort
    assert_equal %w(first last next prev), rels
  end
end
