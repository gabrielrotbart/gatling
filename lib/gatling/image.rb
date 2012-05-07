module Gatling
  class Image

    attr_accessor :file_name, :path, :image

    attr_reader :type

    def initialize image, file_name

      @file_name = file_name

      @image = image

    end

    def save type
      @path = path(type)
      FileUtils::mkdir_p(File.dirname(@path)) unless File.exists?(@path)
      @image.write @path
      @path
    end

    def exists?
      File.exists?(path)
    end

    def path type={:as => :reference}
      @path = File.join(Gatling::Configuration.path(type[:as]), @file_name)
    end

  end

  class ImageFromElement < Image

    def initialize element, file_name
      super(image, file_name)

      @image = Gatling::CaptureElement.new(element).capture
    end

    #TODO: make save a relevant subclass method
  end

  class ImageFromFile < Image

    def initialize file_name
      super(image, file_name)
      @image = Magick::Image.read(path).first
    end

    #TODO: make save a relevant subclass method

  end
end

