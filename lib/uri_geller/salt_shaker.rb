require 'digest/sha2'

module UriGeller
  class SaltShaker
    def initialize(options={})
      @salt = options[:salt] || "very-secret-phrase"
    end
    
    def salt(data)
      (data + digest("#{data + @salt}"))
    end
    
    def remove_salt(soup)
      data = soup[0...-hash_length]
      salt(data) == soup ? data : false
    end
    
    private
    
      def digest(data)
        hasher.send(:hexdigest, data)
      end
    
      def hasher
        @hasher ||= Digest::SHA1.new
      end
      
      def hash_length 
        @hash_length ||= digest('x').length
      end
  end
end