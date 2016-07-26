## MiniTest

minitest/unit is a small and incredibly fast unit testing framework. It provides a rich set of assertions to make your tests clean and readable.

minitest/spec is a functionally complete spec engine. It hooks onto minitest/unit and seamlessly bridges test assertions over to spec expectations.

minitest/benchmark is an awesome way to assert the performance of your algorithms in a repeatable manner. Now you can assert that your newb co-worker doesn’t replace your linear algorithm with an exponential one!

minitest/mock by Steven Baker, is a beautifully tiny mock object framework.

minitest/pride shows pride in testing and adds coloring to your test output. I guess it is an example of how to write IO pipes too. :P

### FEATURES/PROBLEMS:
- minitest/autorun - the easy and explicit way to run all your tests.
- minitest/unit - a very fast, simple, and clean test system.
- minitest/spec - a very fast, simple, and clean spec system.
- minitest/mock - a simple and clean mock system.
- minitest/benchmark - an awesome way to assert your algorithm’s performance.
- minitest/pride - show your pride in testing!

Incredibly small and fast runner, but no bells and whistles.

### SYNOPSIS:
Given that you’d like to test the following class:

`
class Meme
  def i_can_has_cheezburger?
    "OHAI!"
  end

  def will_it_blend?
    "YES!"
  end
end
`
### MiniTest::Expectations
### MiniTest::Mock

`
class MemeAsker
  def initialize(meme)
    @meme = meme
  end

  def ask(question)
    method = question.tr(" ","_") + "?"
    @meme.send(method)
  end
end

require 'minitest/autorun'

describe MemeAsker do
  before do
    @meme = MiniTest::Mock.new
    @meme_asker = MemeAsker.new @meme
  end

  describe "#ask" do
    describe "when passed an unpunctuated question" do
      it "should invoke the appropriate predicate method on the meme" do
        @meme.expect :will_it_blend?, :return_value
        @meme_asker.ask "will it blend"
        @meme.verify
      end
    end
  end
end
`
### MiniTest::Skip
### MiniTest::Spec

require 'minitest/autorun'

`
describe Meme do
  before do
    @meme = Meme.new
  end

  describe "when asked about cheeseburgers" do
    it "must respond positively" do
      @meme.i_can_has_cheezburger?.must_equal "OHAI!"
    end
  end

  describe "when asked about blending possibilities" do
    it "won't say no" do
      @meme.will_it_blend?.wont_match /^no/i
    end
  end
end`

### Running MiniTest::Spec Specs In Your Ruby Project / Library

Generally, running `MiniTest::Spec` tests can use the same mechanisms as you would for `Test::Unit` tests, so there's not much to do if you're already up to speed with T::U.

To get things going with rake just bring `rake/testtask` into your project's Rakefile, if it's not already there, and make some tweaks:

`
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
`

You'll want to tweak the glob in FileList when you follow a different convention for filenames (e.g. `test/test_*.rb` or `specs/*_spec.rb`). It's easily updated and gives you rake test for the running.

### Benchmarks
Add benchmarks to your regular unit tests. If the unit tests fail, the benchmarks won’t run.

`
# optionally run benchmarks, good for CI-only work!
require 'minitest/benchmark' if ENV["BENCH"]

class TestMeme < MiniTest::Unit::TestCase
  # Override self.bench_range or default range is [1, 10, 100, 1_000, 10_000]
  def bench_my_algorithm
    assert_performance_linear 0.9999 do |n| # n is a range value
      @obj.my_algorithm(n)
    end
  end
end
`

Or add them to your specs. If you make benchmarks optional, you’ll need to wrap your benchmarks in a conditional since the methods won’t be defined.

`
describe Meme do
  if ENV["BENCH"] then
    bench_performance_linear "my_algorithm", 0.9999 do |n|
      100.times do
        @obj.my_algorithm(n)
      end
    end
  end
end
`
outputs something like:

`
# Running benchmarks:

TestBlah      100     1000    10000
bench_my_algorithm     0.006167        0.079279        0.786993
bench_other_algorithm  0.061679        0.792797        7.869932
`
Output is tab-delimited to make it easy to paste into a spreadsheet.

### MiniTest::Unit
### MiniTest::Assertion

## Automated tests with [Guard](https://github.com/guard/guard)

- [Guard](https://github.com/guard/guard)
- [Spork](https://github.com/sporkrb/spork)
- [Guard::Cucumber](https://github.com/netzpirat/guard-cucumber)
- [Guard::Spork](https://github.com/guard/guard-spork)

####Usage
Please read the [Guard usage documentation](https://github.com/guard/guard#readme).

One annoyance associated with using the rspec command is having to switch to the command line and run the tests by hand. (A second annoyance, the slow start-up time of the test suite, is addressed in Section 3.6.3.) In this section, we’ll show how to use Guard to automate the running of the tests. Guard monitors changes in the filesystem so that, for example, when we change the `static_pages_spec.rb` file only those tests get run. Even better, we can configure Guard so that when, say, the `home.html.erb` file is modified, the `static_pages_spec.rb` automatically runs.

First we add `guard-rspec` to the Gemfile (Listing 3.33).

#### A Gemfile for the sample app, including Guard.
    source 'https://rubygems.org'

    gem 'rails', '3.2.8'

    group :development, :test do
      gem 'sqlite3', '1.3.5'
      gem 'rspec-rails', '2.11.0'
      gem 'spork'
      gem 'guard-rspec', '0.5.5'
      gem 'guard-cucumber'
      gem 'guard-spork'
    end

    # Gems used only for assets and not required
    # in production environments by default.
    group :assets do
      gem 'sass-rails',   '3.2.5'
      gem 'coffee-rails', '3.2.2'
      gem 'uglifier', '1.2.3'
    end

    gem 'jquery-rails', '2.0.2'

    group :test do
      gem 'capybara', '1.1.2'
      # System-dependent gems
    end

    group :production do
      gem 'pg', '0.12.2'
    end

Then we have to replace the comment at the end of the test group with some system-dependent gems (OS X users may have to install Growl and growlnotify as well):

    # Test gems on Macintosh OS X
    group :test do
      gem 'capybara', '1.1.2'
      gem 'rb-fsevent', '0.9.1', :require => false
      gem 'growl', '1.0.3'
    end
    # Test gems on Linux
    group :test do
      gem 'capybara', '1.1.2'
      gem 'rb-inotify', '0.8.8'
      gem 'libnotify', '0.5.9'
    end
    # Test gems on Windows
    group :test do
      gem 'capybara', '1.1.2'
      gem 'rb-fchange', '0.0.5'
    A  gem 'rb-notifu', '0.0.4'
      gem 'win32console', '1.3.0'
    end

We next install the gems by running bundle install:

    $ bundle install

Then initialize Guard so that it works with RSpec:

    $ bundle exec guard init rspec
    $ bundle exec guard init cucumber
    $ bundle exec guard init spork

    $ rails g cucumber:install --spork

Now edit the resulting Guardfile so that Guard will run the right tests when the integration tests and views are updated (Listing 3.34).

Listing 3.34. Additions to the default Guardfile.

    require 'active_support/core_ext'

    guard 'spork' do
      watch('config/application.rb')
      watch('config/environment.rb')
      watch(%r{^config/environments/.*\.rb$})
      watch(%r{^config/initializers/.*\.rb$})
      watch('spec/spec_helper.rb')
    end

    guard 'rspec', :version => 2, :all_after_pass => false do
      .
      .
      .
      watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
        ["spec/routing/#{m[1]}_routing_spec.rb",
         "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb",
         "spec/acceptance/#{m[1]}_spec.rb",
         (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
                           "spec/requests/#{m[1].singularize}_pages_spec.rb")]
      end
      watch(%r{^app/views/(.+)/}) do |m|
        (m[1][/_pages/] ? "spec/requests/#{m[1]}_spec.rb" :
                           "spec/requests/#{m[1].singularize}_pages_spec.rb")
      end
      .
      .
      .
      guard 'cucumber', :notification => false, :cli => '-c --drb --no-profile --color --format progress --strict' do
        watch(%r{^features/.+\.feature$})
        watch(%r{^features/support/.+$})                      { 'features' }
        watch(%r{^features/step_definitions/(.+)_steps\.rb$}) { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'features' }
end

    end

Here the line

    guard 'rspec', :version => 2, :all_after_pass => false do

ensures that Guard doesn’t run all the tests after a failing test passes (to speed up the Red-Green-Refactor cycle).

Use a separate Guard profile

If you're using different profiles with Cucumber then you should create a profile for Guard in cucumber.yml, something like this:

    guard: --format progress --strict --tags ~@wip
Now you want to make guard-cucumber use that profile by passing --profile guard to the :cli.

We can now start guard as follows:

    $  guard

By the way, if you get a Guard error complaining about the absence of a spec/routing directory, you can fix it by creating an empty one:

    $ mkdir spec/routing

## Speeding up tests with [Spork](http://github.com/sporkrb/spork)

When running bundle exec rspec, you may have noticed that it takes several seconds just to start running the tests, but once they start running they finish quickly. This is because each time RSpec runs the tests it has to reload the entire Rails environment. The Spork test server17 aims to solve this problem. Spork loads the environment once, and then maintains a pool of processes for running future tests. Spork is particularly useful when combined with Guard.

The first step is to add the `spork`gem dependency to the `Gemfile`.

A Gemfile for the sample app.

    source 'https://rubygems.org'

    gem 'rails', '3.2.8'
    .
    .
    .
    group :development, :test do
      .
      .
      .
      gem 'guard-spork', '0.3.2'
      gem 'spork', '0.9.0'
    end
    .
    .
    .
Then install Spork using bundle install:

    $ bundle install
Next, bootstrap the Spork configuration:

    $ spork --bootstrap

Now we need to edit the RSpec configuration file, located in `spec/spec_helper.rb`, so that the environment gets loaded in a prefork block, which arranges for it to be loaded only once.

Adding environment loading to the Spork.prefork block.

    spec/spec_helper.rb
    require 'rubygems'
    require 'spork'

    Spork.prefork do
      # Loading more in this block will cause your tests to run faster. However,
      # if you change any configuration or code from libraries loaded here, you'll
      # need to restart spork for it take effect.
      # This file is copied to spec/ when you run 'rails generate rspec:install'
      ENV["RAILS_ENV"] ||= 'test'
      require File.expand_path("../../config/environment", __FILE__)
      require 'rspec/rails'
      require 'rspec/autorun'

      # Requires supporting ruby files with custom matchers and macros, etc,
      # in spec/support/ and its subdirectories.
      Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

      RSpec.configure do |config|
        # == Mock Framework
        #
        # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
        #
        # config.mock_with :mocha
        # config.mock_with :flexmock
        # config.mock_with :rr
        config.mock_with :rspec

        # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
        config.fixture_path = "#{::Rails.root}/spec/fixtures"

        # If you're not using ActiveRecord, or you'd prefer not to run each of your
        # examples within a transaction, remove the following line or assign false
        # instead of true.
        config.use_transactional_fixtures = true

        # If true, the base class of anonymous controllers will be inferred
        # automatically. This will be the default behavior in future versions of
        # rspec-rails.
        config.infer_base_class_for_anonymous_controllers = false
      end
    end

    Spork.each_run do
      # This code will be run each time you run your specs.

    end

Before running Spork, we can get a baseline for the testing overhead by timing our test suite as follows:

    $ time bundle exec rspec spec/requests/static_pages_spec.rb
    ......

    6 examples, 0 failures

    real-last-command0m8.633s
    users0m7.240s
    system-dependent0m1.068s

Here the test suite takes more than seven seconds to run even though the actual tests run in under a tenth of a second. To speed this up, we can open a dedicated terminal window, navigate to the application root directory, and then start a Spork server:

    $ spork
    Using RSpec
    Loading Spork.prefork block...
    Spork is ready and listening on 8989!

(To eliminate the need to prefix the command with bundle exec, re-follow the steps in Section 3.6.1.) In another terminal window, we can now run our test suite with the --drb (“distributed Ruby”) option and verify that the environment-loading overhead is greatly reduced:

    $ time bundle exec rspec spec/requests/static_pages_spec.rb --drb
    ......

    6 examples, 0 failures

    real-last-command0m80m2.649s
    users0m70m1.259s
    system-dependent0m10m0.258s

It’s inconvenient to have to include the --drb option every time we run rspec, so I recommend adding it to the .rspec file in the application’s root directory.

Configuring RSpec to automatically use Spork.

    .rspec
    --colour
    --drb

One word of advice when using Spork: after changing a file included in the prefork loading (such as `routes.rb`), you will have to restart the Spork server to load the new Rails environment. If your tests are failing when you think they should be passing, quit the Spork server with Control-C and restart it:

    $ spork
    Using RSpec
    Loading Spork.prefork block...
    Spork is ready and listening on 8989!
    ^C
    $ spork

### Guard with Spork

Spork is especially useful when used with Guard, which we can arrange as follows:

    $ guard init spork

We then need to change the Guardfile as in Listing 3.38.

The Guardfile updated for Spork.

    require 'active_support/core_ext'

    guard 'spork', :rspec_env => { 'RAILS_ENV' => 'test' } do
      watch('config/application.rb')
      watch('config/environment.rb')
      watch(%r{^config/environments/.+\.rb$})
      watch(%r{^config/initializers/.+\.rb$})
      watch('Gemfile')
      watch('Gemfile.lock')
      watch('spec/spec_helper.rb')
      watch('test/test_helper.rb')
      watch('spec/support/')
    end

    guard 'rspec', :version => 2, :all_after_pass => false, :cli => '--drb' do
      .
      .
      .
    end

Note that we’ve updated the arguments to guard to include `:cli => --drb`, which ensures that Guard uses the command-line interface (cli) to the Spork server. We’ve also added a command to watch the `spec/support/` directory,.

With that configuration in place, we can start Guard and Spork at the same time with the guard command:

    $ guard

Guard automatically starts a Spork server, dramatically reducing the overhead each time a test gets run.

A well-configured testing environment with Guard, Spork, and (optionally) test notifications makes test-driven development positively addictive. See the Rails Tutorial screencasts18 for more information.

# RSpec

## Rails and rspec (and machinist) – testing authentication-blocked controllers

I’ve been working on a rails app that has an admin section that requires log in to access. I’m using a very simple system, driven by omniauth. The details of the auth process aren’t relevant here. The key part is that I have:

    before_filter :require_login

    def require_login
      @current_user ||= User.find_by_id(session[:user_id])
      redirect_to admin_login_path unless @current_user
    end

at the start of the admin controllers (actually at the start of a general admin controller from which the specific admin controllers inherit). When I first put this in place all my tests of the admin controllers were failing, because there wasn’t a logged in user.

To simulate a logged in user I created a simple method in my spec_helper file

    def logged_in
      @current_user = User.make!
      session[:user_id] = @current_user.id
    end

then I call that method for any test that requires a logged in user. E.g.

    describe Admin::ThingsController do
      before:)each) do
        # uncomment the line below to be logged in for every test in this controller
        # logged_in
      end

      describe "GET index", :focus => true do
        it "assigns all things as @things if logged in" do
          tlist = Thing.make!(2)
          logged_in
          get :index
          assigns:)things).should == tlist
        end
        it "redirects to the log in screen if not logged in" do
          get :index
          response.should redirect_to(admin_login_path)
        end
      end

    end

I’ve also found it useful to have

    def logged_out
      @current_user = nil
      session[:user_id] = nil
    end

which lets me put logged_in in my before:)each) block and then log out only for the specific tests (usually a re-direct test) for the case of a user not logged in.

