class UsersController < ApplicationController


  before_action :authenticate_user!
	before_action :correct_user, only: [:edit, :update]
  before_action :configure_permitted_parameters, if: :devise_controller?
  #デバイス機能実行前にconfigure_permitted_parametersの実行をする。


  def show
  	@user = User.find(params[:id])
  	@books = @user.books.all
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
  end

  def index
  	@users = User.all #一覧表示するためにUserモデルのデータを全て変数に入れて取り出す。
  	@book = Book.new #new bookの新規投稿で必要（保存処理はbookコントローラー側で実施）
    @user = current_user
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])
  	if @user.update(user_params)
  		redirect_to user_path(@user.id), notice: "successfully updated user!"
  	else
  		render "edit"
  	end
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.followers
  end

  private
  def user_params
  	params.require(:user).permit(:name, :introduction, :profile_image)
  end

  #url直接防止 メソッドを自己定義してbefore_actionで発動。
  def correct_user
    user = User.find(params[:id])
    if current_user != user
      redirect_to user_path(current_user)
    end
  end

end