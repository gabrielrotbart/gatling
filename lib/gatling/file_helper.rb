module Gatling
  class FileHelper
    class << self

      def make_required_directories
        Gatling::Configuration.paths.each { | key, directory | make_dir directory  }
      end

      private

      def make_dir(path)
        FileUtils::mkdir_p(File.join(path))
      end
      
    end
  end
end