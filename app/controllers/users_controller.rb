class UsersController < ApplicationController
    before_action :signed_in_user,  only: [:index, :edit, :update, :destroy, :following, :followers]
    before_action :correct_user,    only: [:edit, :update]
    before_action :admin_user,      only: :destroy

    def index
        @users = User.paginate(page: params[:page])
    end

    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])
    end

    def new
        @user = User.new
        redirect_to root_path, notice: "You already have an account!" if signed_in?
    end

    def create
        if signed_in?
            redirect_to root_path, notice: "You already have an account!"
        else
            @user = User.new(user_params)
            if @user.save
                sign_in @user
                flash[:success] = "Welcome to the Sample App!"
                redirect_to @user
            else
                render 'new'
            end
        end
    end

    def edit
    end

    def update
        if @user.update_attributes(user_params)
            flash[:success] = "Profile Updated"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def destroy
        user_destroy = User.find(params[:id])

        if current_user.id == user_destroy.id
            flash[:error] = "Can't delete yourself!"
        else
            user_destroy.destroy
            flash[:success] = "User #{user_destroy.name} destroyed."
            redirect_to users_url
        end
    end

    def following
        @title = "Following"
        @user = User.find(params[:id])
        @users = @user.followed_users.paginate(page: params[:page])
        render 'show_follow'
    end

    def followers
        @title = "Followers"
        @user = User.find(params[:id])
        @users = @user.followers.paginate(page: params[:page])
        render 'show_follow'
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end
end
