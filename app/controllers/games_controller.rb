class GamesController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :authenticate
  before_action :current_user,   only: [:edit, :update]
  def index

    @games = Game.search(params[:search])
  end

  def show
    @user = User.find(params[:user_id])
    @game = Game.find(params[:id])
    if current_user?(@user)
      flash[:notice] = "You don't have access to that!"
      redirect_to user_games_path
    end
  end

  def new
    @game = Game.new
  end

  def create
    #render plain: params[:game].inspect
    @user = User.find(params[:user_id])
    @game = @user.games.build(game_params)

    if @game.save
      redirect_to user_games_path
    else
      render 'new'
    end
  end

  def edit
      @game = Game.find(params[:id])
  end

  def update
    @game = Game.find(params[:id])
    if (@game.update(game_params))
      redirect_to user_games_path
    else
      render 'edit'
    end
  end

  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    redirect_to user_games_path
  end

  def search
    if params[:title]
      @game = Game.where('title LIKE ?', "%#{params[:title]}%")
    else
        @game = Game.all
    end
  end

private

  def game_params
    params.require(:game).permit(:title, :genre, :platform, :user_id, :search)
  end

  def logged_in_user
    unless logged_in?
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end
  # To check if any user is not changing other users data



end
