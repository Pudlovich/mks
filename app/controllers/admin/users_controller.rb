class Admin::UsersController < AdminController

  def index
    @users=User.all.newest_first
  end

  def edit
    @user=User.find(params[:id])
  end

  def update

  end
end
