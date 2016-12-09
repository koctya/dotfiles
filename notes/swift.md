# [Swift](https://swift.org)

## REPL 
it's accessible from both the command line and from the LLDB debugger terminal.
 
To open the REPL in the command line, type this command:

    xcrun swift  


- [The Swift Programming Language (Swift 2.2)](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/TheBasics.html#//apple_ref/doc/uid/TP40014097-CH5-ID309)

# "Webkit Browser in 30 Lines of Swift" from practicalswift.com

Create a file called browser.swift (or whatever) containing this:

    #!/usr/bin/swift  
    import WebKit  
    let application = NSApplication.sharedApplication()  
    application.setActivationPolicy(NSApplicationActivationPolicy.Regular)  
    let window = NSWindow(contentRect: NSMakeRect(0, 0, 960, 720), styleMask: NSTitledWindowMask | NSClosableWindowMask | NSMiniaturizableWindowMask, backing: .Buffered, `defer`: false)  
    window.center()  
    window.title = "Minimal Swift WebKit Browser"  
    window.makeKeyAndOrderFront(window)  
    class WindowDelegate: NSObject, NSWindowDelegate {  
        func windowWillClose(notification: NSNotification) {  
            NSApplication.sharedApplication().terminate(0)  
        }  
    }  
    let windowDelegate = WindowDelegate()  
    window.delegate = windowDelegate  
    class ApplicationDelegate: NSObject, NSApplicationDelegate {  
        var _window: NSWindow  
        init(window: NSWindow) {  
            self._window = window  
        }  
        func applicationDidFinishLaunching(notification: NSNotification) {  
            let webView = WebView(frame: self._window.contentView.frame)  
            self._window.contentView.addSubview(webView)  
            webView.mainFrame.loadRequest(NSURLRequest(URL: NSURL(string: "https://forums.developer.apple.com/thread/5137")!))  
        }  
    }  
    let applicationDelegate = ApplicationDelegate(window: window)  
    application.delegate = applicationDelegate  
    application.activateIgnoringOtherApps(true)  
    application.run()  
 
1. Make it executable (chmod +x browser.swift).
 
1. Run (./browser.swift)

Another way of drawing in the window is to not use an NSView, but draw directly into the window:
 
    NSGraphicsContext.setCurrentContext(window.graphicsContext)  
    NSColor.redColor().set()  
    NSRectFill(NSRect(x:0,y:0,width:100,height:100))  
    window.flushWindow()  
 
The steps here are:
1. Setting the current graphics context (a global variable for the thread) to the graphics context of the window
1. Setting the current color of the graphics context to red
1. Filling a rectangle in the graphics context
1. Flushing the contents so that the result is visible
 
And now you can show a window and draw into it only using the command line.
 
Even though this is possible, depending on what you want to do it is probably better to use the playgrounds in Xcode, since they work in a similiar way to a command line, but actually runs in the same kind of environment as "normal" applications.

## Resources

- [Fun with Swift](http://joearms.github.io/2016/01/04/fun-with-swift.html) - Joe Armstrong
- [Swift Functional Programming Tutorial](https://www.raywenderlich.com/82599/swift-functional-programming-tutorial)
- [Swift 2 Tutorial: A Quick Start](https://www.raywenderlich.com/115253/swift-2-tutorial-a-quick-start)
- [Learn Swift by running Scripts](https://medium.com/swift-programming/1-learn-swift-by-running-scripts-73fdf8507f4b#.d4riid2lz)
- [Single-file Cocoa application with Swift](http://czak.pl/2015/09/23/single-file-cocoa-app-with-swift.html)
- [Eonil/CocoaProgrammaticHowtoCollection](https://github.com/Eonil/CocoaProgrammaticHowtoCollection)
- [Swift from the commandline](https://forums.developer.apple.com/thread/5137)
- [NSOpenPanel in Swift . How to open?](http://stackoverflow.com/questions/26609778/nsopenpanel-in-swift-how-to-open)
- [Objective-C to Swift Converter](https://objectivec2swift.com/#/converter/code)
- http://practicalswift.com/
- [JavaScript OS X App Examples](https://github.com/tylergaw/js-osx-app-examples)
- [OS X Core Controls Tutorial: Part 1/2](http://www.raywenderlich.com/82046/introduction-to-os-x-tutorial-core-controls-and-swift-part-1)
- [Build an iPhone app from the command line](http://commandlinefanatic.com/cgi-bin/showarticle.cgi?article=art024)
- [A Swift Kick in the Pants](http://mediautopia.weebly.com/swift-1-intro.html)
- [Using Swift As a Scripting Language](http://dev.iachieved.it/iachievedit/using-swift-as-a-scripting-language/)
- [Programming in Swift Language Swift 2.0](http://www.knowstack.com/swift-programming-an-introduction/)
