
# Capybara-WebKit: Bringing WebKit to your integration tests

Capybara supports using different ‘drivers’ to run the scenarios you specify and by default it’ll use Rack::Test or Selenium (which uses Firefox’s Gecko engine). [capybara-webkit](https://github.com/thoughtbot/capybara-webkit) is a library by the guys at Thoughtbot that gives Capybara a WebKit-powered driver using the WebKit implementation in Qt, a popular cross-platform development toolkit.

## Installation

Here’s the bad news. You need Qt installed in order to install capybara-webkit. If you’re on OS X, [grab it from here](http://qt.nokia.com/downloads/qt-for-open-source-cpp-development-on-mac-os-x) (pick the Cocoa: Mac binary package – the 206MB version). You can install via homebrew too (using brew install qt), but Thoughtbot says it takes forever (well, almost).

For other platforms, check out Qt’s [Downloads page](http://qt.nokia.com/downloads).
If you’re on CentOS, in particular, check this article.
d
Once you’ve installed the Qt toolkit, add this to your app’s Gemfile:

	gem 'capybara-webkit'

Then run *bundle* and you’re off to the races.

## Usage

Once everything’s installed, you can set Capybara’s JavaScript driver to use Webkit by default, by adding this to your normal Capybara config options (or if you have none, in spec/spec_helper.rb in most Rails 3 cases):

	Capybara.javascript_driver = :webkit

Then, if you’re using Cucumber you can add the following tag to the header of your scenario to trigger JavaScript usage specifically (it’s not done by default):

	@javascript

In regular RSpec code, you can do something like this:

	feature "The signup page" do
		scenario "should load", :js => true do
			visit new_user_registration_path
			page.should have_selector("form.user_new")
		end
	end

You could also use the *:driver* option to specify *:webkit* if you want to choose the driver on a per scenario / describe basis. The same applies to *@webkit* in Cucumber.

If you’re on OS X, when you first run tests using capybara-webkit the OS X firewall might go a little crazy since it works by connecting over a socket. Just approve it and you’re on your way.

You may also have issues if you’re using transaction fixtures. If so, read the “Transactional Fixtures” section of the [Capybara README](https://github.com/cavalle/capybara).

----
# [Configure capybara-webkit to run acceptance specs with Javascript/AJAX](http://rainux.org/configure-capybara-webkit-to-run-acceptance-specs-with-javascript-ajax)

- Add capybara-webkit to your Gemfile and let Guard::Bundler install it automatically (or manually via bundle install if you don’t use Guard).

	gem 'capybara-webkit', '>= 1.0.0.beta4'  
- Set Javascript driver to :webkit for Capybara in spec_helper.rb.

	Capybara.javascript_driver = :webkit  
- Configure RSpec use non-transactional fixtures, configure [Database Cleaner](https://github.com/bmabey/database_cleaner) in *spec_helper.rb.*

> Notice with this setup, we’ll only use truncation strategy when driver is not *:rack_test*. this will make normal specs run faster.

	
	config.use_transactional_fixtures = false  
	  
	config.before :each do  
	  if Capybara.current_driver == :rack_test  
	    DatabaseCleaner.strategy = :transaction  
	    DatabaseCleaner.start  
	  else  
	    DatabaseCleaner.strategy = :truncation  
	  end  
	end  
	  
	config.after :each do  
	  DatabaseCleaner.clean  
	end

- Tag your scenarios in spec/acceptance/*_spec.rb to use Javascript driver if necessary.

	scenario 'Create a lolita via AJAX', :js => true do  
	end  

- Wait for any AJAX call to be completed in your specs. This is very important, or you will get many strange issues like no database record found, AJAX call get empty response with 0 status code, etc.

> For example if you have a simple AJAX form, the success callback will simply redirect browser to another page via location.href = '/yet_another_page';. You can use the following code to wait for it done.


	scenario 'Create a lolita via AJAX', :js => true do  
	  visit new_lolita_path  
	  
	  click_on 'Submit'  
	  
	  wait_until { page.current_path == lolita_path(Lolita.last) }  
	  
	  # Your expections for the new page  
	end  

----
# [Taming a Capybara](http://www.emmanueloga.com/2011/07/26/taming-a-capybara.html)
![](images/capybara.jpg)


Running acceptance tests in our rails 3 application turned out to be non trivial, even though there are excellent tools out there, and they keep getting better.

We are currently using [capybara](https://github.com/jnicklas/capybara) with the [capybara-webkit driver](https://github.com/thoughtbot/capybara-webkit), which is great because it runs in headless mode, without annoying browser windows popping up. I heard the QT download can be pretty big for mac users though, so have some spare bandwidth around if you have a mac and are planning to give it a try.

As we kept adding tests, the size of our **spec/support/capybara.rb** file grew with a lot of hacks. Here is an anotated version of that file and some others related, should it be helpful to anybody out there. Perhaps somebody will want to comment on better solutions for some of the nasty hacks.

### Gemfile
	group :test do
	  gem 'capybara', '~> 1.0.0'
	
	  # The git version worked better for us at the time we installed it.
	  gem 'capybara-webkit', :git => "git://github.com/thoughtbot/capybara-webkit"
	
	  # This is needed by capybara's save_and_open_page method.
	  gem 'launchy'
	
	  # This *might* be needed in some setups
	  gem 'database_cleaner'
	end

### config/initializers/session_store.rb

	# We deploy our application to several different subdomains, and we need
	# to configure the domain for cookies in order to avoid the sessions
	# getting mixed.
	# But the domain option was messing with capybara browsers' ability to
	# remember cookies, so we just exclude the domain config on the test environment.
	options = { :key => "_our_app_session_#{Rails.env}" }
	options[:domain] = Settings.cookies_host unless Rails.env.test?

	Rails.application.config.session_store :cookie_store, options

### spec/spec_helper.rb

	RSpec.configure do |config|
	  # .. rspec stuff
	end
	
	# This is how we load our support files for rspec, this keeps the size of
	# the spec_helper.rb file manageable.
	Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
	
### spec/support/capybara.rb

	require "capybara/rails"
	require 'capybara/rspec'
	
	# Setup capybara webkit as the driver for javascript-enabled tests.
	Capybara.javascript_driver = :webkit
	
	# In our setup, for some reason the browsers capybara was driving were
	# not openning the right host:port. Below, we force the correct
	# host:port.
	Capybara.server_port = 7787
	
	# We have more than one controller inheriting from
	# ActionController::Base, and, in our app, ApplicationController redefines
	# the default_url_options method, so we need to redefine the method for
	# the two classes.
	[ApplicationController, ActionController::Base, Listing].each do |klass|
	  klass.class_eval do
	    def default_url_options(options = {})
	      { :host => "127.0.0.1", :port => Capybara.server_port }.merge(options)
	    end
	  end
	end
	
	# Here we do some selective configuration for tests which run with the
	# rack backend and tests which run with the webkit backend.
	RSpec.configure do |config|
	  # In order for the database to have the same data both for the
	  # capybara process and the web application process, we need either to
	  # disable transactional fixtures (which produces very slow runs),
	  # or use the hack you can find below in this file.
	  config.use_transactional_fixtures = true
	
	  # Uncomment in case your db gets dirty somehow.
	  # DatabaseCleaner.clean_with(:truncation)
	
	  config.before :each do
	    if Capybara.current_driver != :rack_test
	      # With selenium/webkit the host is set automatically if it was nil.
	      Capybara.app_host = nil
	    # config.use_transactional_fixtures = false
	    # $use_truncation = true
	    else
	      # We found Capybara.app_host needs to be nil when using rack backend,
	      # but point to 127.0.0.1 when using selenium or webkit.
	      Capybara.app_host = "http://127.0.0.1"
	    # config.use_transactional_fixtures = true
	    end
	  end
	
	# config.after :each do
	#   DatabaseCleaner.clean_with(:truncation) if $use_truncation
	# end
	end
	
	# Big Fat Hack (TM) so the ActiveRecord connections are shared across threads.
	# This is a variation of a hack you can find all over the web to make
	# capybara usable without having to switch to non transactional
	# fixtures.
	# http://groups.google.com/group/ruby-capybara/browse_thread/thread/248e89ae2acbf603/e5da9e9bfac733e0
	Thread.main[:activerecord_connection] = ActiveRecord::Base.retrieve_connection
	
	def (ActiveRecord::Base).connection
	  Thread.main[:activerecord_connection]
	end
	
	# Last but not least, when using capybara-webkit sometimes the response
	# is not available when capybara tries to retrieve the contents of the
	# page. Of all the possible solutions, this was the simplest for us:
	# introducing a fixed delay each time something is clicked in the browser.
	# https://github.com/thoughtbot/capybara-webkit/issues/111
	class Capybara::Driver::Webkit::Browser
	  alias original_command command
	
	  def command(name, *args)
	    result = original_command(name, *args)
	    sleep(1) if args.first == "click"
	    result
	  end
	end
	
### Final Thoughts

Even though the config above allows our acceptance tests to merrily run, I'm not completely satisfied with the hoops we needed to jump in order to get things to work.

I have the feeling having the acceptance tests completely isolated from the main application (even in a separate repository) could be a good thing. In this direction it would be worthy to try and write the acceptance tests using a tool like phantomjs. I'm not talking about getting a phantomjs driver for capybara, but directly writing the whole acceptance suite with phantomjs in javascript.

## Integration Testing & Capybara-Webkit
    UPDATE: After this article I posted a gist titled Never sleep() using Capybara! that details how to deal with CSS animations and AJAX requests using Capybara. Check it out too!
Those that know me are familiar that I do not use RSpec or Test::Unit but instead opt for a simple testing framework built into Ruby 1.9, [MiniTest::Spec](http://metaskills.net/2011/03/26/using-minitest-spec-with-rails/). I also use the [Capybara-WebKit](https://github.com/thoughtbot/capybara-webkit) driver for my acceptance testing in both Rails 2.3 and [Rails 3.1's](https://github.com/metaskills/holygrail_rails31) standard integration test layer. Reference the `integration_test_helper.rb` file in each link above to learn how to use Capybara-WebKit with your rails app. Thanks to Wyatt Greene for his original article on the matter.

So why the fuss? Well Capybara-WebKit is a headless WebKit browser that you can direct right from your test suite. What makes it so awesome is that it renders web pages with full JavaScript support and is much faster than selenium based Capybara drivers. Since jQuery Mobile is entirely based on JavaScript with HTML & CSS3 - Capybara-WebKit is a perfect candidate to acceptance test your mobile application. The only gotcha is scoping your Capybara actions to a certain page that is dynamically loaded into the DOM. No problem! This is easily solvable using the page ids from the `mobile_page_id` helper method I mentioned above. So whatever your testing framework, here are a few helpers that are critical. Assume these are mixed into your test helper.

    private
    
    include MobileConcerns::Helpers # Mentioned above.
    
    def current_page_id(path=nil)
      path = path || current_path
      "div##{mobile_page_id(path)}.ui-page-active"
    end
    
    def current_page(path=nil)
      find(current_page_id(path))
    end
    
    def within_current_page(path=nil)
      within(current_page_id(path)) { yield }
    end

So let's go over these. First is the `current_page_id` method. Most of the time you are going to pass a path argument to this method, since the Capybara's `current_path` will only work correctly on the first page load, not each following AJAX page load which would change the location hash. See how this is using the `mobile_page_id` helper mixed in and described above? Next is the `current_page` helper. It finds the passed path/id with Capybara's find method. The `within_current_page` leverages Capybara's `within` helper to scope your action to that particular DOM element. Here is a classic example using these.

    should 'be able to navigate to logged in user page and change email' do
      login_as @user
      visit mobile_homepage_path
      click_on 'My Account'
      user_path = mobile_user_path(@user)
      assert current_page(user_path)
      # Change email
      new_email = Forgery(:email).address
      within_current_page(user_path) do
        fill_in 'email', :with => new_email
        click_button 'Save Changes'
      end
      @user.reload.email.must_equal new_email
    end

Hopefully you can see how this simple page id foundation can help you better test your jQuery Mobile app with Capybara-WebKit. What an awesome tool! I sometimes find it hard to believe we are now at the point where we can easily test this much JavaScript in a headless browser directed by Ruby.

    # Have you ever had to sleep() in Capybara-WebKit to wait for AJAX and/or CSS animations?
    
    describe 'Modal' do
      
      should 'display login errors' do
        visit root_path
        click_link 'My HomeMarks'
        within '#login_area' do
          fill_in 'email', with: 'will@not.work'
          fill_in 'password', with: 'test'
          click_button 'Login'
        end
        # DO NOT sleep(1) HERE!
        assert_modal_visible
        page.find(modal_wrapper_id).text.must_match %r{login failed.*use the forgot password}i
      end
      
    end
    
    # Avoid it by using Capybara's #wait_until method. My modal visible/hidden helpers
    # do just that. The #wait_until uses the default timeout value.
    
    def modal_wrapper_id
      '#hmarks_modal_sheet_wrap'
    end
    
    def assert_modal_visible
      wait_until { page.find(modal_wrapper_id).visible? }
    rescue Capybara::TimeoutError
      flunk 'Expected modal to be visible.'
    end
    
    def assert_modal_hidden
      wait_until { !page.find(modal_wrapper_id).visible? }
    rescue Capybara::TimeoutError
      flunk 'Expected modal to be hidden.'
    end
    
    # Examples of waiting for a page loading to show and hide in jQuery Mobile.
    
    def wait_for_loading
      wait_until { page.find('html')[:class].include?('ui-loading') }
    rescue Capybara::TimeoutError
      flunk "Failed at waiting for loading to appear."
    end
    
    def wait_for_loaded
      wait_until { !page.find('html')[:class].include?('ui-loading') }
    rescue Capybara::TimeoutError
      flunk "Failed at waiting for loading to complete."
    end
    
    def wait_for_page_load
      wait_for_loading && wait_for_loaded
    end

##Testing Hover Events With Capybara

Recently, I needed to write an integration test that involved hovering on elements. It was a bit painful to figure out, but the solution is simple. There are three things you need to know:

1. You need to use capybara-webkit as you javascript driver
1. You have to trigger the ‘mouseover’ event
1. This solution isn’t well documented

When I started trying to figure out how to hover on elements in my tests, I only found one working solution and it involved triggering events via jQuery like this:

    page.execute_script('$("#element").trigger("mouseenter")')

I was happy that it worked, but having to use to use jQuery in the middle of a spec felt like a hack. It turns out, the solution is pretty simple.

First, you need to use capybara-webkit in order to go with this solution. Add it to your Gemfile with gem "`capybara-webkit`" and run `bundle` to install the gem. Then, you need to add a line to your spec_helper file to tell rspec to use that driver for your tests involving js (default is selenium):

    RSpec.configure do |config|
      # ...
      Capybara.javascript_driver = :webkit
    end

Once you are using capybara-webkit, you can trigger events on elements such as a mouseover event:

    page.find('#element').trigger(:mouseover)

This code looks so similar to the jQuery-based solution that I was surprised that I did not figure this out quicker. What tripped me up though was the specific event that I was triggering. Initially, I was triggering the mouseenter event. When you do that, you get no errors but it doesn’t seem to do anything. I did some experimenting and it seems that no errors are raised when you trigger an unsupported event (such as a made up one). Anyhow, hovering on elements turns out to be pretty simple.

###Capybara-Webkit debugging

    UPDATE: The :webkit_debug driver is now in capybara-webkit.

To use it, specify it in your Gemfile:

    gem 'capybara-webkit', :git =>'git://github.com/thoughtbot/capybara-webkit.git', :ref => 'a4538v'

    Capybara.javascript_driver = :webkit_debug

 Just added a commit that exposes the capybara-webkit socket debugger.

To use it, specify it in your Gemfile:

    gem 'capybara-webkit', :git =>'git://github.com/thoughtbot/capybara-webkit.git', :ref => '01665e6'

and register the driver:

    Capybara.register_driver :webkit_debug do |app|
      browser = Capybara::Driver::Webkit::Browser.new:)socket_class => Capybara::Driver::Webkit::SocketDebugger)
      Capybara::Driver::Webkit.new(app, :browser => browser)
    end

    Capybara.javascript_driver = :webkit_debug


## Non-Standard Driver Methods

capybara-webkit supports a few methods that are not part of the standard capybara API. You can access these by calling driver on the capybara session. When using the DSL, that will look like `page.driver.method_name`.

**console_messages**: returns an array of messages printed using console.log

    # In Javascript:
    console.log("hello")
    # In Ruby:
    page.driver.console_messages
    => {:source=>"http://example.com", :line_number=>1, :message=>"hello"}

**error_messages**: returns an array of Javascript errors that occurred

    page.driver.error_messages
    => {:source=>"http://example.com", :line_number=>1, :message=>"SyntaxError: Parse error"}

**resize_window**: change the viewport size to the given width and height

    page.driver.resize_window(500, 300)
    page.driver.evaluate_script("window.innerWidth")
    => 500

**render**: render a screenshot of the current view (requires [mini_magick](https://github.com/probablycorey/mini_magick) and [ImageMagick](http://www.imagemagick.org/))

    page.driver.render "tmp/screenshot.png"

**cookies**: allows read-only access of cookies for the current session

    page.driver.cookies["alpha"]
    => "abc"

gem "mini_magick"

### Cookies - Putting the Pieces Together

Long story short: each Capybara driver handles its cookies differently. The cookies hash we access in our step is specific to `Rack::Test` and is actually a `Rack::Test::CookieJar` object.
If you want your application cookies to Just Work™ from anywhere in your Cucumber suite, throw the following into `features/support/cookies.rb`:

    module Capybara
      class Session
        def cookies
          @cookies ||= begin
            secret = Rails.application.config.secret_token
            cookies = ActionDispatch::Cookies::CookieJar.new(secret)
            cookies.stub(:close!)
            cookies
          end
        end
      end
    end

    Before do
      request = ActionDispatch::Request.any_instance
      request.stub(:cookie_jar).and_return{ page.cookies }
      request.stub(:cookies).and_return{ page.cookies }
    end

You’ll need a stubbing library. I’m using RSpec.

This allows each of your Capybara sessions to keep its own separate set of cookies. And they’re real cookies, meaning that you can use cookies.permananent and cookies.signed just like you do in your controllers. Then, after each scenario, Capybara will clean its sessions, along with your cookies.
Just use `page.cookies` and you’re good to go!

    When /^I am signed in as "([^"]*)"$/ do |email|
      page.cookies[:token] = User.find_by_email!(email).token
    end

> robert February 23, 2012 http://www.ameil.com
Interesting. It doesn’t work for me thou. I am receiving “undefined method ‘any_instance’”. Is there an extra setup step required somewhere?

> Steve Richert February 23, 2012 http://collectiveidea.com
@robert: You may need to require "cucumber/rspec/doubles" somewhere in your Cucumber setup.

> On Thu, Apr 29, 2010 at 4:49 PM, Randy Schmidt <m...@r38y.com> wrote:
Oh how I wish "cucumber cookies" weren't a real thing. It makes
googling for an answer kinda hard.

> Try using negative keywords: cucumber cookies -food -recipe -photos

#### More on  cookies
The trickiest part to fix was the failing test. To test some “remember me” functionality I manually set a cookie, and this no longer worked with Capybara:

    cookies[:remember_me_id] = remember_me_id

After some searching I found a Gist from Nicholas Rutherford in which he dealt with cookies. 

cookie_steps.rb

    Then /^show me the cookies!$/ do
      driver = Capybara.current_session.driver
      case driver
      when Capybara::Driver::Selenium
        announce_selenium_cookies(Capybara.current_session.driver.browser)
      when Capybara::Driver::RackTest
        announce_rack_test_cookies(get_rack_test_cookie_jar)
      else 
        raise "unsupported driver, use rack::test or selenium/webdriver"
      end
    end
    
    Given /^I close my browser \(clearing the Medify session\)$/ do
      delete_cookie session_cookie_name
    end
    
    module CookieStepHelper
      def session_cookie_name
        Rails.application.config.session_options[:key] #for rails 3, courtesy of https://github.com/ilpoldo
        #else just hard code it as follows
        #'_appname_session' #or check in browser for what your app is using
      end
    
      def delete_cookie(cookie_name)
        driver = Capybara.current_session.driver
        case driver
        when Capybara::Driver::Selenium
          browser = Capybara.current_session.driver.browser
          announce_selenium_cookies(browser) if @announce
          browser.manage.delete_cookie(cookie_name)
          announce "Deleted cookie: #{cookie_name}" if @announce
          announce_selenium_cookies(browser) if @announce
        when Capybara::Driver::RackTest
          announce_rack_test_cookies(get_rack_test_cookie_jar) if @announce
          delete_rack_test_cookie(get_rack_test_cookie_jar, cookie_name)
          announce "Deleted cookie: #{cookie_name}" if @announce
          announce_rack_test_cookies(get_rack_test_cookie_jar) if @announce
        else 
          raise "unsupported driver, use rack::test or selenium/webdriver"
        end
      end
    
      def announce_rack_test_cookies(cookie_jar)
        announce "Current cookies: #{cookie_jar.instance_variable_get(:@cookies).map(&:inspect).join("\n")}"
      end
      
      def announce_selenium_cookies(browser)
        announce "Current cookies: #{browser.manage.all_cookies.map(&:inspect).join("\n")}"
      end
      
      def get_rack_test_cookie_jar
        rack_test_driver = Capybara.current_session.driver
        cookie_jar = rack_test_driver.current_session.instance_variable_get(:@rack_mock_session).cookie_jar
      end
      
      def delete_rack_test_cookie(cookie_jar, cookie_name)
        cookie_jar.instance_variable_get(:@cookies).reject! do |existing_cookie|
          existing_cookie.name.downcase == cookie_name
        end
      end
    end
    World(CookieStepHelper)
    Before('@announce') do
      @announce = true
    end

remember_me.feature

      @javascript @announce
      Scenario: remembering users so they don't have to log in again for a while
        Given an activated member exists with forename: "Paul", surname: "Smith", email: "paul_smith_91@gmail.com", password: "bananabanana"
        When I go to the dashboard
        Then I should see "Existing Member Login"
        When I fill in "Email" with "paul_smith_91@gmail.com" within "#member_login"
        And I fill in "Password" with "bananabanana" within "#member_login"
        And I check "Remember me"
        And I press "Sign in"
        Then I should be on the dashboard
        And I should see "Logged in as Paul Smith"
        And I should see "Sign out"
    
        Given I close my browser (clearing the Medify session)
        When I come back next time
        And I go to the dashboard
        Then I should see "Logged in as Paul Smith"
        And I should see "Sign out"
    
      @rack_test @announce
      Scenario: don't remember users across browser restarts if they don't want it
        Given an activated member exists with forename: "Paul", surname: "Smith", email: "paul_smith_91@gmail.com", password: "bananabanana"
        When I go to the dashboard
        Then I should see "Existing Member Login"
        When I fill in "Email" with "paul_smith_91@gmail.com" within "#member_login"
        And I fill in "Password" with "bananabanana" within "#member_login"
        And I uncheck "Remember me"
        And I press "Sign in"
        Then I should be on the dashboard
        And I should see "Logged in as Paul Smith"
        And I should see "Sign out"
    
        Given I close my browser (clearing the Medify session)
        When I come back next time
        And I go to the dashboard
        Then I should see "Existing Member Login"
        And I should not see "Logged in as Paul Smith"
        And I should not see "Sign out"


Thanks to his code I could set my cookie with the following snippet:

    cookies = Capybara.current_session.driver.current_session.instance_variable_get:)@rack_mock_session).cookie_jar
    cookies[:remember_me_id] = remember_me_id

And with that, my switch to Capybara was complete. Any questions?

#### [show_me_the_cookies](https://github.com/nruth/show_me_the_cookies)