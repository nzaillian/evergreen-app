source "http://rubygems.org"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails"

# Database gems
platforms :mri, :mingw do
  group :postgresql do
    gem "pg"
  end

  group :sqlite do
    gem "sqlite3"
  end
end

platforms :mri_18, :mingw_18 do
  group :mysql do
    gem "mysql"
  end
end

platforms :mri_19, :mingw_19 do
  group :mysql do
    gem "mysql2"
  end
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails"
  gem "coffee-rails"
  gem "uglifier"
end

group :development, :test do
  gem "factory_girl", require: "factory_girl"
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

gem "haml-rails"

gem "dalli"

gem "jquery-rails"

gem "jquery-ui-rails"

gem "jquery-turbolinks"

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem "turbolinks"

gem "figaro"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder"

gem "devise"

gem "breadcrumbs_on_rails"

gem "tabs_on_rails"

gem "handles_sortable_columns"

gem "sprockets-rails"

gem "cancan"

#gem "therubyracer"

gem "font-awesome-rails"

gem "better_errors"

gem "exception_notification", require: "exception_notifier"

gem "formtastic"

gem "formtastic-bootstrap", path: "./vendor/gems/formtastic-bootstrap"

gem "bootstrap-sass"

gem "codemirror-rails"

gem "redcarpet"

gem "mailman"

gem "kaminari"

gem "carrierwave"

#gem "rmagick"

gem "uuidtools", require: "uuidtools"

gem "mail_view"

#gem "nokogiri"

gem "friendly_id"

gem "delayed_job"

gem "daemons"

gem "delayed_job_active_record"