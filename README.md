# Secret Santa

An app to help you run a secret santa group.

## Development

The app aims to be as self-contained as possible, running entirely over SQLite, with the Solid gems ([Solid Cache][solid_cache],
[Solid Queue][solid_queue], [Solid Cable][solid_cable]) backing the cache, jobs and Action Cable in production.
To run the application all you need is Ruby; [asdf][asdf] is the recommended version manager.

```bash
# Install Ruby
asdf install

# Install Ruby dependencies and setup the DB
bin/setup

# Run the server and Tailwind watcher
bin/dev

# Run all tests
bin/rspec
```

### Linters

A [lefthook] pre-commit hook runs [StandardRB][standardruby] (Ruby) and [Prettier][prettier]
(everything else) over the staged files, fixing what they can and re-staging the fixes. Prettier
needs a NodeJS environment. Run `bundle exec lefthook install` once to enable the hook. It doesn't
run the tests, so run `bin/rspec` yourself before pushing. CI runs them on pull requests and before every
deploy from `main`.

[solid_cache]: https://github.com/rails/solid_cache
[solid_queue]: https://github.com/rails/solid_queue
[solid_cable]: https://github.com/rails/solid_cable
[asdf]: https://github.com/asdf-vm/asdf
[standardruby]: https://github.com/standardrb/standard
[prettier]: https://github.com/prettier/prettier
