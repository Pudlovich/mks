class Admin::UsersController < AdminController

  def index
    @users=User.all.newest_first
  end

  def edit

  end

  def update

  end
end
