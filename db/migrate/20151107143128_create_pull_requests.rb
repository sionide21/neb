class CreatePullRequests < ActiveRecord::Migration
  def change
    create_table :pull_requests do |t|
      t.references :repository, index: true, foreign_key: true
      t.integer :github_id, null: false
      t.text :link
      t.text :title
      t.text :author
      t.text :labels, array: true, default: []
      t.text :state

      t.timestamps null: false
    end

    add_index :pull_requests, :github_id, unique: true
  end
end
