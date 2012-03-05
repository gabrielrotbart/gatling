require 'spec_helper'
require_relative '../lib/gatling/file_helper'

describe Gatling::FileHelper do

  describe ':make_dir' do
    before :all do
      Gatling::Configuration.reference_image_path = './gatling' 
    end

    it 'should make required directories' do
      FileUtils.should_receive(:mkdir_p).with './gatling/candidate'
      FileUtils.should_receive(:mkdir_p).with './gatling/diff'
      FileUtils.should_receive(:mkdir_p).with './gatling/temp'  
      subject.make_required_directories
    end


    it 'should call FileUtils with the image reference path combined with the path we want to make' do
      FileUtils.should_receive(:mkdir_p).with './gatling/my_path'
      subject.make_dir 'my_path'
    end

  end
end