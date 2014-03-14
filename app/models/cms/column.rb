class Cms::Column < ActiveRecord::Base
  validates_presence_of :name,:function,:path,:site
  validates :path, uniqueness: { scope: :site, message: "栏目路径不可重复" },if: "parent_column.nil?"
  validates :path, uniqueness: { scope: :parent_column, message: "栏目路径不可重复" },unless: "parent_column.nil?"

  belongs_to :site
  belongs_to :function
  has_many   :templates,dependent: :destroy
  has_many   :categories

  belongs_to :parent_column ,class_name: "Column", foreign_key: "parent_column_id" 
  has_many   :child_columns ,class_name: "Column", foreign_key: "parent_column_id" ,dependent: :destroy
end
