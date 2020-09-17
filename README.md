# Quick start


## Getting the data
StackExchange publishes its dumps under the creative commons license on [archive.org]*(https://archive.org/download/stackexchange). If you'd like to switch to a different stack exchange dump, please feel free.

```bash
npm install
curl https://ia800107.us.archive.org/27/items/stackexchange/korean.stackexchange.com.7z --output dump.7z
npm run generate dump.7z
```

## Get Sqitch

Sqitch is an independent database migration framework. It has a very git like way of thinking of database changes. It allows
you to rework 

We use [sqitch](https://sqitch.org/) for our migrations. Follow the instructions on sqitch's site to install it for your system. Once you have sqitch you can create a database for the stackexchange api.


## Running migrations

```
$ createdb stackexchange_api
$ cd migrations
$ sqitch deploy -t pg:stackexchange_api
```

This should deploy the migrations and set the database.

## Setting the environment.

We use two environment variables, one for the database connection and the other for identifying the schema.

```
$ export DATABASE_URL=postgres:///stackexchange_api?sslmode=disable
$ export GQL_SCHEMA=stackdump
```

## Running

You can start the postgraphile server with the following.

```
$ npm start
```

Now visit [http://localhost:4000/graphiql] to explore.