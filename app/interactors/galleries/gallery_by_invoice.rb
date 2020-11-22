module Galleries
  class GalleryByInvoice
    include Interactor

    def call
      context.result = InvoiceItem.joins(cart_item: :project).
          joins('inner join galleries g on g.project_id = projects.id').
          select('g.id gallery_id').where('invoice_id = ?', context.invoice.id).
          order('invoice_items.id desc').take(1)[0]
    end
  end
end