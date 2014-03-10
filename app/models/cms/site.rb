class Cms::Site < ActiveRecord::Base
  validates_presence_of :name,:site_key
  validates_uniqueness_of :site_key
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ ,:allow_blank => true

  belongs_to :theme
  has_many   :columns,dependent: :destroy
  has_many   :themes,dependent: :destroy

  has_many :feedbacks ,dependent: :destroy
end
