class Cms::Info < ActiveRecord::Base
	validates_presence_of :title,:category

	belongs_to :category
	belongs_to :column

	def cover_picture_thumb
	   unless cover_picture_file.blank?
	   	 thumb_name = cover_picture_file[0..cover_picture_file.index('.')-1] + "_thumb.jpg" 
	   	 full_name = Rails.root.join("public",thumb_name)
         #if File.exist?(full_name)   #TODO 每次访问都检测，可能影响性能
         	thumb_name
         #else
         #	cover_picture_file
         #end
	   end
	end
end
