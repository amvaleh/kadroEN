module SelectableImages
  class ReduceOfLikeOrDislike
    include Interactor

    def call
      if context.status == true
        context.selectable_image.dislike_number -= context.amount
      elsif context.status == false
        context.selectable_image.like_number -= context.amount
      end
    end
  end
end
