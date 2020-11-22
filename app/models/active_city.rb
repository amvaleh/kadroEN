class ActiveCity < ActiveRecord::Base
  self.primary_key = :name

  def readonly?
    true
  end
end
