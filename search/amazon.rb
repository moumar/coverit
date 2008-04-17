require 'amazon/ecs'

module CoverSearch 
  class Amazon
    def initialize
      amazon_key = File.read("/home/moumar/.amazon_key").chop
      ::Amazon::Ecs.options = {:aWS_access_key_id => amazon_key}
    end

    def search(query)
      links = []
      [nil, :fr, :uk].each do |country|
        res = ::Amazon::Ecs.item_search(query, :search_index => 'Music', :country => country, :response_group => "Medium")
        res.items.each do |item|
          %w{smallimage mediumimage largeimage}.each do |n| 
            if h = item.get_hash(n)
              links << h[:url]
            end
          end
        end
      end
      return links.compact
    end
  end
end

if __FILE__ == $0
  require "pp"
  pp CoverSearch::Amazon.new.search("funk fever")
end
