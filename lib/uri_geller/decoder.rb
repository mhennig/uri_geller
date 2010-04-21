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
      def extract(data)
        data = unescape data
        data = Base64.decode64 data
        data = Zlib::Inflate.inflate data
      end
      
      def unescape(soup)
        soup.tr("-_,", "+/=")
      end
      
      def unserialize(soup)
        ActiveSupport::JSON.decode(soup).symbolize_keys
      end
      
      def decrypt(datasoup)
        @salt_shaker ||= SaltShaker.new(:salt => @secret)
        @salt_shaker.remove_salt(datasoup)
      end
  end
end