module Frames
  class  FixAllFrames
    include Interactor

    def call
      frames = Frame.where(public_id: nil).load
      frames.each do |f|
        Frames::FixFrames.call(frame: f)
      end
    end
  end
end