# ActsAsBayes

TODO: Bayes Classification added to your model

Status: unstable but under development

Travis:
[![Build Status](https://secure.travis-ci.org/vpereira/acts_as_bayes.png)](http://travis-ci.org/vpereira/acts_as_bayes)

## Installation

Add this line to your application's Gemfile:

    gem 'acts_as_bayes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install acts_as_bayes

## Usage

In your Model, add it:

     class Foo
       include Mongoid::Document
       include ActsAsBayes
       
       field :title, :type=>String, :default=>""
       acts_as_bayes :on=>:title
     end

Now as soon as you update a document, we calculate the frequency of
words and then Lorem ipsum dolor sit amet, consectetur clamat pars.
Remota et neque ingeniis ipsas. Collegerunt octo summum et invidiosum.
Beate ut viderent defensionis procul modo propositum autem, quosdam,
animadverti insitam modo beate seditiose nec. 

     Foo.create!(:title=>"wow, that is sexy, right?)
     Foo.last.words => [:wow=>1, :sex=>1, :right=>1]

There is a class named BayesCategory. It will be populated
automatically. Maybe it would be better to populate it before with train
data

## TODO

* write more tests
* write a test app using it
* maybe find a way to use a custom categories model

## Contributing

It is unstable. but it works. I'm using it. You can use it as well. 
Please i would like to see more pull requests than tickets. You are a
developer, you can ruby and you need this gem. So, please help us to
help you :-) 

 
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
