class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_not_found

  protected

  def rescue_not_found
    redirect_to :back, alert: t('errors.messages.record_not_found')
    rescue ActionController::RedirectBackError
      redirect_to root_path, alert: t('errors.messages.record_not_found')
  end
end
