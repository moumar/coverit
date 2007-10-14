#amazon search
require 'amazon/search'

module CoverSearch 
  class Amazon 
    def search(query)
      links = []
      [nil, 'fr', 'uk'].each do |country|
	begin
          request = ::Amazon::Search::Request.new(nil, nil, country)
	  result = request.keyword_search(query, 'music')
	  result.products.each do |prod|
	    links << [ prod.image_url_small, prod.image_url_medium, prod.image_url_large ]
	  end
	rescue ::Amazon::Search::Request::SearchError => e
	  #log(e.message + " '#{search_str}'")
	end
      end
      return links.flatten.compact
    end
  end
end

if __FILE__ == $0
  require "pp"
  pp CoverSearch::Amazon.new.search("funk fever")
end
