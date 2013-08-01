require 'spec_helper'

describe Gatling::CaptureElement do

  # creating a dummy class to test a module
  class SomeClass
  end

  before :each do
    subject = SomeClass.new
    subject.extend(Gatling::CaptureElement)
  end

  after :each do
    config_clean_up
  end

  it '.capture should return a cropped image' do
      capybara_element = mock(Capybara::Node::Element)
      position = {:x => 1, :y => 2, :width => 100, :height => 200}
      magick_image = Magick::Image.new(position[:width],position[:height])


      subject.should_receive(:get_element_position).with(capybara_element).and_return(position)
      subject.should_receive(:take_screenshot).and_return(magick_image)
      subject.should_receive(:crop_element).and_return(magick_image)

      image = subject.capture(capybara_element)
      image.class.should == Magick::Image
  end

end

