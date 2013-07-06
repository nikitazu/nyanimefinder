# encoding=utf-8
require "nyanimefinder/version"
require 'net/http'

module Nyanimefinder
  class Finder
    attr_accessor :query
    
    def initialize
      @query = nil
    end
    
    def find(args)
      if @query.nil?
        raise 'Internal error: @query is not initialized'
      end
      
      url = @query + args.join('+')
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
    
  end
end
