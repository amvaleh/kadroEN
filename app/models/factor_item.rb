class FactorItem < ApplicationRecord
  before_validation :assign_relation

  belongs_to :factor
  belongs_to :relation, polymorphic: true

  attr_accessor :relation_user, :relation_item


  def relation_user
    self.relation.id if self.relation.is_a? User
  end

  def relation_item
    self.relation.id if self.relation.is_a? Item
  end

  protected
  def assign_relation
    if !@relation_user.blank? && !@relation_item.blank?
      errors.add(:itemizable, "can't have both a domain and a service")
    else
      unless @relation_user.blank?
        self.relation = User.find(@relation_user)
      end

      unless @relation_item.blank?
        self.relation = Item.find(@relation_item)
      end
    end
  end
end
