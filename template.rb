# Remove sqlite3 as default database adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''
gsub_file 'Gemfile', /# Use sqlite3 .*\n/, ''

# Use postgresql as the database for Active Record
append_to_file  'Gemfile', "\n\# Use postgresql as the database for Active Record"
gem 'pg'

# Replace jbuilder
append_to_file  'Gemfile', "\n\n\# Replace jbuilder"
gem 'active_model_serializers', '~> 0.8.1'

# Use LESS as dynamic stylesheet language for the Rails asset pipeline
append_to_file  'Gemfile', "\n\n\# Use LESS as dynamic stylesheet language for the Rails asset pipeline"
gem 'less-rails', '~> 2.5.0'

# Use Twitter Bootstrap view and layout generator
append_to_file  'Gemfile', "\n\n\# Use Twitter Bootstrap view and layout generator"
gem 'twitter-bootstrap-rails', '~> 3.2.0'

# 12factor (Heroku deployment) configuration compliance
append_to_file  'Gemfile', "\n\n\# 12factor (Heroku deployment) configuration compliance" 
gem 'rails_12factor', group: :production

# Use new relic extension for performance monitoring
append_to_file  'Gemfile', "\n\n\# Use new relic extension for performance monitoring"
gem 'newrelic_rpm'

# Copy files directly from repo
def copy_from_repo(filename, options = {})
  repo = 'https://raw.github.com/theorenck/rails_template/master/'
  repo = options[:repo] unless options[:repo].nil?
  source_filename = filename
  destination_filename = filename
  begin
    remove_file destination_filename
    get repo + source_filename, destination_filename
  rescue OpenURI::HTTPError
    say "Unable to obtain #{source_filename} from the repo #{repo}"
  end
end

# Add a module for CPF/CNPJ calculation
copy_from_repo 'lib/pessoa_utils.rb'

# Add a presenter base class
copy_from_repo 'app/presenters/base_presenter.rb'

# Add CPF,CNPJ and Email validators
copy_from_repo 'app/validators/cpf_validator.rb'
copy_from_repo 'app/validators/cnpj_validator.rb'
copy_from_repo 'app/validators/email_validator.rb'

# Configure postgresql database
copy_from_repo 'config/database.yml'
begin
  say "Creating a database configuration '#{app_name}' for PostgreSQL"
  gsub_file "config/database.yml", /database: myapp_development/, "database: #{app_name.underscore}_development"
  gsub_file "config/database.yml", /database: myapp_test/,        "database: #{app_name.underscore}_test"
  gsub_file "config/database.yml", /database: myapp_production/,  "database: #{app_name.underscore}_production"
rescue StandardError
  raise "unable to create database configuration for PostgreSQL"
end

run 'bundle install --without production'

# Install and create bootstrap layouts
run 'rails g bootstrap:install'
run 'rails g bootstrap:layout application'

# Initialize git repo, add and commit
git :init
git add: %Q{ --all }
git commit: %Q{ -m "Initial commit" }
