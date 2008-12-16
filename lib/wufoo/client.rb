module Wufoo
  class Client
    include HTTParty
    
    attr_accessor :url, :api_key
    
    def initialize(url, api_key)
      @url, @api_key = url, api_key
    end
    
    def post(path, data)
      data.merge!({
        :w_api_key => api_key,
      })
      self.class.post("#{@url}#{path}", :query => data, :format => :json)
    end
  end
end