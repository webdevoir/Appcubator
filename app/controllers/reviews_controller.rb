class ReviewsController < ApplicationController
  before_action :require_signin
  before_action :set_project

  def index
    @reviews = @project.reviews
  end

  def new
    @review = @project.reviews.new
  end

  def create
    @review = @project.reviews.new(review_params)
    @review.user = current_user
      if @review.save
      redirect_to project_path(@project),
                    notice: "Thanks for your review!"
    else
      render :new
    end
  end

  def destroy
    @review = @project.reviews.find(params[:id])
    @review.destroy
    redirect_to project_path(@project), notice: "Review successfully deleted!"
  end


  private

  def review_params
    params.require(:review).permit(:name, :remark, :stars)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
