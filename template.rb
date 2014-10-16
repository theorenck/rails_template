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

# Remove sqlite3 as default database adapter
gsub_file 'Gemfile', /gem 'sqlite3'\n/, ''

# Use postgresql as the database for Active Record
gem 'pg'

# Replace jbuilder
gem 'active_model_serializers', '~> 0.8.1'

#Use new relic extension for performance monitoring
gem 'newrelic_rpm'

# Use a Sass-powered version of Bootstrap
gem 'bootstrap-sass', '~> 3.2.0'

# Use a Sass-powered version of font-awesome icon library
gem 'font-awesome-sass', '~> 4.1.0'

# 12factor (Heroku deployment) configuration compliance 
gem 'rails_12factor', group: :production

# Add a module for CPF/CNPJ calculation
copy_from_repo 'lib/pessoa_utils.rb'

# Add a presenter base class
copy_from_repo 'app/presenters/base_presenter.rb'

# Add CPF,CNPJ and Email validators
copy_from_repo 'app/validators/cpf_validator.rb'
copy_from_repo 'app/validators/cnpj_validator.rb'
copy_from_repo 'app/validators/email_validator.rb'
