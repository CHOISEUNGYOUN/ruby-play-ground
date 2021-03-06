class UsersController < ApplicationController
  def my_portfolio
    @user = current_user
    @tracked_stocks = current_user.stocks
  end

  def my_friends
    @friends = current_user.friends
  end

  def show
    @user = User.find(params[:id])
    @tracked_stocks = @user.stocks
  end

  def follow
    @friend = User.find(params[:id])
    current_user.friends << @friend
    flash[:notice] = "#{@friend.first_name} was successfully added in your friend list!"
    redirect_to my_friends_path
  end

  def search
    if params[:q].blank?
      respond_to do |format|
        flash.now[:alert] = "input your keywords"
        format.js { render partial: "friends/result" }
      end
    end

    @friends = User.search_friend(params[:q]).without(current_user)

    if @friends.present?
      respond_to do |format|
        format.js { render partial: "friends/result" }
      end
    else
      respond_to do |format|
        flash.now[:alert] = "no result found"
        format.js { render partial: "friends/result" }
      end
    end
  end

  def unfriend
    @friend = Friendship.find_by(user: current_user, friend: params[:id])
    @friend.destroy
    flash[:notice] = "#{@friend.friend.first_name} was successfully removed from your friend list."
    redirect_to my_friends_path
  end
end
