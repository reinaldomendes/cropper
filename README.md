#cropper
=======
Rails gem with Jquery and [Jcrop](deepliquid.com/content/Jcrop.html)

# Expiremental Version use for your account and Risk


## How does works.

Crops an image and send to your form, when you update/create your model, the cropped
image path is sent to your model. integrating with paperclip in a simple way.


## Installation

Add Cropper to your Gemfile:

```ruby
gem 'cropper', :git => 'git://github.com/reinaldomendes/cropper.git'
```
And run `bundle install` within your app's directory.


## in your model
### without paperclip
```ruby
#User
 class User < ActiveRecord::Base   
   cropper :image
   def image= file
    FileUtils.copy(file,SOME_DIRECTORY)
    #.. do something
    super SOME_DIRECTORY
    
   end
   ...
 end
```

### using paperclip
If you are using [paperclip](https://github.com/thoughtbot/paperclip)
go to your active record model.

```ruby
#User
 class User < ActiveRecord::Base
   has_attached_file :image
   cropper :image
   ...
 end
```

## in your view
### Using prettyPhoto

```erb
 #new.html.erb
 <%= form_for(@user) do |f| %>
    <%= f.crop_field :file,:rel => 'prettyPhoto' do %>
      .... Any Html Here
    <%end%>
 <%end %>
```
### Using iframe 
```erb
 #new.html.erb
 <iframe id="myIframe"></iframe>
 <%= form_for(@user) do |f| %>
    <%= f.crop_field :file,:target => 'myIframe' do %>
      .... Any Html Here
    <%end%>
 <%end %>
```
also you can bind events with jQuery or other library, the inportant thing to
observe is: the url of link created by "f.crop_field" method.


## Modifying the behavior of Jcrop
You can call methods of 'jcrop_api'
```html
 //new.html.erb
<script type="text/javascript">
//<![CDATA[
  window.cropper = {
    init: function(jcrop_api){// the init method of copper object expose the 'jcrop_api' object
      
    jcrop_api.setOptions({
        'aspectRatio' : 3/4,
        'minSize' : [60,80]
      });
    }
  }
//]]>
</script> 
```

## Temporary Image Files
Cropper uses the rails temp dir/cropper to save temporary image files. Those
files is auto excluded in certain time.

## configuration
You can control this time by defining the following initializer
```ruby
 #config/initializers/cropper.rb
 Cropper.setup do| config|
   cropper.clean_tmp_time = 15.minutes #clean temporary files time
   cropper.mount_at = "/" # scope for rails routes
 end
```



## More reference about Jcrop
[http://deepliquid.com/content/Jcrop.html](deepliquid.com/content/Jcrop.html)

## TODO
* Create rails generators for more flexibility of user
* Simplify cropper views, separating embed js in other files when possible.





