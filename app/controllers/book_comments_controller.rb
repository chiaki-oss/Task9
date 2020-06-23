class BookCommentsController < ApplicationController
	before_action :authenticate_user!

	def create
		@book = Book.find(params[:book_id])
		@comment = BookComment.new(book_comment_params)
		@comment.user_id = current_user.id  #commentにuserid代入
		@comment.book_id = @book.id
		@comment.save
		@book_comment = BookComment.new
	end

	def destroy
		comment = BookComment.find_by(id: params[:id], book_id: params[:book_id])
		@book = comment.book
		#@book = Book.find_by(user_id: comment.user_id)
		comment.destroy
		#current/user本一覧
		# books = Book.where(user_id: current_user)
		# books = current_user.books
		# user = @book.user
	end

	private
	def book_comment_params
		params.require(:book_comment).permit(:comment)
	end
end
