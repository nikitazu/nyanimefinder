require 'nyanimefinder/dateformat'
require 'date'

describe Nyanimefinder::Dateformat do
  
  it 'can parse from en' do
    Nyanimefinder::Dateformat.from_en('Jul 29, 1995').should eql(DateTime.new(1995, 7, 29))
    Nyanimefinder::Dateformat.from_en('Jun 3, 2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_en('Jun 03, 2010').should eql(DateTime.new(2010, 6, 3))
  end
  
  it 'can parse from ru' do
    Nyanimefinder::Dateformat.from_ru('29.07.1995').should eql(DateTime.new(1995, 7, 29))
    Nyanimefinder::Dateformat.from_ru('03.06.2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_ru('3.6.2010').should eql(DateTime.new(2010, 6, 3))
  end
  
  it 'can format to en' do
    Nyanimefinder::Dateformat.to_en(DateTime.new(1995, 7, 29)).should eql('Jul 29, 1995')
    Nyanimefinder::Dateformat.to_en(DateTime.new(2010, 6, 3)).should eql('Jun 03, 2010')
  end
  
  it 'can format to ru' do
    Nyanimefinder::Dateformat.to_ru(DateTime.new(1995, 7, 29)).should eql('29.07.1995')
    Nyanimefinder::Dateformat.to_ru(DateTime.new(2010, 6, 3)).should eql('03.06.2010')
  end
  
  it 'can understand world-art.ru' do
    Nyanimefinder::Dateformat.from_worldart('29.07.1995').should eql(DateTime.new(1995, 7, 29))
    Nyanimefinder::Dateformat.from_worldart('03.06.2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_worldart('3.6.2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_worldart('').should be_nil
  end
  
  it 'can understand myanimelist.net' do
    Nyanimefinder::Dateformat.from_myanimelist('Jul 29, 1995').should eql(DateTime.new(1995, 7, 29))
    Nyanimefinder::Dateformat.from_myanimelist('Jun 3, 2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_myanimelist('Jun 03, 2010').should eql(DateTime.new(2010, 6, 3))
    Nyanimefinder::Dateformat.from_myanimelist('').should be_nil
    Nyanimefinder::Dateformat.from_myanimelist('?').should be_nil
  end
  
end
