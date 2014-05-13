class CreateCmsInfos < ActiveRecord::Migration
  def change
    create_table :cms_infos do |t|
      t.string :title
      t.references :category, index: true
      t.references :column, index: true
      t.text :description
      t.text :content
      t.string :cover_picture_file
      t.string :attachment_file
      t.integer :view_count
      t.integer  :the_order         
      t.boolean :is_sticky
      t.boolean :is_recommend
      t.boolean :is_enabled

      t.timestamps
    end
  end
end
