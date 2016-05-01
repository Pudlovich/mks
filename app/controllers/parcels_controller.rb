class ParcelsController < ApplicationController

  def index
    if current_user
      @parcels = current_user.parcels.order(created_at: :desc)
    end
  end

  def new
  end

  def create
  end

  def show
  end
end
