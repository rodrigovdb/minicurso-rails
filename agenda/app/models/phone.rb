class Phone < ApplicationRecord
  belongs_to :person

  validates :number, presence: true
end
