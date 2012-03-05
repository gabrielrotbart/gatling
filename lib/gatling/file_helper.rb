module Gatling
  class FileHelper
    #
    def initialize
     @reference_image_file = Gatling::Configuration.reference_image_path
    end

    def make_dir(path)
      # begin
        FileUtils::mkdir_p(File.join(@reference_image_file, path))
      # rescue
        # puts "Could not create directory #{path}. Please make sure you have permission"
      # end
    end

  end
end