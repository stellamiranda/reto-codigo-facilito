class Task < ApplicationRecord
  #validations
  validates :title, presence: true
  validates :description, presence: true
  validates :description, length: { maximum: 80}
  #relations
  belongs_to :user
  has_one_attached :image, dependent: :destroy
  #before_save
  #after_update

  before_validation do
    if title.blank?
      self.title = nil
    end

    if description.blank?
      self.description = nil
    end
  end
end
