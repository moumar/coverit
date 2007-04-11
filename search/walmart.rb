require "cgi"
require "mechanize"
require "pp"

module CoverSearch
  class Walmart
    PRODUCTS_PER_PAGE = 20 # or 40
    WALMART_URL = "http://www.walmart.com/catalog/search-ng.gsp?search_constraint=4104&search_query=%s&Continue.x=0&Continue.y=0&Continue=Find&ics=#{PRODUCTS_PER_PAGE}&ico=%d"
    #WALMART_URL = "http://www.walmart.com/search/search-ng.do?search_query=%s&search_constraint=4104&ics=20&ico=%d&ref=null"
    PRODUCT_URL = %r{/catalog/product.gsp\?product_id=(\d+)}
    
    def initialize
      @meca = WWW::Mechanize.new
    end
    
    def search(query)
      @query = query
      #@meca.watch_for_set = { "img" => nil }
      page = @meca.get( url_for_page(1) )
      #only one match
      if ( uri = page.uri.request_uri ) =~ PRODUCT_URL
	[ get_image_url(uri) ]
      else
	@meca.page.body =~ %r{<span class="SearchHeaderNumber">(\d+) items found </span>}
	#Skip to Page&nbsp;&nbsp;&nbsp;1&nbsp;<a href="http://www.walmart.com/search/search-ng.do?search_query=rolling+stones&amp;search_constraint=4104&amp;ics=40&amp;ico=40&amp;ref=null">2</a>&nbsp;
	num_products = $1.to_f
	num_pages = (num_products/PRODUCTS_PER_PAGE).ceil

	products_urls = get_product_urls()
	2.upto(num_pages) do |page_num|
	  begin
	    @meca.get( url_for_page(page_num) )
	    products_urls += get_product_urls()
	  rescue Exception
	  end
	end
	
	products_urls.collect { |url| get_image_url(url) }.compact
      end
    end
  #      url = location.protocol + "//" + location.hostname + file + "?image=" + url;
  #      "/catalog/detail.gsp?image=http://i.walmart.com/i/p/00/07/55/96/29/0007559629872_500X500.jpg&product_id=3342669"
  #    javascript:photo_opener('http://i.walmart.com/i/p/00/07/55/96/29/0007559629872_500X500.jpg&product_id=3342669', '/catalog/detail.gsp')
    
    private

    def url_for_page(num)
      sprintf(WALMART_URL, CGI.escape(@query), PRODUCTS_PER_PAGE*(num-1) )
    end

    def get_product_urls
      @meca.page.links.collect do |l|
	l.href =~ PRODUCT_URL ?  l.href : nil
      end.compact.uniq
    end

    def get_image_url(url)
      begin
	page = @meca.get(url)
      rescue Exception
	return nil
      end
      link = page.links.select { |l| l.node.text == "See larger image" }.first
      link.href =~ %r{photo_opener\('([^']+)', '([^']+)'\)}
      url = "#$2?image=#$1"

      @meca.get(url).body =~ %r{<img src="([^"]+\.jpg)" width=}
      return $1
  #    @meca.get(url).watches["img"].each do |node| 
  #      url = node.attributes["src"]
  #      return url if url =~ /\.jpg$/
  #    end
    end
  end
end

if $0 == __FILE__
  #single result
  #p WalmartSearch.new("plant_life").search

  #single page
  pp WalmartSearch.new(ARGV[0]).search
  #"handsome boys modeling school"
  #p WalmartSearch.new("plantlife").search
  #walmart_search(
  #multiple page
  #walmart_search()
end
