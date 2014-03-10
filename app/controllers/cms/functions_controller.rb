class Cms::FunctionsController < ApplicationController
  before_action :set_cms_function, only: [:show, :edit, :update, :destroy]
  before_action :set_parent_functions, only: [:new,:edit,:create,:update]

  # GET /site/functions
  # GET /site/functions.json
  def index 
    @cms_functions = Cms::Function.where("parent_function_id is NULL").order("name DESC")
  end

  # GET /site/functions/1
  # GET /site/functions/1.json
  def show
  end

  # GET /site/functions/new
  def new
    @cms_function = Cms::Function.new
  end

  # GET /site/functions/1/edit
  def edit
  end

  # POST /site/functions
  # POST /site/functions.json
  def create
    @cms_function = Cms::Function.new(cms_function_params)

    respond_to do |format|
      if @cms_function.save
        format.html { redirect_to cms.functions_url, notice: '功能已创建.' }
        format.json { render action: 'show', status: :created, location: @cms_function }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_function.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/functions/1
  # PATCH/PUT /site/functions/1.json
  def update
    respond_to do |format|
      if @cms_function.update(cms_function_params)
        format.html { redirect_to cms.functions_url, notice: '功能已更新.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_function.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/functions/1
  # DELETE /site/functions/1.json
  def destroy
    if Cms::Column.find_by_function_id(@cms_function.id)
      flash[:error] = "该功能还有站点栏目使用，不能删除"
    else
      @cms_function.destroy
    end
    
    
    respond_to do |format|
      format.html { redirect_to cms.functions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_parent_functions
      @parent_functions = Cms::Function.where("parent_function_id is NULL").order("name DESC")      
    end
    def set_cms_function
      @cms_function = Cms::Function.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_function_params
      params.require(:function).permit(:name, :method,:content,:parent_function_id)
    end
end
