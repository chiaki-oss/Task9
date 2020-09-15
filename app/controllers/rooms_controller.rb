class RoomsController < ApplicationController
	before_action :authenticate_user!

	def create
		@room = Room.create
		@send_user = Entry.create(room_id: @room.id, user_id: current_user.id)
		# mergeメソッド：ストロングパラメーターが生成される際にroom_id(send_userの）を追加
		@sent_user = Entry.create((room_params).merge(room_id: @room.id))
		redirect_to room_path(@room)
	end

	def show
		@room = Room.find(params[:id])
		# ユーザーとのチャット記録があるかの確認
		if Entry.where(user_id: current_user.id, room_id: @room.id).present?
			# ルームに紐づくメッセージ
			@messages = @room.messages.includes(:user)
			@message = Message.new
			# ルームに参加したユーザー取得
			@entries = @room.entries
		else
			redirect_back(fallback_location: room_path)
		end
	end

	private
	def room_params
		params.require(:entry).permit(:user_id, :room_id)
	end

end
