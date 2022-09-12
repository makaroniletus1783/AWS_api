class Sale < ApplicationRecord
  validates :name, presence: true
  validates :amount, numericality: {greater_than_or_equal_to: 0}
  validates :price, numericality: {greater_than: 0}, :allow_blank => true
end
