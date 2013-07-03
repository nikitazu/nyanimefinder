require "nyanimefinder/version"
require 'nokogiri'
require 'net/http'

module Nyanimefinder
  class MyAnimeList
    def search_anime query
      url  = "http://myanimelist.net/anime.php?q=#{query}"
      html = Net::HTTP.get_response(URI.parse(url)).body
      doc  = Nokogiri::HTML(html)
      
      not_found_div = doc.css('html>body>div#myanimelist>div#contentWrapper>div#content>div>div')[1]
      if not_found_div.text == 'No titles that matched your query were found.' then
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
  end

  ROWHTML = <<-ROWHTML
  <tr>
        <td class="borderClass bgColor" width="50" valign="top">
          <div class="picSurround">
            <a href="http://myanimelist.net/anime/1587/Tenpou_Ibun_Ayakashi_Ayashi" class=
            "hoverinfo_trigger" id="#sarea1587" rel="#sinfo1587"><img src=
            "http://cdn.myanimelist.net/images/anime/11/4452t.jpg" border="0" /></a>
          </div>
        </td>

        <td class="borderClass bgColor" valign="top">
          <div id="sarea1587">
            <div id="sinfo1587" rel="a1587" class="hoverinfo"></div>
          </div><a href=
          "http://myanimelist.net/anime/1587/Tenpou_Ibun_Ayakashi_Ayashi"><strong>Tenpou
          Ibun Ayakashi Ayashi</strong></a> <a href=
          "http://myanimelist.net/panel.php?go=add&amp;selected_series_id=1587&amp;hideLayout"
          title="Quick add anime to my list" class="Lightbox_AddEdit button_add">add</a>

          <div style="margin-top: 3px;" class="lightLink"></div>

          <div class="spaceit">
            In the year of Tenpo 14, Yoi, monsters from another world attack Edo. Those who
            fight against them are members of Bansha Aratemesho. In public, Bansha
            Aratemsho is known as an organization to study fo... <a href=
            "http://myanimelist.net/anime/1587/Tenpou_Ibun_Ayakashi_Ayashi">read more.</a>
          </div>
        </td>

        <td class="borderClass bgColor" align="center">TV</td>

        <td class="borderClass bgColor" align="center">25</td>

        <td class="borderClass bgColor" align="center">7.11</td>
      </tr>
  ROWHTML
end
