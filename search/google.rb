#google search
require "uri"
require "open-uri"

module CoverSearch
  class Google
    #URL = "http://images.google.com/images?as_q=%s&svnum=10&hl=en"
    BASE_URL = "http://images.google.fr/images?q=%s&ndsp=18&svnum=10&hl=fr&sa=N&imgsz=medium%%7Clarge%%7Cxlarge"
    def search(query)
      page = open(sprintf(BASE_URL, URI.escape(query) )).read 
      #dyn.Img(\"http://www.trip-hop.net/album-1088-ttc-ceci-nest-pas-un-disque-big-dada.html&h=200&w=200&sz=9&hl=fr&start=8\",\"\",\"KevCkM3VC2ouxM:\",\"http://www.trip-hop.net/images/jacquettes/big/1088.jpg\",\"104\",\"104\",\""
      #<a href=/imgres?imgurl=http://www.isc.tamu.edu/~lewing/gallery/gzilla/gzilla-test.1.jpg&imgrefurl=http://www.isc.tamu.edu/~lewing/gallery/gzilla/&h=641&w=543&sz=45&tbnid=Nc4Dzf9z-DkySM:&tbnh=135&tbnw=114&hl=fr&start=5&prev=/images%3Fq%3Dtest%26svnum%3D10%26hl%3Dfr%26lr%3D%26sa%3DG><img src=/images?q=tbn:Nc4Dzf9z-DkySM:www.isc.tamu.edu/~lewing/gallery/gzilla/gzilla-test.1.jpg width=114 height=135></a><
      p page
      #page.scan(%r{href=/imgres\?imgurl=([^&]+)&}).flatten
      page.scan(%r{dyn.Img\((?:"[^"]*",){3}"([^"]+)"}).flatten
    end
  end
end

if __FILE__ == $0
  require "pp"
  urls = CoverSearch::Google.new.search("ttc ceci n'est pas un disque")
  pp urls
  p urls.size
end
