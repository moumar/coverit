require 'amazon/ecs'

module CoverSearch 
  class Amazon
    def initialize
      ::Amazon::Ecs.options = YAML::load_file(File.expand_path("~/.amazon.yml"))
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
