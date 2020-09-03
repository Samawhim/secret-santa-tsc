class Event < ApplicationRecord
  has_many :participants, dependent: :destroy
  accepts_nested_attributes_for :participants

  validates :title, presence: true
  validates :max_price, presence: true
end
