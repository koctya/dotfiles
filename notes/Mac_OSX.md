# Mac OS X

http://www.bresink.com/osx/TinkerTool.html

http://www.itproportal.com/2013/07/19/a-guide-to-using-os-xs-automator-to-create-your-own-software/

http://www.itproportal.com/2013/10/25/10-of-the-most-impressive-new-features-in-apples-os-x-mavericks/

http://www.itproportal.com/2012/10/02/os-x-mountain-lion-hidden-mysteries-of-the-option-key/

http://reviews.cnet.com/apple-os-x-10.9-mavericks/?part=rss&subj=latestreviews&tag=title&utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+cnet%2FYIff+%28CNET+Latest+Reviews%29

http://teratalks.com/2013/12/free-how-to-put-color-back-into-os-xs-boring-finder-sidebar/

http://www.macobserver.com/tmo/article/the-most-enduring-and-endearing-features-of-os-x-throughout-the-years2

http://www.macobserver.com/tmo/article/the-most-enduring-and-endearing-features-of-os-x-throughout-the-years.-part

http://computers.tutsplus.com/tutorials/how-to-verify-and-repair-a-disk-from-the-os-x-command-line--cms-21561

http://blogs.computerworld.com/mac-os-x/23923/os-x-mavericks-using-apples-hidden-wi-fi-diagnostics-tool

http://computers.tutsplus.com/tutorials/introducing-markdown-on-os-x--cms-20764

http://www.mitchchn.me/2014/os-x-terminal/

http://blogs.computerworld.com/mac-os-x/23810/how-avoid-paying-apple-extra-icloud-storage

http://www.imore.com/heartbleed-new-openssl-hack-how-does-it-affect-os-x-and-ios


http://www.macworld.com/article/2138687/latest-iwork-update-is-another-win-for-applescript.html#tk.rss_all

http://www.macworld.com/article/2105200/bad-applescript-safari-and-curling-urls.html

http://computers.tutsplus.com/tutorials/change-your-dns-for-safer-faster-browsing--mac-61232


http://www.cultofmac.com/254380/jony-ives-cars/

http://www.t-gaap.com/2014/2/19/apple-readying-a8-macbook-air

http://bohemianboomer.com/2014/02/this-app-is-the-clean-colorful-and-free-way-to-clean-up-your-mac/

http://www.itproportal.com/reviews/hardware/apple-mac-pro-review/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+itproportal%2Frss+%28Latest+ITProPortal+News%29

http://www.macworld.co.uk/news/mac/10-reasons-why-macs-are-better-pcs-3471928/

http://www.theguardian.com/technology/blog/2014/jan/28/mac-pro-seymour-cray-would-have-approved

http://mac360.com/2012/06/the-easy-way-to-turn-your-skype-calls-into-quicktime-movies-on-a-mac/

http://mac360.com/2014/01/free-how-to-keep-nefarious-apps-on-your-mac-from-phoning-home/

http://mac360.com/2012/04/10-easy-point-and-click-ways-to-secure-your-mac-with-a-single-app/

http://www.technightowl.com/newsletter/2014/01/newsletter-issue-736/#macs

http://appledailyreport.com/philips-28-inch-4k-ultra-hd-monitor-gives-me-hope-for-a-retina-display-imac/

Summary

## Startup options
It’s important to read over the description of each Mac startup option to ensure that you understand its use and purpose. Once you’re familiar with these options, however, just use the table below as a handy guide in case you forget the specific keys necessary for each option.

    STARTUP KEYS		|	DESCRIPTION
    Command-R	Boot to OS X Recovery Mode
    Alt/Option	Access Mac Startup Manager
    C	Boot to CD, DVD, or USB
    N	NetBoot
    Shift	Safe Boot
    Command-V	Verbose Mode
    Command-S	Single User Mode
    Command-Option-P-R	Reset PRAM
    T	Enable Target Disk Mode

## useful Terminal commands for OS X

3. Show hidden files in Finder

Terminal also provides you with an easy way to show all hidden files in Finder. It’s done with the following command:

    defaults write com.apple.finder AppleShowAllFiles -bool TRUE

After making this change, you’ll have to restart finder, which can be done with the following command:

    killall Finder

Now, when using Finder to search for files, even files that were normally hidden to protect you from making unintentional changes that could potentially damage your system, will be displayed.

You can also easy hide hidden files once again by repeating the above commands, except replacing “TRUE” with “FALSE” instead.

10. Set your Mac’s screensaver as the wallpaper

If you’re in the mood for some eye candy, you can set your current screensaver as your Mac wallpaper temporarily with Terminal by using the following fun and quirky command:

    /System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background

This will make your current screensaver the desktop wallpaper for as long as the command is running. If you close the Terminal app or use the `Control + C` shortcut, then the wallpaper will return to normal.

4. Make your Mac say anything you want

You can also use Terminal to have your Mac say anything you want. If you want your Mac to say something out loud, you can use the “say” command, followed by whatever it is you want your Mac to say. Here’s an example:

    say “Hi iDownloadBlog, Terminal says hello.”

In this example, your Mac will say exactly what is in the quotes using the default system voice

5. Keep your Mac from falling asleep

Terminal comes with a way to keep your Mac from falling asleep, dimming the display, or showing the screensaver. Simply use the following command:

    caffeinate

With this command having been used, your Mac will act like it just drank a Trenta-sized coffee at Starbucks. You can also set time periods up so the command is only active for a temporary period of time. To do this, add the “-t” flag, followed by a number of seconds you want the feature to be enabled for, like this:

    caffeinate -t 150000

In this example, our Mac would stay awake for 150,000 seconds, and then after that time period, the command would be auto-disabled. You can also press Control + C to end the command early at any time.
