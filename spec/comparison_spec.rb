require 'spec_helper'

describe Gatling::Comparison do

  before do
    apple = Magick::Image.new(100,100) { self.background_color = "green" }
    orange = Magick::Image.new(100,100) { self.background_color = "orange" }
    @apple = Gatling::Image.new(apple, "apple.png")
    @orange = Gatling::Image.new(orange, "orange.png")
  end

  describe 'will make images from ' do

  end

  describe 'will compare two images' do

    it 'will return true if the images are identical' do
      Gatling::Comparison.new(@apple, @apple).matches?.should == true
    end

    it 'will return false if the images are different' do
      Gatling::Comparison.new(@orange, @apple).matches?.should == false
    end
  end

  describe 'Diff images' do
    describe 'for two images with the same size' do
      it 'will be generated' do
        Gatling::Comparison.new(@apple, @orange).diff_image.class.should == Gatling::Image
      end
    end

    describe 'for two images with different sizes' do
      before do
        apple = Magick::Image.new(30,300) { self.background_color = "green" }
        orange = Magick::Image.new(80,100) { self.background_color = "orange" }
        @apple = Gatling::Image.new(apple, "apple.png")
        @orange = Gatling::Image.new(orange, "orange.png")

        @diff_image = Gatling::Comparison.new(@apple, @orange).diff_image
      end

      it 'will be generated' do
        @diff_image.class.should == Gatling::Image
      end

      it 'will be extended to cover the difference in both images' do
        @diff_image.image.columns.should eql 80
        @diff_image.image.rows.should eql 300
      end
    end
  end
end
