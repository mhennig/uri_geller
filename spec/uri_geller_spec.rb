require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UriGeller do
  before do 
    @encoder ||= UriGeller::Encoder.new(:secret => 'my-secret')
    @decoder ||= UriGeller::Decoder.new(:secret => 'my-secret')
    @data    ||= {:name => "Matthias Hennig", :age => 10, :birthdate => "1979/05/07"}
  end
  
  it "can serialize and deserialize simple hash with data of different types" do
    @decoder.decode(@encoder.encode(@data)).should == @data
  end
  
  it "can not decode when data was changed" do
    encoded = @encoder.encode(@data)
    encoded += "something_added"
    @decoder.decode(encoded).should == nil
  end
  
  it "can not decode with a wrong secret" do 
    encoded = @encoder.encode(@data)
    wrong_decoder = UriGeller::Decoder.new(:secret => 'wrong-secret')
    wrong_decoder.decode(encoded).should == nil
  end
  
  it "works also with class-methods" do
    UriGeller.decode(UriGeller.encode(@data)).should == @data
  end
  
  it "can also evaluate secret-keys" do
    UriGeller.decode(UriGeller.encode(@data, 'nil - caused by'), 'wrong secret').should == nil
  end
end
