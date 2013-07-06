require 'nyanimefinder/myanimelist'
require 'date'

HERE = File.dirname(File.expand_path(__FILE__))

describe Nyanimefinder::MyAnimeList do
  it 'not results should be parsed as nil' do
    html = File.read File.join HERE, 'myanimelist_nothing.html'
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.parse_multi_result html
    result.should be_nil
  end
  
  it 'many results should be parsed as list of maps' do
    html = File.read File.join HERE, 'myanimelist_multi.html'
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.parse_multi_result html
    result.should_not be_nil
    result.should eql([
      {:web_url=>"http://myanimelist.net/anime/534/Slayers", 
        :title=>"Slayers", :type=>"TV", :series=>"26", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/6/19870t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/5233/Slayers_Evolution-R", 
        :title=>"Slayers Evolution-R", :type=>"TV", :series=>"13", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/5/20938t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/1171/Slayers_Excellent", 
        :title=>"Slayers Excellent", :type=>"OVA", :series=>"3", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/8/34993t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/867/Slayers_Gorgeous", 
        :title=>"Slayers Gorgeous", :type=>"Movie", :series=>"1", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/5/34991t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/868/Slayers_Great", 
        :title=>"Slayers Great", :type=>"Movie", :series=>"1", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/4/13097t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/535/Slayers_Next", 
        :title=>"Slayers Next", :type=>"TV", :series=>"26", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/4/19918t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/866/Slayers_Premium", 
        :title=>"Slayers Premium", :type=>"Movie", :series=>"1", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/2/20969t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/869/Slayers_Return", 
        :title=>"Slayers Return", :type=>"Movie", :series=>"1", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/9/34997t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/4028/Slayers_Revolution", 
        :title=>"Slayers Revolution", :type=>"TV", :series=>"13", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/7/20940t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/1170/Slayers_Special", 
        :title=>"Slayers Special", :type=>"OVA", :series=>"3", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/8/20099t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/1172/Slayers_Try", 
        :title=>"Slayers Try", :type=>"TV", :series=>"26", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/9/19872t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/536/Slayers:_The_Motion_Picture", 
        :title=>"Slayers: The Motion Picture", :type=>"Movie", :series=>"1", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/10/2644t.jpg"},
        
      {:web_url=>"http://myanimelist.net/anime/1587/Tenpou_Ibun_Ayakashi_Ayashi", 
        :title=>"Tenpou Ibun Ayakashi Ayashi", :type=>"TV", :series=>"25", 
        :image_url=>"http://cdn.myanimelist.net/images/anime/11/4452t.jpg"}
    ])
  end
  
  it 'single result OVA' do
    # myanimelist.net behaves smartassy for its users
    # when result is single item it opens anime main page
    # instead of search results list
    
    html = File.read File.join HERE, 'myanimelist_single.html'
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.parse_single_result html
    result.should_not be_nil
    result.should eql([{
      #:web_url    =>  "http://myanimelist.net/anime/1171/Slayers_Excellent", 
      :title      =>  "Slayers Excellent", 
      :type       =>  "OVA", 
      :series     =>  "3", 
      :image_url  =>  "http://cdn.myanimelist.net/images/anime/8/34993.jpg",
      :airing     =>  "finished",
      :airing_start => DateTime.new(1998, 10, 25),
      :airing_end   => DateTime.new(1999,  3, 25),
    }])
  end
  
  it 'single result TV airing' do
    html = File.read File.join HERE, 'myanimelist_single2.html'
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.parse_single_result html
    result.should_not be_nil
    result.should eql([{
      #:web_url    =>  "http://myanimelist.net/anime/16498/Shingeki_no_Kyojin", 
      :title      =>  "Shingeki no Kyojin",
      :type       =>  "TV", 
      :series     =>  "25", 
      :image_url  =>  "http://cdn.myanimelist.net/images/anime/10/47347.jpg",
      :airing     =>  "currently",
      :airing_start => DateTime.new(2013, 4, 7),
      :airing_end   => nil,
      :other_titles => [ "Attack on Titan" ]
    }])
  end
  
  it 'single result MOVIE' do
    html = File.read File.join HERE, 'myanimelist_single3.html'
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.parse_single_result html
    result.should_not be_nil
    result.should eql([{
      #:web_url    =>  "http://myanimelist.net/anime/536/Slayers:_The_Motion_Picture", 
      :title      =>  "Slayers: The Motion Picture",
      :type       =>  "Movie", 
      :series     =>  "1", 
      #:year       =>  "1995",
      #:country    =>  "Япония",
      :image_url  =>  "http://cdn.myanimelist.net/images/anime/10/2644.jpg",
      :airing     =>  "finished",
      :airing_start => DateTime.new(1995, 7, 29),
      :airing_end   => nil,
      :other_titles => [
        "Slayers: The Motion Picture",
        "Slayers Perfect",
        "Gekijouban Slayers",
        "Slayers Movie 1",
      ]
    }])
  end
end
