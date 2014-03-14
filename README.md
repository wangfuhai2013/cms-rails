cms-rails
=========
这是一个基于rails开发的内容管理系统组件

##1. 生成新应用
$ rails new appname 

##2. 修改gem包的引用
```ruby
$ vi Gemfile
gem 'will_paginate', '~> 3.0'
gem 'redactor-rails' ,:git => 'git://github.com/SammyLin/redactor-rails.git'
gem "carrierwave"
gem "mini_magick"
gem 'ums',:git => 'git://github.com/wangfuhai2013/ums-rails.git'
gem 'cms',:git => 'git://github.com/wangfuhai2013/cms-rails.git'
```
##3. 安装gem包 
```sh
$ bundle install
```
##4. 将数据库脚本拷过来
```sh
$ rake cms:install:migrations
```
##5. 增加初始化数据脚本
```ruby
$ vi db/seeds.rb

Cms::Engine.load_seed
```
##6. 修改路由
```ruby
$ vi config/routes.rb

mount Cms::Engine =>'/cms'
```
##7. 增加配置项
```ruby
$ vi config/application.rb
...
    config.time_zone = 'Beijing'
    config.active_record.default_timezone = :local

    config.upload_path = "upload"
    config.upload_extname = ".png;.bmp;.jpeg;.jpg;.gif;.mp3"
    config.image_max_width = 720
    config.image_thumb_size = "150x150^" 

    WillPaginate.per_page = 15
...
```
##8. 引入helper类
```ruby
$ vi application_controller.rb

  helper Cms::Engine.helpers
  include Cms::ApplicationHelper  
```
##9. 安装RedactorRails
```ruby
$ rails generate redactor:install --devise
$ vi application.js

//= require redactor-rails
//= require redactor-rails/langs/zh_cn
//= require redactor-rails/plugins/fontsize
//= require redactor-rails/plugins/fontfamily
//= require redactor-rails/plugins/fontcolor
//= require redactor-rails/plugins/fullscreen
```
```sh
$ vi application.css

*= require redactor-rails
*= require redactor-rails/plugins
```
```ruby
$ vi application_controller.rb

class ApplicationController < ActionController::Base
  def redactor_authenticate_user!
     true
  end
  def redactor_current_user
    nil
  end  
end
#hack for redactor
class NilClass
def id
  0
end
end
```
```ruby
$ vi redactor_rails_document_uploader.rb
$ vi redactor_rails_picture_uploader.rb

  def store_dir
    #"system/redactor_assets/pictures/#{model.id}"
    "upload/redactor/" + model.created_at.strftime("%Y%m/%d/") + 
          "#{model.id}_" + Digest::SHA1.hexdigest(model.id.to_s+"redactor")[0,6].to_s
  end
  def cache_dir
    Rails.root.join('tmp/redactor')
  end
```
##8. 运行数据库脚本
```sh
$ rake db:migrate
$ rake db:seed
```