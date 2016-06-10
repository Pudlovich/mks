class Admin::UsersController < AdminController

  def index
    @users = User.newest_first.paginate(page: params[:page], per_page: 9)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    edited_user = User.find(params[:id])
    if edited_user == current_user
      flash[:alert] = t('errors.messages.not_authorized')
    else
      edited_user.update!(user_params) 
      flash[:notice] = t('.role_changed_succesfully')
    end
    redirect_to action: "index"
  end

  private

  def user_params
    params.require(:user).permit(:role)
  end
end
