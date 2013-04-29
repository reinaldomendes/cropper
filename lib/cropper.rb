require "cropper/engine"

require "cropper/rails" if defined?(Rails)


module Cropper
  def self.attr_name_for(attr)
    "#{attr}_cropped"
  end
  #def self.attr_options_for(attr)
   # "#{attr}_cropped_options"
  #end
end
