class OrdersController < ApplicationController
  include AppHelpers::Cart
  before_action :set_order, only: [:show, :destroy]
  before_action :check_login
  authorize_resource

  def index
    if current_user.role?(:customer)
      @all_orders = current_user.customer.orders.chronological.paginate(page: params[:page]).per_page(10)
    else
      @all_orders = Order.chronological.paginate(:page => params[:page]).per_page(10)
    end
    
  end

  def show
    @orderitems = @order.order_items
    get_related_data()
  end

  def new
    @cart = create_cart
  end

  def create
    @order = Order.new(order_params)
    @order.date = Date.current
    if @order.save
      @order.pay
      redirect_to @order, notice: "Thank you for ordering from the Baking Factory."
    else
      render action: 'new'
    end
  end

  # def update
  #   if @visit.update_attributes(visit_params)
  #     flash[:notice] = "Successfully updated visit by #{@visit.pet.name}."
  #     redirect_to @visit
  #   else
  #     render action: 'edit'
  #   end
  # end


  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:address_id, :customer_id, :grand_total)
  end
  def get_related_data
    @customer = @order.customer
    @orderitems = @order.order_items.to_a.sort_by{|i| i.item.name}
    @total = @order.grand_total
  end

end