module Rw
  class PermissionError < StandardError; end

  class PermissionErrorClass
    include Interactor
    def call
      context.permission_class = PermissionError
    end
  end
end
