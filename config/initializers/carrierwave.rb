# module CarrierWave
#   module MiniMagick
#     def quality(percentage)
#       manipulate! do |img|
#         img.quality(percentage.to_s)
#         img = yield(img) if block_given?
#         img
#       end
#     end
#   end
# end
module CarrierWave
  module RMagick
    def quality(percentage)
      manipulate! do |img|
        img.write(current_path){ self.quality = percentage } unless img.quality == percentage
        img = yield(img) if block_given?
        img
      end
    end
  end
end
