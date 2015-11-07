class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.integer :github_id, null: false
      t.text :name
      t.text :secret

      t.timestamps null: false
    end

    add_index :repositories, :github_id, unique: true
  end
end
