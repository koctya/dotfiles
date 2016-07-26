## Ohai

Ohai is a great little gem for gathering data about a system - used in Chef but also useful on its own.  The documentation for it from the Chef site shows you how to load all available plugins, but you might have reason to load only a select one or two, then query the data.  What reasons?  Performance and memory footprint are two that come to mind - and if you are wondering if there is really that much different between 1 plugin and all of the ones that ship with Ohai, there definitely is - I found (in very unscientific dabbling) that the time to load a single plugin, say, networking, versus the whole complement to be 0.5 seconds faster and 2 MB smaller.  Depending on the environment you are trying to use Ohai in, that could be a big difference.

First step is to get a list of the plugins available.  After loading all the plugins, you can inspect your laoded-up object to get a list, like this:

    require 'pp'  
    puts my_loaded_ohai_object.seen_plugins.sort.pretty_inspect

The seen_plugins array has the list of all plugins your system loaded (and pretty_inspect just outputs that list with line ends inserted, you could do that a lot of other ways too). You will notice in this list a lot of plugins, many of them with a generic name, like network, and then a specific implementation like linux::network.  You are going to use the general implementation, which then relies on the specific implementation underneath, rather than call the specific implementation directly.

Looking into the Ohai source at the code for all_plugins, we see that each individual plugin is required via require_plugin, and that the plugin os is required first.

So the code to require only network would be:

    my_ohai_object_with_no_plugins.require_plugin('os') 
    my_ohai_object_with_no_plugins.require_plugin('network') 
    puts my_ohai_object_with_no_plugins['network']
   
You might also notice that all_plugins waits on any child processes to complete - I guess because some plugins fork to complete their work, but have not peaked through all the plugins to verify this. Either way, its easy to move that waiting code to a separate function you can call on your Ohai::System object:

    class Ohai::System
     def wait_on_children
       unless RUBY_PLATFORM =~ /mswin|mingw32|windows/
         # Catch any errant children who need to be reaped
         begin
           true while Process.wait(-1, Process::WNOHANG)
         rescue Errno::ECHILD
         end
       end
     end
    end

    # then, after the code above to load only certain plugins: 
    my_ohai_object_with_no_plugins.wait_on_children

That breaks encapsulation a bit, of course, forcing the object to reveal too much of how it gets its job done, but as a hack to load only certain plugins, is not that bad.

To do this, add the following line to /etc/chef/client.rb; this examples shows 4 plugins being disabled:

    Ohai::Config[:disabled_plugins] = ["passwd", "rackspace", "dmi", "dmi_common"]

To see the list of available plugins run:

    gem content ohai | grep lib/ohai/plugins

Check ohai plugins loadtime

    #!/usr/bin/env ruby
    
    # Check on the load times for Ohai plugins.
    # To disable from chef-solo and chef-client runs see
    # http://wiki.opscode.com/display/chef/Disabling+Ohai+Plugins
    
    require 'benchmark'
    
    require 'rubygems'
    require 'ohai'
    
    ohai = Ohai::System.new()
    ohai.require_plugin('os')
    
    Ohai::Config[:plugin_path].each do |path|
      [
        Dir[File.join(path, '*')],
        Dir[File.join(path, ohai.data['os'], '**', '*')]
      ].flatten.each do |file|
        file_regex = Regexp.new("#{path}#{File::SEPARATOR}(.+).rb$")
        md = file_regex.match(file)
        if md
          plugin_name = md[1].gsub(File::SEPARATOR, "::")
          dur = Benchmark.realtime do
            ohai.require_plugin(plugin_name) unless ohai.seen_plugins.has_key?(plugin_name)
          end
          puts "Loaded #{plugin_name} in #{(dur*1000).to_i / 1000.0} seconds"
        end
      end
    end