module Cropper
  module Rails
    module ActiveRecord
      def self.included(base)
        base.send :extend,ClassMethods
      end
      module ClassMethods
        def self.extended(base)
        
        end
        def cropper(attr, options={})                
          method = Cropper.attr_name_for(attr)
          opt_attr = Cropper.attr_options_for(attr)          
          cattr_accessor opt_attr.to_sym          
          self.send("#{opt_attr}=",options)
          cattr_reader opt_attr.to_sym          
          
          define_method(method) do
            ret = send(attr)
            if ret.respond_to?(:path)
              ret = ret.path
            end
            ret
          end
          define_method("#{method}=") do|value|          
            if value.present?
              old_val = send(attr)
              value =  File.open(value) if old_val.respond_to?(:path)
              send("#{attr}=",value) 
            end
          end                
        end
      end
    
    end
  end
end


ActiveRecord::Base.send :include, Cropper::Rails::ActiveRecord
