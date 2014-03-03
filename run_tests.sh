## export here keeps the variable inside this file scope
export NODE_ENV=testing


mocha --compilers coffee:coffee-script/register --reporter spec -G

## with watch - my best options
#mocha --compilers coffee:coffee-script/register --reporter spec -G -w

## nyan cat reporter - funniest options
#mocha --compilers coffee:coffee-script/register --reporter nyan

## need JSCover (https://github.com/tntim96/JSCover)
#mocha --compilers coffee:coffee-script/register --reporter mocha-lcov-reporter
