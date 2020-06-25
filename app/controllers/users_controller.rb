class UsersController < ApplicationController
  before_action :authenticate_user!
  #ログインしてなければ飛ばない
  before_action :ensure_correct_user,only: [:edit, :update]
  #編集制限

  #Usersページ
  def index
    @users = User.all
    @user = User.new
    @book = Book.new    #Users画面での新規投稿フォーム用
    @books = Book.all
  end

  #Home画面
  def show
  	@user = User.find(params[:id]) #db取得:profile表示
    @book = Book.new
    @books = @user.books #index/book (userの投稿のみ表示)
    @book_comment = BookComment.new
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
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
    @user = User.find(params[:id])
    @users = @user.following
    render 'show_follow'
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
    render 'show_follow'
  end

  def serach
    @users = User.where('name ?', params[:name])
    render "search"
  end

  private
  def user_params
  	params.require(:user).permit(:name, :profile_image, :introduction, :postal_code, :prefecture_code, :address_city, :address_street)
  end
end
