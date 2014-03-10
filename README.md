cms-rails
=========
这是一个基于rails开发的内容管理系统组件

##1. 生成新应用
$ rails new appname 

##2. 修改gem包的引用
```sh
$ vi Gemfile
```
```ruby
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
```sh
$ vi db/seeds.rb
```
```ruby
Cms::Engine.load_seed
```
##6. 修改路由
```sh
$ vi config/routes.rb
```
```ruby
mount Cms::Engine =>'/ums'
```
##7. 引入helper类
```sh
$ vi application_controller.rb
```
```ruby
  helper Cms::Engine.helpers
  include Cms::ApplicationHelper  
```
##8. 安装RedactorRails
```sh
$ rails generate redactor:install --devise
$ vi application.js
```
```ruby
//= require redactor-rails
//= require redactor-rails/langs/zh_cn
//= require redactor-rails/plugins/fontsize
//= require redactor-rails/plugins/fontfamily
//= require redactor-rails/plugins/fontcolor
//= require redactor-rails/plugins/fullscreen
```
```sh
$ vi application.css
```
```ruby
*= require redactor-rails
*= redactor-rails/plugins
```
```sh
$ vi application_controller.rb
```
```ruby
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
```sh
$ vi redactor_rails_document_uploader.rb
$ vi redactor_rails_picture_uploader.rb
```
```ruby
  def store_dir
    #"system/redactor_assets/pictures/#{model.id}"
    "redactor/" + model.created_at.strftime("%Y%m/%d/") + 
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