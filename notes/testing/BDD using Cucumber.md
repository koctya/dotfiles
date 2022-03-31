# BDD using Cucumber

For those who don't know, Cucumber arose from [RSpec's Story Runner](http://blog.davidchelimsky.net/2007/10/21/story-runner-in-plain-english/).

One of the most important advantages of using Behavior Driven Development is that it allows the product owner to write acceptance criteria in the form of features. The developer can then work towards developing step definitions to test the features the product owner has defined. The step definitions correlate with the acceptance criteria/features with the intention of leaving no discrepancies between what the product owner wants from their product and what the programmer develops.

### Stop thinking in terms of tests. 
As Bob Martin has been saying for a few years “Speciﬁcation, not Veriﬁcation”. What Bob means is that veriﬁcation (aka testing) is all about making sure 
(i.e. verifying) that your code functions correctly while speciﬁcation is all about deﬁning what it means (i.e.specifying) for your code to function correctly

### Imperitive vs Declarative Scenarios

Last week I was looking at some of the presentations from GoRuCo that Confreaks recently posted. One of them was a presentation on rspec's story runner given by Bryan Helmkamp's (of webrat fame.) It is a great presentation which I highly recommend for anyone looking into incorporating the story runner into their development process. In the presentation Bryan talked about the differences between imperative and declarative scenarios. In my opinion, both styles have benefits and should be used appropriately based on the situation. The majority of examples on rspec's story runner currently on the web, including mine, are of the imperative type. Since the declarative type has many advantages I thought it would be worth while to present some examples and contrast the differences between the two styles.


Lets look at the example I gave in my previous post (slightly modified):

        Story: Animal Submission
        
          As a Zoologist
          I want to add a new animal to the site
          So that I can share my animal knowledge with the community
        
          Scenario: successful submission
          Given I'm on the animal creation page
        
          When I fill in Name with 'Alligator'
          And select Phylum as 'Chordata'
          And fill in Animal Class with 'Sauropsida'
          And fill in Order with 'Crocodilia'
          And fill in Family with 'Alligatoridae'
          And fill in Genus with 'Alligator'
          And check Lay Eggs
          And click the Create button

          Then I should see the notice 'Thank you for your animal submission!'
          And the page should include the animal's name, phylum, animal class, order, family, and genus

The imperative style uses highly reusable granular steps which outlines much of the user interface. This binds the scenario to that interface and requires more design decisions made up front. The step matchers for these granular steps are very easy to write as I demonstrated in my webrat post. Once these steps are in place you can write the majority of your scenarios in this fashion without having to write custom step matchers. Due to the granularity of the scenarios however they become very brittle as they are subject to requirement changes from the customer. If a new field is added, for example, you must update the scenario to reflect this even though the underlying goal of the scenario has not changed.


Lets rewrite the above example in a more declarative fashion. The story narrative and scenario title will remain the same.

        Story: Animal Submission
        
          As a Zoologist
          I want to add a new animal to the site
          So that I can share my animal knowledge with the community
        
          Scenario: successful submission
          Given I'm on the animal creation page
        
          When I add a new animal
        
          Then I should see the page for my newly created animal
          And the notice 'Thank you for your animal submission!'

This style is more aligned with User Stories in the agile sense having more of the "token for conversation" feel to it. The first thing that you should observe about this style is how much smaller it is than the imperative one. This is a good thing. The imperative style tends to produce noisy scenarios that drown out the signal. With the declarative style the goal of the scenario remains clear. When a new field is added to the form the scenario does not have to be modified. Yes, you will have to modify the underlying step matcher but the scenario does not have to suffer dilution due to the change. The trade off is, of course, that you will now be writing step matchers for all of your scenarios. Looking at our example, the implementation for the When step is very similar to the imperative scenario steps:

        # animal_steps.rb
        When "I add a new animal" do
          fills_in 'Name', :with => 'Alligator'
          selects 'Chordata', :from => 'Phylum'
          fills_in 'Animal Class', :with => 'Sauropsida'
          fills_in 'Order', :with => 'Crocodilia'
          fills_in 'Family', :with => 'Alligatoridae'
          fills_in 'Genus', :with => 'Alligator'
          checks 'Lay Eggs'
          clicks_button 'Create'
        end

The majority of the imperative step matchers were merely wrappers for webrat so creating custom steps for each scenario is not much of a deterrent. Additionally, the reuse of steps will only take you so far before your stories start to feel unnatural as you try to force each scenario to use the same phrasing. Creating custom steps for each scenario actually turns out to be better for reducing duplication in most cases. That is because you can now extract duplicate code from the step matchers into helper methods. The place to put these helpers is in the Spec::Story::World module (monkey patch it.)

Another way to reduce duplication in step matchers that I learned recently is to call other steps directly within another one. For example, if you have this step:

    Given "a user named $user_name" do |user_name|
      User.create!(:name => user_name, ....)
    end

and you now want to have a step that matches ‘Given a user named Jim with a photo album’ you can reuse the above step directly in the new one like so:

    Given "a user named $user_name with a photo album" do |user_name|
      Given "a user named #{user_name}"
      ....
    end

I haven’t experimented with this approach too much so I’m not sure how much I like it, but I can see occasions where it would prove useful.


I have made a strong case for the declarative style of writing scenarios. It would seem that one should never write a scenario imperatively based solely on the merits of maintenance and communicating story intent. While I think the declarative style has many strengths it is not the best choice for all situations. The imperative style should not be discounted entirely because when used judiciously in the right scenario it can highlight certain aspects of the functionality and improve communication. It is also important to realize that the two types are not mutually exclusive. The styles can be mixed throughout an app, a story, and even an individual scenario to provide the appropriate level of granularity as the situation demands.

One of the most important factors in deciding which type of style to adopt however has nothing to do with maintenance or code duplication; that factor is the customer. While these stories may be acting as integration tests for the developer that is not the original purpose. The stories are meant to facilitate communication between developer and stakeholder about business value and functionality. If your stakeholder needs each form field outlined in the scenario in order to have confidence in the system then the imperative style is a better route to go. Specs (unit tests) are just for the developer but stories need to appease the wider audience of developer and stakeholder so an appropriate balance needs to be reached. As in most areas of software development there is no right answer and in the end it just depends on the situation.


Aside from the materials already linked to in this post another great resource (actually, it is the best that I have found) on the various ways to approach story runner is David Chelimsky's ETEC slides. In the slides he refers to the imperative style as detailed scenarios. He will be giving a similar talk at at RailsConf, so be sure to catch it if your able to make it to RailsConf this year.

## [Testing with the help of machinist, forgery, cucumber, webrat and rspec](http://itsignals.cascadia.com.au/?p=30)

I’ve been using [rspec](http://github.com/dchelimsky/rspec/wikis/home) for my testing for some now and have played around the edges with rspec user stories. When I started working on a new application a month or two ago I thought it would be a great opportunity to revisit my testing approach and my testing toolkit. After reading and researching the current trends I have settled on the following:

- [machinist](http://github.com/notahat/machinist/tree/master) - After trying many fixture replacement plugins I’m happy with machinist, so far it does everything I need.
- [forgery](http://github.com/sevenwire/forgery/tree/master) - Machinist includes Sham which allows me to create dummy data for my fixtures, I use forgery which is a very nice fake data generator to supply the data to Sham,
- [cucumber](http://github.com/aslakhellesoy/cucumber/tree/master) - Is the replacement for rspec user stories, it allows you to write plain text stories (features) and execute them as functional tests.
- webrat - It lets you write expressive and robust acceptance tests for a Ruby web application.
- [rspec](http://github.com/dchelimsky/rspec/wikis/home) - Is a Behaviour Driven Development (BDD) framework for writing executable code examples.

After reading lot’s of articles and looking at lots of example code I was finding it all very daunting, I found myself suffering from a severe case of coders block. I really did not know where to start, how to structure my code, how to write the features and so on. I was hoping that the Rspec book might have been released before I had to start development to give me some direction but the beta release has been delayed and I had to face my fears and dive in.

Once I started, I was pleasantly surprised how natural the whole process felt, after writing my first half dozen features or so I was really starting to enjoy it! In this article I want to give a brief overview of what I did to get started, show some example features and steps, as well as demonstrating how all the tools in my toolkit mesh together to form a very nice testing framework. I’m still very new to the process of writing features and steps and am still becoming familiar with all the tools, so I’m sure that I will make adjustments as I become more experienced in using the framework.

I will not go into how to install the plugins as this is well documented for each plugin.

### Creating my fixtures

I create my fixtures using machinist. To use machinist you use a class method called blueprint which is an extension of `ActiveRecord::Base` which means you can use it on any of your ActiveRecord models. In my application I have an "Account" link that allows the user to modify their account details including the password and email address which is the first feature I wanted to write. So the first thing I did was to create some blueprints for my user models in the blueprint.rb file which resides in the spec directory. The first thing I do is define some standard sham’s that I will use in my blueprints, I use forgery to populate these shams with some good dummy data.

    require ‘forgery’
    
    # Shams
    # We use forgery to make up some test data
    
    Sham.name  { NameForgery.full_name }
    Sham.login  { InternetForgery.user_name }
    Sham.email  { InternetForgery.email_address }
    Sham.password  { BasicForgery.password }
    Sham.string { BasicForgery.text }
    Sham.text { LoremIpsumForgery.text }
    
    # Blueprints
    
    Role.blueprint do
      name { ‘guest’ }
    end
    
    SiteUser.blueprint do
      user_type { ‘SiteUser’ }
      login { Sham.login }
      name { Sham.name }
      email = Sham.email
      email { email }
      email_confirmation { email }
      pwd = Sham.password
      password { pwd }
      password_confirmation { pwd }
      accept_terms { ‘true’ }
      time_zone { ‘Melbourne’ } 
    end
    
    OpenidUser.blueprint do
      user_type { ‘OpenidUser’ }
      time_zone { ‘Melbourne’ } 
      email { Sham.email }
    end

These blueprints allow me to easily create some objects using make, i.e.

    user = SiteUser.make

### Where to put my test files

There are any number of ways to structure your files and directories, after reading this article I decided to create a new sub-directory for each model that I wanted to test, so my directory structure looks something like this:
![](images/features_directory.png)
 

 

So for model User I created a users directory which contains a user.feature file and a steps_definitions sub-directory where the step files will be located, in this case we have user-steps.rb.

### Setting up my env.rb

Before we start writing features we need to tweak the cucumber env.rb file. I’ve added code to load webrat and machinist, my file looks like this:

    # Sets up the Rails environment for Cucumber
    ENV["RAILS_ENV"] = "test"
    require File.expand_path(File.dirname(__FILE__) + ‘/../../config/environment’)
    require ‘cucumber/rails/world’
    Cucumber::Rails.use_transactional_fixtures
    
    # Add webrat
    require "webrat"
    Webrat.configure do |config|
      config.mode = :rails
    end

    # Comment out the next line if you’re not using RSpec’s matchers (should / should_not) in your steps.
    require ‘cucumber/rails/rspec’
    
    # Add machinist
    require File.join(RAILS_ROOT, ’spec’, ‘blueprints’)
    
### Writing my first feature

The first feature I wanted to write was the ability for the user to display their account details once they had logged in. I initially started writing the feature using my own words to describe it, for example:

    Feature: User functions
    
    In order to maintain the correct account information
    As a logged in user
    I want to maintain my account information
    
    Scenario: Display my account information if I am an SiteUser
      Given I am logged in as a SiteUser 
      When I go to the "Account" page
      Then I should see my account details
        And I should see a "Change Password" link
        And I should see "Change Email" link

I then implemented each of these in my steps file using webrat. It’s only after some time that I realized that cucumber comes with a webrat steps definition file, i.e. webrat_steps.rb. Which contains a lot of standard webrat steps which I could directly call from my feature definition. So I could rewrite my scenario using the webrat steps:

    Scenario: Display my account information if I am an SiteUser
      Given I am logged in as a SiteUser 
      When I follow "Account" 
      Then I should see "Account"
        And I should see my account details
        And I should see "Change Password"
        And I should see "Change Email"

The steps in bold are all webrat steps that I do not have to implement in my own steps file as they are implemented in the webrat steps file! There are only two steps that I have to define myself.

#### Step 1: Given I am logged in as a SiteUser

This step is quite involved as I have to figure out how to login a user using a user name/password, I also need to cater for those users that use an OpenID. I decided to create a `step_helper.rb` file which is located in the `/features/step-definitions` sub-directory and will be automatically loaded by cucumber, which will contain any shared steps. It currently contains only one step that handles the login process for a user and looks like this:

    # Login
    # e.g.
    # Given I login as a SiteUser in the guest role
    # Given I login as a OpenidUser in the admin role
    #
    Given /I login as a (.*) in the (.*) role/i do |user_type, role|
      role = Role.make
      @user = Object::const_get(user_type).make_unsaved:)roles => role)  
      if (!@user.openid)
        @user.activate!
        visit login_path
        fill_in("login", :with => @user.login)
        fill_in("password", :with => @user.password)
      else
        # identity_url not allowed to be set via mass assignment in blueprint
        @user.identity_url = ‘https://good.openid.url/’
        @user.activate!
        visit login_with_openid_path
        fill_in("openid_identifier", :with => @user.identity_url)    
      end  
      click_button("Log in")
      Then ‘I should see "Dashboard"’
    end

 To use it I create a separate step within my steps file. One important point to note is that you can reuse steps by calling them directly from within other steps. In the example below we are calling the shared login step from within the step by calling `Given "I login as a #{user_type} in the guest role"`.

    Given /I am logged in as a (.*)/i do |user_type|
       Given "I login as a #{user_type} in the guest role"
    end

This step can then be used in my feature like this:

    Given I am logged in as a SiteUser

#### Step 2: And I should see my account details

The last step we need to implement is the one that checks to make sure that the users account details are actually being displayed. The step do this looks like this:

    Then /I should see my account details/ do
      Then "I should see \"#{@user.name}\""
      Then "I should see \"#{@user.company}\""
    end

### Running my features

Before we run the feature here is the content of our feature and step file so far.

    Feature: User functions
    
    In order to maintain the correct account information
    As a logged in user
    I want to maintain my account information
    
    Scenario: Display my account information if I am an SiteUser
      Given I am logged in as a SiteUser 
      When I follow "Account" 
      Then I should see "Account"
        And I should see my account details
        And I should see "Change Password"
        And I should see "Change Email"

And my user-steps.rb looks like this:

    Given /I am logged in as a (.*)/i do |user_type|
       Given "I login as a #{user_type} in the guest role"
    end
    
    Then /I should see my account details/ do
      Then "I should see \"#{@user.name}\""
      Then "I should see \"#{@user.company}\""
    end

When I run the the feature assuming I’ve implemented the code I get the following output:


![](images/run_feature.png)
 

### More example features

Here are a few more example features and the steps.

    Feature: User functions
    
    In order to maintain the correct account information
    As a logged in user
    I want to maintain my account information
    
    Scenario: Display my account information if I am an SiteUser
      Given I am logged in as a SiteUser 
      When I follow "Account" 
      Then I should see "Account"
        And I should see my account details
        And I should see "Change Password"
        And I should see "Change Email"
    
    Scenario: Display my account information if I am an OpenidUser
      Given I am logged in as a OpenidUser 
      When I follow "Account" 
      Then I should see "Account"
        And I should see my account details
        And I should not see "Change Password"
        And I should not see "Change Email"
    
    Scenario: Allow me to change my password
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Password"
        And I fill in my new password details
        And I press "Change your password"
      Then my password should be changed
        And I should see "Account"
        And I should see "Password successfully updated"
    
    Scenario: Not allow me to change my password if the old password incorrect
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Password"
        And I fill in an incorrect old password
        And I press "Change your password"
      Then my password should not be changed
        And I should see "You password was not changed, your old password is incorrect."
    
    Scenario: Not allow me to change my password when the password and confirmation is not the same
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Password"
        And I fill in an incorrect password confirmation
        And I press "Change your password"
      Then my password should not be changed
        And I should see "New password does not match the password confirmation."
    
    Scenario: Allow me to change my account details
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I fill in my new account details
        And I press "Save"
      Then my account details should be changed
        And I should see "Account details updated."
    
    Scenario: Allow me to change my email
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Email"
        And I fill in my new email address
        And I press "Change your email"
      Then my email should be changed
        And I should see "Account"
        And I should see "Email successfully updated"
    
    Scenario: Not allow me to change my email when the email and confirmation is not the same
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Email"
        And I fill in an incorrect email confirmation
        And I press "Change your email"
      Then my email should not be changed
        And I should see "New email does not match the email confirmation."

Steps in user-steps.rb

    Given /I am logged in as a (.*)/i do |user_type|
       Given "I login as a #{user_type} in the guest role"
    end
    
    Then /I should see my account details/ do
      Then "I should see \"#{@user.name}\""
      Then "I should see \"#{@user.company}\""
    end
    
    When /I fill in my new password details/ do
      When "I fill in \"old_password\" with \"#{@user.password}\""
      When ‘I fill in "password" with "test_123"’
      When ‘I fill in "password_confirmation" with "test_123"’
    end
    
    When /I fill in an incorrect old password/ do
      When "I fill in \"old_password\" with \"#{@user.password + ‘xyz’}\""
      When ‘I fill in "password" with "test_123"’
      When ‘I fill in "password_confirmation" with "test_123"’
    end
    
    When /I fill in an incorrect password confirmation/ do
      When "I fill in \"old_password\" with \"#{@user.password}\""
      When ‘I fill in "password" with "test_123"’
      When ‘I fill in "password_confirmation" with "test_1234"’
    end
    
    When /I fill in my new account details/ do
      When ‘I fill in "user_name" with "Fred Flintstone"’
      When ‘I fill in "user_company" with "Acme Rocks"’
      When ‘I select "(GMT+10:00) Canberra" from "user_time_zone"’
    end
    
    Then /my password should be changed/ do
      SiteUser.find_by_id(@user.id).authenticated?(’test_123′).should == true
    end
    
    Then /my password should not be changed/ do
      SiteUser.find_by_id(@user.id).authenticated?(’test_123′).should == false
    end
    
    Then /my account details should be changed/ do
      u = SiteUser.find_by_id(@user.id)
      u.name.should == ‘Fred Flintstone’
      u.company.should == ‘Acme Rocks’
      u.time_zone.should == ‘Canberra’
    end
    
    When /I fill in my new email address/ do
      When ‘I fill in "email" with "test@isp.com"’
      When ‘I fill in "email_confirmation" with "test@isp.com"’
    end
    
    When /I fill in an incorrect email confirmation/ do
      When ‘I fill in "email" with "test@isp.com"’
      When ‘I fill in "email_confirmation" with "test123@isp.com"’
    end
    
    Then /my email should be changed/ do
      SiteUser.find_by_id(@user.id).email.should == ‘test@isp.com’
    end
    
    Then /my email should not be changed/ do
      SiteUser.find_by_id(@user.id).email.should_not == ‘test@isp.com’
    end 

> This was a very useful post, thanks for sharing. I did not have to add machinist to the env.rb file and it still worked. I also used it with Faker and it seems to work great. The only issue i am really having is that it is really slow to run cucumber features. I only have one feature with one scenerio and the run time is like 30-50 seconds which is crazy long. Any hints on what might be the issue?

### Feature Writing Style

There seems to be two styles that you can use when writing your features, "Imperative" and "Declarative" which is described in detail in the article Imperative vs Declarative Scenarios in User Stories written by Ben Mabey. I understand the extreme cases as demonstrated by the examples given by Ben, but what about a feature such as this one, can this be classed as being written using the Imperative style?

    Scenario: Allow me to change my password
      Given I am logged in as a SiteUser 
      When I follow "Account" 
        And I follow "Change Password"
        And I fill in my new password details
        And I press "Change your password"
      Then my password should be changed
        And I should see "Account"
        And I should see "Password successfully updated"

Does the Imperative style dictate that all steps appear in the feature, the example above do have some steps that are defined in the steps file, but there are a few other details that could be moved to the steps file as well. So if the one above is Imperative does this modified version make it declarative?

    Scenario: Allow me to change my password
      Given I am logged in as a SiteUser 
      When I go to the "Change Password" page
        And I fill in my new password details
      Then my password details should be changed

At this stage I’m not sure, for now I will stay with the first style as it provides details that may be important to someone reading the feature but hides the non-essential detail in the steps file.

##  Changing The DSL
we can create a IntegrationHelper module specifically for the integration tests. If we want to avoid tagging all of our integration tests, we configure an `:example_group` with a `:file_path` to our integration tests.

###### `spec_helper.rb`

    ...
    Spork.prefork do
      ...
      RSpec.configure do |config|
        ...
    #  config.include MySpec::IntegrationHelper, :integration => true
       config.include MySpec::IntegrationHelper, :type => :integration, :example_group => {
         :file_path => config.escaped_path(%w[spec integration])
       }
      end
    ...

###### `integration_helper.rb`

    module MySpec
      module IntegrationHelper
        def self.included(base)
          base.class_eval do
            include DSLHelper
          end
        end
      end
    
      module DSLHelper
        def self.included(base)
          class << base
            alias_method :Given, :describe
            alias_method :And, :describe
            alias_method :When, :describe
          end
    
          RSpec::Core::ExampleGroup.class_eval do
            define_example_method :Then
            define_example_method :And_
            define_example_method :Or
          end
        end
      end
    end
    
    class Object
      alias_method :Scenario, :describe
    end

###### `post_viewing_spec.rb`
    ...
    Scenario "Meet Capybara (non admin).", :integration => true do
      Given "He's crawling around our app." do
        ...
        When "he visits the post index page," do
          ...
          Then "he should see a listing of posts" ...
          And_ "the posts should be in div.postShow" ...
    
          When "Capybara clicks on the 'Show' link for the first post," do
            ...
            Then "he should see the show page" ...
            And_ "he shouldn't see an edit link" ...

### Session Helper Methods
The last spec was testing a feature that only admins should be able to see (the 'Edit' link). When we spec'd the post index view, we stubbed the `#admin?` method in order to hide the 'Edit' link. If we generate some scaffolding now for Post, this integration test fails because there is no `#admin?` method yet.

What can we do if we don't want to switch gears and work on the site's administration features yet? As with the view specs, we can stub out the `#admin?` method in our integration tests. So let's create a `SessionsHelper` module to toggle `#admin?` from true to false depending on our needs. In the `ApplicationController`, we'll just declare the helper method and raise a reminder that we need to implement the code for that method.

    > rails g scaffold post title:string description:text sequence:integer status:string published_at:datetime -s
________________________________________________________________

###### `integration_helper.rb`
    module MySpec
      module IntegrationHelper
        def self.included(base)
          base.class_eval do
            include DSLHelper
            include SessionsHelper
          end
        end
      end
    
      module SessionsHelper
        def not_admin
          ApplicationController.class_eval do
            def admin?
              false
            end
          end
        end
    
        def sign_in_admin
          ApplicationController.class_eval do
            def admin?
              true
            end
          end
        end
        ...
________________________________________________________________

###### `application_controller.rb`
    class ApplicationController < ActionController::Base
      protect_from_forgery
    
      helper_method :admin?
    
      protected
    
      def admin?
        raise 'Hacka says wha? (Need to write this code.)'
      end
    end
________________________________________________________________

###### `post_viewing_spec.rb`
    ...
    Scenario "Meet Capybara (non admin)." do
      before { not_admin }
      Given "He's crawling around our app." do
        ...

# [Outside-In BDD: How?](http://www.sarahmei.com/blog/2010/05/29/outside-in-bdd/)

#### Updated with [Rails 3.1 and Cucumber: getting started with outside-in testing](http://ridingrails.net/rails-3-cucumber-started-outside-in-testing/) 
Because I like the narrative of the original, but want the update to 3.2 and with websteps removed.

I use rspec on every project, and I’ve started adding [cucumber](http://cukes.info/) to all my projects in the last few months. There’s lots of information out there about how to set up and use cucumber, but there isn’t much covering your developer workflow when you’re using these tools.

How do you start, and how do you know you’re finished? What do you test, and where? These questions can be answered hundreds of different ways, but here’s my way.


## First up, create your new Rails code:

    $ rails new outsidein -T
    $ cd outsidein
    $ rm public/index.html

Add `cucumber-rails` and `database_cleaner` to `:development` and `:test` groups in your Gemfile:

    source 'https://rubygems.org'
    
    gem 'rails', '3.2.8'
    
    gem 'sqlite3'
    
    # Gems used only for assets and not required
    # in production environments by default.
    group :assets do
      gem 'sass-rails',   '~> 3.2.3'
      gem 'coffee-rails', '~> 3.2.1'
      # See https://github.com/sstephenson/execjs#readme for more supported runtimes
      gem 'therubyracer', :platforms => :ruby
    
      gem 'uglifier', '>= 1.0.3'
    end
    
    gem 'jquery-rails'
    gem 'haml-rails'
    
    # To use ActiveModel has_secure_password
    # gem 'bcrypt-ruby', '~> 3.0.0'
    
    group :development, :test do
      gem 'pry'
      gem 'pry-nav'
      gem 'cucumber-rails'
      gem 'database_cleaner'
      gem 'rspec-rails'
      gem 'spork'
    end

Set up Cucumber

    $ rails generate cucumber:install

## The first code I write: a feature

As a developer, rather than a designer, I’m always tempted to start with unit tests and work out towards a cucumber feature (“inside-out” testing). But that approach gets me into no end of trouble. I usually end up writing and testing stuff on the model that I don’t ultimately need. Plus once I’m down in the weeds coding, I lose track of the big picture.

So I like to do outside-in testing instead. I start each story I get from tracker with a cucumber feature that expresses how the PM will be able to accept it when I’m done. The feature helps me frame the problem properly, and focus on doing exactly what I need to make it work. Since I come back to it periodically while I’m coding, I keep focused on the higher-level goal. And finally – if I write it first, I can’t skip writing it once I’m done.

## Before we get going…

There are certain types of tests I don’t write in this example (and in some cases, at all). Let’s get those out of the way so you don’t have to come up with a scathing comment at the bottom of the post.

-  **Model tests**. In this example, my model doesn’t do anything other than default ActiveRecord behavior, so it doesn’t need any tests. **Don’t test rails internals**. Once my model has custom behavior, it will have specs, too.
-  **View tests**. I have no tests that verify that my markup is what I expect. That’s because they’re a waste of time. Yes, even with complex views. Verify behavior with cucumber tests, unit-test Javascript with [jasmine](http://github.com/pivotal/jasmine), and leave the rest to the humans. You’ll waste more developer time maintaining them than it would take humans to verify them. Verifiers are a whole lot cheaper than developers.
-    **Error case tests**. In this example, there are no error cases. The model has no validations, and the table has no constraints. Once there are error cases, I generally put those in the model if I can, in the controller when I have to, and never in the cucumber tests. The latter is mostly a suite-speed consideration – cucumber tests run much more slowly than rspec. Cucumber’s great for for happy path tests; I leave the rest to rspec.

Let’s get going!

## The first feature

Say I’m doing a library app and the first story is “User can enter a new book into the system.” Before I write any other code, I write this feature:

    Feature: User manages books
      Scenario: User adds a new book
        Given I go to the new book page
        And I fill in "Name" with "War & Peace"
        And I fill in "Description" with "Long Russian novel"
        When I press "Create"
        Then I should be on the book list page
        And I should see "War & Peace"

## Starting the fail-fix cycle

###Step 1: Given I go to the new book page

####$ cucumber

 We have no steps.
 Solution: Add file `features/step_definitions/book_steps.rb`, and copy in the output:

    Given /^I go to the new book page$/ do
      pending # express the regexp above with the code you wish you had
    end
    
    Given /^I fill in "(.*?)" with "(.*?)"$/ do |arg1, arg2|
      pending # express the regexp above with the code you wish you had
    end
    
    When /^I press "(.*?)"$/ do |arg1|
      pending # express the regexp above with the code you wish you had
    end
    
    Then /^I should be on the book list page$/ do
      pending # express the regexp above with the code you wish you had
    end
    
    Then /^I should see "(.*?)"$/ do |arg1|
      pending # express the regexp above with the code you wish you had
    end

I run it using cucumber features, and it fails on the first line – Given I go to the new book page – because cucumber doesn’t know where the “new book page” is. 

Solution:

    Given /^I go to the new book page$/ do
      visit new_book_path
    end

#### $ cucumber

Now when I run cucumber, it fails because it can’t find new_book_path. So I add that to routes.rb:

    resources :books, :only => [:new]

Solution: Add `resources :books` to `config/routes.rb`.

While we’re at it, go ahead and add a root path, this will be helpful later: `root :to => 'books#index'`

#### $ cucumber
Now when I run cucumber, it complains that it can’t find the BooksController. 

Solution: Add the controller file `app/controllers/books_controller.rb`

    class BooksController < ApplicationController
    end

#### $ cucumber

Failing again: The action 'new' could not be found for BooksController (AbstractController::ActionNotFound)
Solution: Add the new method:

    class BooksController < ApplicationController
      def new
      end
    end

#### $ cucumber
      Missing template books/new, application/new with {:locale=>[:en], :formats=>[:html], :handlers=>[:erb, :builder, :coffee]}. Searched in:
        * "/home/kurt/code/rails/outsidein/app/views"
       (ActionView::MissingTemplate)


    $ mkdir app/views/books
    $ e app/views/books/new.html.erb

    Just stick an h2 in that file or something. 
$ cucumber
    Passed!

    One down, four to go. 

### Step 2: And I fill in "Name" with "War & Peace"
#### $ cucumber
Now cucumber  fails on line 2 (And I fill in "Name" with "War & Peace") 

Solution: add the Capybara `fill_in` matcher:

    Given /^I fill in "([^"]*)" with "([^"]*)"$/ do |arg1, arg2|
      fill_in(arg1, :with => arg2)
    end

#### $ cucumber

    Fails: cannot fill in, no text field, text area or password field with id, name, or label 'Name' found (Capybara::ElementNotFound)

Solution: Add a form to the new book page:

    %h2 New books
    = form_for @book do |f|
      = f.label :name
      = f.text_field :name
      = f.submit 'Create'

#### $ cucumber
    FAIL! undefined method `model_name' for NilClass:Class (ActionView::Template::Error)

Solution: Add instance variable to make Rails happy. In `app/controllers/books_controller.rb`, add :

      def new
        @book = Book.new
      end

#### $ cucumber

    Failing on uninitialized constant BooksController::Book (NameError)

Solution: Add model to make Rails happy:

    rails g model book name:string

Run rake `db:migrate` and rake `db:test:prepare`

#### $ cucumber

Failing on 

      cannot fill in, no text field, text area or password field with id, name, or label 'Description' found (Capybara::ElementNotFound)

Solution: create a migration to add the description;

    rails g migration AddDescriptionToBooks description:text

Run `rake db:migrate && rake db:test:prepare`

#### $ cucumber

Now fails on 
      cannot fill in, no text field, text area or password field with id, name, or label 'Description' found (Capybara::ElementNotFound)

Solution: Add the description to the form;

    %h2 New books
    = form_for @book do |f|
      = f.label :name
      = f.text_field :name
      = f.label :description
      = f.text_area :description
      = f.submit 'Create'

Running cucumber again, we pass. Excellent. 

### Step 3: When I press "Create"

In our last episode, cucumber was visibly annoyed because there was no @book object for the form to operate on. I run it again to see if it's still sulking.

Yep. This time it tells me that it can't find books_path. form_for tries to submit to the create path by default, which I haven't added yet. I add it to the routes.

      map.resources :books, :o nly => [:new, :create]

This time, when I run cucumber, it gets through the first three lines (woo hoo!) and fails on the 4th, saying no action responded to create. Back to the rspec-cave, batman!

###rspec: The Sequel to The Return

I add a controller spec for the create method.

      describe "#create" do
        it "should create a new book" do
          post :create, "book" => {"name" => "Jane Eyre", "description" => "Something Victorian"}
          assigns(:book).should_not be_nil
          assigns(:book).name.should == "Jane Eyre"
        end
      end

When I run it, I get the same message as in cucumber: no action responded to create. So I create the create:

    class BooksController < ApplicationController
      def new
        @book = Book.new
      end
      def create
      end
    end

Now when I re-run the spec, it fails saying that `assigns(:book)` is nil, which makes sense. I put in the guts of `create` to make that pass.

      def create
        @book = Book.new(params[:book])
        @book.save
      end

Now rspec passes! Back to cucumber.

### So...cucumber. We meet again.

When I re-run the feature, it says I'm missing a template for create, which is correct. However, in this case, I don't want to make a template for create - I want to redirect to the book list page. So once again, I'm back with rspec.

### rspec: Back so soon?

I add that expectation to the controller spec for create.

        it "should redirect to the book list page" do
          response.should redirect_to books_path
        end

It fails saying there's no redirect. So to make it pass, I add a redirect to the controller code.

      def create
        @book = Book.new(params[:book])
        if @book.save
          redirect_to books_path
        end
      end

Now my controller specs pass. Cucumber, I'm coming for you!

### Oh, you again.

Last time, we got through the first 3 lines of the feature and failed on line 4 (When I press "Create"). When I run it this time, it gets through the same 3 lines and then fails in the same place again, saying that no action responded to index. I add index to the routes.

      map.resources :books, :o nly => [:new, :create, :index]

I re-run the feature and get the same error message. WTF, cucumber?! It turns out that rails' implementation of REST uses the same path helper for create and index, so the path helper for index already exists, even though the method does not. A little strange, I know. But we need an index method, so it's back to rspec.

### rspec: For the first time, for the last time...

I write a spec for the index method.

      describe "#index" do
        it "should be successful" do
          get :index
          response.should be_success
        end
      end

I still get no action responded to index. So l add the method in BooksController, empty to start.

      def index
      end

Specs pass, back to cucumber!

### How can I miss you if you won't go away?

Cucumber tells me there's no template for index. So I create an empty one, and re-run. This run, for the first time, I pass line 4 (yaaaaay) but then it fails on line 5 (Then I should be on the book list page) because it can't figure out what I mean by "the book list page." That goes in the cucumber path helper.

        when /the book list page/
          books_path

OMG five out of six steps pass! Now cucumber says it can't find "War & Peace" on the page, so let's make the index view list the existing books. Back to rspec...
### Don't go away mad...just go away.

I add the following it block to the spec for index.

        it "should assign a list of existing books" do
          Book.create!(:name => "Endymion", :description => "weird")
          get :index
          assigns(:books).should_not be_nil
          assigns(:books).length.should == 1
        end

It fails because I'm not creating @books in the controller, so I fix that.

      def index
        @books = Book.all
      end

Now the specs pass - back to cucumber.

### We really have to stop seeing each other like this.

Cucumber still says it can't find War & Peace, because I haven't added printing out the books to the index view. I'll fix that.

    <%- @books.each do |book| -%>
        <%= h book.name %>
        <%= h book.description %>
    <%- end -%>

Re-run cucumber and ... ta-da! The feature passes! I've done everything I need to call the story done. I have the minimum amount of code I need, because all the code I wrote was driven by the feature. Story: **delivered**!



## More Cucumbers...
see [wiki](https://github.com/cucumber/cucumber/wiki/Related-tools) for full list..

- [aruba](https://github.com/cucumber/aruba) - Aruba is Cucumber extension for Command line applications written in any programming language.
- [cucumber-cpp](https://github.com/cucumber/cucumber-cpp/) - Support for writing Cucumber step definitions in C++
- [Frank](http://testingwithfrank.com/) - Painless iOS Testing With Cucumber

## Cucumber spork config.

#### add to Gemfile

	group :test do
	  gem 'cucumber-rails', '~>1.3.0', :require => false
	  gem 'database_cleaner', '~>0.8.0'

`bundle install`
	  
`rails generate cucumber:install`

#### config/cucumber.yml
	<%
	rerun = File.file?('rerun.txt') ? IO.read('rerun.txt') : ""
	rerun_opts = rerun.to_s.strip.empty? ? "--format #{ENV['CUCUMBER_FORMAT'] || 'progress'} features" : "--format #{ENV['CUCUMBER_FORMAT'] || 'pretty'} #{rerun}"
	std_opts = "--format #{ENV['CUCUMBER_FORMAT'] || 'pretty'} --strict --tags ~@wip"
	%>
	default: <%= std_opts %> features
	wip: --tags @wip:3 --wip features
	rerun: <%= rerun_opts %> --format rerun --out rerun.txt --strict --tags ~@wip

#### Guardfile

	# A sample Guardfile
	# More info at https://github.com/guard/guard#readme
	require 'active_support/core_ext'

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

	guard 'spork', :cucumber_env => { 'RAILS_ENV' => 'test' }, :rspec_env => { 'RAILS_ENV' => 'test' } do
	  watch('config/application.rb')
	  watch('config/environment.rb')
	  watch(%r{^config/environments/.+\.rb$})
	  watch(%r{^config/initializers/.+\.rb$})
	  watch('Gemfile')
	  watch('Gemfile.lock')
	  watch('spec/spec_helper.rb')
	  watch('test/test_helper.rb')
	end

	

### Configuration For Testing JavaScript
Capybara uses a Rack strategy at baseline. If we need to test a page with JavaScript, we need to switch the driver that Capybara uses. Out of the box, we can use Selenium. We could use Selenium for all of our tests, however, using a browser-based driver will slow down our tests significantly. Therefore we use Selenium only for JavaScript tests. We can accomplish this by tagging the example groups with '`:js => true`' and configure RSpec to use the DatabaseCleaner gem as described [here](https://github.com/lailsonbm/contact_manager_app).

If we want to exclude the Selenium tests from routine runs, we can use RSpec's `filter_run_excluding` configuration option. Then we can put together a freedom patch to rspec-core to run the excluded tests from the command line. What we're doing here is intercepting the tags before they are included in the filtering process in RSpec's World class.

(Note: This hack is working for me with and without Autotest and Spork running.The ability to use RSpec tags while Spork is running was recently added to rspec-core, so you have to use rspec-core master at this point (or patch your local copy.) Also, the ZenTest version of Autotest doesn't allow command line options to be passed on to RSpec. However, this is supported in the grosser version of Autotest. With that, we can hack a solution to enable RSpec to take the Autotest command line configurations. Here's some extra information.)

###### `spec_helper.rb`
    ...
    Spork.prefork do
      ...
      RSpec.configure do |config|
        ...
        config.use_transactional_fixtures = false
      end
      #################################################
      RSpec.configure do |config|
        config.before(:suite) do
          DatabaseCleaner.strategy = :transaction
          DatabaseCleaner.clean_with :truncation
        end
    
        config.before(:each) do
          if example.metadata[:js]
            Capybara.current_driver = :selenium
            DatabaseCleaner.strategy = :truncation
          else
            DatabaseCleaner.strategy = :transaction
            DatabaseCleaner.start
          end
        end
    
        config.after(:each) do
          Capybara.use_default_driver if example.metadata[:js]
          DatabaseCleaner.clean
        end
      end
      #################################################
      RSpec.configure do |config|
        config.filter_run_excluding :js => true
      end
    
      # 'rspec spec' runs all tests excluding 'js'
      # 'rspec spec -t js' runs only 'js' tests
      # 'rspec spec -t all' runs all tests including 'js'
       module RSpec
        module Core
          class World
            attr_accessor :hack_run_all
    
            def inclusion_filter
              if @configuration && @configuration.filter && @configuration.filter.has_key?(:all)
                @configuration.filter = nil
                self.hack_run_all = true
              end
              @configuration.filter
            end
    
            def exclusion_filter
              @configuration.exclusion_filter.delete(:js) if self.hack_run_all || (@configuration.filter && @configuration.filter.has_key?(:js))
              @configuration.exclusion_filter
            end
          end
        end
      end
    end
    ...

### Reference - Implicit Matchers
What if we only have Capybara in our Gemfile? Capybara doesn't define have_selector in its DSL, yet we can still use it in our tests. In this case, RSpec takes advantage of method_missing.

 `#method_missing` will pick out all references to methods that start with `have_` and create a new `RSpec::Matchers::Has` object. As we saw above, this object's `#matches?` method will be called, and in this case, the method will change `have_selector` into `has_selector?`. The matcher works since `has_selector?` is define in Capybara.

Implicit Matcher Process
    page.should( have_selector('a') )
________________________________________________________________

###### `rspec-expectations/lib/rspec/matchers/method_missing.rb`
    module RSpec
      module Matchers
        private
        def method_missing(method, *args, &block) 
          return Matchers::BePredicate.new(method, *args, &block) if method.to_s =~ /^be_/
          return Matchers::Has.new(method, *args, &block) if method.to_s =~ /^have_/
          super
        end
________________________________________________________________

###### `rspec-expectations/lib/rspec/matchers/has.rb`
    module RSpec
      module Matchers
        class Has
          ...
          def matches?(actual)    # 'actual' here is 'page'
            actual.__send__(predicate(@expected), *@args)
          end
          ...
        private
        
          def predicate(sym)
            "#{sym.to_s.sub("have_","has_")}?".to_sym
          end

## Cucumber Testing Tips

Stop in rails console if something fails in cucumber test

If a cucumber test fails then one of the first things I check for is the state of current data. In order to do that I used to put debugger statements. I still use this technique but here is a much better approach.

Create a file called `stop.rb` and put this file at `features/support/stop.rb`.

The contents of `stop.rb` are as follows:

  

        # Usage:
        #  @wip @stop
        #  Scenario: change password
        #    ........................
        # $ cucumber -p wip
        After do |scenario|
          if scenario.failed? && scenario.source_tag_names.include?("@wip") && scenario.source_tag_names.include?("@stop")
            puts "Scenario failed. You are in rails console becuase of @stop. Type exit when you are done"
            require 'irb'
            require 'irb/completion'
            ARGV.clear
            IRB.start
          end
        end
  

At the end of `features/support/env.rb` add the following line

  

    require File.expand_path(File.dirname(__FILE__) + '/stop')
  

As mentioned in the Usage above, add tags `@wip` and `@stop` to a scenario. Now execute the cucumber tests using following command.

  

    $ cucumber -p wip
  

If your cucumber test fails then you will be taken to a rails console where you can do things like

  

    Scenario failed. You are in rails console becuase of @stop. Type exit when you are done
    ree-1.8.7-2010.02 :001 > p User.count
      SQL (0.2ms)  SELECT COUNT(*) FROM "users"
      1
    => nil


##   Smelly Cucumbers

Let’s look at one of the offending Cucumber tests, modified slightly. For what it’s worth, I don’t just make todo applications, but they do make a good example. In this case, it’s a good example of a poor cuke.

    Feature: Todo item management
    Scenario: Adding a todo item
        Given: I have a todo list named "Mondays list"
        When I go to the home page
        And I fill in "username" with "dave"
        And I fill in "password" with "secret"
        And I press "Log In"
        And I go to the todo page
        And I click on link "Mondays list"
        And I fill in "todo" with "Grab some milk"
        And I press "Add todo"
        Then I should see "Todo item added successfully"
    
It’s pretty awful yeah? It gets worse, when you realize there are update and delete scenarios.

#### It’s Confusing

We can definitely smell a couple of things wrong here. At first glance, it’s confusing. We have to imagine pages springing into view, populating text fields, pressing buttons. The behavior is lost in lots of pointless detail.

Cucumber was developed in order to involve clients and stakeholders in the development process. We could be dealing with people who may not be technically minded or whose experience of the web may only be lolcats. As great as that may be, asking them to imagine filling out a couple of forms online before making sure we are meeting their requirements is a bit much.

#### It’s Brittle

Secondly, the test is brittle. What if the log in process changes? Or the login URL? Even if the mechanics of adding a todo item has not changed, the test will fail. That cannot be good news.

#### It’s Lazy

The final smell is the assertion, or “Then”. What is that actually testing? The Rails flash. It’s a lazy assertion that made me shudder.

### Doing it Right

It’s time to stop beating myself up and do something about the now infamous scenario. First of all, I want to describe the feature properly. Gherkin allows us to just write text after we declare the feature and it wont kick in until it reaches a keyword.

    Feature: Todo item management
      I want to track items I need to do in a list. That way I will never forget them. I want to add, edit, delete and mark todo items as finished.

Gherkin actually provides a nice syntax to remove decisions about what to write, it takes the format “In order/As a/I want”. I prefer to write a story, but I could have easily have written:

    Feature: Todo item management
      In order to remember things
      As a person with too much on his mind
      I want to maintain todos on a list

Thats much better, but the log in thing still really bothers me. It is a detail I shouldn’t worry about here. I’m talking about adding a todo item, so why am I distracting myself with this log in nonsense. Luckily, we can handle this using the Gherkin keyword “Background:”.

Feature: Todo item management
I want to track items I need to do in a list. That way I will never forget them. I want to add, edit, delete and mark todo items as finished.

    Background:
        Given I am logged in as a normal user
    Scenario: Adding a todo item
        Given: I have a todo list named "Mondays list"
        When I add a todo item "Grab some milk"
        Then it should be added to the todo list

The background will act as a setup and run before each scenario in the feature. 

Background is great, but there is another way, which I tend to use when dealing with logins: Cucumber hooks.

    @user_logged_in
    Scenario: Adding a todo item
      Given: I have a todo list named "Mondays list"

I can add the implementation of this hook in a support file along with other roles. It’s especially helpful when using a third party authorization library (such as warden) like so:

    Before('@user_logged_in') do
      user = User.create(name: "test_user", admin: false)
      login_as user
    end

Now for the step definitions. Written in Ruby they are a real breeze.

    Given /^I have a todo list named "([^"]*)"$/ do |list_name|
      @todo_list = Factory.create:)list, name: list_name)
    end
    When /^I add a todo item "([^"]*)"$/ do |item_description|
      visit todo_path(@todo_List)
      fill_in "Description", with: item_description
      click_button "Add Item"
    end
    
    Then /^the Item should be added to the client$/ do
      @todo_list.reload
      @todo_list.items.length.should eql 1
    end

As a rule, try to keep the scenarios tight and don’t try to cover too much of the feature in a single scenario. It sounds like common sense, but I have often been distracted by complementary elements of a feature. Finally, don’t be scared to tear down and re-write “work in progress” scenarios. Cucumber also facilitates a great discovery process for your application. Allow the Cucumber tests to drive your development, always extracting as much testing into your unit tests/specs. 

###  Writing BDD  tests
[Eat your meat AND your vegetables!](http://agile-itspeople.blogspot.com/2011/10/eat-your-meat-and-your-vegetables.html)

## [Cucumber - Rails](https://github.com/cucumber/cucumber-rails/)

Before you can use the generator, add the gem to your project's Gemfile as follows:

    group :test do
      gem 'cucumber-rails', :require => false
      # database_cleaner is not required, but highly recommended
      gem 'database_cleaner'
    end

Finally, bootstrap your Rails app, for example:

    rails generate cucumber:install

### Removed features
The following files will no longer be generated if you are running ``rails generate cucumber:instal`l`:

* `features/step_definitions/web_steps.rb`
* `features/support/paths.rb`
* `features/support/selectors.rb`

The reason behind this is that the steps defined in `web_steps.rb` leads people to write scenarios of a very imperative nature that are hard to read and hard to maintain. Cucumber scenarios should not be a series of steps that describe what a user clicks. Instead, they should express what a user *does*. 

Example:

    Given I have signed up as "user@host.com"

with a Step Definition that perhaps looks like this:

    Given /^I have signed up as "([^"]*)"$/ do |email|
      visit(signup_path)
      fill_in('Email', :with => email)
      fill_in('Email', :with => email)
      fill_in('Password', :with => 's3cr3t')
      fill_in('Password Confirmation', :with => 's3cr3t')
      click_button('Sign up')
    end

Moving user interface details from the scenarios and down to the step definitions makes scenarios much easier to read. If you change the user interface you only have to change a step definition or two instead of a lot of scenarios that explicitly describe how to sign up.

You can learn more about the reasoning behind this change at the following links:

* [Cucumber mailing list: Removing web_steps.rb in Cucumber 1.1.0](http://groups.google.com/group/cukes/browse_thread/thread/26f80b93c94f2952)
* [Cucumber-Rails issue #174: Remove web_steps.rb since it encourages people to write poor tests.](https://github.com/cucumber/cucumber-rails/issues/174)
* [Refuctoring your Cukes by Matt Wynne](http://skillsmatter.com/podcast/home/refuctoring-your-cukes)
* [Imperative vs Declarative Scenarios in User Stories by Ben Mabey](http://benmabey.com/2008/05/19/imperative-vs-declarative-scenarios-in-user-stories.html)
* [Whose domain is it anyway? by Dan North](http://dannorth.net/2011/01/31/whose-domain-is-it-anyway/)
* [You're Cuking it Wrong by Jonas Nicklas](http://elabs.se/blog/15-you-re-cuking-it-wrong)

You can learn more about what Capybara has to offer in Capybara's [README](https://github.com/jnicklas/capybara).

    Background: A simple calendar app
      Given I have created a new Rails 3 app "rails-3-app" with cucumber-rails support
      And I successfully run `bundle exec rails g scaffold appointment name:string when:datetime`
      And I write to "features/step_definitions/date_time_steps.rb" with:
      """
      When /^(?:|I )select "([^"]+)" as the "([^"]+)" time$/ do |time, selector|
        select_time(selector, :with => time)
      end

      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date$/ do |date, selector|
        select_date(selector, :with => date)
      end

      When /^(?:|I )select "([^"]+)" as the "([^"]+)" date and time$/ do |datetime, selector|
        select_datetime(selector, :with => datetime)
      end
      """

### Comments on [Rails in Action](http://www.manning.com/katz) book
 However, if you have found yourself writing too verbose Cucumber tests rather than doing coding, I have to ask... why were YOU writing the tests? Cucumber is verbose (i.e. basically written english) because it was designed to be written by non coders... (e.g. Product Owners, Users, BA's, etc..) Ideally they would write the Cucumber tests and you would write the fixtures (code) that make them work. The move away from the low level that the web_steps.rb file was enabling is meant to allow these team members to express the tests in terms more relevant to the way they are used to thinking about the application. If the developers are writing all the tests, you are not really getting the whole value of doing BDD. 

I am currently going through the book, without web_steps, using the latest version of cucumber, and still writing the features. I believe Cucumber Features are an essential part to developing a web application. I know it would be a lot of work, and I can link you to my github for what I've done so far if you'd like to see my implementation of it, but I feel that writing the features without web_steps is crucial.

I don't agree with the hard reset of cucumber-rails to 1.0.6 however, as I feel it would encourage poorly written Cucumber tests, as outlined in [The training wheels came off](http://aslakhellesoy.com/post/11055981222/the-training-wheels-came-off)

You can still use Capybara, and I highly suggest it. Something like:

features/creating_projects.feature

    Feature: Creating Projects
        Scenario: Create a project
            Given I am on the homepage
            When I go to the new project page
            And I create a project named "Awesome Project"
            Then I should see the created project.
    
features/step_definitions/project_steps.rb

    Given /^I am on the homepage$/ do
        visit '/'
    end
    
    When /^I go to the new project page$/ do
        click_link 'New Project'
    end
    
    When /^I create a project named "([^"]*)"$/ do |project_name|
        fill_    in 'Name', with: project_name
        click_button 'Create'
    end

    Then /^I should see the created project$/ do
        page.should have_content 'Project has been created'
    end


You could even take out the homepage part most likely. But this is just an example. Although it is some extra steps, it can certainly be done without too much, especially since Cucumber can guide you through the process.
 
> Groups going the RSpec + Capybara (and/or maybe Steak) approach seem to often be missing the engagement by the business users and their tests seem to tend toward programmer friendly Integration Tests rather than true Acceptance Tests. (http://agile-itspeople.blogspot.com/2011/10/eat-your-meat-and-your-vegetables.html)

## Use Capybara on any HTML fragment or page

Capybara’s Node class has a great Matchers mixin with tons of goodies that can be used like so, in RSpec:

    page.should have_content("This should be on the page")
    page.should have_selector("a[href='http://thoughtbot.com']")

Enter `Capybara::Node::Simple`. This class’ docs proclaim its usefulness:

It is useful in that it does not require a session, an application or a driver, but can still use Capybara’s finders and matchers on any string that contains HTML
We’re still on Test::Unit for Gemcutter, so I had to do the following in test/test_helper.rb:

    class Test::Unit::TestCase
      def page
        Capybara::Node::Simple.new(@response.body)
      end
    end

Now the Gemcutter test suite can do assertions like so:

    assert page.has_content?("Rails (3.0.9)")
    assert page.has_selector?("a[href='/gems/rails/versions/3.0.9']")


## Capybara 2.0 Upgrade Guide
Aug 22, 2012; 
The Capybara 2.0.0 beta is out. 

The bad news: If you upgrade to Capybara 2.0.0, you may have to make some changes to your test suite to get it passing.

The good news: Once you’re compatible with Capybara 2.0.0, you can probably go back and forth between 1.1.2 and 2.0.0 without any changes, should you decide that 2.0.0 is not for you (yet).

### Compatibility Notes

Third-party drivers like WebKit or Poltergeist are not yet compatible with Capybara 2.0. Use the default :selenium driver in the meantime.

Also, Capybara 2.0 will likely drop Ruby 1.8.7 compatibility.

How to Upgrade

The latest 2.0.0 beta release is about a month old. I recommend you use Capybara master, since it has some fixes, and is generally in better shape than the beta:

Gemfile

    group :test do
      gem 'capybara', git: 'https://github.com/jnicklas/capybara'
    end

There are two things that will likely cause breakage in your test suite: data-method, and ambiguous matches. Let’s get to them one by one.

### “data-method” Not Respected by Default

The RackTest driver – that’s the fast default driver, when you’re not using `js: true` – no longer respects Rails’s `data-method` attribute unless you tell it to.

For example, say you have the following link in a view:

    = link_to "Delete", article_path(@article), method: :delete

In Capybara 1.1.2, `click_on 'Delete'` would work magically, even though it technically requires JavaScript. In Capybara 2.0.0, I recommend you get the magic behavior back by enabling :`respect_data_method`:

spec/support/capybara.rb

    require 'capybara/rails'
    require 'capybara/rspec'
    
    # Override default rack_test driver to respect data-method attributes.
    Capybara.register_driver :rack_test do |app|
      Capybara::RackTest::Driver.new(app, :respect_data_method => true)
    end

My personal hope is that this will be no longer necessary by the time we hit the 2.0.0 release 

### Ambiguous Matches

The find method, as well as most actions like `click_on`, `fill_in`, etc., now raise an error if more than one element is found. While in Capybara 1.1.2, it would simply select the first matching element, now the matches have to be unambiguous.

Here is a common way this can break your test suite:

    fill_in 'Password', with: 'secret'
    fill_in 'Password confirmation', with: 'secret'

The first `fill_in` will fail now, because searching for “Password” will match both the “Password” label, and the “Password confirmation” label (as a sub-string), so it’s not unambiguous.

The best way to fix this is to match against the name or id attribute – such as `fill_in 'password', with: 'secret'` – or, when there’s no good name or id, add auxiliary `.js-password` and `.js-password-confirmation` classes. (The `js-` prefix is for behavioral classes as recommended in the [GitHub styleguide](https://github.com/styleguide/javascript).)

    find('.js-password').set 'secret'
    find('.js-password-confirmation').set 'secret'

I find that using `.js-` classes instead of matching against English text is actually a good practice in general to keep your tests from getting brittle.

Should you absolutely need to get the old behavior, you can use the `first` method:

    click_on 'ambiguous' # old
    first(:link, 'ambiguous').click # new

###Minor changes

You can assume that these don’t affect you unless something breaks:

`has_content?` checks for substrings in text, rather than using XPath `contains(...)` expressions. This means improved whitespace normalization, and suppression of invisible elements, like `head`, `script`, etc.

`select` and `unselect` don’t allow for substring matches anymore.

`Capybara.server_boot_timeout` and `Capybara.prefer_visible_elements` are no longer needed and have been removed.

`Capybara.timeout` and `wait_until` have been removed, as well as the Selenium driver’s `:resynchronize` option. In general, if you have to wait for Ajax requests to come back, like before you should try using `page.should have_content` or `page.should have_css` to search for some change on the page that indicates that the request has completed. The check will essentially act as a gate for the Ajax request, as it will poll repeatedly until the condition is true. If that doesn’t work for you, you could implement your own simple `wait_for` helper method (see e.g. this [gist](https://gist.github.com/10c41024510ee9f235e0)).

The `find(:my_id)` symbol syntax might go away. In new code, prefer `find('#my_id')`, as recommended in the documentation.

Goodies

These won’t break your code when you upgrade, but they’re sweet new additions:

- Lots of new selectors, like `find(:field, '...')`, etc. These can come in handy if you find yourself doing intricate node finding. Check the `add_selector` calls in `lib/capybara/selector.rb` for a list.

- `has_content?` accepts regexes.

Posted by Funding Gates Aug 22nd, 2012

## Cucumber tips
started from [10 Useful Cucumber Tips](http://www.adrianperez.org/blog/2012/05/17/ten-useful-cucumber-tips/)

### 1. Write Declarative Step Definitions

I thank this has become so common-practice, and I totally advocate the decision of removing `web_steps.rb`. As you go to the roots of the process itself, it’s all meant to be described in a language that’s both familiar to your end users and yourself, but also uses dead simple domain terms, as in a token for a conversation. A good written feature might be written like this.


    Scenario: User subscribes to category
    Given a User exists
    And is logged in
    When he subscribes to the "Programming" category
    Then he should see the posts listed on that category
Perhaps it suffers from a little global abuse but it seems to me that the readability gains outperform that. In order to get the most of this fairly simple feature, and to get the overall picture, you need to understand that:

1. We don’t care about which User exists, we just want to imply it exists. I don’t care about any specific user information in this moment, so don’t use it. A generic user factory it’s just enough.
2. We don’t care about the how’s in anywhere, we use code for that, the features should have the what’s and not the how’s.
3. Which user is logged in should be implicit, as is here. Why? Because there’s no interaction with other user’s here, we just don’t need it.
4. He should see the posts in that category, we’ve just created it right? We don’t care about other categories right now.

### 2. Use unique actions across you steps codebase

Your actions should be unique. They should be easily distinguishable from any other actions, and they shouldn’t be ambigious. Don’t do this, although it might seem pretty trivial.


    When /I (order|buy) (.+)/ do |item|
      # ...
    end

Although the flexibilty might temp you, it’ll hurt you later. You’re to be expected to have clarity and unabiguity in your feature files.

### 3. Use and compare only what you need in Tables

Table diffs are a great feature. Just get in mind don’t to over-use them. When you’re comparing it seems that you can add to readability by cutting the clutter and writing the right step definition.


    Background:
      Given the following Products:
        | name  | price  | description |
        | Socks | 5.00   | ...         |
        | Cap   | 3.00   | ...         |
    
      # ...
    
    Scenario: Buying Products
      # ...
      When I buy a "Cap"
      And I buy a pair of "Socks"
      Then my shopping list should contain:
      | Socks |
      | Cap   |

Adjust your table diffs to use and compare only relevant information. We don’t care about the price and description in the shopping list, we only want to verify the products are there.

As an aside, it would be really nice if we can avoid the need to prevent repeating the action and do some chain step defining, but it would be strange or abused, I mean I guess there is a good reason this hasn’t been implemented. I’m talking about something like this:


    # ... Same as before
    When I buy a "Cap"
    And a pair of "Socks"
    # ...
Chain the “buy a…” step definition. What do you think?

### 4. DRY with Transforms

This is one of the nicest features added to Cucumber. It allows you to avoid the need of repeating the same data transformation from scenario to step definition and instead defining those in a single place. Of course, it could be abused as everything in life, but it’s still a life-saver on it’s own right. This simple example it’s perhaps the most common example found in my code:

features/steps_definitions/transforms.rb

    Transform /^\d+/ do |number|
      number.to_i
    end

Then, on the step definition (Look mom, no `to_i`!)


    Then /^I should have (\d+) pets/ do |count|
      Pets.count.should == count
    end

### 5. Use Tagged Hooks

Tagged hooks are a great feature that allows you to run custom code before and after a tagged scenario. It builds upon the normal `Before` and `After` hooks, but now you can use tags with it. This helps avoiding global abuse and code duplication, along with the added readability.

Suppose you need to perform certain actions if the scenario is for an administrator. You don’t want to repeat those actions, and you don’t want to call that helper method on every feature/scenario, right?

In the scenario, just a tag away:


    @admin
    Scenario: Whatever you want

And you define the tagged hook:

    Before('@admin') do
      user = Factory.create(:admin)
      login(user)
    end

Clean and concise.

### 6. Use Feature Tags and Subfolders

Cucumber tags are so great that I couldn’t help by mentioning them. You should try to use that as much as it makes sense. Subfolders too. Don’t try to put everything in a single place when you’re only a `require features` away.

Get comfortable with the `@wip` tag.

Integrate your team’s workflow with tags as well.

### 7. Nest Steps with Care

Nest steps carefully, in preference don’t nest them at all. Nesting comes with coupling and there are good chances that the benefits are not that huge.

### 8. Name Feature Branches

Choosing branch names and feature file names is entirely up to you. I use, as many, prefixed feature branches. Setting up your branches name to be as closely as possible to the feature you’re working on, and the filename when the feature is described it’s a very helpful inniciative. Examples:

Branch: feature/commenting Feature: features/commenting.feature

Branch: feature/profile-notifications Feature: features/profile/notifications.feature

### 9. Use guard-cucumber

Use `guard-cucumber` to run your features for you. Features are slow, I know, but you should do this anyways. It’s pretty anonnying to having your features running that many times, so what about using the Gem and pausing the file modification from time to time? I work this way and I run my entire suite on every “Pomodoro” break.

### 10. Take screenshots

No, I’m not telling you how to use PrintScreen or Shutter ;)

Besides the known HTML reports, it came to me somewhere that you can actually take screenshot of your scenarios involving javascript. This is a really neat feature for reports (people love visuals), but specially for debugging.


    After('@javascript') do |scenario|
      if(scenario.failed?)
        page.driver.browser.save_screenshot("html/#{scenario.__id__}.png")
        embed("#{scenario.__id__}.png", "image/png", "SCREENSHOT")
      end
    end

Conclusion

### Step through your Cucumber features one step at a time
If you want to step through your cucumber scenarios simulating an interactive debugger, add this hook:

    AfterStep('@pause') do
      print "Press Return to continue..."
      STDIN.getc
    end
Then tag any feature with “@pause” and you’re all set.

### 4 – Exploit the Cucumber formats

Cucumber can output results in many formats. You can use the normal dots, or show all the steps one by one, use HTML, or even use the ‘profiler’ format that will tell you about which steps are slowing down your tests the most.

To change the output style, change the following lines in lib/tasks/cucumber.rake


    Cucumber::Rake::Task.new(:features) do |t|
      t.cucumber_opts = "--format progress"
    end

The options are:

- Progress – Dots for passing. Takes up the least lines of output. Useful for when you have enough steps that it becomes hard to find which one is failing b/c you have to scroll up so much.

- Pretty – The plain text, with color.

- Profile – A red/yellow format that gives the avg runtime of the longest steps.

- Usage – Great for cleaning up step files. Gives you a list of all your steps, with the unused steps in red at the bottom.

### 5 – Speed is not your friend

Cucumber encourages full-stack testing. This is why we use it. But it’s easy to end up with a 6 minute test suite. So, before testing that case where a user has 20 cats, 40 dogs, and 15 carrots, consider whether you want to wait for that test to run 3000 times over the next months as you code.

Once you do end up with a 2-20 minute test suite, consider:

Seeding common data

[Ben’s tip about seeding data](http://www.ruby-forum.com/topic/174289#763689) helps immensely.


    normal_cat = Cat.make
    normal_hair = Hair.make
    
    Given "I have the setup that we used to create 500 times indvidually" do
       @cat = normal_cat
       @hair = normal_hair
    end

[Testjour](http://github.com/brynary/testjour/tree/master) is a gem for “Distributed test running with autodiscovery via Bonjour.” It helped one team take their test suite from 20 minutes to 2.

Deleting some tests (gasp!)

Chances are, you have some scenarios that can be trashed, or commented out. For example, if you have a huge suite of tests that run on a part of your app that is very decoupled and not going to change for several weeks or months, but adds 1 minute to your suite runtime, consider commenting out the non-essential components. You lose some coverage, but if you are doing BDD, then saving 1 minute worth of testing time may be worth it.

### Use Tags

Tags are a great way to organize your features and scenarios in non functional ways. You could use @small, @medium and @large, or maybe @hare, @tortoise, and @sloth. Using tags let you keep a feature’s scenarios together structurally, but run them separately. It also makes it easy to move features/scenarios between groups, and to have a given feature’s scenarios split between groups.

The advantage of separating them this way is that you can selectively run scenarios at different times and/or frequencies, i.e. run faster scenarios more often, or run really big/slow scenarios overnight on a schedule.

Tagging has uses beyond separating scenarios into groups based on how fast they are:

- When they should be run: on @checkin, @hourly, @daily
- What external dependencies they have: @local, @database, @network
- Level: @functional, @system, @smoke
- Etc.

###  Make Scenarios Independent and Deterministic

There shouldn’t be any sort of coupling between scenarios. The main source of such coupling is state that persists between scenarios. This can be accidental, or worse, by design. For example one scenario could step through adding a record to a database, and subsequent scenarios depend on the existence of that record.

This may work, but will create a problem if the order in which scenarios run changes, or they are run in parallel. Scenarios need to be completely independent.

Each time a scenario runs, it should run the same, giving identical results. The purpose of a scenario is to describe how your system works. If you don’t have confidence that this is always the case, then it isn’t doing its job. If you have non-deterministic scenarios, find out why and fix them.

### 

## Capybara Cheat Sheet
Webrat alternative which aims to support all browser simulators.
![I am Capybara](images/capy-1-300.png)

### API

Navigating
----------

visit articles_path

Clicking links and buttons
--------------------------

- click 'Link Text' 
- click_button
- click_link

Interacting with forms
----------------------

- attach_file
- fill_in 'First Name', :with => 'John'
- check 'A checkbox'
- uncheck 'A checkbox'
- choose 'A radio button'
- select 'Peter Pan', :from => 'friends'
- unselect

Querying
--------

Takes a CSS selector (or XPath if you're into that).
Translates nicely into RSpec matchers:

- page.should have_no_button("Save")

Use should have_no_* versions with RSpec matchers b/c
should_not doesn't wait for a timeout from the driver

- page.has_content?
- page.has_css?
- page.has_no_content?
- page.has_no_css?
- page.has_no_xpath?
- page.has_xpath?
- page.has_link?
- page.has_no_link?
- page.has_button?("Update")
- page.has_no_button?
- page.has_field?
- page.has_no_field?
- page.has_checked_field?
- page.has_unchecked_field?
- page.has_no_table?
- page.has_table?
- page.has_select?
- page.has_no_select?

Finding
-------

- find
- find_button
- find_by_id
- find_field
- find_link
- locate

Scoping
-------

- within
- within_fieldset
- within_table
- within_frame
- scope_to

Scripting
---------

- execute_script
- evaluate_script

Debugging
---------

- save_and_open_page

Miscellaneous
-------------

- all
- body
- current_url
- drag
- field_labeled
- source
- wait_until
- current_path

