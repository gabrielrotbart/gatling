module Gatling
  class FileHelper
   
    def initialize
      @reference_image_file = Gatling::Configuration.reference_image_path
    end

    def make_required_directories
      required_directories = ['candidate', 'diff', 'temp']
      required_directories.each { | directory | make_dir directory }
    end

    def make_dir(path)
      FileUtils::mkdir_p(File.join(@reference_image_file, path))
    end



  end
end