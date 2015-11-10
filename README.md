# Depends

We all need somebody to depend on.

## Purpose

Depends is a tool to find out what RubyGems depends on gems you depend on. Is that confusing?

Okay, sit down. No, really, sit down.

Thank you! :-)

Gems are things you use to avoid writting code that other people wrote better than you could,
or perhaps you're just lazy. That's okay, we're all a little lazy. To prove this I've devised 
this little application named after a brand of adult diapers. Because.

Depends uses the RubyGems.org reverse dependency API endpoint to figure out what gems have a 
runtime dependency on the gem you ask it about. In even simpler terms, there are a lot of gems 
out there that depend on Rake or Bundler. That makes sense because those two gems are utility
gems that pretty much every single Ruby application ends up needing to run.

There are also gems that are a little less popular but still dependended on by a surprising 
amount of other gems:

- As a gem maintainer, wouldn't you like to know how many other gem maintainers have a vested interest in your gem working the way it's supposed to? 
- As a gem user, wouldn't you like to know how many gems depend on that gem you're using to know whether it's been sufficiencly tested in production?

Well you're in luck, Depends will tell you just that. First just how many gems have a runtime depepdency on a gem you're curious about. But more importantly what those gems are and whether they could benefit from a newer version of that gem they depend on, perhaps because it dramatically improves performance?

## Inspiration

This project was inspired by Richard (@schneems) Schneeman and his blog post ["Who Does your Gem Work For?"](http://www.schneems.com/blogs/2015-09-30-reverse-rubygems/).

## Side-effects

As a consequence of putting this project together I've fixed an issue in the RubyGems.org reverse dependency API that [caused it to return yanked gems](https://github.com/rubygems/rubygems.org/pull/1104) and added [a new parameter to filter reverse dependencies by either only runtime or development dependencies](https://github.com/rubygems/rubygems.org/pull/1099) to get a clearer picture of the gems whose runtime environment a gem services.

I hope to make many more improvements to the RubyGems.org API if necessary in the future as this project evolves.

## License

This project is [MIT licensed](LICENSE.txt).
