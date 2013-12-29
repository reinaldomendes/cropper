module Cropper
  class Engine < ::Rails::Engine
    #isolate_namespace Cropper
    
    config.class.class_eval do
      attr_accessor :mount_at
      attr_accessor :clean_tmp_time
    end
    config.mount_at = '/' 
    config.clean_tmp_time = 15.minutes
    # Check the gem config
    initializer "check config" do |app|
      # make sure mount_at ends with trailing slash
      config.mount_at += '/' unless config.mount_at.last == '/'
    end
    
    initializer "static assets" do |app|
      app.middleware.use ::ActionDispatch::Static, "#{root}/public"
    end
    
    
    initializer "sweeper" do
      #cronjob clean image tmp
      require "eventmachine"
      require 'rufus/scheduler'
      scheduler = Rufus::Scheduler.new
      scheduler.every config.clean_tmp_time do
        #puts "clean"
        Cropper::Image.sweep
      end
    end
    #ActionDispatch::Callbacks.before do
      
    #end
  end
end
