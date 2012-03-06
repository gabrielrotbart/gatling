module Gatling
  class FileHelper
    class << self

      def make_required_directories
        Gatling::Configuration.paths.each { | key, directory | make_dir directory  }
      end

      def path_from_type(type)
        if Gatling::Configuration.paths.keys.include? type
          return Gatling::Configuration.paths[type]
        else
          raise "Unkown image type '#{type}'"
        end
      end 

      private

      def make_dir(path)
        FileUtils::mkdir_p(File.join(path))
      end
      
    end
  end
end