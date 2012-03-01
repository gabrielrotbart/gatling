module Gatling
  class ImageWrangler
   
    def self.get_element_position element
      element = element.native
      position = Hash.new{}
      position[:x] = element.location.x
      position[:y] = element.location.y
      position[:width] = element.size.width
      position[:height] = element.size.height
      position
    end

    def self.crop_element image, element_to_crop
      position = get_element_position(element_to_crop)
      @cropped_element = image.crop(position[:x], position[:y], position[:width], position[:height])
    end

    def self.exclude image, element_to_exclude
    end

  end
end
