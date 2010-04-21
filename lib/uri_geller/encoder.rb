require 'rubygems'
require 'active_support'
require 'zlib'
require 'cgi'
require 'uri_geller/salt_shaker'

module UriGeller
  class Encoder 
    def initialize(options={})
      @secret = options[:secret] || "very-secret-phrase"
    end
    
    def encode(data)
      crypt compress(serialize(data))
    end
    
    def compress(data)
      data = Zlib::Deflate.deflate(data, 1)
      data = Base64.encode64(data).gsub("\n",'')
      data = escape data

      #escape Base64.encode64(Zlib::Deflate.deflate(data)).gsub("\n",'')
      #CGI::escape(ActiveSupport::Base64.encode64(Zlib::Deflate.deflate(data)))
    end
    
    def escape(data)
      data.tr("+/=", "-_,")
    end
    
    def serialize(data)
      ActiveSupport::JSON.encode(data)
    end
    
    def crypt(data)
      @salt_shaker ||= SaltShaker.new(:salt => @secret)
      @salt_shaker.salt data
    end
  end
end