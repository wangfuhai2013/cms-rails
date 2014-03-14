class CreateCmsThemes < ActiveRecord::Migration
  def change
    create_table :cms_themes do |t|
      t.string :name
      t.string :path
      t.string :template_type, :default => 'D' 
      t.references :site, index: true
      t.text     :template_css
      t.text     :template_layout
      t.text     :template_js
      t.string   :ua_type
      t.boolean  :is_enabled

      t.timestamps
    end
  end
end
