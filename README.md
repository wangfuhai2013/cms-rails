cms-rails
=========
这是一个基于rails开发的内容管理系统组件

##1. 生成新应用
$ rails new appname 

##2. 修改gem包的引用
```ruby
$ vi Gemfile
gem 'will_paginate', '~> 3.0'
gem 'redactor-rails' ,:git => 'git://github.com/wangfuhai2013/redactor-rails.git'
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
```
```sh
$ vi application.css

*= require redactor-rails
```
##8. 运行数据库脚本
```sh
$ rake db:migrate
$ rake db:seed
```