class BooksController < ApplicationController
  before_action :authenticate_user!
  #ログインしてなければ飛ばない
  before_action :ensure_correct_user,only: [:edit, :update, :destroy]
  #編集制限

  def index
  	@books = Book.all  #indexbook
    @book = Book.new  #newbook
    @user = current_user #プロフィール編集用
    @users = User.all
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user  #booksからユーザー情報取得
    @newbook = Book.new  #新規投稿用変数
  end

  def create
  	@book = Book.new(book_params)
    @book.user_id = current_user.id  #投稿にユーザーid保存
  	if @book.save   #投稿後詳細ページへ
      redirect_to book_path(@book),flash: {complete: "You have created book successfully."}
    else
      @books = Book.all  #投稿再取得
      @user = User.new   #プロフィール表示用
      render "books/index" #Booksページへ
    end
  end

  def edit
    @book = Book.find(params[:id])
  end
  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book),flash: {success: "You have updated book successfully."}
    else
      render :edit
    end
  end
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  #編集制限
  def ensure_correct_user
    @book = Book.find(params[:id])
    if @book.user_id != current_user.id
      redirect_to books_path
    end
  end
  
  private
  def book_params
  	params.require(:book).permit(:title, :body, :user_id)
  end
end
