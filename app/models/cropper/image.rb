module Cropper
  class Image 
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming
    
    
    TEMP_PATH = "#{::Rails.root}/tmp/cropper"
    
    def self.sweep      
      Dir["#{TEMP_PATH}/*"].each do |dir|
        
        limit = File.mtime(dir) + Cropper::Engine.config.clean_tmp_time
        if Time.current > limit
          FileUtils.rm_r dir, :force => true
        end
      end
    end
    

    
    
    
    CROP_ATTRIBUTES = ['x','y','x2','y2','w','h','img_height','img_width']
    
    attr_accessor :image
    #attr_accessor :id
    attr_accessor :persisted
    alias :persisted? persisted
    
    validates :image, :presence => true
    
    def initialize(attributes={})
      @id=nil
      attributes = attributes.with_indifferent_access      
      self.id = attributes[:id]      
    end
    
    def update_attributes(attributes= {})
      attributes.each do |k,v|
        if self.respond_to?(k)
          self.send("#{k}=",v)
        end
      end
      valid?
    end
    
    protected
    

    
    
    
    public
    def image=value      
      if value.is_a?(ActionDispatch::Http::UploadedFile)             
        filename = "#{TEMP_PATH}/#{File.basename(value.path)}/original/#{value.original_filename}"        
        
        FileUtils.mkdir_p(File.dirname(filename))
        FileUtils.copy_file(value.path,filename,false)
        @image = filename
        
      
      end            
    end
    def id      
      
      if persisted?       
        path = self.image
        ary = path.to_s.split(File::SEPARATOR)        
        @id = ary[ary.length - 3]        
      else
        @id
      end
    end
    
    def id= value
      if value.present?        
        base_path = "#{TEMP_PATH}/#{value}/original"
        if File.directory?(base_path)
          file = Dir["#{base_path}/*"].first                    
          if File.file?(file)
            @id = value          
            @image= file
          end
        end
      end
    end
    
    def persisted?
      self.image.present?
    end
    
    def cropped_image_path
      new_name = self.image.to_s.gsub('/original/','/cropper/')
      FileUtils.mkdir_p(File.dirname(new_name))
      new_name
    end
    def cropped_image      
      new_name = cropped_image_path      
      new_name if File.file?(new_name)
    end
    
    def crop(attributes)
      require 'RMagick'
      original_list = Magick::ImageList.new(self.image)
      x = attributes[:x].to_f
      y = attributes[:y].to_f
      w = attributes[:w].to_f
      h = attributes[:h].to_f
      
      img_width = attributes[:img_width].to_f
      img_height = attributes[:img_height].to_f
      original_img = original_list.first
      
      o_w = original_img.columns
      o_h = original_img.rows
      
      yfactor = o_h / img_height
      xfactor = o_w / img_width
      
      new_y = y * yfactor
      new_x = x * xfactor
      #raise "#{y} #{new_y}"
      
      new_h = h * yfactor
      new_w = w * xfactor      
      
      
      cropped = original_list.crop(new_x,new_y,new_w,new_h)
      new_name = cropped_image_path      
      
      cropped.write(new_name)      
    end
    
  end    
  
end
