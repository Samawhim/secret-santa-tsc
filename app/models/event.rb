class Event < ApplicationRecord
  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants, allow_destroy: true

  validates :title, presence: true
  validates :max_price, presence: true
end
