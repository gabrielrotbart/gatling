module Gatling
  class Image

    attr_accessor :rmagick_image, :file_name, :path

    def initialize
      @rmagick_image = :rmagick_image
      @file_name = :file_name
    end
    
    def save type
      @path = File.join(Gatling::Configuration.path_from_type(type[:as]), @file_name)
      @rmagick_image.write @path 
      @path
    end

    def exists?
      File.exists?(File.join(Gatling::Configuration.path_from_type(:reference), @file_name))
    end

    def base_on_element element
      @rmagick_image = Gatling::CaptureElement.new(element).capture
    end

    def base_on_file file_name
      @rmagick_image = Magick::Image.read(File.join(Gatling::Configuration.path_from_type(:reference), file_name)).first
      @file_name = file_name
    end

  end
end


