# Little Printer Hello World Example (Ruby)

This is an example publication, written in Ruby using the [Sinatra framework](http://www.sinatrarb.com/). The same example can also be
seen in:

* [PHP](https://github.com/bergcloud/lp-hello-world-php)
* [Python](https://github.com/bergcloud/lp-hello-world-python)

This example shows how to set up and validate a form for a subscriber to
configure the publication.

Read more about this example [on the developer site](http://remote.bergcloud.com/developers/littleprinter/examples/hello_world). 

## Run it

Run the server with:

    $ bundle exec ruby publication.rb

You can then visit these URLs:

* `/edition/?lang=english&name=Phil&local_delivery_time=2013-11-11T12:20:30-08:00`
* `/icon.png`
* `/meta.json`
* `/sample/`

In addition, the `/validate_config/` URL should accept a POST request with
a field named `config` containing a string like:

    {"lang":"english","name":"Phil"}


----

BERG Cloud Developer documentation: http://remote.bergcloud.com/developers/

