class Participant < ApplicationRecord
  belongs_to :event
  attr_accessor :santa

  validates :name, presence: true, uniqueness: {scope: :event}
  validates :email, presence: true, format: { with: /\A.*@.*\.com\z/ }, uniqueness: {scope: :event}
end
