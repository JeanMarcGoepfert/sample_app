class Micropost < ActiveRecord::Base
    validates :user_id, presence: true
    belongs_to :user
    validates :user_id, presence: true
end
