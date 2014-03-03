jshcm-testing
=============

[js-hcm] testing with mocha and chai

how to run
==========

start with `npm install`

you need to start 2 different redis instances by
```bash
redis-server --port <port number>
```

For example, I use port 6379 for development and 7777 for testing.
However, you can choose any port you like and edit config files in `config/` dir

When you are ready with the environment. Run test by `sh run_tests.sh`