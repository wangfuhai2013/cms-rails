class Cms::Feedback < ActiveRecord::Base
  validates_presence_of :site,:content
  validates_format_of :email, :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/ ,
                      :allow_blank => true,:message => "邮箱不合法"
  belongs_to :site
end
