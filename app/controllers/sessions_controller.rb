class SessionsController < ApplicationController
  # This is required because of a quirk the "developer" authentication
  # strategy. We'll remove this when we move to a "real" provider.
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :require_login, only: [:new, :create, :destroy]

  def new
  end

  def create
    #binding.pry
    if params[:email].nil?
      # After entering a name and email value in the /auth/developer
      # path and submitting the form, you will see a pretty-print of
      # the authentication data object that comes from the "developer"
      # strategy. In production, we'll swap this strategy for something
      # like 'github' or 'facebook' or some other authentication broker
      pp request.env['omniauth.auth']

      # We're going to save the authentication information in the session
      # for demonstration purposes. We want to keep this data somewhere so that,
      # after redirect, we have access to the returned data
      session[:email] = request.env['omniauth.auth']['info']['email']
      session[:omniauth_data] = request.env['omniauth.auth']

      # Ye olde redirect
      redirect_to root_path
    else
      user = User.find_by(email: params[:email])
      if user.nil?
        redirect_to "/signin", alert: "No such email found."
      elsif user.authenticate(params[:password])
        session[:email] = user.email
        redirect_to user_path(user)
      else
        flash[:notice] = "Incorrect password."
        redirect_to "/signin", alert: "Incorrect password."
      end
    end
  end

  def destroy
   # params.raise.inspect
    session.clear
    redirect_to root_url
  end
end
