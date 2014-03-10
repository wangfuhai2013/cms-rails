class Cms::SitesController < ApplicationController
  before_action :set_site, only: [:show, :edit, :update, :destroy]

  # GET /site/sites
  # GET /site/sites.json
  def index
    @sites = Cms::Site.all
  end

  # GET /site/sites/1
  # GET /site/sites/1.json
  def show
  end

  # GET /site/sites/new
  def new
    @site = Cms::Site.new
    @site.is_enabled = true
  end

  # GET /site/sites/1/edit
  def edit
  end

  # POST /site/sites
  # POST /site/sites.json
  def create
    @site = Cms::Site.new(cms_site_params)

    respond_to do |format|
      if @site.save
        format.html { redirect_to cms.sites_url, notice: '站点已创建.' }
        format.json { render action: 'show', status: :created, location: @site }
      else
        format.html { render action: 'new' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/sites/1
  # PATCH/PUT /site/sites/1.json
  def update
    respond_to do |format|
      if @site.update(cms_site_params)

        format.html { redirect_to cms.sites_url, notice: '站点已修改.' }
        format.json { head :no_content }
      else
        @accounts = Account.all
        @cms_theme = Cms::Theme.all
        format.html { render action: 'edit' }
        format.json { render json: @site.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/sites/1
  # DELETE /site/sites/1.json
  def destroy
    if @site.columns.size > 0
      flash[:error] = "该站点存在多个栏目，不能删除"
    else
      delete_file(@site.logo_file) if !@site.logo_file.blank?
      @site.destroy
    end

    respond_to do |format|
      format.html { redirect_to cms.sites_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Cms::Site.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_site_params
      params.require(:site).permit(:name, :tel, :email, :site_key,:address, :zip, :domain,:is_enabled)
    end
end
