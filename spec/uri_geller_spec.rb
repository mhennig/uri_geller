require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe UriGeller do
  before do
    @secret  = "test-123"
    # @decoded = {:name => "John Doe", :score => "1001", :deposit => "98.76", :comment => "ÄÖÜäöü123=", :birthdate => "1979/05/07"}
    @decoded = UriGeller.assertion
    @encoded = "eAHtVMtuGzEM_BViz8Zm3TZxXaC39FL0mlsujMS1CUiiooeRoOi_d7Ruv6Eo4MMKq5E4HA4h_pwSR5m-TN_tnOjRZNpN1VkZ0H5Z9th6yVa1ATh-ng8PQJzFKGkgz31Z3Kex-odtdWOVDVk3ZHX7Dx-_IuhFSzt7bhvz8XB8vlvu8R1wFCydQPYDaSNprj2St2CFkJYgr-3IWarimrReiL1mreo0nUiC4rSKRwSJ9hrNU5OYEa3JqVffU6PeKPAL-EnalVso8ikxcdDXzjM9NZKkEeQUdfxcsOW4o9eulZLVVroneZPitHFTS9RD4OjsyjwuQdTItFFqxmUShvIITXatAKnaTI-DknsT0tKh6VqsJiqSi5wleSmoHMDFQs9IJ5CDSklqFXIawl-LUFCntZ-UG6UhiDIXbHqZ6dubk9wEjlWFB-Yci8M917OiESMCVeRi6tFNuDicQlLXQ-ZRN9m6wmYmL1XKOI0WhgweBinsqH987XG-de9_7h5e4UXK--0ljrFze4m3OfrP5uj06zfeRsL28ca9067a3e7f90cd6adb11acdca7b615432057b5"
  end
  
  it "decodes in a predictable manner" do
    
    puts UriGeller::decode(@encoded, @secret).to_yaml
    
    UriGeller.decode(@encoded, @secret).should == @decoded
  end
  
  it "encodes same output for same input" do
    UriGeller.encode(@decoded, @secret).should == UriGeller.encode(@decoded, @secret)
  end
  
  it "decodes same output for same input" do
    # UriGeller.decode(@encoded, @secret).should == UriGeller.decode(@encoded, @secret)
  end
  
  it "spits out what came in" do
    UriGeller.decode(UriGeller.encode(@decoded)).should == @decoded
  end
  
  it "can not decode when data was changed" do
    UriGeller.decode(UriGeller.encode(@decoded) +  "some-salt").should == nil
    UriGeller.decode(@encoded + "some salt", @secret).should == nil
  end
  
  it "can not decode with a wrong secret" do 
    UriGeller.decode(UriGeller.encode(@decoded, @secret), 'wrong secret').should == nil
    UriGeller.decode(@encoded,  'wrong-secret').should == nil
  end
  
  it "produces strings that are url-conform" do
    
    data = { :name => "qtweurztüölö)(Z//&)",
      :comment => ('ü' * 2000)
    }
    UriGeller.encode(data, @secret).length.should < 2000;
  end
end
