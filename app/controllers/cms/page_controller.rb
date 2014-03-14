class Cms::PageController < ApplicationController

  include Cms::FeedbacksHelper
  include Cms::InfosHelper

  skip_before_filter :verify_authenticity_token,:authorize
  before_action :set_site_and_theme
  layout  false

  def index
      #获取栏目对象
      if params[:column].nil?
         column = @site.columns.order(:the_order).take
      else
         column = @site.columns.where(:path => params[:column]).take
      end
      if column.nil?
        logger.error("站点栏目不存:@site.name:"+@site.name+",column:"+params[:column])
        render text: "<p>该站点栏目暂不存在,请联系网站管理员</p>"
        return
      end
      #更新计数器
      @site.update_column(:view_count,@site.view_count + 1)
      column.update_column(:view_count,column.view_count + 1) if column
      if params[:child_column].nil? #未指定子栏目
        @site_column = column        
        method = column.function.method
      else #指定子栏目，以子栏目为准
        @site_column = @site.columns.where(:parent_column_id => column.id ,:path => params[:child_column]).take
        method = @site_column.function.parent_function.method + "_" + @site_column.function.method
        @site_column.update_column(:view_count,@site_column.view_count + 1)
      end
      logger.debug("@site_column:"+@site_column.name+",method:"+method+",theme:"+@theme.name)           

      #执行栏目方法
      if respond_to?(method)
      	send method 
      else
        logger.info("method:"+ method+" is inexistence,site:"+@site.id.to_s+"("+@site.name+")"+",column:"+@site_column.name)
      end
      
      #通过模板生成响应页面
      unless performed?
        #template = Site::Template.where(theme:@theme,column:@site_column).take
        result_tempalte = ''
        if @theme.template_type =='D' # 数据库模板
          template = @theme.templates.where(column:@site_column).take

          body_template = template.content if template
          layout = @theme.template_layout unless @theme.template_layout.blank?          
        else #文件模板
          if @theme.path && @theme.path.start_with?('/') 
            theme_path = @theme.path
          else
            theme_path = File.join(Rails.root,'public','theme', @theme.path.to_s) #TODO 模板文件安全问题
          end
          layout_file = File.join(theme_path,'layout.html.erb')
          layout = File.read(layout_file) if File.file?(layout_file)

          if @site_column.parent_column
            body_file = File.join(theme_path,@site_column.parent_column.path,@site_column.path + ".html.erb")
          else
            if @site_column.child_columns.size > 0
              body_file = File.join(theme_path,@site_column.path,"index.html.erb") #有子栏目
            else
              body_file = File.join(theme_path,@site_column.path + ".html.erb") #无子栏目
            end
          end       
          logger.debug("body_file:" + body_file)
          body_template = File.read(body_file) if File.file?(body_file)

        end
        if layout
          result_tempalte = layout.sub("{{body_template}}",body_template.to_s) 
        else
          result_tempalte = body_template if body_template
        end

        #logger.debug("result_tempalte:" + result_tempalte.to_s)
        render inline: result_tempalte
      end
  end

  def css
    css = @theme.template_css
  	render text: css, content_type: "text/css"
  end

  def js
    js = @theme.template_js
  	render js: js
  end
  
  private
  def set_site_and_theme 
  	@site = Cms::Site.all.take
    themes = @site.themes.where(is_enabled:true) if @site
    if @site.nil? || !@site.is_enabled || themes.nil? || themes.size == 0
      logger.error("set_site_and_theme error:@site:"+@site.to_s+",themes:"+themes.to_s)
      render text: "<p>该站点暂不可用,请联系网站管理员</p>"
      return
    end
    is_mobile = false #默认使用电脑模板
    is_mobile = true if request.user_agent && request.user_agent.downcase.match("ios|android|phone")
    @theme = themes[0] 
    themes.each do |t|
      @theme = t if t.ua_type == 'P' && !is_mobile
      @theme = t if t.ua_type == 'M' && is_mobile   
    end
  end
end
