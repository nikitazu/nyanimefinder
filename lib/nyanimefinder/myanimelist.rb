require "nyanimefinder/version"
require 'nokogiri'
require 'net/http'
require 'date'

module Nyanimefinder
  class MyAnimeList
    
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
      
      # check for no results
      # ====================
      not_found_div = doc.css('html>body>div#myanimelist>div#contentWrapper>div#content>div>div')[1]
      if not_found_div != nil and not_found_div.text == 'No titles that matched your query were found.' then
        return nil
      end
      
      results_table = doc.css('html>body>div#myanimelist>div#contentWrapper>div#content table').last
      if results_table == nil then
        return nil
      end
      
      animes = []
      rows = results_table.css('tr')
      rows[1, rows.count].each do |row|
        
        data = row.css('td')
        
        animes << {
          web_url: data[0].css('div a')[0].attr('href'),
          title: data[1].css('a')[0].text,
          type: data[2].text,
          series: data[3].text,
          image_url: data[0].css('div a img').attr('src').value,
          #description: data[1].css('div.spaceit')[0].text.strip
        }
      end
      
      return animes
    end
    
    def parse_single_result html
      doc  = Nokogiri::HTML(html)
      
      content = doc.css('html>body>div#myanimelist>div#contentWrapper')
      title = content.css('h1')[0].text.gsub! /^Ranked #\d+/i, ''
      data = content.css('div#content>table>tr>td')[0].text
      image_url = content.css('div#content>table>tr>td>div img')[0]['src']
      
      match = /Type: (\w+)\s+Episodes: (\d+)\s+Status: (Finished Airing|Currently Airing|Not Yet Aired)/.match(data)
      
      airing_start = ''
      airing_end = ''
      airing = content.css('div#content>table>tr>td>div.spaceit')
        .map    { |div| div.text }
        .select { |text| /Aired:/.match(text) }[0]
        
      if airing != nil then
        airing_data = airing.gsub(/Aired: /, '').split('to').map { |x| x.strip }
        airing_start = DateTime.strptime(airing_data[0], '%b %d, %Y').strftime('%d.%m.%Y')
        airing_end = airing_data[1]
        if airing_end == nil or airing_end == '?' then
          airing_end = nil
        else
          airing_end = DateTime.strptime(airing_end, '%b %d, %Y').strftime('%d.%m.%Y')
        end
      end
      
      anime = {
        title: title,
        type: match[1],
        series: match[2],
        image_url: image_url,
        airing: match[3].split(' ').first.downcase,
        airing_start: airing_start,
        airing_end: airing_end
      }
      
      other_title = /English: (.+)Japanese:/.match(data)
      if other_title != nil then
        titles = other_title[1].gsub(/Synonyms: /, ',').split(',').map { |title| title.strip }
        anime[:other_titles] = titles
      end
      
      return [anime]
    end

  end
end
