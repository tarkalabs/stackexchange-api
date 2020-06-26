const express = require("express");
const app = express();
const { postgraphile } = require("postgraphile");
require("dotenv").config();

app.use(postgraphile(
  process.env.DB_URL,
  "stackdump",
  {
    watchPg: true,
    graphiql: true,
    enhanceGraphiql: true,
  },
));

app.listen(3000, () => {
  console.log("Server Started!");
});
