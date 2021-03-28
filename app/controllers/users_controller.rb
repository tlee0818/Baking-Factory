class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    authorize_resource
  
    def index
      # finding all the active owners and paginating that list (will_paginate)
      @employees = User.all.employees.paginate(page: params[:page]).per_page(15)
      @customers = User.all.customers.paginate(page: params[:page]).per_page(15)
    end
  
    def new
      @user = User.new
    end
  
    def edit
      @user.role = "customer" if current_user.role?(:customer)
    end
  
    def create
      @user = User.new(user_params)
      @user.role = "customer" if current_user.role?(:customer)
      if @user.save
        flash[:notice] = "Successfully added #{@user.username} as a user."
        redirect_to users_url
      else
        render action: 'new'
      end
    end
  
    def update
      if @user.update_attributes(user_params)
        flash[:notice] = "Successfully updated #{@user.username}."
        redirect_to users_url
      else
        render action: 'edit'
      end
    end
  
    def destroy
      if @user.destroy
        redirect_to users_url, notice: "Successfully removed #{@user.username}"
      ## There is no 'else' for now; we have no restrictions on user deletion (although we probably should)
      # else
      #   render action: 'show'
      end
    end
  
    private
      def set_user
        @user = User.find(params[:id])
      end
  
      def user_params
        params.require(:user).permit(:username, :active, :username, :role, :password, :password_confirmation)
      end
  
  end
  