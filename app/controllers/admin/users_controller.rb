class Admin::UsersController < AdminController

  def index
    @users=User.all.newest_first
  end

  def edit
    @user=User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    if user.admin?
      flash[:alert] = t('errors.messages.not_authorized')
    else
      user.update!(user_params) 
    end
    redirect_to action: "index"
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
