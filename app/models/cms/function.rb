class Cms::Function < ActiveRecord::Base
    validates_presence_of :name,:method

    validates :method, uniqueness: { message: "方法不可重复" },if: "parent_function.nil?"
    validates :method, uniqueness: { scope: :parent_function, message: "方法不可重复" },unless: "parent_function.nil?"

	belongs_to :parent_function ,class_name: "Function", foreign_key: "parent_function_id" 
	has_many   :child_functions ,class_name: "Function", foreign_key: "parent_function_id" ,dependent: :destroy

    has_many :templates ,dependent: :destroy
end
