module Cropper
  module Rails
    module FormBuilder
      def self.included(base)
        base.send :extend,ClassMethods
        base.class_eval do
          def crop_field(method,*args,&block)
            method = Cropper.attr_name_for(method)
            
            @template.content_tag :span,:class => 'cropper_wrapper' do
              
              ret =""  
              
              
              input = @template.text_field(@object_name, method, {})                                          
              ret <<   input
              input_id = (input.to_s.match /id=["'](\w+)/)[1]
              
              
              
              # ary << InstanceTag.new(object_name,.text_field(method,nil, :value => nil)
              url = @template.new_cropper_image_path :input_id => input_id
              if block_given?
                args.insert(0,url)
              else
                args.insert(1,url)
              end
              
              ret << @template.link_to(*args,&block)
              
              ret.html_safe
              
              
            end            
          end
          
        end#end class_eval
      end
      
      
      
      module ClassMethods
      
      end
    
    end
  end
end

ActionView::Helpers::FormBuilder.send :include, Cropper::Rails::FormBuilder
