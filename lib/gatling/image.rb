module Gatling
  class Image

    attr_accessor :rmagick_image, :file_name

    def initialize
      @rmagick_image = :rmagick_image
      @file_name = :file_name
    end
    
    # def save file_name, type
    #   path = File.join(Gatling::FileHelper.path_from_type(type[:as]), file_name)
    #   @rmagick_image.write path 
    #   path
    # end

    def save type
      path = File.join(Gatling::FileHelper.path_from_type(type[:as]), @file_name)
      @rmagick_image.write path 
      path
    end

    def exists?(file, type)
      File.exists?(File.join(Gatling::FileHelper.path_from_type(type[:as]), file))
    end

    def base_on_element element
      @rmagick_image = Gatling::CaptureElement.new(element).capture
    end

    def base_on_file file, type
      @rmagick_image = Magick::Image.read(File.join(path_from_type(type), file)).first
    end

  end
end


