# Secret Santa

An app to help you run a secret santa group.

## Development

The app aims to be as self-contained as possible, running entirely over [litestack][litestack].
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

A [lefthook] post commit hook has been configured to run [StandardRB][standardruby] for Ruby code
and [Prettier][prettier] for Javascript code. For the latter, you need to have a running NodeJS
environment.

[litestack]: https://github.com/oldmoe/litestack
[asdf]: https://github.com/asdf-vm/asdf
[standardruby]: https://github.com/standardrb/standard
[prettier]: https://github.com/prettier/prettier
