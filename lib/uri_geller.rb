require 'rubygems'
require 'uri_geller/encoder'
require 'uri_geller/decoder'

module UriGeller
  def self.encode(data, secret=nil)
    Encoder.new(:secret => secret).encode(data)
  end
  
  def self.decode(soup, secret=nil)
    Decoder.new(:secret => secret).decode(soup)
  end
end