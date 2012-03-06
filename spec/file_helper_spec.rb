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

    it 'should thrown an error with an unknown image type' do
      image_mock = mock(Magick::Image)
      expect { Gatling::FileHelper.path_from_type(:unknown)}.should raise_error "Unkown image type 'unknown'"
    end
  end
end