module Rw
  class Authorize
    # class PermissionError < StandardError; end

    def self.call(user, class_name, method_name, model = nil)
      a_policy = eval("#{class_name}.new(user, model)")
      result = a_policy.send(method_name)
      raise PermissionError, I18n.t(:'messages.permission_denied') unless result
      true
    end
  end
end