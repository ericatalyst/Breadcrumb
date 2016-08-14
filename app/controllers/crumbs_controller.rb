class CrumbsController < ApplicationController
before_action :current_trail
before_action :current_crumb, only: [:edit, :update, :destroy, :show]

  def new
    @crumb = @trail.crumbs.new
  end

  def create
    @crumb = @trail.crumbs.new(crumb_params)
    if @crumb.save
      redirect_to "/trails/#{@trail.id}/edit"
    else
      redirect_to current_user
      #make error handling
    end
  end

  def edit

  end

  def update
    @crumb.update_attributes(crumb_params)
  end

  def destroy
    @crumb.destroy
    redirect_to "/trails/#{@crumb.trail.id}/edit"
  end

  private

  def current_trail
    @trail = Trail.find(params[:trail_id])
  end

  def current_crumb
    @crumb = Crumb.find(params[:id])
  end

  def trail_creator
    if !(current_user == @trail.creator)
      redirect_to_root
    end
  end

  def crumb_params
    params.require(:crumb).permit(:name, :description, :latitude, :longitude, :requires_answer, :answer, :order_number)
  end

end
