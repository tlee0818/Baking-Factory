class Ability
    include CanCan::Ability
  
    def initialize(user)
      # set user to new User if not logged in
      user ||= User.new # i.e., a guest user
      
      # set authorizations for different user roles
      if user.role? :admin
        # they get to do it all
        can :manage, :all
        
      elsif user.role? :baker
        # can manage owners, pets, and visits
        can :read, Item
        can :index, Order
  
        # they can read their own profile
        can :show, User do |u|  
          u.id == user.id
        end

      elsif user.role? :shipper
        # can manage owners, pets, and visits
        can :index, OrderItem
        can :read, OrderItem

        can :index, Item
        can :read, Item

        can :index, Order
        can :read, Order

        can :index, Address
        can :read, Address
  
        # they can read their own profile
        can :show, User do |u|  
          u.id == user.id
        end
  
  
  
      elsif user.role? :customer
        # they can read their own data
        can :show, Customer do |this_cust|  
          user.customer == this_cust
        end
  
        # they can see lists of Orders and Items (controller filters automatically)
        can :read, Item
        can :index, Item
        can :search, Item
        can :create, Address
  
        # they can manage their own orders' data
        can :manage, Order do |this_order|  
          my_orders = user.customer.orders.map(&:id)
          my_orders.include? this_order.id 
        end

        # they can read their own profile
        can :show, Customer do |c|  
          c.user.id == user.id
        end
  
        # they can update their own profile
        can :update, Customer do |c|  
          c.user.id == user.id
        end

        can :show, User do |u|  
          u.id == user.id
        end
  
        # they can update their own profile
        can :update, User do |u|  
          u.id == user.id
        end

        # they can show their own addresses
        can :read, Address do |a|  
          a.customer.user.id == user.id
        end

        can :update, Address do |a|  
          a.customer.user.id == user.id
        end
  
        
      else
        # guests can only read items (plus home pages)
        can :read, Item
        can :new, Customer
        can :new, User
        can :create, Customer
      end
    end
  end
  