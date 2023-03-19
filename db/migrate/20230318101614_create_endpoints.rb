class CreateEndpoints < ActiveRecord::Migration[7.0]
  def change
    create_table :endpoints do |t|
      t.string :uuid, index: true, null: false, unique: true
      t.string :verb
      t.string :path, index: true
      t.jsonb :response, null: false, default: {}

      t.timestamps
    end
  end
end
