web: bundle exec rackup -o 0.0.0.0 -p $PORT
js: ./node_modules/.bin/watchify assets/javascripts/megatron/index.js --debug -t babelify -o public/assets/megatron/megatron-`bundle exec ruby -e 'puts Gem.loaded_specs["megatron"].version'`.js -v
css: rake sass_watch
