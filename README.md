Evergreen App
=============

Evergreen App is an open source question and answer platform that lets you better engage with and support your users and your team.

You can view our site in action here: [http://www.evergreenapp.org](http://www.evergreenapp.org)

### Setup
Evergreen depends on certain features of PostgreSQL for core functionality
so you will need a Postgres install to run the app. You'll also
need Ruby 1.9.3+ (I'm running 2.0.0 right now).

Evergreen uses [Figaro](https://github.com/laserlemon/figaro) to keep certain sensitive configuration information out of the public repository. 
**You will need to add a "config/application.yml"** file to your project tree
and populate it with values for at least the following keys:

    secret_token: [a secret token]

    development:
      domain: [domain of local instance, ex "localhost"]

      db_name: [db name]
      db_user: [db user]
      db_password: [db password]

    test:
      domain: [domain for test server, likely same as above]

      db_name: [test db name]
      db_user: [test db user]
      db_password: [test db password]

You'll likely need to set up ActionMailer credentials for your local 
instance as well. You'll notice "config/action\_mailer\_credentials.rb"
in the .gitignore file. I suggest you put the credentials there.  


This is a Rails 4 application. As noted above, it leverages Postgres for some core functionality (like full text search) so you will need that. 
I've tried to keep dependencies lean otherwise though (for instance,
I'll use ActiveRecord to back delayed\_job until it's actually
a bottlekneck, if ever). I use the "russian doll" caching style (and cache
digests gem to keep cache keys in line with template changes in app updates)
all over the place and have seen great performance with it (most actions
render in under 70ms on unicorn with production settings, many even under 40ms). 
Because of that you may wish to run memcached (or your cache store of choice)
even in your local development environment (and update your config/environments/development.rb
file accordingly).

To install all dependencies, run:

    $ bundle

Once you've done that, you can create the schema using:

    $ rake db:migrate

You can now to start the development server

    $ rails s

And the delayed\_job worker (you'll need to run "rails generate delayed_job" once from project root to create the "delayed\_job" runner script):
    
    $ script/delayed_job

The rspec suite is minimal now. I want the critical flows to 
be covered but not for it to grow to a point where it itself
becomes a significant maintenance burden. To run it:

    $ rspec spec

(I usually run spec suites and/or single specs with
[zeus](https://github.com/burke/zeus) these days to preserve my sanity)


#### About the UUIDs
You might notice that this app uses UUIDs in certain places, but that 
they're generated at the app level (using the "Uuid" model concern)
and not using Postgres' "uuid-ossp" extension and "uuid" type. I initially did use UUID primary keys
generated in the DB with the Postgres extension but ran into too much 
difficulty with compatibility (especially in areas like testing - 
FactoryGirl is not built to work with UUID primary keys for things like
sequences and associations). I have no plans to reintroduce Postgres-native
UUIDs until they are supported more in the Rails ecosystem.

#### Project Roadmap
The raison d'être for this project was personal experience
building and maintaining several web apps
and wanting a QA-style support channel 
(of which there are several providers)
that I did not have to
license on a per-product and/or per-seat basis 
(there are none). 

I've tried to work proven concepts from established QA 
and support products into the functional design of this app.
There are other features that I'd like to work in in the future,
specifically richer posts (there's already markdown support but I 
haven't yet added image attachments and the corresponding UI),
and a XMPP-server-backed chat widget (I haven't had the time
to work out the most appropriate way to integrate that).
I'll keep discussions about these things going on the
[Meta Evergreen board](http://evergreenapp.org/c/meta).

#### Contact
If you want to reach me to discuss this project you can 
do so by email at nicholas@evergreenapp.org or by posting
to the [Meta Evergreen board (evergreenapp.org/c/meta)](http://www.evergreenapp.org/c/meta). I want 
to make sure Evergreen addresses the biggest pain points in this space 
and would be happy to help other product owners get it set up.