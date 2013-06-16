class ActiveRecord::Base
  @@renderer = nil

  def renderer
    @@renderer ||= ActionController::Base.new
  end

  def urls
    Rails.application.routes.url_helpers
  end


  # Hack around load order issues popping up in the
  # edge version of devise (https://github.com/rails/rails/issues/10559). 
  def self.load_concerns(*rel_paths)
    rel_paths.each do |rel_path|
      Dir["#{Rails.root}/app/models/concerns/#{rel_path}/**/*"].each { |f|
        load f
      }
    end
  end
end