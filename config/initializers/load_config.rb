APP_CONFIG = HashWithIndifferentAccess.new(YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env])
