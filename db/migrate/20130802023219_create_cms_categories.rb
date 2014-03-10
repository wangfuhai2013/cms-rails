class CreateCmsCategories < ActiveRecord::Migration
  def change
    create_table :cms_categories do |t|
      t.string :name
      t.references :column, index: true
      t.string   :logo_file
      t.text     :description
      t.integer  :the_order
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
