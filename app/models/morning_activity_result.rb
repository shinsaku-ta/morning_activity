class MorningActivityResult < ApplicationRecord
  belongs_to :user

  enum state: %i[not_implemented success failed]
end
