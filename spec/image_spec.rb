require 'spec_helper'

describe Gatling::Image do

  before :all do
    Gatling::Configuration.reference_image_path = './gatling' 
  end

  it 'should populate itself when loading an image' do
    pending
    File.stub(:exists?).and_return true
    image_mock = mock(Magick::Image)
    Magick::Image.should_receive(:read).with('./gatling/image.png').and_return([image_mock])
    subject.load('image.png')
    subject.rmagick_image.should == image_mock
    subject.file_name.should == 'image.png'
  end


end
