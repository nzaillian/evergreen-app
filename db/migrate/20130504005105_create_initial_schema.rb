class CreateInitialSchema < ActiveRecord::Migration
  def up

    create_table :users do |t|
      t.string :uuid

      # Database authenticatable
      t.string :username
      t.string :email,              :null => false, :default => ""


      ## DEVISE COLUMNS
      t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token

      ## END DEVISE COLUMNS

      t.string :first_name
      t.string :last_name

      t.string :nickname

      t.string :plan

      t.boolean :trial
      t.datetime :trial_end_date
      t.integer :trial_timeout_job_id

      t.boolean :canceled

      t.string :avatar

      t.boolean :active
      t.boolean :account_on_hold

      t.boolean :company_owner

      t.string :time_zone

      t.boolean :notify_of_responses_to_questions
      t.boolean :notify_of_responses_to_participated_in

      t.timestamps
    end
    add_index :users, :uuid
    add_index :users, :username
    add_index :users, :email
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :notify_of_responses_to_questions
    add_index :users, :notify_of_responses_to_participated_in
    add_index :users, :reset_password_token, :unique => true
    add_index :users, :confirmation_token,   :unique => true
    add_index :users, :authentication_token, :unique => true    

    create_table :companies do |t|
      t.string :uuid
      t.string :name
      t.string :tagline
      t.text :description
      t.integer :owner_id
      t.string :maildrop_address
      t.text :welcome_message
      t.boolean :auto_create_questions_from_email
      t.boolean :default_questions_to_public
      t.boolean :site_public
      t.string :logo
      t.string :favicon
      t.text :styles
      t.string :cname
      t.string :slug
      t.string :welcome_message_sidebar_widget_title
      t.boolean :welcome_message_sidebar_widget_enabled, default: true
      t.boolean :site_links_sidebar_widget_enabled, default: true
      t.boolean :tag_box_sidebar_widget_enabled, default: true
      t.timestamps
    end
    add_index :companies, :uuid
    add_index :companies, :owner_id
    add_index :companies, :maildrop_address
    add_index :companies, :cname
    add_index :companies, :slug

    create_table :team_members do |t|
      t.string :uuid
      t.integer :company_id
      t.integer :user_id
      t.boolean :notify_of_new_questions
      t.boolean :notify_of_new_answers_or_comments
      t.string :title
      t.string :role
      t.string :email
      t.string :token
      t.string :status
      t.boolean :featured
      t.integer :sort_position
      t.timestamps
    end
    add_index :team_members, :uuid
    add_index :team_members, :company_id
    add_index :team_members, :user_id
    add_index :team_members, :token
    add_index :team_members, :featured
    add_index :team_members, :sort_position
    add_index :team_members, :notify_of_new_questions
    add_index :team_members, :notify_of_new_answers_or_comments

    create_table :questions do |t|
      t.string :uuid
      t.integer :company_id
      t.integer :user_id
      t.integer :accepted_answer_id
      t.string :title
      t.text :body
      t.tsvector :tsv
      t.string :slug
      t.string :visibility
      t.boolean :site_public # keep on model to avoid abundant joins
      t.boolean :closed
      t.string :email
      t.integer :score
      t.string :tag_names
      t.datetime :last_response_date
      t.timestamps
    end
    add_index :questions, :uuid
    add_index :questions, :site_public
    add_index :questions, :user_id
    add_index :questions, :company_id
    add_index :questions, :slug
    add_index :questions, :last_response_date
    add_index :questions, :created_at
    add_index :questions, :updated_at
    add_index :questions, :accepted_answer_id

    create_table :votes do |t|
      t.integer :user_id
      t.integer :votable_id
      t.string :votable_type
      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :votable_id
    add_index :votes, :votable_type

    create_table :answers do |t|
      t.integer :question_id
      t.integer :user_id
      t.integer :company_id
      t.boolean :accepted
      t.text :body
      t.tsvector :tsv
      t.integer :score
      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :user_id
    add_index :answers, :company_id
    add_index :answers, :score
    add_index :answers, :accepted

    create_table :comments do |t|
      t.integer :answer_id
      t.integer :user_id
      t.integer :company_id
      t.text :body
      t.tsvector :tsv
      t.integer :score
      t.timestamps
    end
    add_index :comments, :answer_id
    add_index :comments, :user_id
    add_index :comments, :company_id
    add_index :comments, :score

    create_table :tags do |t|
      t.integer :company_id
      t.string :name
      t.string :slug
      t.integer :score
      t.timestamps
    end
    add_index :tags, :name
    add_index :tags, :company_id
    add_index :tags, :score
    add_index :tags, :slug

    create_table :question_tags do |t|
      t.integer :question_id
      t.integer :tag_id
    end
    add_index :question_tags, :question_id
    add_index :question_tags, :tag_id

    create_table :links do |t|
      t.integer :company_id
      t.string :title
      t.string :url
      t.integer :position
    end

    add_index :links, :company_id
    add_index :links, :position


    # finally, configure postgres full text indexes
    execute "CREATE EXTENSION unaccent"

    execute "CREATE TRIGGER questions_ts_update BEFORE INSERT OR UPDATE " +
                "ON questions FOR EACH ROW EXECUTE PROCEDURE " +
                "tsvector_update_trigger(tsv, 'pg_catalog.english', title, body, tag_names);"

    execute "CREATE TRIGGER answers_ts_update BEFORE INSERT OR UPDATE " +
                "ON answers FOR EACH ROW EXECUTE PROCEDURE " +
                "tsvector_update_trigger(tsv, 'pg_catalog.english', body);"

    execute "CREATE TRIGGER comments_ts_update BEFORE INSERT OR UPDATE " +
                "ON comments FOR EACH ROW EXECUTE PROCEDURE " +
                "tsvector_update_trigger(tsv, 'pg_catalog.english', body);"
    
    execute "CREATE INDEX questions_fti ON questions USING GIN(tsv)"
    execute "CREATE INDEX answers_fti ON answers USING GIN(tsv)"
    execute "CREATE INDEX comments_fti ON comments USING GIN(tsv)"
  end

  def down
    drop_table :users
    drop_table :questions
    drop_table :votes
    drop_table :answers
    drop_table :comments
    drop_table :tags
    drop_table :question_tags
    drop_table :companies
    drop_table :team_members
    drop_table :links

    execute "DROP EXTENSION unaccent"
  end
end
