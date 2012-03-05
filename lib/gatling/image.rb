module Gatling
  class Image
    attr_accessor :rmagic_image, :name, :type
  
    def initialize (opts={})
      @image = opts[:rmagic_image]
      @name = opts[:name]
      @type = opts[:type]
    end

  end
end