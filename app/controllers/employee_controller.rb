class EmployeeController < ApplicationController
  before_action :require_employee_or_admin

  def require_admin
    unless user_signed_in? && (current_user.employee? || current_user.admin?)
      redirect_to root_path , alert: t('errors.messages.not_authorized')
    end
  end
end
