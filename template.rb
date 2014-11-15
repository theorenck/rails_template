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

def ask_wizard(question)
  ask "\033[1m\033[30m\033[46m" + "prompt".rjust(10) + "\033[1m\033[36m" + "  #{question}\033[0m"
end

def yes_wizard?(question)
  answer = ask_wizard(question + " \033[33m(Y/n)\033[0m")
  case answer.downcase
    when "yes", "y", ""
      true
    when "no", "n"
      false
    else
      yes_wizard?(question)
  end
end

### Use postgresql 

postgresql = yes_wizard?("Do you want to change the database adapter to PostgreSQL?")

if postgresql

  # Remove sqlite3 as default database adapter
  gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''
  gsub_file 'Gemfile', /# Use sqlite3 .*\n/, ''

  # Use postgresql as the database for Active Record
  append_to_file  'Gemfile', "\n\# Use postgresql as the database for Active Record"
  gem 'pg'

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
end

### API Configuration

api = yes_wizard?("Do you want to prepare this app to serve an API?")

if api

  # Replace jbuilder
  append_to_file  'Gemfile', "\n\n\# Replace jbuilder"
  gem 'active_model_serializers', '~> 0.8.1'

  # Use to provide support for Cross-Origin Resource Sharing (CORS) with Rack
  append_to_file  'Gemfile', "\n\n\# Use to provide support for Cross-Origin Resource Sharing (CORS) with Rack"
  gem 'rack-cors', require: 'rack/cors'

end

### Use Bootstrap

bootstrap = yes_wizard?("Do you want to use bootstrap to style your views?")

if bootstrap

  # Use a Sass-powered version of Bootstrap
  append_to_file  'Gemfile', "\n\n\# Use a Sass-powered version of Bootstrap"
  gem 'bootstrap-sass', '~> 3.2.0'

  # Use to install layout and view generator for bootstrap
  append_to_file  'Gemfile', "\n\n\# Use to install layout and view generator for bootstrap"
  gem 'bootstrap-sass-extras'

  run 'rails g bootstrap:install'
  run 'rails g bootstrap:layout application fluid -f'

  # TODO: @import "bootstrap-sprockets";
  # TODO: @import "bootstrap";

end

### Add Theo's Custom Libraries

libs = yes_wizard?("Do you want to add Theo's custom libraries? (Presenters, Validators, etc.)")

if libs

  # Add a presenter base class
  copy_from_repo 'app/presenters/base_presenter.rb'

  # Add a module for CPF/CNPJ calculation
  copy_from_repo 'lib/pessoa_utils.rb'

  # Add CPF,CNPJ and Email validators
  copy_from_repo 'app/validators/cpf_validator.rb'
  copy_from_repo 'app/validators/cnpj_validator.rb'
  copy_from_repo 'app/validators/email_validator.rb'

end

heroku = yes_wizard?("Do you plan to deploy this app on Heroku?")

if heroku

  # 12factor (Heroku deployment) configuration compliance
  append_to_file  'Gemfile', "\n\n\# 12factor (Heroku deployment) configuration compliance" 
  gem 'rails_12factor', group: :production

end

append_to_file  'Gemfile', "\n\n\# Use Web-Console for debbug" 
gem 'web-console', '2.0.0.beta3', group: :development

append_to_file  'Gemfile', "\n\n\# Use Rails ER Diagram generator" 
gem 'rails-erd', group: :development 

run 'bundle install --without production'

### Initialize Git Repopository

git_init = yes_wizard?("Do you want to init a git repo for this app?")

if git_init

  # Initialize git repo, add and commit
  git :init
  git add: %Q{ --all }
  git commit: %Q{ -m "Initial commit" }

end
