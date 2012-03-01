require 'spec_helper'

describe Gatling::ImageWrangler do
  

  it 'should get the position of the css element' do

    #Overiding the stupid public method :y of YAML module
    class OpenStruct
      remove_method :y rescue nil
      alias y psych_y
      private :y
    end
  
    location = OpenStruct.new
    location.x = 1
    location.y = 2

    size = OpenStruct.new
    size.width = 100
    size.height = 200

    mock_element = mock
    mock_element.stub(:native).and_return(mock_element)
    mock_element.stub(:location).and_return(location)
    mock_element.stub(:size).and_return(size)

    position = Gatling::ImageWrangler.get_element_position(mock_element)

    position[:x].should eql(1)
    position[:y].should eql(2)
    position[:width].should eql(100)
    position[:height].should eql(200)
      
  end

end