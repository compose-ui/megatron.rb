# Megatron

This is the repository for the {RubyGem Megatron}[https://rubygems.org/gems/megatron], a
UI framework for providing consistent styles across multiple applications.

Documentation for using the gem can be found at: https://megatron-docs.compose.io

## Setup

This package has both rubygems and node package manager dependencies. To install:

  npm install
  bundle install

## Local Development

Typically, when you work on Megatron, you want to see the outcome in another
Rails application, like `web`. Here is the workflow you can use to accomplish
this engineering feat:

- Check out Megatron locally
- Complete the "Setup" portion of this document
- Export `MEGATRON_PATH`, pointing to the checkout (`web` looks for this environment variable)
- Within a shell session that has the `MEGATRON_PATH` variable set, in your `web` checkout, run `bundle update megatron`
- Bundler should install a link to your local version of Megatron
- After you make changes in Megatron, run `bundle exec cyborg build -j` (without `-j` if first time) to build assets
- Alternatively, run `bundle exec cyborg watch -j` to watch for changes and rebuild assets automatically
- New JS and CSS assets should load in `web` on a page refresh

NOTE: Remember to update the version (`lib/megatron/version.rb`) when you make changes.

## Releasing

Megatron is released to RubyGems automatically with a CI build after you merge a
branch to master. See the `.buildkit/build.sh` file for details. At the time of
writing, when the `megatron-docs/web` job completes successfully, the new gem is
available to install.

## License

This project rocks and uses MIT-LICENSE.
