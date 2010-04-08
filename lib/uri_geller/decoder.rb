require 'rubygems'
require 'active_support'
require 'zlib'
require 'cgi'
require 'uri_geller/salt_shaker'

module UriGeller
  class Decoder
    def initialize(options={})
      @secret = options[:secret] || "very-secret-phrase"
    end
    
    def decode(datasoup)
      if chunk_of_data = decrypt(datasoup)
        unserialize(extract(chunk_of_data))
      else
        nil
      end
    end
    
    private
      def extract(chunk_of_data)
        Zlib::Inflate.inflate(ActiveSupport::Base64.decode64(CGI::unescape(chunk_of_data)))
      end
    
      def unserialize(chunk_of_data)
        ActiveSupport::JSON.decode(chunk_of_data).symbolize_keys
      end
    
      def decrypt(datasoup)
        @salt_shaker ||= SaltShaker.new(:salt => @secret)
        @salt_shaker.remove_salt(datasoup)
      end
  end
end