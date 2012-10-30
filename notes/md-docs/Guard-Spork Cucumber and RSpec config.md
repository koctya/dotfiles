# Guard-Spork Cucumber and RSpec config.

#### add to Gemfile

    group :development, :test do
      gem 'spork', '~> 0.9.0'
      gem 'guard-spork', '~> 0.3.2'
      gem 'guard-rspec', '~> 0.5.10'
      gem 'guard-cucumber', '~> 1.2.0'

`bundle install`

Optional: install cucumber with spork flag;

    rails generate cucumber:install --spork

#### Cucumber

bootstrap your testhelper files

    spork cucumber --bootstrap	  

config/cucumber.yml

	<%
	rerun = File.file?('rerun.txt') ? IO.read('rerun.txt') : ""
	rerun_opts = rerun.to_s.strip.empty? ? "--format #{ENV['CUCUMBER_FORMAT'] || 'progress'} features" : "--format #{ENV['CUCUMBER_FORMAT'] || 'pretty'} #{rerun}"
	std_opts = "--format #{ENV['CUCUMBER_FORMAT'] || 'pretty'} --strict --tags ~@wip"
	%>
	default: --drb <%= std_opts %> features
	wip: --drb --tags @wip:3 --wip features
	rerun:--drb  <%= rerun_opts %> --format rerun --out rerun.txt --strict --tags ~@wip

running cucumber tests to a spork server on another port;

    cucumber --drb --port 8999 

#### Rspec

bootstrap your testhelper files

    spork rspec --bootstrap

add --drb to .rspec file, to run rspecs using spork without having to add the flag on the cmdline.

edit spec/spec_helper.rb

    require 'spork'

    Spork.prefork do
      # ...
      RSpec.configure do |config|
        # ...
        config.treat_symbols_as_metadata_keys_with_true_values = true
        config.filter_run :focus => true
        config.run_all_when_everything_filtered = true
      end
    end
    
    Spork.each_run do
      # This code will be run each time you run your specs.
      FactoryGirl.reload
    end

running rspec tests to a spork server on another port;

    spork -p 5555
    rspec spec --drb --drb-port 5555

#### Guardfile

Initialize the guardfile

    guard init spork
    guard init cucumber
    guard init rspec

###### IMPORTANT: place Spork guard before RSpec/Cucumber/Test::Unit guards!

Pass the :cli => "--drb" option to Guard::RSpec and/or Guard::Cucumber to run them over the Spork DRb server:
(add  `, :bundler => false` to speed up tests where the bundler environment is loaded each time)

port options for starting spork servers

    :test_unit_port => 1233                    # Default: 8988
    :rspec_port => 1234                        # Default: 8989
    :cucumber_port => 4321                     # Default: 8990
    
	# A sample Guardfile
	# More info at https://github.com/guard/guard#readme
	require 'active_support/core_ext'

	guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' }, :bundler => false do
	  watch('config/application.rb')
	  watch('config/environment.rb')
	  watch(%r{^config/environments/.+\.rb$})
	  watch(%r{^config/initializers/.+\.rb$})
	  watch('Gemfile')
	  watch('Gemfile.lock')
	  watch('spec/spec_helper.rb')
	  watch('test/test_helper.rb')
	end

	guard 'rspec', :version => 2, :all_after_pass => false, :cli => '--drb' do
	  watch(%r{^spec/.+_spec\.rb$})
	  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
	  watch('spec/spec_helper.rb')  { "spec" }

	  # Rails example
	  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
	  watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
	  watch(%r{^app/controllers/(.+)_(controller)\.rb$}) do |m|
		["spec/routing/#{m[1]}_routing_spec.rb",
		 "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
		 "spec/acceptance/#{m[1]}_spec.rb",
		 (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
						   "spec/requests/#{m[1].singularize}_spec.rb")]
	  end
	  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
	  watch('config/routes.rb')                           { "spec/routing" }
	  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
	  # Capybara request specs
	  watch(%r{^app/views/(.+)/.*\.(erb|haml)$})  do |m|
		(m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
						   "spec/requests/#{m[1].singularize}_spec.rb")
	  end
	end

    guard 'cucumber', :cli => "--drb", :all_after_pass => false do
      watch(%r{^features/.+\.feature$})
      watch(%r{^features/support/.+$})          { 'features' }
      watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
    end

### Running
Start Guard and Spork at the same time with the guard command:

    $ guard

Guard automatically starts the Spork server(s), and watches cucumber and rspec test files.

## Tip: ... iceberg...

As of Sep 27, 2012 many guard gems are available to watch other types of files, here are a few;

    guard (1.4.0)
    guard-annotate (1.0.0)
    guard-autorefresh (0.0.1)
    guard-coffeescript (1.2.0)
    guard-cucumber (1.2.0)
    guard-frank (0.2.1)
    guard-go (0.0.4)
    guard-haml (0.4)
    guard-haml-coffee (0.2.0)
    guard-jasmine (1.8.3)
    guard-jasmine-headless-webkit (0.3.2)
    guard-livereload (1.0.1)
    guard-markdown (0.2.0)
    guard-middleman (0.1.0)
    guard-minitest (0.5.0)
    guard-redcarpet (0.0.1)
    guard-rspec (1.2.1)
    guard-sass (1.0.0)
    