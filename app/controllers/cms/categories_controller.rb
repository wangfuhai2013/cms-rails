class Cms::CategoriesController < ApplicationController
  before_action :set_cms_category, only: [:show, :edit, :update, :destroy]
  before_action :set_cms_columns, only: [:index,:new,:edit,:create,:update]

  # GET /site/categories
  # GET /site/categories.json
  def index

    @cms_categories = Cms::Category.where(:column_id =>@cms_columns).order(:column_id,:the_order)
    #@cms_categories = Cms::Category.all
  end

  # GET /site/categories/1
  # GET /site/categories/1.json
  def show
  end

  # GET /site/categories/new
  def new
    @cms_category = Cms::Category.new
    @cms_category.the_order = 10
    @cms_category.is_enabled = true
  end

  # GET /site/categories/1/edit
  def edit
  end

  # POST /site/categories
  # POST /site/categories.json
  def create
    @cms_category = Cms::Category.new(cms_category_params)

    respond_to do |format|

      if upload_file_is_permitted && @cms_category.save
        @cms_category.logo_file = upload(params[:category][:logo_file])
        @cms_category.save

        format.html { redirect_to cms.categories_path, notice: 'Category was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cms_category }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/categories/1
  # PATCH/PUT /site/categories/1.json
  def update
    respond_to do |format|
      if @cms_category.update(cms_category_params) && upload_file_is_permitted
        if params[:category][:logo_file]
           delete_file(@cms_category.logo_file) if !@cms_category.logo_file.blank?
           @cms_category.logo_file = upload(params[:category][:logo_file]) 
           @cms_category.save
        end
        format.html { redirect_to cms.categories_path, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/categories/1
  # DELETE /site/categories/1.json
  def destroy
    if @cms_category.infos.size > 0
      flash[:error] = "该类别还有信息数据，不可以删除"
    else
      delete_file(@cms_category.logo_file) if !@cms_category.logo_file.blank?
      @cms_category.destroy
    end  
    
    respond_to do |format|
      format.html { redirect_to cms.categories_url }
      format.json { head :no_content }
    end
  end

  private
    def upload_file_is_permitted
        logo_file_forbid = !check_ext(params[:category][:logo_file]) 
        if logo_file_forbid
           @cms_info.errors.add(:logo_file, "无效的文件类型，只允许:" + 
                  Rails.configuration.upload_extname) 
           false
        else
           true
        end        
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_cms_columns
       @site = Cms::Site.all.take
       @cms_columns = @site.columns.where("parent_column_id is NULL").order("the_order ASC") 
    end

    def set_cms_category
      @cms_category = Cms::Category.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_category_params
      params.require(:category).permit(:name, :column_id,:is_enabled,:description,:the_order)
    end
end
