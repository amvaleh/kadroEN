module Carts
  class CurrentFrames
    include Interactor

    def call
      context.result = Frame.where('id in (?)', context.frame_ids).load
    end
  end
end