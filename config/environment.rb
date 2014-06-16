# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

if ENV['NAZAR_MACHINE']
  if defined?(Gem) && Gem::VERSION >= "1.3.6"
      module Rails
        class GemDependency
          def requirement
            r = super
            (r == Gem::Requirement.default) ? nil : r
          end
        end
      end
    end
end

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')


if Gem::VERSION >= "1.3.6"
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  config.load_paths += Dir["#{RAILS_ROOT}/app/models/**/**"]

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  config.gem "warden"
  config.gem "devise"
  config.gem "ambethia-recaptcha", :lib => "recaptcha/rails"
  #config.gem "recaptcha", :lib => "recaptcha/rails"
  #config.gem "ambethia-recaptcha", :lib => "recaptcha/rails", :source => "http://gems.github.com"

  config.gem 'sqlite3-ruby', :lib => 'sqlite3'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'thoughtbot-factory_girl', :lib => 'factory_girl', :source => 'http://gems.github.com'
  config.gem "prawn"
  config.gem "fastercsv"
#  config.gem "spreedly"
  config.gem "json"
  config.gem 'whenever', :lib => false, :source => 'http://gemcutter.org/'
  config.gem 'hoptoad_notifier'
  config.gem 'valuable'
  config.gem 'sitemap_generator'
  config.gem 'nokogiri', "1.4.2"
#  config.gem 'hpricot'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
end

#if RAILS_ENV == 'production'
#  SPREEDLY_TOKEN = 'b6c943e779fad39fca8f8305199a09732c889c26'
#  Spreedly.configure('amplifiedanalytics', SPREEDLY_TOKEN)
#else
#  SPREEDLY_TOKEN = 'dc789dd06e1b2cbfe9a5568c8baf1245d9581f0d'
#  Spreedly.configure('piplzchoice-test', SPREEDLY_TOKEN)
#end

ActionMailer::Base.smtp_settings = {
  :enable_starttls_auto => true,
  :address => 'smtp.gmail.com',
  :port => 587,
  :domain => 'amplifiedanalytics.com',
  :authentication => :plain,
  :user_name => 'support@amplifiedanalytics.com',
  #:password => 'sdf'
  :password => 'felicia777'
}

ENV['RECAPTCHA_PUBLIC_KEY']  = '6Lcdg8YSAAAAAIunq7iL9jUNQEeY8tp3PNy71eiS'
ENV['RECAPTCHA_PRIVATE_KEY'] = '6Lcdg8YSAAAAABzKZOUkW2EOMMMzqD8CDWUvaOT_'
