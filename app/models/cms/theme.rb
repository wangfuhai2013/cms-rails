class Cms::Theme < ActiveRecord::Base
  validates_presence_of :site,:name
  validates :name, uniqueness: { scope: :site, message: "主题名称不可重复" }
  validates :path, presence: {message: "模板类型为文件，必须设置主题路径" },if: "template_type == 'F'"

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

    def template_type_name
    case self.template_type
    when 'D'
      '数据库'
    when 'F'
      '文件' 
    end 
  end
  
  def self.template_type_options
    [['数据库', 'D'], ['文件', 'F']]
  end
end
