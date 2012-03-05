module Gatling
  class FileHelper

    PATHS = Hash[candidate:'candidate',
          diff:'diff',
          reference:'.',
          temp:'temp']

    def initialize
      @reference_image_file = Gatling::Configuration.reference_image_path
    end

    def make_required_directories
      PATHS.each { | key, directory | make_dir directory  }
    end

    def make_dir(path)
      FileUtils::mkdir_p(File.join(@reference_image_file, path))
    end

    def save_image(image, image_name, type)
      path = File.join @reference_image_file, get_path_from_type(type), "#{image_name}.png"
      image.write path 
      path
    end

    def save_gatling_image(image)
      path = File.join @reference_image_file, image.type, "#{image.name}.png"
      image.rmagic_image.write path 
    end

    private
    
    def get_path_from_type type
      if PATHS.keys.include? type
        return PATHS[type]
      else
        raise "Unkown image type '#{type}'"
      end
    end 

  end
end