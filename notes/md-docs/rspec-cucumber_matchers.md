# RSpec best practices

### First #describe what you are doing …

Begin by using a #describe for each of the methods you plan on defining, passing the method’s name as the argument. For class method specs prefix a “.” to the name, and for instance level specs prefix a “#”. This follows standard Ruby documenting practices and will read well when output by the spec runner.

	describe User do
	 
	  describe '.authenticate' do
	  end
	 
	  describe '.admins' do
	  end
	 
	  describe '#admin?' do
	  end
	 
	  describe '#name' do
	  end
	end
	
#### …Then establish the #context

Write a #context for each execution path through a method; literally specifying the behavior of a method in a given context.

For example, the following method has 2 execution paths:

	class SessionsController &lt; ApplicationController
	 
	  def create
	    user = User.authenticate :email => params[:email],
	                             :password => params[:password]
	    if user.present?
	      session[:user_id] = user.id
	      redirect_to root_path
	    else
	      flash.now[:notice] = 'Invalid email and/or password'
	      render :new
	    end
	  end
	end

Create two contexts in the corresponding spec:

	describe '#create' do
	  context 'given valid credentials' do
	  end
	 
	  context 'given invalid credentials' do
	  end
	end
Note the use of “given” in the argument to each #context. It communicates the context of receiving input. Another great word to use in a context for describing conditional driven behavior is “when”.

	describe '#destroy' do
	   context 'when logged in' do
	   end
	 
	   context 'when not logged in' do
	   end
	 end

By following this style, you can then nest #contexts to clearly define further execution paths.

### #it only expects one thing

By striving to only having one expectation per example, you increase the readability of your specs.

A spec with multiple un-related expectations in a single example:

	describe UsersController do
	 
	  describe '#create' do
	    ...
	 
	    it 'creates a new user' do
	      User.count.should == @count + 1
	      flash[:notice].should be
	      response.should redirect_to(user_path(assigns(:user)))
	    end
	  end
	end

Breaking out the expectations into separate examples clearly defines the behavior and results in easier to maintain examples:

	describe UsersController do
	 
	  describe '#create' do
	    ...
	 
	    it 'creates a new user' do
	      User.count.should == @count + 1
	    end
	 
	    it 'sets a flash message' do
	      flash[:notice].should be
	    end
	 
	    it "redirects to the new user's profile" do
	      response.should redirect_to(user_path(assigns(:user)))
	    end
	  end
	end

Write examples by starting with a present tense verb that describes the behavior.

	it 'creates a new user' do
	end
	 
	it 'sets a flash message' do
	end
	 
	it 'redirects to the home page' do
	end
	 
	it 'finds published posts' do
	end
	 
	it 'enqueues a job' do
	end
	 
	it 'raises an error' do
	end

Finally, don’t begin examples names with the word ‘should’.  It’s redundant and results in hard to read spec output. Likewise, don’t hesitate to use words like ‘the’ or ‘a’ or ‘an’ in your examples when they improve readability.

### Prefer explicitness

 #it, #its and #specify may cut down on the amount of typing but they sacrifice readability.  You now have to read the body of the example in order to determine what its specifying.  Use these sparingly if at all.

Let’s compare the documentation formatter output of the following:

	describe PostsController do
	 
	  describe '#new' do
	    context 'when not logged in' do
	      ...
	 
	      subject do
	        response
	      end
	 
	      it do
	        should redirect_to(sign_in_path)
	      end
	 
	      its :body do
	        should match(/sign in/i)
	      end
	    end
	  end
	end

With the explicit behavior descriptions below:

	describe PostsController do
	 
	  describe '#new' do
	    context 'when not logged in' do
	      ...
	 
	      it 'redirects to the sign in page' do
	        response.should redirect_to(sign_in_path)
	      end
	 
	      it 'displays a message to sign in' do
	        response.body.should match(/sign in/i)
	      end
	    end
	  end
	end

The first example results in blunt, code-like output with redundancy from using the word ‘should’ multiple times:

	$ rspec spec/controllers/posts_controller_spec.rb --format documentation
 
	PostsController
	  #new
	    when not logged in
	      should redirect to "/sign_in"
	      should match /sign in/i

The second results in a very clearly, readable specification:

	$ rspec spec/controllers/posts_controller_spec.rb --format documentation
 
	PostsController
	  #new
	    when not logged in
	      redirects to the sign in page
	      displays a message to sign in

### Run specs to confirm readability

Always run your specs with the ‘–format’ option set to ‘documentation’ (in RSpec 1.x the –format options are ‘nested’ and ‘specdoc’)

	$ rspec spec/controllers/users_controller_spec.rb --format documentation
 
	UsersController
	  #create
	    creates a new user
	    sets a flash message
	    redirects to the new user's profile
	  #show
	    finds the given user
	    displays its profile
	  #show.json
	    returns the given user as JSON
	  #destroy
	    deletes the given user
	    sets a flash message
	    redirects to the home page

Continue to rename your examples until this output reads like clear conversation.

### Use the right matcher

RSpec comes with a lot of useful matchers to help your specs read more like language.  When you feel there is a cleaner way … there usually is!

Here are some of our favorites matchers, before and after they are applied:

	# before: double negative
	object.should_not be_nil
	# after: without the double negative
	object.should be
	 
	# before: 'lambda' is too low level
	lambda { model.save! }.should raise_error(ActiveRecord::RecordNotFound)
	# after: for a more natural expectation replace 'lambda' and 'should' with 'expect' and 'to'
	expect { model.save! }.to raise_error(ActiveRecord::RecordNotFound)
	 
	# before: straight comparison
	collection.size.should == 4
	# after: a higher level size expectation
	collection.should have(4).items

Check out the docs and ask around.

### Formatting

Use ‘do..end’ style multiline blocks for all blocks, even for one-line examples. Further improve readability with a single blank line between all blocks and at the beginning and end of the top level #describe.

Again compare:

	describe PostsController do
	  describe '#new' do
	    context 'when not logged in' do
	      ...
	      subject { response }
	      it { should redirect_to(sign_in_path) }
	      its(:body) { should match(/sign in/i) }
	    end
	  end
	end
With the clearly structured code below:

	describe PostsController do
	 
	  describe '#new' do
	    context 'when not logged in' do
	      ...
	 
	      it 'redirects to the sign in page' do
	        response.should redirect_to(sign_in_path)
	      end
	 
	      it 'displays a message to sign in' do
	        response.body.should match(/sign in/i)
	      end
	    end
	  end
	end

A consistent formatting style is hard to achieve with a team of developers but the time saved from having to learn to visually parse each teammate’s style makes it worthwhile.

## Conclusion

As you can see, all these practices revolve around writing clear specifications readable by all developers. The ideal is to run all specs to not only pass but to have their output completely define your application. Every little step towards that goal helps, and we’re still learning better ways to get there. What are some of your best RSpec practices?

## RSpec Array Matcher

If you're testing arrays a lot, like ActiveRecord's (named) scopes, you should know the following RSpec matcher: =~. It doesn't care about sorting and it gives you all the output you need when the spec fails. Here is an example:

	describe "array matching" do
	
	  it "should pass" do
	    [ 1, 2, 3 ].should =~ [ 2, 3, 1 ]
	  end
	
	  it "should fail" do
	    [ 1, 2, 3 ].should =~ [ 4, 2, 3 ]
	  end
	
	end

Note: There is no inverse (should_not) version of this matcher.

## Detect if a Javascript is running under Selenium WebDriver (with Rails)

Doing this by the book is [super-painful](http://stackoverflow.com/questions/3614472/is-there-a-way-to-detect-that-im-in-a-selenium-webdriver-page-from-javascript).

You might be better of checking against the name of the current Rails environment. To do this, store the environment name in a data-environment of your <body>. E.g., in your application layout:

	%body{'data-environment' => Rails.env}
Now you can say in a piece of Javascript:

	if (	$('body').attr('data-environment') == 'cucumber') {
	  // Code that should happen for Selenium and Rack::Test
	} else {
	  // Code that should happen for other environments
	}

### Grep through the DOM using the Capybara API

When your Cucumber feature needs to browse the page HTML, and you are not sure how to express your query as a clever XPath expression, there is another way: You can use *all* and *find* to grep through the DOM and then perform your search in plain Ruby.

Here is an example for this technique:

	Then /^I should see an image with the filename "([^\"]*)"$/ do |filename|
	  page.all('img').detect do |img|
	    img[:src].include?("/#{filename}")
	  end.should be_present
	end

## Use Capybara on any HTML fragment or page

Capybara’s Node class has a great Matchers mixin with tons of goodies that can be used like so, in RSpec:

	page.should have_content("This should be on the page")
	page.should have_selector("a[href='http://thoughtbot.com']")

Great, but how does one use that in functional/controller tests?

Enter **Capybara::Node::Simple**, which I found purely by chance when source diving. This class’ docs proclaim its usefulness:

> It is useful in that it does not require a session, an application or a driver, but can still use Capybara’s finders and matchers on any string that contains HTML

Bingo! Now, how to use in our test suite? We’re still on Test::Unit for Gemcutter, so I had to do the following in test/test_helper.rb:

	class Test::Unit::TestCase
	  def page
	    Capybara::Node::Simple.new(@response.body)
	  end
	end
Now the Gemcutter test suite can do assertions like so:

	assert page.has_content?("Rails (3.0.9)")
	assert page.has_selector?("a[href='/gems/rails/versions/3.0.9']")
The whole diff is on GitHub if you’d like to see all of the changes of moving our functional tests from Webrat to Capybara.

Gabe also found out that there’s also a shortcut in Capybara for creating a Simple: Capybara.string. The docs for this show that it’s basically sugar on top of the Simple initializer:

	node = Capybara.string <<-HTML
	  <ul>
	    <li id="home">Home</li>
	    <li id="projects">Projects</li>
	  </ul>
	HTML

	node.find('#projects').text # => 'Projects'

I think this pattern is really useful not just for upgrading suites from Webrat, but really anywhere you have an HTML fragment or string that you’d like to use Capybara’s matchers on.

### Is there a way to detect that I'm in a Selenium Webdriver page from Javascript

I'd like to suppress the initialization of TinyMCE inside my tests and can do this easily if the Javascript can detect that I'm running inside a Selenium-automated page.

So, is there some JS code that I can use to detect the Selenium driver? Alternatively, how can I extend the userAgent string to include a pattern that I can detect from JS?

If it really matters, I'm running this through cucumber and capybara on Mac OS X.

Since the question mentions Capybara, here's the equivalent code in Ruby:

	profile = Selenium::WebDriver::Firefox::Profile.new
	profile['general.useragent.override'] = "my ua string"
	
	driver = Selenium::WebDriver.for :firefox, :profile => profile

## [Capybara](https://github.com/jnicklas/capybara) - The missing API

The [Capybara API](http://rubydoc.info/github/jnicklas/capybara) is somewhat hard for parse for a list of methods you can call on a Capybara node. Below you can find such a list. It’s all copied from the Capybara docs, so all credit goes to the Capybara committers.

When you talk to Capybara from a Cucumber step definition, you always have page as the document root note, or whatever you scoped to by saying within(selector) { ... }. You can select child notes by calling page.find(selector) or page.all(selector). You can call the same list of methods on child nodes, select further child nodes, etc.

Inspect a Capybara node

	(String) [](name)
	Retrieve the given attribute.

	(Boolean) checked?
	Whether or not the element is checked.

	(String) path
	An XPath expression describing where on the page the element can be found.

	(Boolean) selected?
	Whether or not the element is selected.

	(String) tag_name
	The tag name of the element.

	(String) text
	The text of the element.

	(String) value
	The value of the form element.

	(Boolean) visible?
	Whether or not the element is visible.

---
Select child nodes

	(Capybara::Element) all(*args)
	Find all elements on the page matching the given selector and options.

	(Capybara::Element) find(*args)
	Find an Element based on the given arguments.

	(Capybara::Element) find_button(locator)
	Find a button on the page.

	(Capybara::Element) find_by_id(id)
	Find a element on the page, given its id.

	(Capybara::Element) find_field(locator) (also: #field_labeled)
	Find a form field on the page.

	(Capybara::Element) find_link(locator)
	Find a link on the page.

	(Object) first(*args)
	Find the first element on the page matching the given selector and options, or nil if no element matches.

---
Manipulate forms in child elements

	(Object) attach_file(locator, path)
	Find a file field on the page and attach a file given its path.

	(Object) check(locator)
	Find a check box and mark it as checked.

	(Object) choose(locator)
	Find a radio button and mark it as checked.

	(Object) click_button(locator)
	Finds a button by id, text or value and clicks it.

	(Object) click_link(locator)
	Finds a link by id or text and clicks it.

	(Object) click_link_or_button(locator) (also: #click_on)
	Finds a button or link by id, text or value and clicks it.

	(Object) fill_in(locator, options = {})
	Locate a text field or text area and fill it in with the given text The field can be found via its name, id or label text.

	(Object) select(value, options = {})
	Find a select box on the page and select a particular option from it.

	(Object) uncheck(locator)
	Find a check box and mark uncheck it.

	(Object) unselect(value, options = {})
	Find a select box on the page and unselect a particular option from it.

---
Check for the presence of child nodes

	(Boolean) has_button?(locator)
	Checks if the page or current node has a button with the given text, value or id.`

	(Boolean) has_checked_field?(locator)
	Checks if the page or current node has a radio button or checkbox with the given label, value or id, that is currently checked.`

	(Boolean) has_content?(content)
	Checks if the page or current node has the given text content, ignoring any HTML tags and normalizing whitespace.`

	(Boolean) has_css?(path, options = {})
	Checks if a given CSS selector is on the page or current node.`

	(Boolean) has_field?(locator, options = {})
	Checks if the page or current node has a form field with the given label, name or id.`

	(Boolean) has_link?(locator, options = {})
	Checks if the page or current node has a link with the given text or id.`

	(Boolean) has_no_button?(locator)
	Checks if the page or current node has no button with the given text, value or id.`

	(Boolean) has_no_checked_field?(locator)
	Checks if the page or current node has no radio button or checkbox with the given label, value or id, that is currently checked.`

	(Boolean) has_no_content?(content)
	Checks if the page or current node does not have the given text content, ignoring any HTML tags and normalizing whitespace.

	(Boolean) has_no_css?(path, options = {})
	Checks if a given CSS selector is not on the page or current node.

	(Boolean) has_no_field?(locator, options = {})
	Checks if the page or current node has no form field with the given label, name or id.

	(Boolean) has_no_link?(locator, options = {})
	Checks if the page or current node has no link with the given text or id.

	(Boolean) has_no_select?(locator, options = {})
	Checks if the page or current node has no select field with the given label, name or id.

	(Boolean) has_no_selector?(*args)
	Checks if a given selector is not on the page or current node.

	(Boolean) has_no_table?(locator, options = {})
	Checks if the page or current node has no table with the given id or caption.

	(Boolean) has_no_unchecked_field?(locator)
	Checks if the page or current node has no radio button or checkbox with the given label, value or id, that is currently unchecked.

	(Boolean) has_no_xpath?(path, options = {})
	Checks if a given XPath expression is not on the page or current node.

	(Boolean) has_select?(locator, options = {})
	Checks if the page or current node has a select field with the given label, name or id.

	(Boolean) has_selector?(*args)
	Checks if a given selector is on the page or current node.

	(Boolean) has_table?(locator, options = {})
	Checks if the page or current node has a table with the given id or caption.

	(Boolean) has_unchecked_field?(locator)
	Checks if the page or current node has a radio button or checkbox with the given label, value or id, that is currently unchecked.

	(Boolean) has_xpath?(path, options = {})
	Checks if a given XPath expression is on the page or current node.
