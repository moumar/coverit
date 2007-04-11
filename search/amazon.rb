#amazon search
require 'amazon/search'

module AmazonBase
  def search(query)
    begin
      res = @req.keyword_search(query, 'music')
    rescue Amazon::Search::Request::SearchError => e
      return []
      #log(e.message + " '#{search_str}'")
    end

    res.products.collect do |prod|
      [ prod.image_url_small, prod.image_url_medium, prod.image_url_large ]
    end.flatten.compact
  end
end

module CoverSearch 
  class Amazon
    include AmazonBase

    def initialize
      @req = ::Amazon::Search::Request.new
    end
  end

  class Amazonfr
    include AmazonBase

    def initialize
      @req = ::Amazon::Search::Request.new(nil, nil, 'fr')
    end
  end
end

if __FILE__ == $0
  require "pp"
  pp CoverSearch::Amazonfr.new.search("funk fever")
end
