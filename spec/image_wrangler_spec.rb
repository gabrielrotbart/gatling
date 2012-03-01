require 'spec_helper'

describe Gatling::ImageWrangler do
  

  it 'should get the position of the css element' do
    location = OpenStruct.new
    location.y = 2
    location.x = 1

    size = OpenStruct.new
    size.width = 100
    size.height = 200

    mock_element = mock(Capybara::Node::Element)
    mock_element.stub!(:native).and_return(mock_element)
    mock_element.stub!(:location).and_return(location)
    mock_element.stub!(:size).and_return(size)
    # puts subject.methods.sort

    position = Gatling::ImageWrangler.get_element_position(mock_element)
    puts "spec"
    puts mock_element.location.inspect

    position[:x].should eql(1)
    position[:y].should eql(2)
    position[:width].should eql(100)
    position[:height].should eql(200)
  end

  # it 'should exclude a specified element from capture' do
  #  element_to_capture =  

  #  element_to_exclude = 'womething.child' 
  # # @cropped_and_censored_element = (element_to_capture, element_to_exclude).exclude
  #  @cropped_and_censored_element.should_not equal(@element_to_capture)
  #  @cropped_and_censored_element.should_not equal(@element_to_exclude)
  # end

end