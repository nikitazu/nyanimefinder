# encoding=utf-8
require "nyanimefinder/version"
require 'nokogiri'
require 'net/http'

module Nyanimefinder
  class WorldArt
    
    def search_anime query
      url      = "http://myanimelist.net/anime.php?q=#{query}"
      response = Net::HTTP.get_response(URI.parse(url))
      
      if response.code == '302'
        # if we got here, then we got single result
        # and were redirected to a page with anime
        redirect = URI.parse(response.header['location'])
        response = Net::HTTP.get_response(redirect)
        return parse_single_result response.body
      else
        return parse_multi_result response.body
      end
    end
    
    def parse_multi_result html
      doc  = Nokogiri::HTML(html)
      
      result = doc.css('html>body table')[6]
      rows = result.css('tr')         # meaningfull rows start at index 5
      rows = rows[5, rows.count - 6]  # and last one is useless
      
      if rows == nil                  # nothing was found, easy
        return nil
      end
      
      animes = []
      rows.each do |row|
        link = row.css('td a')
        url = link.attr('href')
        web_url = "http://www.world-art.ru/#{url}"
        
        match = /\((\d{4}), (\p{Word}+), (\p{Any}+)\)/.match(link.text)
        type_and_series = match[3]
        
        type = ''
        series = ''
        if type_and_series == 'полнометражный фильм' || 
           type_and_series == 'короткометражный фильм' then
          type = 'Movie'
          series = '1'
        else
          tsmatch = /(\p{Word}+), (\d+)/.match(type_and_series)
          if tsmatch != nil then
            type = tsmatch[1]
            series = tsmatch[2]
            if type == 'ТВ' then type = 'TV' end
          end
        end
        
        animes << {
          :web_url    => web_url,
          :title      => link.text,
          :type       => type,
          :series     => series,
          :year       => match[1],
          :country    => match[2]
        }
      end
      
      return animes
    end
    
    def parse_single_result html
      doc  = Nokogiri::HTML(html)
      
      return nil
    end

  end
end
