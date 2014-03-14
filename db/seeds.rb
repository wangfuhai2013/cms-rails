# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

site = Cms::Site.create(name:'默认站点',site_key:'site',is_enabled:true)
site = Cms::Theme.create(name:'默认模板',site:site,template_type:'D',ua_type:'P',is_enabled:true)
Cms::Function.create([{name:"静态页面",method:'static'},{name:"网站首页",method:'home'},
	                  {name:"在线反馈",method:'feedback'}])
info = Cms::Function.create(name:"信息管理",method:'info')
Cms::Function.create([{name:"信息列表",method:'list',parent_function:info},
	                  {name:"信息显示",method:'show',parent_function:info}])

function = Ums::Function.create([{name:"内容管理",controller:'cms'}])
role = Ums::Role.all.first
role.functions.push(function)
role.save