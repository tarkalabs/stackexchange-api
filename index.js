const express = require("express");
const app = express();
const { postgraphile } = require("postgraphile");
const PgSimplifyInflectorPlugin = require("@graphile-contrib/pg-simplify-inflector");
const plugin = require("./plugins/schemaWrapper");
const { initilaize } = require("./gql-plugins/mailer");
require("dotenv").config();
initilaize();
app.use(
  postgraphile(process.env.DB_URL, process.env.GQL_SCHEMA, {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
    pgDefaultRole: "user_anon",
    jwtSecret: process.env.JWT_SECRET,
    jwtPgTypeIdentifier: "stackdump.jwt_token",
    handleErrors: (e) => {
      console.log(e);
    },
    appendPlugins: [PgSimplifyInflectorPlugin, plugin],
  })
);
const postgraphileOptions = {
  retryOnInitFail: true,
};

app.listen(3000, () => {
  console.log("Server Started!");
});
