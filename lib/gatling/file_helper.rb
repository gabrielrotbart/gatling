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
      path = File.join get_path_from_type(type), "#{image_name}.png"
      image.write path 
      path
    end

    def save_gatling_image(image)
      path = File.join image.type, "#{image.name}.png"
      image.rmagic_image.write path 
    end

    private

    def make_dir(path)
      FileUtils::mkdir_p(File.join(path))
    end
    
    def get_path_from_type type
      if @paths.keys.include? type
        return @paths[type]
      else
        raise "Unkown image type '#{type}'"
      end
    end 

  end
end