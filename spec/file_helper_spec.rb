require 'spec_helper'

describe Gatling::FileHelper do

  describe ':make_dir' do
    before :all do
      Gatling::Configuration.reference_image_path = './gatling' 
    end

    it 'should make required directories' do
      FileUtils.should_receive(:mkdir_p).with './gatling/candidate'
      FileUtils.should_receive(:mkdir_p).with './gatling/diff'
      FileUtils.should_receive(:mkdir_p).with './gatling'
      FileUtils.should_receive(:mkdir_p).with './gatling/temp'  
      Gatling::FileHelper.make_required_directories
    end

    it 'should save an image to the path for the type' do
      image_mock = mock(Magick::Image)
      image_mock.should_receive(:write).with './gatling/candidate/image_file_name.png'

      Gatling::FileHelper.save_image(image_mock, 'image_file_name.png', :candidate)
    end

    it 'should thrown an error with an unknown image type' do
      image_mock = mock(Magick::Image)
      expect { Gatling::FileHelper.save_image(image_mock, 'image_file_name', :unknown)}.should raise_error "Unkown image type 'unknown'"
    end

    it 'should check if a file exists, with the file name and type' do
      File.should_receive(:exists?).with './gatling/image.png'
      Gatling::FileHelper.exists?('image.png', :reference)
    end

    it 'should load an image and return it' do
      File.stub(:exists?).and_return true
      image_mock = mock(Magick::Image)
      Magick::Image.should_receive(:read).with('./gatling/temp/image.png').and_return([image_mock])
      image = Gatling::FileHelper.load('image.png', :temp)
    end

    it 'should return false trying to load an image that doesnt exist' do
      File.should_receive(:exists?).and_return false
      #expect{subject.load('image.png', :temp)}.should raise_error(Magick::ImageMagickError, "unable to open file `./gatling/temp/image.png' @ error/png.c/ReadPNGImage/3633")
      Gatling::FileHelper.load('image.png', :temp).should eql false
    end
  end
end