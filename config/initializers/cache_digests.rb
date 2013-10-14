# cache digests haml compatibility 
# see: https://github.com/indirect/haml-rails/issues/50
# (remove this once the version of haml
# into which it's been merged is released)

# Tell cache digests to parse haml view templates
# when calculating cache keys for view fragments
# as Rails only supports ERB by default

ActiveSupport.on_load(:action_view) do
  ActiveSupport.on_load(:after_initialize) do
    require 'action_view/dependency_tracker'
    ActionView::DependencyTracker.register_tracker :haml, ActionView::DependencyTracker::ERBTracker

    if Rails.env.development?
      # recalculate cache digest keys for each request in development

      # using blackhole cache until Rails path is released that allows us to
      # simply set `config.cache_template_loading` false in development.rb
      # https://github.com/rails/rails/pull/10791
      class BlackHole < Hash
        def []=(*); end
      end
      module ::ActionView
        class Digestor
          @@cache = BlackHole.new
        end
      end
    end
  end
end