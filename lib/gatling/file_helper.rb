module Gatling
  class FileHelper

    PATHS = Hash[candidate:'candidate',
          diff:'diff',
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

    def save_image(image, image_name, path)
      begin
        image.write("#{path}/#{image_name}.png")
        image = "#{path}/#{image_name}.png"
      rescue
        raise "Could not save #{image_name} to #{path}. Please make sure you have permission"
      end
    end
  end
end