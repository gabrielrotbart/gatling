module Gatling
  class Image

    attr_accessor :file_name, :path, :image

    attr_reader :type

    def initialize image, file_name

      @file_name = file_name

      @image = image

    end

    def save(type = :reference)
      save_path = path(type)
      FileUtils::mkdir_p(File.dirname(save_path)) unless File.exists?(save_path)
      @image.write save_path
      save_path
    end

    def exists?
      File.exists?(path)
    end

    def path(type = :reference)
      @path = File.join(Gatling::Configuration.path(type), @file_name)
    end

  end

  class ImageFromElement < Image

    def initialize(element, file_name)
      super(image, file_name)
      @element = element
      @image = Gatling::CaptureElement.capture(element)
    end

    def verify_and_save
      comparable = Gatli
      self.compare
    end

    private
    def compare

    end

    def capture_image
      @image = Gatling::CaptureElement.new(@element).capture
    end

    #TODO: make save a relevant subclass method
  end

  class ImageFromFile < Image

    def initialize(file_name)
      super(image, file_name)

      @image = Magick::Image.read(path).first
    end

    #TODO: make save a relevant subclass method

  end
end

