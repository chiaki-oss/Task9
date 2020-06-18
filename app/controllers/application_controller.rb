class ApplicationController < ActionController::Base
	#ログインしてなければログイン画面へ
	# before_action :authenticate_user!
    #ユーザー登録時にnameのデータ操作を許可
	before_action :configure_permitted_parameters, if: :devise_controller?

	def after_sign_in_path_for(resource)
	  user_path(resource)
	end

	protected
	def configure_permitted_parameters
		#ユーザー登録:name,mail,password要
		devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password])
		#ログイン：name,password要
		devise_parameter_sanitizer.permit(:sign_in, keys: [:name, :password])
	end
end
