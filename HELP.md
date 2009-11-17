This provides some simple tags to output content related to the pages authors and the pages siblings (other pages with
the same parent page).

## Extras

You will have the ability to edit a user's bio for display on your site. This is a block of text (which you may
filter with Textile, Markdown, or any filter you have installed) which will be output by the <r:author:bio /> tag.

## Radius Tags

The default <r:author /> tag in Radiant displays the current page's creator's name. This extension overrides it
to allow you to output more details such as <r:author:email /> or "<r:author> Email <r:name /> at <r:email />"
Tags are provided for looping through authors (<r:authors:each />) 

You'll also be able to list the pages created by the current author with `<r:pages:each><r:title /></r:pages:each>`.

You'll have tags to output links to other pages near the current page in the page hierarchy. For example, this will
link to the previous page:

    <r:siblings:previous><r:link /></r:siblings:previous>