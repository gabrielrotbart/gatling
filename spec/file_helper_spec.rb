require 'spec_helper'
require_relative '../lib/gatling/file_helper'

describe Gatling::FileHelper do

  before do
    # Gatling::FileHelper.new
    path = 'my_image_path'
  end

  describe ':make_dir' do

    it 'should make a directory' do
      Gatling::Configuration.reference_image_path = './tmp'
      FileUtils.should_receive(:mkdir_p).with("./tmp/my_path")
      subject.make_dir 'my_path'

    end

    it 'should raise an execption if directory can not be created' do
      pending
    end
  end

end