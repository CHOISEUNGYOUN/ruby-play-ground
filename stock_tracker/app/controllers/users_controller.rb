class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def unfriend
    @friend = Friendship.find_by(user: current_user, friend: params[:id])
    @friend.destroy
    flash[:notice] = "#{@friend.friend.first_name} was successfully removed from your portfolio."
    redirect_to my_friends_path
  end
end
