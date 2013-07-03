require 'nyanimefinder/myanimelist'

describe Nyanimefinder::MyAnimeList do
  it 'abracadabra should not be found' do
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.search_anime 'abracadabra'
    result.should be_nil
  end
  
  it 'slayers should be found... obviously' do
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.search_anime 'slayers'
    result.should_not be_nil
    result.map { |anime| anime[:title] }.should eql([
      'Slayers', 
      'Slayers Evolution-R', 
      'Slayers Excellent', 
      'Slayers Gorgeous',
      'Slayers Great',
      'Slayers Next',
      'Slayers Premium',
      'Slayers Return',
      'Slayers Revolution',
      'Slayers Special',
      'Slayers Try',
      'Slayers: The Motion Picture',
      'Tenpou Ibun Ayakashi Ayashi', # why?
      ])
  end
  
  it 'slayers excellent should be found as a single one' do
    # myanimelist.net behaves smartassy for its users
    # when result is single item it opens anime main page
    # instead of search results list
    
    finder = Nyanimefinder::MyAnimeList.new
    result = finder.search_anime 'slayers+excellent'
    result.should_not be_nil
    result.map { |anime| anime[:title] }.should eql(['Slayers Excellent'])
  end
end
