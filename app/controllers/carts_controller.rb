class CartsController < ApplicationController


  def cart_form_dashboard
    items = Carts::AllItems.call.result

    cart = Carts::CurrentCart.call(user: current_user, frame_id: params[:frame_id]).result
    total = Carts::CurrentCartTotal.call(user: current_user, frame_id: params[:frame_id])
    frame = Frame.find_by(id: params[:frame_id])
    render locals: {items: items, frame_id: params[:frame_id], cart: cart, total: total, frame: frame}
  end


  def cart_items_list_dashboard
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result

    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end


  def cart_form
    items = Carts::AllItems.call.result

    cart = Carts::CurrentCart.call(user: current_user, frame_id: params[:frame_id]).result
    total = Carts::CurrentCartTotal.call(user: current_user, frame_id: params[:frame_id])
    frame = Frame.find_by(id: params[:frame_id])
    render locals: {items: items, frame_id: params[:frame_id], cart: cart, total: total, frame: frame}
  end

  def cart_create
    Carts::CartCreate.call(user: current_user,
                           cart_item_data: {item_id: params[:item_id],
                                            frame_id: params[:frame_id],
                                            quantity: params[:quantity]})
    total = Carts::CurrentCartTotal.call(user: current_user, frame_id: params[:frame_id])
    @cart_count = total.cart_count
    render locals: {total: total}
  end

  def cart_items_list
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result

    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def add_description_to_cart_item
    current_cart_item = CartItem.find_by(item_id: params[:item_id],
                                         frame_id: params[:frame_id])
    current_cart_item.description = nil
    current_cart_item.description = params[:description].first
    current_cart_item.save
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def add_description_to_cart_item_dashboard
    current_cart_item = CartItem.find_by(item_id: params[:item_id],
                                         frame_id: params[:frame_id])
    current_cart_item.description = nil
    current_cart_item.description = params[:description].first
    current_cart_item.save
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def cart_update
    Carts::CartUpdate.call(user: current_user,
                           cart_item_data: {item_id: params[:item_id],
                                            frame_id: params[:frame_id],
                                            quantity: params[:quantity]})
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    @cart_count = total.cart_count

    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def cart_update_dashboard
    Carts::CartUpdate.call(user: current_user,
                           cart_item_data: {item_id: params[:item_id],
                                            frame_id: params[:frame_id],
                                            quantity: params[:quantity]})
    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    @cart_count = total.cart_count

    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def cart_item_delete
    InvoiceFactors::DestroyInvoiceFactors.call(cart_item_id: params[:cart_item_id])

    Carts::CartItemDelete.call(user: current_user, cart_item_id: params[:cart_item_id])

    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    @cart_count = total.cart_count


    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def cart_item_delete_dashboard
    InvoiceFactors::DestroyInvoiceFactors.call(cart_item_id: params[:cart_item_id])

    Carts::CartItemDelete.call(user: current_user, cart_item_id: params[:cart_item_id])

    cart_items = Carts::CurrentCartItems.call(user: current_user).result
    total = Carts::CurrentCartTotal.call(user: current_user)
    current_frames = Carts::CurrentFrames.call(frame_ids: cart_items.map{|c| c.frame_id}).result
    @cart_count = total.cart_count


    render locals: {cart_items: cart_items, total: total, current_frames: current_frames}
  end

  def cart_clear
    Carts::CartClear.call(user: current_user)
    @cart_count = Carts::CurrentCartTotal.call(user: current_user).cart_count
  end

end
