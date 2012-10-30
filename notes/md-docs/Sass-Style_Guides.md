# Front-end Maintainability with Sass and Style Guides

[Sass](http://sass-lang.com/) variables and mix-ins are amazing resources that make managing styles much easier. This is fantastic for maintaining UI elements and adhering to brand guidelines. Within our AppCloud front-end framework we have variables we’ve set up for our colors based on our branding color palette. That can look something like this:

	// --------------------------------------------------
	// COLOR
	// --------------------------------------------------
	$color_border =           #ccc      // light grey
	$color_background =       #f8f8f8   // lightest grey
	$color_background_alt =   #cfdbe8   // light blue
	$color_background_alt2 =  #e3e5cf   // light beige
	$color_text =             #555      // dark grey
	$color_text_alt =         #999      // medium grey
	$color_text_alert =       #910f0f   // bold red
	$color_text_callout =     #236DA6   // bold blue

This way, when we need to use the color for our borders, we can just call on the color variable, $color_border. If we decide to change this color, we only need to change it in one place. If we need variations on this color (like for shadows and highlights), we can use that variable combined with Sass’s built-in functions:

	h1 {
	  border-bottom-color: darken($color_border, 10%);
	}

We’ve used the “*color_*” prefix in these variable names to help avoid any clashes we might run into. It also helps provide some inline context (documentation is always a good thing). The important thing here is we keep our variable and mix-in names descriptive, but we avoid using presentational names that could change one day. By using *$color_text_callout* instead of *$color_text_blue* we don’t have to change all of our variable names if we change the text from blue to red. We can use comments to help remind us of hex value colors which are located in the one place we’d make changes, if need be.

Variables and mix-ins are a great way to help improve and clean up semantic HTML (if it’s done right). In our last related blog post, we mentioned that we’re using the 960 Grid System which uses CSS classes like “*grid_1*”, “*prefix_9*”, and “*alpha*”. For the semantic front-end neat-freaks out there, this can be cringe-worthy. However, if you’re not already using a framework like Compass, you can simply modify the 960 Grid System, allowing you to have the best of both worlds (modular efficiency and clean, semantic HTML). You can turn all the class names within the framework into mix-ins, which will make HTML go from this:

	<div id="sidebar" class="grid_1 prefix alpha">
	  (content goes here)
	</div>
to this:

	<div id="sidebar">
	  (content goes here)
	</div>
That’s so much better, isn’t it? We can do this for other common styles like clear fixes, rounded corners, visibly hiding elements, etc. If you define your UI elements’ visual design styles as variables or mix-ins, you can have a much easier time updating these styles in a consistent way.

Maintaining an Interface Style Guide

Interface Style Guides are an essential way to keep track of branding and visual design guidelines and front end architecture requirements. The key to keeping a style guide useful is that it should stay relevant and informative. However, this can be a tedious task that often gets forgotten or avoided.

Online style guides are easier to maintain and distribute as opposed to printed documents. To keep our style guide relevant, it lives in our internal-only admin section on the very same application it describes. We display our color palette alongside the relevant Sass variables and since we’ve built the style guide into the application using the same front-end, we can use the same variables we’re referencing to render this palette. When we change values to these variables, the palette updates automatically.

![](http://www.engineyard.com/blog/wp-content/uploads/image_1.png)

Another benefit to adding your online style guide to your application is you get one central place to check to make sure all HTML elements are looking the way they’re supposed to. If the styles are broken here, most likely they’re broken elsewhere.

![](http://www.engineyard.com/blog/wp-content/uploads/image_2.png)

Finally, this method allows development teams to have a reference guide so they know what code they would use to get the effect they’re looking for, such as icons.

![](http://www.engineyard.com/blog/wp-content/uploads/image_3.png)

We continue to evolve the AppCloud front-end through iterations; good organization and documentation is essential to make this front-end architecture work for both designers and developers on our team. What methods does your company or team use? We’d love to hear from you.
