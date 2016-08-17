class TrailsController < ApplicationController
before_action :current_trail, only: [:edit, :update, :destroy, :show, :publish, :addtag, :removetag]
before_action :log_in
before_action :redirect, only: [:edit, :update, :destroy]
before_action :already_published, only: [:edit, :update]

  def index
    @trails = current_user.nearby_trails.page params[:page]
  end

  def new
    @trail = current_user.created_trails.new
  end

  def create
  @trail = current_user.created_trails.new(trail_params)
    if @trail.save
      redirect_to "/trails/#{@trail.id}/edit"
    else
      redirect_to current_user,
      alert: "Errors."
    end
  end

  def edit
      @your_tags = TagTrail.where(trail: @trail)
      @other_tags = Tag.all
  end

  def update

  end

  def removetag
    tag = Tag.find(params[:tag_id])
    t = TagTrail.find_by(trail: @trail, tag: tag)
    t.destroy
    redirect_to request.referer
  end

  def addtag
    tag = Tag.find(params[:tag_id])
    if !TagTrail.find_by(trail: @trail, tag: tag)
      TagTrail.create(trail: @trail, tag: tag)
    end
    redirect_to request.referer
  end

  def publish
    if @trail.too_many_crumbs
      redirect_to @trail,
      alert: "Please make sure your trail has between one and twenty crumbs."
    else
      @trail.update_attribute(:published, true)
      @trail.order_crumbs
      redirect_to current_user
    end
  end

  def destroy
    @trail.destroy
    render json: params[:id]
  end

  def placed_crumbs
    render :json => {crumbs: current_trail.crumbs }
  end


private

  def trail_params
    params.require(:trail).permit(:name, :description, :latitude, :longitude, :priv, :published, :password, :img)
  end

  def destroy_params
    params.require(:params).permit(:id)
  end

  def current_trail
    @trail = Trail.find(params[:id])
  end

  def log_in
    if !current_user
      redirect_to new_user_session_path
    end
  end

  def redirect
   unless current_user == @trail.creator
     redirect_to new_user_session_path
   end
  end

  def already_published
    if @trail.published
      redirect_to current_user,
      alert: "Cannot change a published trail."
    end
  end

end
