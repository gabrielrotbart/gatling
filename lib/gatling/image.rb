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
      @image = capture_image
    end

    def verify_and_save
      Gatling::Configuration.max_no_tries.times do
        verifiable_image = capture_image
        matches = self.verify(verifiable_image)
        if matches
          self.save
          return() 
        end  
      end
      raise 'Could not save a stable image. This could be due to animations or page load times. Saved a reference image, delete it to re-try'
    end

    private
    def verify(verifiable)
      match = Gatling::Comparison.new(@image,verifiable).matches?
    end

    def capture_image
      Gatling::CaptureElement.capture(@element)
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

