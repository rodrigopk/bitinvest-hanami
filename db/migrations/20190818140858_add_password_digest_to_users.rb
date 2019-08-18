# frozen_string_literal: true

Hanami::Model.migration do
  change do
    alter_table :users do
      add_column :password_digest, String, null: false
    end
  end
end
