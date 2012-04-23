module Gatling
  class Image

    attr_accessor :file_name, :path, :image

    attr_reader :type

    def initialize image, file_name

      @file_name = file_name

      @image = image

    end

    def save type
      path = Gatling::Configuration.path(type[:as])
      FileUtils::mkdir_p(path) unless File.exists?(path)
      @path = File.join(path, @file_name)
      @image.write @path
      @path
    end

    def exists?
      File.exists?(File.join(Gatling::Configuration.path(:reference), @file_name))
    end

  end

  class ImageFromElement < Image

    def initialize element, file_name
      super(image, file_name)

      @image = Gatling::CaptureElement.new(element).capture
    end

  end

  class ImageFromFile < Image

    def initialize file_name
      super(image, file_name)

      @image = Magick::Image.read(File.join(Gatling::Configuration.path(:reference), @file_name)).first
    end


  end
end


