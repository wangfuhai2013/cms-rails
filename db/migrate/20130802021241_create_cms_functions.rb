
class CreateCmsFunctions < ActiveRecord::Migration
  def change
    create_table :cms_functions do |t|
      t.string :name
      t.integer  :parent_function_id      
      t.string :method      
      t.text     :content
      t.timestamps
    end
  end
end
