Sibling Tags
============

This extension for Radiant provides tags allowing you to refer to the neighbouring siblings of a page.

Installation
------------

If your Radiant site is running on version 0.6.9 or greater, you can install extensions very easily. If you are using an 
older version of Radiant, don't worry, it is still quite straightforward. Instructions follow for both.

### Installing for Radiant 0.6.9+

In a terminal, `cd` to the root directory of your Radiant site. Run the following command:

    script/extension install sibling_tags

That's it!

### Installing for Radiant pre-0.6.9

This extension is hosted on github. If you have git installed, then `cd` to the root of your radiant project and 
issue this command: 

    git clone git://github.com/nelstrom/radiant-sibling-tags-extension.git vendor/extensions/sibling_tags

If you don’t have git, then you can instead download the tarball from this URL:

    http://github.com/nelstrom/radiant-sibling-tags-extension/tarball/master

and expand the contents to `your-radiant-project/vendor/extensions/sibling_tags`. 

This extension does not modify the database, so there is no need to run any migrations. Your done!

Usage
-----

When you restart you Radiant site, you should have access to the sibling tags in regular pages of your site. 
Documentation for each individual tag is provided within Radiant. If you go to edit a page, then click the '<b>Available 
tags</b>' link, you should see a list of all the available tags. You can filter the list, by typing 'sibling' into the 
field at the top right of the window.

For examples of usage, we'll use the following site map:

    Title                 Date of Publication
    ----------------      -------------------
    Home                  
      \_Articles          
          \_Apple         2008-02-29
          \_Brocolli      2007-12-17
          \_Carrot        2008-01-25

Using the sibling tags, you can access immediate neighbours of a page. But which pages are considered neighbours depends 
upon how you shuffle the deck! You can sort pages by any field that is stored in the database. Most likely you will want 
to sort by date of publication, or  by page title. These could also be arranged in ascending or descending order. 

By default, pages are sorted in ascending order of publication, i.e. from oldest to newest. The children of 'Articles' 
in the above site map would be arranged as follows:

    Default order:  Brocolli, Carrot, Apple

Lets examine the following snippet of code:

    <r:siblings>
      <r:previous>Previous article: <r:link/></r:previous>
      <r:next>Next article: <r:link/></r:next>
    </r:siblings>

If this was called on the 'Carrot' page, it would output:

    Previous article: <a href="/articles/brocolli">Brocolli</a>
    Next article: <a href="/articles/apple">Apple</a>

Whereas, if the same snippet was called from the 'Brocolli' page, it would output:

    Next article: <a href="/articles/carrot">Carrot</a>

When arranged in the default sort order, 'Brocolli' comes first, so it has no predecessor. Hence, the contents of the 
`<r:siblings:previous></r:siblings:previous>` tag are not output.

You can change the sort order using the `order` and `by` attributes. `order` can either be 
`asc` or `desc`, whereas `by` can be any column name associated with a page in the database.

The following lists demonstrate how the 'Articles' pages above could be sorted:

    order="desc":                Apple, Carrot, Brocolli
    by="title":                  Apple, Brocolli, Carrot
    by="title" order="desc":     Carrot, Brocolli, Apple

Remember that the default values are `order="asc"` and `by="published_at"`, so if either of these are not 
specified, they fall back to those values.

This example demonstrates how these sorting options may be applied:

    <r:siblings by="title">
      <r:previous>Previous in alphabet:<r:link/></r:previous>
      <r:unless_previous>This is the start of the alphabet.</r:unless_previous>
      <r:next>Next in alphabet: <r:link/></r:next>
      <r:unless_next>This is the end of the alphabet.</r:unless_next>
    </r:siblings>

Where do the conditions go?
---------------------------

You can specify `order` and `by` attributes inside of the `<r:siblings/>` tag itself, and these conditions are inherited by the child tags. The following examples are equivalent:
  
    <r:siblings>
      <r:previous by="title"><r:link/></r:previous>
      <r:next by="title"><r:link/></r:next>
    </r:siblings>
  
    <r:siblings by="title">
      <r:previous><r:link/></r:previous>
      <r:next><r:link/></r:next>
    </r:siblings>

By placing the `by` attribute in the `<r:siblings/>` tag, we can save on repetition. If you are planning on using both `<r:previous/>` and `<r:next/>` tags, then the second example is neater. However, if you just want to fetch one of the two, then you don't even have to nest the tags within a `<r:siblings/>` tag. Just make sure that you specify the full namespace at once, e.g.:

    <r:siblings:previous by="title"><r:link/></r:siblings:previous>

    <r:siblings:next by="title"><r:link/></r:siblings:next>

When you specify conditions in the `<r:siblings/>` tag, they are inherited by nested tags, but they may also be overridden. E.g.:

    <r:siblings by="title" order="asc">
      <r:next>Next alphabetically: <r:link/></r:next>
      <r:previous>Previous alphabetically: <r:link/></r:previous>
    
      <r:next by="published_at">Next chronologically</r:next>
      <r:previous by="published_at">Previous chronologically</r:previous>
    </r:siblings>

In this example, the first usage of `<r:next/>` and `<r:previous/>` inherit the attributes set in `<r:siblings/>`. The second time these same tags are used, they provide their own attributes, and these override the values set by the parent `<r:siblings/>` tag.


Credits
-------

Jim Gay created the `siblings:each`, `each_before` and `each_after` tags.