# coffee(java)script stuff

https://efendibooks.com/minibooks/testing-with-coffeescript

http://coffeescriptcookbook.com/chapters/testing/testing_with_jasmine

## Gulp

http://gulpjs.com/

https://github.com/OverZealous/gulp-task-listing

https://github.com/gulpjs/gulp/blob/master/docs/recipes/using-coffee-script-for-gulpfile.md
Using coffee-script for gulpfile
As discussed in issue #103, there are 2 ways to do this.

    Use gulp --require coffee-script/register at the command line
    Require in gulpfile.coffee after requiring coffee-script in gulpfile.js

gulpfile.js

    require('coffee-script/register');
    require('./gulpfile.coffee');

gulpfile.coffee

    gulp = require 'gulp'

    gulp.task 'default', ->
      console.log('default task called')

http://weblogs.asp.net/shijuvarghese/archive/2014/02/19/gulp-js-a-better-alternative-to-grunt-js.aspx

https://github.com/gulpjs/gulp

http://julienrenaux.fr/2014/05/25/introduction-to-gulp-js-with-practical-examples/

http://www.frontendjournal.com/how-to-build-an-asset-pipeline-with-gulpjs-for-any-webapp/

https://medium.com/@alexslansky/playing-with-gulp-browserify-node-sass-bourbon-react-and-shoe-a1ea2dd606b

http://stackoverflow.com/questions/23023650/is-it-possible-to-pass-a-flag-to-gulp-to-have-it-run-tasks-in-different-ways

https://github.com/gulpjs/gulp/blob/master/CHANGELOG.md#35

http://viget.com/extend/gulp-browserify-starter-faq

http://maximilianschmitt.me/posts/gulp-js-tutorial-sass-browserify-jade/

https://github.com/CaryLandholt/gulp-ng-classify

http://addyosmani.com/blog/environment-specific-builds-with-grunt-gulp-or-broccoli/

http://www.frontendjournal.com/how-to-build-an-asset-pipeline-with-gulpjs-for-any-webapp/

# Clojurescript


https://github.com/swannodette/lt-cljs-tutorial

https://github.com/swannodette/lt-cljs-tutorial/blob/master/lt-cljs-tutorial.cljs


# Javascript

http://mattgreer.org/articles/promises-in-wicked-detail/

https://www.promisejs.org/

http://jsfiddle.net/

http://browserify.org/

http://codeofrob.com/entries/you-have-ruined-javascript.html

http://swannodette.github.io/2013/12/17/the-future-of-javascript-mvcs/

http://blog.reverberate.org/2014/02/on-future-of-javascript-mvc-frameworks.html

http://blog.reverberate.org/2014/02/react-demystified.html

http://swannodette.github.io/2013/12/17/the-future-of-javascript-mvcs/

http://dev.opera.com/articles/view/opera-javascript-for-hackers-1/

http://modernweb.com/2014/02/10/build-desktop-apps-with-javascript-and-node-webkit/

http://www.sitepoint.com/getting-started-browserify/?utm_source=javascriptweekly&utm_medium=email

# Node

https://github.com/maxogden/art-of-node

npm install learnyounode -g

https://github.com/maxogden/art-of-node

http://www.nearform.com/nodecrunch/node-js-becoming-go-technology-enterprise#.UyLJD_vIfGh


http://blogs.atlassian.com/2013/11/harmony-generators-and-promises-for-node-js-async-fun-and-profit/

http://blog.millermedeiros.com/node-js-ant-grunt-and-other-build-tools/

http://gruntjs.com/

