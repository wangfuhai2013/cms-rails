class Cms::FeedbacksController < ApplicationController
  before_action :set_cms_feedback, only: [:show, :edit, :update, :destroy]

  # GET /site/feedbacks
  # GET /site/feedbacks.json
  def index
    @site = Cms::Site.all.take
    @cms_feedbacks = Cms::Feedback.where(:site_id =>@site.id).order("id DESC")
  end

  # GET /site/feedbacks/1
  # GET /site/feedbacks/1.json
  def show
  end

  # GET /site/feedbacks/new
  def new
    @cms_feedback = Cms::Feedback.new
  end

  # GET /site/feedbacks/1/edit
  def edit
  end

  # POST /site/feedbacks
  # POST /site/feedbacks.json
  def create
    @cms_feedback = Cms::Feedback.new(cms_feedback_params)

    respond_to do |format|
      if @cms_feedback.save
        format.html { redirect_to @cms_feedback, notice: 'Feedback was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cms_feedback }
      else
        format.html { render action: 'new' }
        format.json { render json: @cms_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /site/feedbacks/1
  # PATCH/PUT /site/feedbacks/1.json
  def update
    respond_to do |format|
      if @cms_feedback.update(cms_feedback_params)
        format.html { redirect_to @cms_feedback, notice: 'Feedback was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cms_feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /site/feedbacks/1
  # DELETE /site/feedbacks/1.json
  def destroy
    @cms_feedback.destroy
    respond_to do |format|
      format.html { redirect_to cms.feedbacks_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cms_feedback
      @cms_feedback = Cms::Feedback.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cms_feedback_params
      params.require(:feedback).permit(:cms_id, :name, :tel, :email, :content)
    end
end
