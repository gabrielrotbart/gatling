module Gatling
  class Image

    attr_accessor :file_name, :path, :image

    attr_reader :type

    def initialize(type, file_name, element_or_image = nil)

      @file_name = file_name

      case type
      when :from_file
        @image = image_from_file(file_name)
      when :from_element
        @image = image_from_element(element_or_image)
      when :from_diff
        @image = element_or_image
      else
        raise 'WRONG IMAGE TYPE'
      end

    end

    def save type
      path = Gatling::Configuration.path_from_type(type[:as])
      FileUtils::mkdir_p(path) unless File.exists?(path)
      @path = File.join(path, @file_name)
      @image.write @path
      @path
    end

    def exists?
      File.exists?(File.join(Gatling::Configuration.path_from_type(:reference), @file_name))
    end

    private

    def image_from_element element
      Gatling::CaptureElement.new(element).capture
    end

    def image_from_file file_name
      Magick::Image.read(File.join(Gatling::Configuration.path_from_type(:reference), file_name)).first
    end


  end

end


