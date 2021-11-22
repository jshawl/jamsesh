class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :email
      t.string :name
      t.string :image
      t.integer :token_expires_at

      t.timestamps
    end
  end
end
