class OrderItemsController < ApplicationController
    before_action :check_login, except: [:index, :show]
    before_action :set_order_item, only: [:show, :edit, :update, :destroy]
    authorize_resource
    
    def index
    end
  
    def show
    end
  
    def new
    end
  
    def edit
        @order_item.date = Date.today
    end
  
    def create
    end
  
    def update
    end
  
    def destroy
    end
  
    private
    def set_order_item
      @item = Item.find(params[:id])
    end
  
    def order_item_params
      params.require(:order_item).permit(:order_id, :item_id, :quantity, :shipped_on)
    end
  
  end