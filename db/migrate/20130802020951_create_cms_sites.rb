class CreateCmsSites < ActiveRecord::Migration
  def change
    create_table :cms_sites do |t|
      t.string :name
      t.references :account, index: true
      t.string :site_key      
      t.string :logo_file
      t.string :tel
      t.string :email
      t.string :address
      t.string :zip
      t.string :domain
      t.integer  :view_count,      default: 0
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
