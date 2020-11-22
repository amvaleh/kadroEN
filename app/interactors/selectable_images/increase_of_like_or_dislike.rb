module SelectableImages
  class IncreaseOfLikeOrDislike
    include Interactor

    def call
      if context.status == "like"
        context.selectable_image.like_number += context.amount
      elsif context.status == "dislike"
        context.selectable_image.dislike_number += context.amount
      end
    end
  end
end
