# [Jekyll](https://github.com/mojombo/jekyll) static site notes

Jekyll is a simple, blog aware, static site generator. It takes a template directory, runs it through Textile or Markdown and Liquid converters, and spits out a complete, static website suitable for serving with Apache or your favorite web server. This is also the engine behind [GitHub Pages](http://pages.github.com/), which you can use to host your project’s page or blog right here from GitHub.

###[Install](https://github.com/mojombo/jekyll/wiki/install)
The best way to install Jekyll is via RubyGems:

	sudo gem install jekyll

## [Template Data](http://wiki.github.com/mojombo/jekyll/template-data)
Jekyll traverses your site looking for files to process. Any files with YAML Front Matter are subject to processing. For each of these files, Jekyll makes a variety of data available to the pages via the Liquid templating system. The following is a reference of the available data.

#### Global
	Variable	Description

- **site**	 Sitewide information + Configuration settings from _config.yml
- **page**	 This is just the YAML Front Matter with 2 additions: url and content.
- **content**	 In layout files, this contains the content of the subview(s). This is the variable used to insert the rendered content into the layout. This is not used in post files or page files.
- **paginator**	 When the paginate configuration option is set, this variable becomes available for use.

## [YAML Front Matter](https://github.com/mojombo/jekyll/wiki/yaml-front-matter)

Any files that contain a YAML front matter block will be processed by Jekyll as special files. The front matter must be the first thing in the file and takes the form of:

	```yaml
	---
	layout: post
	title: Blogging Like a Hacker
	---
	```

Between the triple-dashed lines, you can set predefined variables (see below for a reference) or custom data of your own.

### Predefined Global Variables
	Variable	 Description

- layout	 - If set, this specifies the layout file to use. Use the layout file name without file extension. Layout files must be placed in the _layouts directory.
- permalink	-  If you need your processed URLs to be something other than the default /year/month/day/title.html then you can set this variable and it will be used as the final URL.
- published	-  Set to false if you don’t want a post to show up when the site is generated.
- category/categories	- Instead of placing posts inside of folders, you can specify one or more categories that the post belongs to. When the site is generated the post will act as though it had been set with these categories normally.
Categories (plural key) can be specified as a YAML list or a space-separated string.
- tags	- Similar to categories, one or multiple tags can be added to a post. Also like categories, tags can be specified as a YAML list or a space-separated string.

###Custom Variables
Any variables in the front matter that are not predefined are mixed into the data that is sent to the Liquid templating engine during the conversion. For instance, if you set a title, you can use that in your layout to set the page title:

	<title>{{ page.title }}</title>

##[Configuration](https://github.com/mojombo/jekyll/wiki/configuration)
Jekyll allows you to concoct your sites in any way you can dream up. The following is a list of the currently supported configuration options. These can all be specified by creating a _config.yml file in your site’s root directory. There are also flags for the jekyll executable which are described below next to their respective configuration options. The order of precedence for conflicting settings is this:

1. Command-line flags
2. Configuration file settings
3. Defaults
###Configuration Settings

<table>
<tr>
<td> <strong>Setting</strong> </td>
		<td> <strong>Config</strong> </td>
		<td> <strong>Flag</strong> </td>
		<td> <strong>Description</strong> </td>
	</tr>
<tr>
<td> Safe </td>
		<td> <pre>safe: [boolean]</pre> </td>
		<td> <code>--safe</code> </td>
		<td> Disables custom <a href="Plugins">plugins</a>. </td>
	</tr>
<tr>
<td> Regeneration </td>
		<td> <pre>auto: [boolean]</pre> </td>
		<td> <code>--no-auto --auto</code> </td>
		<td> Enables or disables Jekyll from recreating the site when files are modified. </td>
	</tr>
<tr>
<td> Local Server </td>
		<td> <pre>server: [boolean]</pre> </td>
		<td> <code>--server</code> </td>
		<td> Fires up a server that will host your _site directory </td>
	</tr>
<tr>
<td> Local Server Port </td>
		<td> <pre>server_port: [integer]</pre> </td>
		<td> <code>--server [port]</code> </td>
		<td> Changes the port that the Jekyll server will run on </td>
	</tr>
<tr>
<td> Base <span class="caps">URL</span> </td>
		<td> <pre>baseurl: [BASE_URL]</pre> </td>
		<td> <code>--base-url [url]</code> </td>
		<td> Serve website from a given base <span class="caps">URL</span> </td>
	</tr>
<tr>
<td> <span class="caps">URL</span> </td>
		<td> <pre>url: [<span class="caps">URL</span>]</pre> </td>
		<td> <code>--url [url]</code> </td>
		<td> Sets site.url, useful for environment switching </td>
	</tr>
<tr>
<td> Site Destination </td>
		<td> <pre>destination: [dir]</pre> </td>
		<td> <pre>jekyll [dest]</pre> </td>
		<td> Changes the directory where Jekyll will write files to </td>
	</tr>
<tr>
<td> Site Source </td>
		<td> <pre>source: [dir]</pre> </td>
		<td> <pre>jekyll [source] [dest]</pre> </td>
		<td> Changes the directory where Jekyll will look to transform files </td>
	</tr>
<tr>
<td> Markdown </td>
		<td> <pre>markdown: [engine]</pre> </td>
		<td> <code>--rdiscount</code> or <code>--kramdown</code> or <code>--redcarpet</code> </td>
		<td> Uses RDiscount or [engine] instead of Maruku. </td>
	</tr>
<tr>
<td> Pygments </td>
		<td> <pre>pygments: [boolean]</pre> </td>
		<td> <code>--pygments</code> </td>
		<td> Enables highlight tag with Pygments. </td>
	</tr>
<tr>
<td> Future </td>
		<td> <pre>future: [boolean]</pre> </td>
		<td> <code>--no-future --future</code> </td>
		<td> Publishes posts with a future date </td>
	</tr>
<tr>
<td> <span class="caps">LSI</span> </td>
		<td> <pre>lsi: [boolean]</pre> </td>
		<td> <code>--lsi</code> </td>
		<td> Produces an index for related posts. </td>
	</tr>
<tr>
<td> Permalink </td>
		<td> <pre>permalink: [style]</pre> </td>
		<td> <code>--permalink=[style]</code> </td>
		<td> Controls the URLs that posts are generated with. Please refer to the <a class="internal present" href="/mojombo/jekyll/wiki/Permalinks">Permalinks</a> page for more info. </td>
	</tr>
<tr>
<td> Pagination</td>
		<td> <pre>paginate: [per_page]</pre> </td>
		<td> <code>--paginate [per_page]</code> </td>
		<td> Splits your posts up over multiple subdirectories called “page2”, “page3”, … “pageN” </td>
	</tr>
<tr>
<td> Exclude </td>
		<td> <pre>exclude: [dir1, file1, dir2]</pre> </td>
		<td> </td>
		<td> A list of directories and files to exclude from the conversion </td>
	</tr>
<tr>
<td> Include </td>
		<td> <pre>include: [dir1, file1, dir2]</pre> </td>
		<td> </td>
		<td> A list of directories and files to specifically include in the conversion. <code>.htaccess</code> is a good example since dotfiles are excluded by default. </td>
	</tr>
<tr>
<td> Limit Posts </td>
		<td> <pre>limit_posts: [max_posts]</pre> </td>
		<td> <pre> <code>--limit_posts=[max_posts]</code></pre> </td>
		<td> Limits the number of posts to parse and publish </td>
	</tr>
</table>
###Default Configuration
Note — You cannot use tabs in configuration files. This will either lead to parsing errors, or Jekyll will use the default settings.

	safe:        false
	auto:        false
	server:      false
	server_port: 4000
	baseurl:    /
	url: http://localhost:4000
	
	source:      .
	destination: ./_site
	plugins:     ./_plugins
	
	future:      true
	lsi:         false
	pygments:    false
	markdown:    maruku
	permalink:   date
	
	maruku:
	  use_tex:    false
	  use_divs:   false
	  png_engine: blahtex
	  png_dir:    images/latex
	  png_url:    /images/latex
	
	rdiscount:
	  extensions: []
	
	kramdown:
	  auto_ids: true,
	  footnote_nr: 1
	  entity_output: as_char
	  toc_levels: 1..6
	  use_coderay: false
	  
	  coderay:
	    coderay_wrap: div
	    coderay_line_numbers: inline
	    coderay_line_numbers_start: 1
	    coderay_tab_width: 4
	    coderay_bold_every: 10
	    coderay_css: style
