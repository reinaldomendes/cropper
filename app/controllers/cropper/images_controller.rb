require_dependency "cropper/application_controller"

module Cropper
  class ImagesController < ApplicationController
    
    def resource_class
      Cropper::Image
    end
    def resource      
      @image ||= resource_class.new(:id => params[:id]) 
    end
    helper_method :resource
    def __(*args)
      hsh = args.pop if args.length > 1
      hsh ||= {}
      unless hsh.is_a?(Hash)
        args << hsh
        hsh = {}
      end
      hsh = hsh.reverse_merge :scope => "cropper.images", :default => args.first
      args << hsh
      view_context.t(*args)
    end
    helper_method :__
    
    def prefix_params
      resource_class.model_name.underscore.gsub('/','_')
    end
    helper_method :prefix_params
    
    #show image
    def show
      file = resource.image
      if params[:cropped]
        file = resource.cropped_image
      end
      send_file file, :disposition => 'inline'
    end
    # show from
    def new
      
    end
    
    # upload image
    def create      
      model_params = params[prefix_params]
      if resource.update_attributes(model_params)                
        
         hsh = {
          :input_id => params[:input_id],
          :action => :edit,
          :controller => params[:controller],
          :id => resource.id
        }  
        
        redirect_to url_for(hsh)
      else
        render :action => :new
      end
      
    end
    
    # show image to crop
    def edit
      
    end
    
    # finish image crop
    def finish
      
    end
    
    # crop image
    def update
      model_params = params[prefix_params]
      resource.crop(model_params)
      if resource.cropped_image 
        hsh = {
          :input_id => params[:input_id],
          :action => :finish,
          :controller => params[:controller],
          :id => resource.id
        }        
        redirect_to url_for(hsh)
      else
        render :action => :edit
      end
      
    end
  end
end
