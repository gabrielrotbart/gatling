require 'spec_helper'

describe Gatling::CaptureElement do
  
  before do

    capybara_node = mock (Capybara::Node::Element)
    Gatling::Configuration.reference_image_path="./"
    Gatling::CaptureElement.new capybara_node, capybara_node
  end

  it 'should get the position of the css element' do
    mock_element = mock(Capybara::Node::Element)
    mock_element.stub!(:location).and_return('1')
    
    position = subject.get_element_position(mock_element)
    position[:x].should eql(1)
  end

  # it 'should exclude a specified element from capture' do
  #  element_to_capture =  

  #  element_to_exclude = 'womething.child' 
  # # @cropped_and_censored_element = (element_to_capture, element_to_exclude).exclude
  #  @cropped_and_censored_element.should_not equal(@element_to_capture)
  #  @cropped_and_censored_element.should_not equal(@element_to_exclude)
  # end

end