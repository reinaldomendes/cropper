::Rails.application.routes.draw do
  mount_at =  Cropper::Engine.config.mount_at
  scope "#{mount_at}/:input_id" do
    namespace :cropper do
      resources :images, :only => [:new,:edit,:create,:update,:show] do
        member do
          get :finish
        end
      end
    end
  end
end
