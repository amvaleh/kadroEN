require "find"
require "fileutils"

module Invoices
  class CreateZip
    include Interactor

    def call
      if context.order_type.to_i == 1
        vch_header = Cart.find_by(id: context.order_id)
        result = Cart.joins(:cart_items).
          joins("inner join items i on i.id = cart_items.item_id").
          joins("inner join item_types it2 on i.item_type_id = it2.id").
          select("i.*, cart_items.frame_id, cart_items.quantity, CASE WHEN i.width > 16 THEN concat(i.width, '_', i.height, '_', 'silk') ELSE concat(i.width, '_', i.height, '_', 'luster') END AS size, it2.title, it2.category").
          where("carts.id = ? and (i.width is not null and i.height is not null)", context.order_id).load
      else
        vch_header = Invoice.find_by(id: context.order_id)
        result = Invoice.joins(invoice_items: :cart_item).
          joins("inner join items i on i.id = cart_items.item_id").
          joins("inner join item_types it2 on i.item_type_id = it2.id").
          select("i.*, cart_items.frame_id, invoice_items.quantity, CASE WHEN i.width > 16 THEN concat(i.width, '_', i.height, '_', 'silk') ELSE concat(i.width, '_', i.height, '_', 'luster') END AS size, it2.title, it2.category").
          where("invoices.id = ? and (i.width is not null and i.height is not null)", context.order_id).load
      end
      frames = Carts::CurrentFrames.call(frame_ids: result.map { |c| c.frame_id }).result
      description = ""
      if frames.nil? || frames.length == 0
        context.fail!
      else
        result.each do |r|
          frame = frames.detect { |f| f.id == r.frame_id }
          FileUtils.mkdir_p("#{Rails.root}/print_orders/#{vch_header.id}/#{r.category}/#{r.size}/#{r.quantity}")
          FileUtils.cp("#{Rails.root}/public#{frame.file_address(false, "original")}",
                       "#{Rails.root}/print_orders/#{vch_header.id}/#{r.category}/#{r.size}//#{r.quantity}/#{frame.original_filename}")
        end  
	vch_header.invoice_items.each do |i|
            description = description + "#{i.cart_item.frame.original_filename} - #{i.cart_item.item.title} :\n#{i.cart_item.description}\n\n"
        end
        if description != ""
          puts `cd "#{Rails.root}/print_orders/#{vch_header.id}" && touch description.txt && echo "#{description}" > description.txt`
        end
        directory = "#{Rails.root}/print_orders/#{vch_header.id}"
        zip_file_name = if context.order_type.to_i == 1
            "#{Rails.root}/print_orders/cart_#{vch_header.id}.zip"
          else
            "#{Rails.root}/print_orders/invoice_#{vch_header.id}.zip"
          end
        File.delete(zip_file_name) if File.exist?(zip_file_name)
        zip(directory, zip_file_name, true)
      end
    end

    def zip(dir, zip_dir, remove_after = false)
      Zip::ZipFile.open(zip_dir, Zip::ZipFile::CREATE) do |zipfile|
        Find.find(dir) do |path|
          Find.prune if File.basename(path)[0] == ?.
          dest = /#{dir}\/(\w.*)/.match(path)
          # Skip files if they exists
          begin
            zipfile.add(dest[1], path) if dest
          rescue Zip::ZipEntryExistsError
          end
        end
      end
      FileUtils.rm_rf(dir) if remove_after
    end
  end
end
