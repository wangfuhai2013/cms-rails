class CreateCmsTemplates < ActiveRecord::Migration
  def change
    create_table :cms_templates do |t|
      t.string :name
      t.references :theme, index: true
      t.references :function, index: true
      t.references :column, index: true      
      t.text :content
      
      t.timestamps
    end
  end
end
