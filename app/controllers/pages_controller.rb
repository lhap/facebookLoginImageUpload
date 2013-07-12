class PagesController < ApplicationController
  
  def home
  @user = User.all 
  end
end
