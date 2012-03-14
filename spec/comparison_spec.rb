require 'spec_helper'

describe Gatling::Comparison do

  before do
    apple = Magick::Image.new(100,100) { self.background_color = "green" }
    orange = Magick::Image.new(100,100) { self.background_color = "orange" }
    @apple = Gatling::Image.new(:from_diff, 'apple.png', apple)
    @orange = Gatling::Image.new(:from_diff, 'orange.png', orange)
  end

  describe 'will compare two images' do

    it 'will return true if the images are identical' do
      subject.compare(@apple, @apple)
      subject.match.should == true
    end

    it 'will return false if the images are different' do
      subject.compare(@apple, @orange)
      subject.match.should == false
    end
  end

  describe 'Diff images' do
    it 'will give us a diff' do
      subject.compare(@apple, @orange)
      subject.diff_image.class.should == Gatling::Image
    end
  end
end
