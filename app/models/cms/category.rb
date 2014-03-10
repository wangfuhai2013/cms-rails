class Cms::Category < ActiveRecord::Base
	validates_presence_of :name
	belongs_to :column

	has_many :infos
    def full_name(split_str = '>')
    	self.column.name + split_str + self.name
    end
end
