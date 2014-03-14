class Cms::ThemesController < ApplicationController
  before_action :set_site, only: [:index, :create]
  before_action :set_cms_theme, only: [:show, :edit, :update, :destroy]

  # GET /site/themes
  # GET /site/themes.json
  def index
    @cms_themes = Cms::Theme.where(site_id:@site.id)
   #@cms_themes = Cms::Theme.all
  end

  # GET /site/themes/1
  # GET /site/themes/1.json
  def show
    @cms_templates = @cms_theme.templates.joins(:column).where("cms_columns.parent_column_id is NULL").
                      order("cms_columns.the_order ASC")
  end

  # GET /site/themes/new
  def new
    @cms_theme = Cms::Theme.new
    @cms_theme.is_enabled = true
  end

  # GET /site/themes/1/edit
  def edit
  end

  # POST /site/themes
  # POST /site/themes.json
  def create
    @cms_theme = Cms::Theme.new(cms_theme_params)
    @cms_theme.site_id = @site.id # 站点不可修改

    respond_to do |format|
      if @cms_theme.save
        #根据站点栏目创建模板
        site = Cms::Site.find(@cms_theme.site_id)
        site.columns.each do |column|
            template = Cms::Template.new
            template.theme = @cms_theme
            template.column = column
            template.function = column.function
            template.content = column.function.content
            template.save           
        end

        format.html { redirect_to @cms_theme, notice: 'Theme was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cms_theme }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/themes/1
  # PATCH/PUT /site/themes/1.json
  def update
    respond_to do |format|
      if @cms_theme.update(cms_theme_params)
        format.html { redirect_to @cms_theme, notice: 'Theme was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_theme.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/themes/1
  # DELETE /site/themes/1.json
  def destroy
    if @cms_theme.site.themes.size == 1 
      flash[:error] = "该模板是此站点唯一模板，不能删除"
    else
      @cms_theme.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to cms.themes_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Cms::Site.all.take
    end

    def set_cms_theme
      @cms_theme = Cms::Theme.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_theme_params
      params.require(:theme).permit(:name,:path,:template_type,:ua_type,:is_enabled,
                                    :template_css,:template_layout,:template_js)
    end
end
