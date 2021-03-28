class CustomersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  def index
    @active_customers = Customer.active.alphabetical.paginate(:page => params[:page]).per_page(10)
    @inactive_customers = Customer.inactive.alphabetical.paginate(:page => params[:page]).per_page(10)
  end

  def show
    @previous_orders = @customer.orders.chronological
    @suggestions = Item.where(category: @customer.orders.first.order_items.first.item.category).first(3)
  end

  def search
    if (params[:query].blank?)
      flash[:error] = "Please Enter a Keyword"
      redirect_to customers_path
    else
      @query = params[:query]
      @customers = Customer.search(@query).alphabetical.paginate(:page => params[:page]).per_page(10)
    end

  end

  def new
    @customer = Customer.new
  end

  def edit
    # reformat phone w/ dashes when displayed for editing (preference; not required)
    @customer.phone = number_to_phone(@customer.phone)
  end

  def create
    @customer = Customer.new(customer_params)
    @user = User.new(user_params)

    unless(current_user.role?(:admin))
      @user.role = "customer"
    end

    if !@user.save
      @customer.valid?
      render action: 'new'
    else
      @customer.user_id = @user.id
      if @customer.save
        if(!current_user.role?(:admin))
          flash[:notice] = "Successfully created #{@customer.proper_name}. Please login with your credentials"
        else
          flash[:notice] = "Successfully created #{@customer.proper_name}."
        end
        
        redirect_to login_path 
      else
        render action: 'new'
      end      
    end
  end
  def update
    respond_to do |format|
      if @customer.update_attributes(customer_params)
        format.html { redirect_to(@customer, :notice => "Successfully updated #{@customer.proper_name}.") }
        format.json { respond_with_bip(@customer) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@customer) }
      end
    end
  end


 
  private
  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :phone, :active)
  end

  def user_params      
    params.require(:customer).permit(:active, :username, :password, :password_confirmation, :role)
  end

end