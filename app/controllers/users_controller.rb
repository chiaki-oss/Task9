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
    # チャット 本人のエントリーの記録と対象者の記録を取得
    @from_who = Entry.where(user_id: current_user.id)
    @to_who = Entry.where(user_id: @user.id)

    if @user.id != current_user.id
      # ユーザが属してるルームIDを全取得
      @from_who.each do |from|
        @to_who.each do |to|
          # 既に二人のチャット履歴がある場合、ステータスはtrue、room_idの取得
          if from.room_id == to.room_id then
            @room_status = true
            @roomID = from.room_id
          end
        end
      end

      # 二人のチャットが初めての場合、新規作成
      unless @room_status
        @room = Room.new
        @entry = Entry.new
      end
    end

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
  	params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def zipedit
    params.require(:user).permit(:postal_code, :prefecture_name, :address_city, :address_street)
  end

end
