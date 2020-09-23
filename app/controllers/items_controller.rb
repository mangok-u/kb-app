class ItemsController < ApplicationController

  def index
    @items=Item.all
    if request.fullpath.include?("admin")
      @items.each do |item|
        @path=admin_item_path(current_admin.id,item.id)
      end
      render layout: 'admin'
    else
      @items.each do |item|
        @path=item_path(item.id)
      end
    end
  
  end 

  def show
    @item=Item.find(params[:id])
      if @cart_in_this=@item.cart_items.find_by(cart_id: session['cart_id'])
        @cart_in_this
      end
    if request.fullpath.include?("admin")
      render layout: 'admin'
    end
   
  end

  def new
    @item=Item.new
    render layout: 'admin' 
  end

  def create
    @item=Item.new(item_params)
    if @item.save
      redirect_to  items_path
    else
      render layout: 'admin', action: :new
    end
  end

  def edit
    @item=Item.find(params[:id])
    @label_count=@item.images.length
    render layout: 'admin'
  end
  
  def update
    @item=Item.find(params[:id])
    if @item.update(item_params)
      redirect_to root_path
    else
      render  render layout: 'admin', action: :edit
    end
  end

  def destroy
    item=Item.find(params[:id])
    item.update(hide:true)
    render json: item

  end

  private

  def item_params
    params.require(:item).permit(:name,:detail,:price,images:[])
  end
end
