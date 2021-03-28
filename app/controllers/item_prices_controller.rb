class ItemPricesController < ApplicationController
  before_action :check_login
  authorize_resource
  
  def new
    @item_price = ItemPrice.new
    @item = Item.find(params[:item_id])
  end
  
  def create
    @item_price = ItemPrice.new(item_price_params)
    @item_price.start_date = Date.current
    @item_price.price = @item_price.price unless @item_price.price.nil?
    if @item_price.save
      flash[:notice] = "Successfully updated item costs."
      redirect_to item_path(@item_price.item)
    else
      @item = Item.find(params[:item_price][:item_id])
      render action: 'new', locals: { item: @item_price }
    end
  end

  private
    def item_price_params
      params.require(:item_price).permit(:item_id, :price)
    end

end