This is the source code for [The Dev Garden](http://devgarden.macalester.edu)’s web site.

# Installation

- Install Ruby, Rails and PostgreSQL. The [Railsbridge Installfest](http://docs.railsbridge.org/installfest/) is a good installation guide.
- Clone this repository.
- `cd devgarden`
- `bundle install`
- `rake db:setup`
- If you want fill your local database with fake data: `rake db:fake`

To run the site locally:

- Run `unicorn` on the command line.
- Visit `http://localhost:8080` in your web browser.
