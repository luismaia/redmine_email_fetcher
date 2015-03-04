# Create EMAIL_CONFIGURATIONS model
class CreateEmailConfigurations < ActiveRecord::Migration
  def change
    create_table :email_configurations do |t|
      t.string :configuration_type, null: false

      t.string :host, null: false
      t.integer :port, null: false
      t.boolean :ssl, default: true, null: false
      t.string :username, null: false
      t.string :password, null: false
      t.string :folder, default: 'INBOX', null: false

      t.string :move_on_success # IMAP
      t.string :move_on_failure # IMAP
      t.boolean :delete_unprocessed, default: false, null: false # POP3
      t.boolean :apop, default: false, null: false # POP3

      t.string :unknown_user, default: 'accept', null: false
      t.boolean :no_account_notice, default: false, null: false
      t.boolean :no_permission_check, default: true, null: false
      t.string :default_group

      t.references :project, index: false, null: false
      t.references :tracker, index: false, null: false
      t.string :category
      t.string :priority
      t.string :allow_override

      t.datetime :last_fetch_at, null: true
      t.boolean :flg_active, default: true
    end

    add_index(:email_configurations, [:host, :port, :username, :folder],
              unique: true, name: 'index_unique_email_configuration')
  end
end
