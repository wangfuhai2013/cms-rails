class Cms::Theme < ActiveRecord::Base
  validates_presence_of :site,:name
  validates :name, uniqueness: { scope: :site, message: "主题名称不可重复" }
  
  belongs_to  :site
  belongs_to :reference_theme, class_name:"Cms::Theme"
  has_many :templates ,dependent: :destroy

  def ua_type_name
  	case self.ua_type
  	when 'P'
  		'电脑'
  	when 'M'
  		'手机' 
  	end	
  end
  
  def self.ua_type_options
    [['电脑', 'P'], ['手机', 'M']]
  end
end
