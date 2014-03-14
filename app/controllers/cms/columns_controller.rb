class Cms::ColumnsController < ApplicationController
  before_action :set_cms_column, only: [:show, :edit, :update, :destroy]
  before_action :set_cms_functions, olny: [:new,:edit,:create,:update]

  # GET /site/columns
  # GET /site/columns.json
  def index
    @site = Cms::Site.all.take
    @cms_columns = @site.columns.where("parent_column_id is NULL").order("the_order ASC") # Cms::Column.find_by_cms_id(@site.id)
  end

  # GET /site/columns/1
  # GET /site/columns/1.json
  def show
  end

  # GET /site/columns/new
  def new
    @cms_column = Cms::Column.new
    @cms_column.is_enabled = true
    @cms_column.has_menu = true
    @cms_column.the_order = 10
  end

  # GET /site/columns/1/edit
  def edit
  end

  # POST /site/columns
  # POST /site/columns.json
  def create
    @cms_column = Cms::Column.new(cms_column_params)
    @site = Cms::Site.all.take
    @cms_column.site = @site

    respond_to do |format|
      if @cms_column.save
           @site.themes.each do |theme|
              template = Cms::Template.new
              template.theme = theme
              template.column = @cms_column
              template.function = @cms_column.function
              template.content = @cms_column.function.content
              template.save    
            end
         #对应的功能有子功能则自动增加子栏目
         if @cms_column.function.child_functions.size >0
            @cms_column.function.child_functions.each do |child_function|
              add_child_column(child_function,@cms_column)
           end
        end

        format.html { redirect_to cms.columns_url, notice: '栏目已成功创建.' }
        format.json { render action: 'show', status: :created, location: @cms_column }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_column.errors, status: :unprocessable_entity }
      end
    end
  end

  #增加子栏目
  def add_child_column(child_function,parent_column)
    child_column = Cms::Column.new
    child_column.name = child_function.name
    child_column.path = child_function.method
    child_column.has_menu = parent_column.has_menu          
    child_column.is_enabled = true
    child_column.the_order = 10              
    child_column.parent_column = parent_column
    child_column.site = parent_column.site
    child_column.function = child_function

    child_column.save
    parent_column.site.themes.each do |theme|
      child_template = Cms::Template.new
      child_template.theme = theme
      child_template.column = child_column
      child_template.function = child_column.function
      child_template.content = child_column.function.content
      child_template.save    
    end
  end

  # PATCH/PUT /site/columns/1
  # PATCH/PUT /site/columns/1.json
  def update
    respond_to do |format|
      if @cms_column.update(cms_column_params)

        #子功能有增加，自动添加相关栏目、模板
        if @cms_column.parent_column.nil? &&
           @cms_column.function.child_functions.size > @cms_column.child_columns.size
           @cms_column.function.child_functions.each do |child_function|
              child_column = @cms_column.child_columns.find_by(function:child_function)
              add_child_column(child_function,@cms_column) if child_column.nil?
           end        
        end

        format.html { redirect_to cms.columns_url, notice: '栏目已修改.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_column.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/columns/1
  # DELETE /site/columns/1.json
  def destroy
    #先删除子节点

    if @cms_column.parent_column.nil?
      if Cms::Category.find_by_column_id(@cms_column.id)
        flash[:error] = "该栏目还有类别，不可以删除"
      else
        @cms_column.destroy
      end      
    else
      flash[:error] = "子栏目不可以单独删除"
    end
    

    respond_to do |format|
      format.html { redirect_to cms.columns_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_functions
      @cms_functions =  Cms::Function.where("parent_function_id is NULL").order("name DESC")
    end
    def set_cms_column
      @cms_column = Cms::Column.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_column_params
      params.require(:column).permit(:name, :path, :function_id, :is_top_menu, :is_bottom_menu,
                                     :has_menu,:parent_column_id,:the_order, :content, :is_enabled)
    end
end
