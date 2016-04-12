# Custom [Activeadmin](http://activeadmin.info/)

1. Adding a custom behavior to ActiveAdmin::BaseController:

Often times, you'll want to add a before_filter to something like your typical ApplicationController, but scoped to the ActiveAdmin engine. In this case, you can add custom behavior by following this pattern:

    # config/initializers/active_admin_extensions.rb:
    ActiveAdmin::BaseController.send(:include, ActiveAdmin::SiteRestriction)

    # lib/active_admin/site_restriction.rb:
    module ActiveAdmin
      module SiteRestriction
        extend ActiveSupport::Concern
        included do
          before_filter :restrict_to_own_site
        end
        private
        def restrict_to_own_site
          unless current_site == current_admin_user.site
            render_404
          end
        end
      end
    end

2. Conditionally add a navigation menu item:

When you have multiple admin types, you may want to only show certain menu items to a specific type of admin user. You can conditionally show menu items:

    # app/admin/resource.rb:
    ActiveAdmin.register Resource do
      menu :parent => "Super Admin Only", :if => proc { current_admin_user.super_admin? }
    end

3. To display an already uploaded image on the form:

ActiveAdmin uses [Formtastic](https://github.com/justinfrench/formtastic) behind the scenes for forms. Persisting uploads between invalid form submissions can be accomplished via `f.input :image_cache, :as => :hidden`. However you may want to display the already uploaded image upon visiting the form for editing an existing item. You could use set one using a hint (`f.input :image, :hint => (f.template.image_tag(f.object.image.url) if f.object.image?)`), but this won't allow you to set any text as a hint. Instead, you could add some custom behavior to the Formtastic FileInput:

    # app/admin/inputs/file_input.rb
    class FileInput < Formtastic::Inputs::FileInput
      def to_html
        input_wrapping do
          label_html <<
          builder.file_field(method, input_html_options) <<
          image_preview_content
        end
      end
      private
      def image_preview_content
        image_preview? ? image_preview_html : ""
      end
      def image_preview?
        options[:image_preview] && @object.send(method).present?
      end
      def image_preview_html
        template.image_tag(@object.send(method).url, :class => "image-preview")
      end
    end

    # app/admin/my_class.rb
    ActiveAdmin.register MyClass do
      form do |f|
        f.input :logo_image, :image_preview => true
      end
    end

7. Dynamic Site Title:

It's possible you have multiple user types or sites that are managed via a single CMS. In this case, you may want to update the title displayed in the Navigation Menu.

    # config/initializers/active_admin.rb
    config.site_title = proc { "#{current_site.name} CMS" }

8. use abre templates in place of regular erb views

Also, it isn't well documented on the Github page, but digging through the source, it appears you can also use abre templates in place of regular erb views like so (notice the .arb file extension):

app/views/whatever/show.html.arb

    h2 "Why is Arbre awesome?"

    ul do
      li "The DOM is implemented in ruby"
      li "You can create object oriented views"
      li "Templates suck"
    end

That way, your controller could look like this:

app/controllers/whatever_controller.rb

    def show
      # nothing necessary here, by default renders show.html.arb
    end

## add charts

[Custom activeadmin pages](http://juanda.me/create-custom-activeadmin-pages-with-charts/)

# [Arbre](https://github.com/activeadmin/arbre) - HTML Views in Ruby
