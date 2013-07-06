require 'date'

module Nyanimefinder
  module Dateformat
    def self.from_en(str)
      DateTime.strptime str, '%b %d, %Y'
    end
  
    def self.from_ru(str)
      DateTime.strptime str, '%d.%m.%Y'
    end
  
    def self.to_en(dt)
      dt.strftime '%b %d, %Y'
    end
  
    def self.to_ru(dt)
      dt.strftime '%d.%m.%Y'
    end
    
    def self.from_worldart(str)
      begin
        self.from_ru str
      rescue
        nil
      end
    end
    
    def self.from_myanimelist(str)
      begin
        self.from_en str
      rescue
        nil
      end
    end
  end
end
