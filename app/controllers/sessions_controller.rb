class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      #To get the failing test to pass, instead of flash we use flash.now, which is 
      #specifically designed for displaying flash messages on rendered pages; unlike 
      #the contents of flash, its contents disappear as soon as there is an additional 
      #request.
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end