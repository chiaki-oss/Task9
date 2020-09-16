class MessagesController < ApplicationController
	before_action :authenticate_user!, :only =>[:create, :show]

	def show
	    @user = User.find(params[:id])
	    rooms = current_user.entries.pluck(:room_id)
	    entries = Entry.find_by(user_id: @user.id, room_id: rooms)

	    unless entries.nil?
		  # チャット履歴がある場合は、entryてーぶるのroom取得
	      @room = entries.room
	    else
	    # なければRoom新規作成、保存。Entryに参加者と本人のuser.id,roomidを記録
	      @room = Room.new
	      @room.save
	      Entry.create(user_id: current_user.id, room_id: @room.id)
	      Entry.create(user_id: @user.id, room_id: @room.id)
	    end
	    @messages = @room.messages #Roomにある全メッセージ取得
	    @message = Message.new(room_id: @room.id)
	end

	def create
	    @message = current_user.messages.new(message_params)
	    @message.save
	end

	private
	def message_params
		params.require(:message).permit(:user_id, :room_id, :message)
	end

end
