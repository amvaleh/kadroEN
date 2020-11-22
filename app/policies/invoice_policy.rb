class InvoicePolicy < Struct.new(:user, :invoice)
  def invoice_show?
    has_invoice?(user, invoice)
  end

  def create_zip?
    AdminUser.where(id: user.id).count > 0
  end

  private

  def has_invoice?(user, invoice)
    Invoice.joins(invoice_items: :cart_item).
        joins('inner join carts c on c.id = cart_items.cart_id').
        where('c.user_id = ? and invoices.id = ?', user.id, invoice.id).count > 0
  end
end