module Photographers::Analyze
  class PhotographerBoughtFrames
    include Interactor

    def call
      context.bought_frames = InvoiceItem.joins(:invoice).
          where('invoices.status = 1').
          joins(cart_item: :project).joins(cart_item: {item: :item_type}).
          where('projects.photographer_id = ? and item_types.category = ?', context.photographer_id, "download").sum(:quantity)
    end
  end


end