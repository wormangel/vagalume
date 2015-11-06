require "multi_json"
require "open-uri"
require_relative "vagalume/core_ext/array"
require_relative "vagalume/search_result"
require_relative "vagalume/language"
require_relative "vagalume/song"
require_relative "vagalume/artist"
require_relative "vagalume/lyric_formatter"
require_relative "vagalume/status"
require_relative "vagalume/validator"

module Vagalume
  extend self

  BASE_URL = "http://www.vagalume.com.br/api/search.php?"

  # Search through the vagalume API
  # @param criteria [Hash]
  # @example
  #   client = Vagalume.find(mus: "Tech Noir", art: "Gunship", nolyrics: false, ytid: true)
  def find(criteria)
    validator = Vagalume::Validator.new
    criteria = validator.confirm(criteria)
    request_url = BASE_URL + to_query(criteria)
    result = MultiJson.decode(open(request_url).read)
    search_result = Vagalume::SearchResult.new(result)
  end

  def get_lyric(artist, song, options)
    search = find(artist, song)
    formatter = Vagalume::LyricFormatter.new
    formatter.format(search, options)
  end

  def to_query(hash)
    hash.collect do |key, value|
      "#{URI.escape(key.to_s)}=#{URI.escape(value.to_s)}"
    end.compact.sort! * '&'
  end
end