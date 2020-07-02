const express = require("express");
const app = express();
const { postgraphile } = require("postgraphile");
require("dotenv").config();

app.use(postgraphile(
  process.env.DB_URL || "postgres:///sqitch_test",
  "stackdump",
  {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
  },
));
const postgraphileOptions = {
  retryOnInitFail: true,
};

app.listen(3000, () => {
  console.log("Server Started!");
});
