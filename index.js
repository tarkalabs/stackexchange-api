const express = require("express");
const app = express();
const { postgraphile } = require("postgraphile");
require("dotenv").config({path: process.cwd() + '/VARIABLES.env'});

app.use(postgraphile(
  process.env.DB_URL,
  "stackdump",
  {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
    pgDefaultRole: "user_anon",
    jwtSecret: process.env.SECRET_URI,
    jwtPgTypeIdentifier: "stackdump.jwt_token",
  },
));
const postgraphileOptions = {
  retryOnInitFail: true,
};

app.listen(3000, () => {
  console.log("Server Started!");
});
