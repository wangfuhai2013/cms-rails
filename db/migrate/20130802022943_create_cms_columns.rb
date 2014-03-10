class CreateCmsColumns < ActiveRecord::Migration
  def change
    create_table :cms_columns do |t|
      t.string :name
      t.integer  :parent_column_id      
      t.string :path
      t.integer  :the_order            
      t.references :site, index: true
      t.references :function, index: true
      t.references :template, index: true
      t.boolean :is_top_menu
      t.boolean :is_bottom_menu
      t.boolean  :has_menu,         default: true            
      t.text :content
      t.integer  :view_count,       default: 0
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
