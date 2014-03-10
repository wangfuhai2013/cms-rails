class Cms::Template < ActiveRecord::Base
  validates_presence_of :theme,:function,:column
  validates :column, uniqueness: { scope: :theme, message: "该栏目已有模板" }

  belongs_to :theme
  belongs_to :function
  belongs_to :column
  belongs_to :reference_template, class_name:"Cms::Template"
end
