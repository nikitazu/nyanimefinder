require 'thor'
require 'nyanimefinder/myanimelist'
require 'nyanimefinder/worldart'

module Nyanimefinder
  class CLI < Thor
    desc 'find SOURCE ARGS ...', 'finds all anime in SOURCE with ARGS in title'
    def find(source, *args)
      finder = nil
      
      if source == 'worldart' then
        finder = Nyanimefinder::WorldArt.new
      elsif source == 'myanimelist' then
        finder = Nyanimefinder::MyAnimeList.new
      else
        raise "Unknown SOURCE: #{source}! Choose between [myanimelist] and [worldart]"
      end
      
      animes = finder.find args
      animes.each do |anime|
        anime.each do |key, value|
          printf "%10s => %s\n", key, value
        end
        puts
      end
    end
  end
end
