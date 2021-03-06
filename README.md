# Welcome to CouchTweet

CouchTweet is an example Rails web application that makes learning about [Apache CouchDB](https://couchdb.apache.org/) and the [CouchRest Model](https://github.com/couchrest/couchrest_model) gem easier.  It uses Twitter's data model and website as a template.  Because CouchDB is a distributed key/value database, CouchTweet can scale across many servers or run on just a single laptop.  We can use [CouchProxy](http://www.lousymedia.com/couchproxy/) to build a cluster of CouchTweet nodes for high traffic load tests.

## Getting Started

```
$ script/bootstrap
$ script/server
$ open http://localhost:3000
```

Then sign in with user1 and 'user1 password'.

## Dependencies

* couchdb >= 1.2.0
* redis >= 2.4.0
* ruby >= 1.9.3

## Contact

Project contact: David Graham <david.malcom.graham@gmail.com>

I'll do my best to answer any questions!

## License

CouchTweet is released under the MIT license.  Check the LICENSE file for details.
