class Cms::InfosController < ApplicationController
  before_action :set_cms_info, only: [:show, :edit, :update, :destroy]
  before_action :set_cms_categories, only: [:index,:new,:edit,:create,:update]
  after_action :get_thumb_image, only: [:create,:update]

  # GET /site/infos
  # GET /site/infos.json
  def index
    category_ids = "0"
    @cms_categories.each do |category|
      category_ids += "," + category.id.to_s
    end
    where = "1" 
    where += " AND category_id IN (#{category_ids}) " if params[:category_id].blank?
    where += " AND category_id = #{params[:category_id]} " unless params[:category_id].blank?
    where += " AND title like '%#{params[:title]}%' " unless params[:title].blank?    
    @cms_infos = Cms::Info.where(where).order(the_order: :asc,updated_at: :desc).page(params[:page])
  end

  # GET /site/infos/1
  # GET /site/infos/1.json
  def show
  end

  # GET /site/infos/new
  def new
    @cms_info = Cms::Info.new
    @cms_info.is_enabled = true
    @cms_info.the_order = 10
  end

  # GET /site/infos/1/edit
  def edit
  end

  # POST /site/infos
  # POST /site/infos.json
  def create
    @cms_info = Cms::Info.new(cms_info_params)
    @cms_info.column = @cms_info.category.column
    respond_to do |format|
      if upload_file_is_permitted && @cms_info.save
        @cms_info.cover_picture_file = Utils::FileUtil.upload(params[:info][:cover_picture_file])
        @cms_info.attachment_file = Utils::FileUtil.upload(params[:info][:attachment_file])
        @cms_info.save

        format.html { redirect_to cms.infos_path, notice: '信息已成功创建.' }
        format.json { render action: 'show', status: :created, location: @cms_info }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/infos/1
  # PATCH/PUT /site/infos/1.json
  def update
    respond_to do |format|
      if @cms_info.update(cms_info_params) && upload_file_is_permitted 
        @cms_info.column = @cms_info.category.column

        if params[:info][:cover_picture_file]
           Utils::FileUtil.delete_file(@cms_info.cover_picture_file) if !@cms_info.cover_picture_file.blank?
           @cms_info.cover_picture_file = Utils::FileUtil.upload(params[:info][:cover_picture_file]) 
        end
        if params[:info][:attachment_file]
           Utils::FileUtil.delete_file(@cms_info.attachment_file) if !@cms_info.attachment_file.blank?
           @cms_info.attachment_file = upload(params[:info][:attachment_file]) 
        end
        @cms_info.save

        format.html { redirect_to cms.infos_path, notice: '信息已成功更新.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/infos/1
  # DELETE /site/infos/1.json
  def destroy
    
    Utils::FileUtil.delete_file(@cms_info.cover_picture_file) if !@cms_info.cover_picture_file.blank?
    Utils::FileUtil.delete_file(@cms_info.attachment_file) if !@cms_info.attachment_file.blank?

    @cms_info.destroy
    respond_to do |format|
      format.html { redirect_to cms.infos_url }
      format.json { head :no_content }
    end
  end

  private
     def upload_file_is_permitted
        cover_file_forbid = !Utils::FileUtil.check_ext(params[:info][:cover_picture_file]) 
        att_file_forbid = !Utils::FileUtil.check_ext(params[:info][:attachment_file]) 
        if cover_file_forbid ||att_file_forbid
           @cms_info.errors.add(:cover_picture_file, "无效的文件类型，只允许:"+ Rails.configuration.upload_extname) if cover_file_forbid
           @cms_info.errors.add(:attachment_file, "无效的文件类型，只允许:"+ Rails.configuration.upload_extname) if att_file_forbid
           false
        else
           true
        end        
    end
    def get_thumb_image
      if @cms_info.valid? && params[:info][:cover_picture_file] && upload_file_is_permitted
         Utils::FileUtil.thumb_image (Rails.root.join("public",@cms_info.cover_picture_file).to_s) 
      end
    end

    def set_cms_categories
      @site = Cms::Site.all.take
      @cms_columns = @site.columns 
      @cms_categories = Cms::Category.where(:column_id =>@cms_columns).order("column_id ASC")
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_info
      @cms_info = Cms::Info.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_info_params
      params.require(:info).permit(:title, :description, :category_id,:content, 
                     :is_enabled,:is_sticky,:is_recommend,:the_order)
    end
end
