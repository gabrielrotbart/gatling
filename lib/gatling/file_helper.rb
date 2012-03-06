module Gatling
  class FileHelper
    
    def initialize
      reference_image_path = Gatling::Configuration.reference_image_path
      @paths = Hash[reference:reference_image_path,
                    candidate:File.join(reference_image_path, 'candidate'),
                    diff:File.join(reference_image_path, 'diff'),
                    temp:File.join(reference_image_path, 'temp')]
    end

    def make_required_directories
      @paths.each { | key, directory | make_dir directory  }
    end

    def save_image(image, image_name, type)
      path = File.join(path_from_type(type), "#{image_name}")
      image.write path 
      path
    end

    def save_gatling_image(image)
      path = File.join(image.type, "#{image.name}.png")
      image.rmagic_image.write path 
    end

    def exists?(file, type)
      File.exists?(File.join(path_from_type(type), file))
    end

    def load(file, type)
      if exists?(file, type)
        return Magick::Image.read(File.join(path_from_type(type), file)).first
      end
      return false
    end

    private

    def make_dir(path)
      FileUtils::mkdir_p(File.join(path))
    end
    
    def path_from_type(type)
      if @paths.keys.include? type
        return @paths[type]
      else
        raise "Unkown image type '#{type}'"
      end
    end 

  end
end