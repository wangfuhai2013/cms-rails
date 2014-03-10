class CreateCmsFeedbacks < ActiveRecord::Migration
  def change
    create_table :cms_feedbacks do |t|
      t.references :site, index: true
      t.string :name
      t.string :tel
      t.string :email
      t.text :content

      t.timestamps
    end
  end
end
