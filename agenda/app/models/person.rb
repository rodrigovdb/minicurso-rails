class Person < ApplicationRecord
  has_many :phones

  validates :name, presence: true,
                   uniqueness: true,
                   length: { minimum: 5, maximum: 255 }
end
