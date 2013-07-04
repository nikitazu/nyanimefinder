# encoding=utf-8
require 'nyanimefinder/worldart'

HERE = File.dirname(File.expand_path(__FILE__))

describe Nyanimefinder::WorldArt do
  it 'not results should be parsed as nil' do
    html = File.read File.join HERE, 'worldart_nothing.html'
    finder = Nyanimefinder::WorldArt.new
    result = finder.parse_multi_result html
    result.should be_nil
  end
  
  it 'many results should be parsed as list of maps' do
    html = File.read File.join HERE, 'worldart_multi.html'
    finder = Nyanimefinder::WorldArt.new
    result = finder.parse_multi_result html
    result.should_not be_nil
    result.should eql([      
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=7101", :title=>"Рубаки: Эволюция-Эр (2009, Япония, ТВ, 13 эп.)", :type=>"TV", :series=>"13", :year=>"2009", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=6896", :title=>"Рубаки: Революция (2008, Япония, ТВ, 13 эп.)", :type=>"TV", :series=>"13", :year=>"2008", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=5953", :title=>"Странная история эпохи Тэмпо: Аякасиаяси (2006, Япония, ТВ, 25 эп. + 5 DVD-спэшлов)", :type=>"TV", :series=>"25", :year=>"2006", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=3699", :title=>"Slayers Premium (2001, Япония, короткометражный фильм)", :type=>"Movie", :series=>"1", :year=>"2001", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=203", :title=>"Превосходные Рубаки (1998, Япония, OVA, 3 эп.)", :type=>"OVA", :series=>"3", :year=>"1998", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=204", :title=>"Slayers Gorgeous (1998, Япония, полнометражный фильм)", :type=>"Movie", :series=>"1", :year=>"1998", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=3270", :title=>"Затерянная Вселенная (1998, Япония, ТВ, 26 эп.)", :type=>"TV", :series=>"26", :year=>"1998", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=202", :title=>"Великие Рубаки на большом экране (1997, Япония, полнометражный фильм)", :type=>"Movie", :series=>"1", :year=>"1997", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=732", :title=>"Рубаки Try [ТВ] (1997, Япония, ТВ, 26 эп.)", :type=>"TV", :series=>"26", :year=>"1997", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=200", :title=>"Возвращение Рубак на большой экран (1996, Япония, полнометражный фильм)", :type=>"Movie", :series=>"1", :year=>"1996", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=201", :title=>"Особые Рубаки (1996, Япония, OVA, 3 эп.)", :type=>"OVA", :series=>"3", :year=>"1996", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=731", :title=>"Рубаки Некст [ТВ] (1996, Япония, ТВ, 26 эп.)", :type=>"TV", :series=>"26", :year=>"1996", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=199", :title=>"Рубаки на большом экране (1995, Япония, полнометражный фильм)", :type=>"Movie", :series=>"1", :year=>"1995", :country=>"Япония"},
      {:web_url=>"http://www.world-art.ru/animation/animation.php?id=730", :title=>"Рубаки [ТВ] (1995, Япония, ТВ, 26 эп.)", :type=>"TV", :series=>"26", :year=>"1995", :country=>"Япония"},
    ])
  end
  
  it 'single result should be parsed as list of maps too' do
    # myanimelist.net behaves smartassy for its users
    # when result is single item it opens anime main page
    # instead of search results list
    
    html = File.read File.join HERE, 'worldart_single.html'
    finder = Nyanimefinder::WorldArt.new
    result = finder.parse_single_result html
    result.should_not be_nil
    result.should eql([{
      #:web_url    =>  "http://myanimelist.net/anime/1171/Slayers_Excellent", 
      :title      =>  "Превосходные Рубаки", 
      #:type       =>  "OVA", 
      #:series     =>  "3", 
      :image_url  =>  "http://www.world-art.ru/animation/img/1000/203/1.jpg",
      #:airing     =>  "finished"
      :other_titles => [
        "Slayers Excellent",
        "Slayers: Lina-chan's Great Fashion Strategy",
        "Slayers: The Fearful Future",
        "Slayers: The Labyrinth",
        "スレイヤーズえくせれんと"
      ]
    }])
  end
  
  it 'single result should be parsed as list of maps with additional info' do
    html = File.read File.join HERE, 'worldart_single2.html'
    finder = Nyanimefinder::WorldArt.new
    result = finder.parse_single_result html
    result.should_not be_nil
    result.should eql([{
      #:web_url    =>  "http://myanimelist.net/anime/16498/Shingeki_no_Kyojin", 
      :title      =>  "Вторжение гигантов",
      #:type       =>  "TV", 
      #:series     =>  "25", 
      :image_url  =>  "http://www.world-art.ru/animation/img/2000/1245/1.jpg",
      #:airing     =>  "currently",
      :other_titles => [
        "Attack on Titan",
        "Shingeki no Kyojin",
        "Вторжение титанов",
        "Атака титанов",
      ]
    }])
  end
end
