storage_type = Rails.application.config.active_storage.service

if Rails.env == "production"
 # storage_type =
elsif Rails.env == "development"
 storage_type = :local
else
 storage_type = :test
end
