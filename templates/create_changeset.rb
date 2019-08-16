class CreateChangesets < ActiveRecord::Migration[5.1]
  def change
    create_table :changesets, id: :bigserial do |table|
      table.bigserial :version, null: false
      table.text :action, null: false
      table.jsonb :differences, null: false, default: {}
      table.jsonb :metadata, null: false, default: {}

      table.string :auditable_id, null: false
      table.string :auditable_type, null: false
      table.string :associated_id, null: false
      table.string :associated_type, null: false
      table.uuid :actor_id, null: false
      table.timestamp :created_at, null: false

      table.index :version, unique: true
      table.index [:auditable_id, :auditable_type]
      table.index [:associated_id, :associated_type]
      table.index :actor_id
      table.index :created_at
    end
  end
end
