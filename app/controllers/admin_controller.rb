class AdminController < ApplicationController
  before_action :require_admin

  def require_admin
    unless user_signed_in? && current_user.admin?
      redirect_to root_path , notice: t('errors.messages.not_authorized')
    end
  end
end
