class RoomsController < ApplicationController

  skip_before_action :require_login, only: [:index, :show]

  def index
    @rooms = Room.active.by_remaining_time
  end

  def show
    @room = Room.includes(:bids).find(params[:id])
  end

  def publish
    Room.create_sample_rooms!
    redirect_to rooms_path
  end

end
