# Web dev notes

## Haml

## [Sass](http://sass-lang.com/)

### placing a div in the dead center of a page (vertically and horizontally).

The mixin definition:

    =dead-center(!height,!width)
      :height= !height
      :margin-top= -(!height / 2)
      :top 50%
      :width= !width
      :margin-left= -(!width / 2)
      :left 50%
      :position absolute
      :text-align center

To use it on an element:

    #centered
      +dead-center(200px,500px)

Now I'll never forget how. Thanks Sass!
