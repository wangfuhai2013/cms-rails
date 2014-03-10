class Cms::TemplatesController < ApplicationController
  before_action :set_cms_template, only: [:show, :edit, :update, :destroy]

  # GET /site/templates
  # GET /site/templates.json
  def index
    @cms_templates = Cms::Template.all
  end

  # GET /site/templates/1
  # GET /site/templates/1.json
  def show
  end

  # GET /site/templates/new
  def new
    @cms_theme = Cms::Theme.find(params[:theme_id])
    @cms_template = Cms::Template.new
    @cms_template.theme = @cms_theme
    
    @cms_functions = Cms::Function.where(:parent_function_id => nil)
  end

  # GET /site/templates/1/edit
  def edit
     #@cms_functions = Cms::Function.where(:parent_function_id => nil)
  end

  # POST /site/templates
  # POST /site/templates.json
  def create
    #不直接创建，随主题或栏目一起创建
=begin    
    @cms_template = Cms::Template.new(cms_template_params)

    respond_to do |format|
      if @cms_template.save

        if @cms_template.function.child_functions.size >0
            @cms_template.function.child_functions.each do |child_function|
               child_template = Cms::Template.new
               child_template.name = child_function.name
               child_template.function = child_function
               child_template.theme = @cms_template.theme
               child_template.save
            end
        end
        format.html { redirect_to cms.theme_url(@cms_template.theme), notice: 'Template was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cms_template }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_template.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PATCH/PUT /site/templates/1
  # PATCH/PUT /site/templates/1.json
  def update
    respond_to do |format|
      if @cms_template.update(cms_template_params)
        format.html { redirect_to cms.theme_url(@cms_template.theme), notice: 'Template was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/templates/1
  # DELETE /site/templates/1.json
  def destroy
  #模板不直接删除，由栏目删除
=begin
    if @cms_template.function.child_functions.size > 0 
       child_function_templates = Cms::Template.joins(:function).
                                  where("theme_id = ? AND cms.functions.parent_function_id = ?",
                                  @cms_template.theme_id,@cms_template.function_id)
       child_function_templates.each do |child_template| 
          template = Cms::Template.find(child_template.id)
          template.destroy
       end
    end
    theme = @cms_template.theme
    @cms_template.destroy
    respond_to do |format|
      format.html { redirect_to cms.theme_url(theme) }
      format.json { head :no_content }
    end
=end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_template
      @cms_template = Cms::Template.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_template_params
      params.require(:template).permit(:content)
    end
end
