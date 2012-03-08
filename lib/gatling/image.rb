module Gatling
  class Image

    attr_accessor :file_name, :path

    def initialize(type, file_name, *element)
      
      type == :from_file ? image_from_file(file_name) | type.to_s

    end



    def save type
      @path = File.join(Gatling::Configuration.path_from_type(type[:as]), @file_name)
      @rmagick_image.write @path
      @path
    end

    def exists?
      File.exists?(File.join(Gatling::Configuration.path_from_type(:reference), @file_name))
    end

    private

    def create(type, file_name, *element)

    end

    def image_from_element element
      @rmagick_image = Gatling::CaptureElement.new(element).capture
    end

    def image_from_file file_name
      @rmagick_image = Magick::Image.read(File.join(Gatling::Configuration.path_from_type(:reference), file_name)).first
      @file_name = file_name
    end


  end

end


