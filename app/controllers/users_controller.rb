class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :following, :followers]
  before_action :ensure_correct_user,only: [:edit, :update]

  def index
    @users = User.all
    @book = Book.new #投稿フォーム
  end

  #Home画面
  def show
    @book = Book.new
    @books = @user.books
    @book_comment = BookComment.new
  end

  def update
  	if @user.update(user_params)
      redirect_to @user, notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  #編集制限(自分のページに戻す)
  def ensure_correct_user
    if params[:id].to_i != current_user.id
      @users = User.all
      redirect_to user_path(current_user.id)
    end
  end

  #Follow
  def following
  end
  def followers
  end

  def serach
    @users = User.where('name ?', params[:name])
    render "search"
  end

  private
  def user_params
  	params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def zipedit
    params.require(:user).permit(:postal_code, :prefecture_name, :address_city, :address_street)
  end

  def set_user
    @user = User.find(params[:id])
  end

end
