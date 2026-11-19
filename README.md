# Secret Santa

An app to help you run a secret santa group.

## Development

The app aims to be as self-contained as possible, running entirely over SQLite, with the Solid gems ([Solid Cache][solid_cache],
[Solid Queue][solid_queue], [Solid Cable][solid_cable]) backing the cache, jobs and Action Cable in production.
To run the application you need Ruby, plus [Bun][bun] for the JavaScript linting tools. Both versions are pinned in
`.tool-versions`, which [mise-en-place][mise] reads.

```bash
# Install Ruby and Bun
mise install

# Install Ruby and JavaScript dependencies and set up the DB
bin/setup

# Run the server and Tailwind watcher
bin/dev

# Run all tests
bin/rspec
```

In development, emails are printed to the `bin/dev` log rather than sent, so follow sign-in links from there.

### Linters

| Tool                       | Checks                                       | Run it with                                                         |
| -------------------------- | -------------------------------------------- | ------------------------------------------------------------------- |
| [StandardRB][standardruby] | Ruby, plus the project's custom RuboCop cops | `bundle exec standardrb`                                            |
| [Prettier][prettier]       | Formatting of everything else                | `bun run lint:prettier`                                             |
| [Oxlint][oxlint]           | JavaScript                                   | `bun run lint:js`                                                   |
| [Herb][herb]               | ERB templates                                | `bun run lint:erb`                                                  |
| [Herb][herb] (validate)    | Templates compile and every render resolves  | `bundle exec herb analyze . && bundle exec herb actionview check .` |

`bun run lint` runs Prettier, Oxlint and Herb's linter together.

A [Lefthook][lefthook] pre-commit hook runs all of them over the staged files, fixing what they can and re-staging the
fixes. Run `bundle exec lefthook install` once to enable the hook. It doesn't run the tests, so run `bin/rspec` yourself
before pushing. CI runs the linters and tests on pull requests and before every deploy from `main`.

[solid_cache]: https://github.com/rails/solid_cache
[solid_queue]: https://github.com/rails/solid_queue
[solid_cable]: https://github.com/rails/solid_cable
[mise]: https://mise.jdx.dev
[bun]: https://bun.sh
[lefthook]: https://github.com/evilmartians/lefthook
[standardruby]: https://github.com/standardrb/standard
[prettier]: https://github.com/prettier/prettier
[oxlint]: https://oxc.rs/docs/guide/usage/linter
[herb]: https://herb-tools.dev
