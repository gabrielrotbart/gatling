module Gatling
  class ImageWrangler
   
    def self.get_element_position element
puts "inside"
     
      location = element.location
      puts location.x
      puts "x:'#{location.x}', y:'#{location.y}'"
      #element = element.native
      position = Hash.new{}
      position[:x] = location.x
      position[:y] = location.y
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
