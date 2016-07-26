# Rails Hash forms.
configuration is stored in a YAML file

Well, to use form_for, you need an object, and you can use this to do that:

In your controller:

	class TestItController < ApplicationController
	  def index
	    hashit = {:support_email  => "test@test.com",
	              :allow_comments => 0}
	    @hashit  = Hashit.new(hashit)
	  end
	end

Hashit is defined in RAILS_ROOT/app/models/hashit.rb although it could probably live in /lib:

	class Hashit
	  def initialize(hash)
	    hash.each do |k,v|
	      #self.class.send:)define_method, k, proc{v})
 	      self.instance_variable_set("@#{k}", v)  ##  create instance variable
          self.class.send:)define_method, k, proc{self.instance_variable_get("@#{k}")})  ## method to return instance variable
          self.class.send:)define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})  ## method to set instance variable

	    end
	  end
	end

It takes each key/value pair and defines a method for this class with the key as its name and value for its value, this is what support_email() would be.
Here is the view that uses the @hashit object from the controller:

	<% form_for :hashit, :url => {:action => 'index'} do |f| %>
	  <%= f.text_field :support_email %>
	<% end %>

Now, if you like the idea of turning a hash into an object, then for setting the values you can just do the same thing, you just need a method= method, define_method("method=", ...).

Example of its use:
 
	hashit = {:support_email  => "test@test.com",
	          :allow_comments => 0}
	@hashit  = Hashit.new(hashit)
	logger.error @hashit.inspect        #=> #<Hashit:0xb6a65110 @allow_comments=0, @support_email="test@test.com">
	logger.error @hashit.support_email  #=> test@test.com
	logger.error "setting variables"  
	@hashit.support_email = "new@some_email"
	logger.error @hashit.support_email  #=> new@some_email

## Customized form builders

You can also build forms using a customized FormBuilder class. Subclass FormBuilder and override or define some more helpers, then use your custom builder. For example, let’s say you made a helper to automatically add labels to form inputs.

	<%= form_for @person, :url => { :action => "create" }, :builder => LabellingFormBuilder do |f| %>
	  <%= f.text_field :first_name %>
	  <%= f.text_field :last_name %>
	  <%= f.text_area :biography %>
	  <%= f.check_box :admin %>
	  <%= f.submit %>
	<% end %>
In this case, if you use this:

	<%= render f %>
The rendered template is people/_labelling_form and the local variable referencing the form builder is called labelling_form.

The custom FormBuilder class is automatically merged with the options of a nested fields_for call, unless it’s explicitly set.

In many cases you will want to wrap the above in another helper, so you could do something like the following:

	def labelled_form_for(record_or_name_or_array, *args, &proc)
	  options = args.extract_options!
	  form_for(record_or_name_or_array, *(args << options.merge(:builder => LabellingFormBuilder)), &proc)
	end
If you don’t need to attach a form to a model instance, then check out FormTagHelper#form_tag.

# ActiveModel

	class Preference
		include ActiveModel::Validations
		include ActiveModel::Conversion
		extend ActiveModel::Naming
	
		def initialize(*attr)
		end

		def persisted? 
			false
		end
	end
