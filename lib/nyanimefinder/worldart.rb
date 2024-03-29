# encoding=utf-8
require "nyanimefinder/version"
require 'nyanimefinder/dateformat'
require 'nyanimefinder/finder'
require 'nokogiri'
require 'net/http'

#http://www.world-art.ru/search.php?public_search=slayers&global_sector=animation


module Nyanimefinder
  class WorldArt < Finder
    
    def initialize
      @query = 'http://www.world-art.ru/search.php?global_sector=animation&public_search='
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
          web_url: web_url,
          title:   link.text,
          type:    type,
          series:  series,
          year:    match[1],
          country: match[2]
        }
      end
      
      return animes
    end
    
    def parse_single_result html
      doc  = Nokogiri::HTML(html)
      
      content_table = nil
      
      doc.css('html>body table').each do |table|
        header = table.css('table>tr>td.bg2')
        if header != nil then
          info = header.select { |h| h.text != '' }
          if info != nil and info.count > 0 then
            if /Основная информация:/.match(info[0].text) != nil then
              # this is good table
              content_table = table
            end
          end
        end
      end
      
      if content_table == nil then
        return nil
      end
      
      data_table = content_table.css('table').select { |t| 
        t.css('tr td a').select { |a| 
          /^http:\/\/www\.world-art\.ru\/animation\/animation_poster\.php\?id=/.match(a['href'])
        }.count > 0 
      }
      
      if data_table == nil or data_table.count == 0
        return nil
      end
      
      data = data_table.first
      
      titles = []
      begin
        titles = data.css('tr')[1].css('td')[2].to_s.split( /<br>/ ).select { |title| 
          title != '' and /</.match(title) == nil
        }
      rescue
        titles = []
      end
      
      fonts = data.css('tr td font')
      
      type_and_series = fonts[3].text
      
      country = ''
      mcountry = /Производство:\p{Blank}*(\p{Any}+)Жанр:/.match(type_and_series)
      if mcountry != nil then
        country = mcountry[1].strip
      end
      
      type = ''
      series = ''
      time = ''
      mtype = /Тип: (\p{Any}+), (\d+) мин.(Выпуск|Премьера):/.match(type_and_series)
      if mtype != nil
        type = mtype[1]
        if type == 'полнометражный фильм' or type == 'короткометражный фильм' then
          type = 'Movie'
          series = '1'
        else
          tsmatch = /(\p{Word}+) \((\d+) эп.\)/.match(type)
          if tsmatch != nil then
            type = tsmatch[1]
            series = tsmatch[2]
            if type == 'ТВ' then type = 'TV' end
          end
        end
        time = mtype[2]
      end
      
      airing_start = nil
      airing_end = nil
      
      mairing = /Выпуск: c (\d\d\.\d\d\.\d\d\d\d) по  (\d\d\.\d\d\.\d\d\d\d)/.match(type_and_series)
      if mairing == nil then
        mairing = /Выпуск: c (\d\d\.\d\d\.\d\d\d\d)/.match(type_and_series)
        if mairing == nil then
          mairing = /Премьера: (\d\d\.\d\d\.\d\d\d\d)/.match(type_and_series)
        end
      end
      
      if mairing != nil then
        airing_start = Dateformat.from_worldart(mairing[1])
        airing_end = Dateformat.from_worldart(mairing[2])
      end
      
      image_url = data.css('tr td a img')[0]['src']
      poster_url = data.css('tr td a')[0]['href']
      #anime_id = /animation_poster\.php\?id=(\d+)/.match(poster_url)[1]
      #web_url = "http://www.world-art.ru/animation/animation.php?id=#{anime_id}"
      
      anime = {
        #web_url:      web_url,
        title:        fonts[0].text.gsub(/ \[/, ''),
        type:         type,
        series:       series, 
        year:         fonts[1].text,
        country:      country,
        image_url:    image_url,
        airing_start: airing_start,
        airing_end:   airing_end,
        other_titles: titles
      }
      
      return [anime]
    end

  end
end
