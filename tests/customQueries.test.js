const pg = require("pg");
const crypto = require("crypto");
require("dotenv").config();
let client,
  username = `${crypto.randomBytes(7).toString("hex")}@${crypto
    .randomBytes(4)
    .toString("hex")}.com`,
  password = crypto.randomBytes(7).toString("hex");
beforeAll(async () => {
  client = new pg.Client({
    connectionString: process.env.DB_URL,
  });
  try {
    await client.connect();
    await client.query("BEGIN;");
  } catch (e) {
    console.log(e);
  }
});

describe("Testing Custom Queries", function () {
  it("Check register user", async () => {
    await client.query("SELECT stackdump.register_user($1, $2)", [
      username,
      password,
    ]);
    let res = await client.query(
      "SELECT * FROM stackdump_private.accounts WHERE username = $1",
      [username]
    );
    expect(res.rows[0].register_user).not.toEqual(null);
  });

  it("Check authentication", async () => {
    let res = await client.query("SELECT stackdump.authenticate($1,$2)", [
      username,
      password,
    ]);
    expect(res.rows[0].authenticate).not.toEqual(null);
  });
});

afterAll(async () => {
  try {
    await client.query("ROLLBACK;");
    client.end();
  } catch (e) {
    console.log(e);
  }
});
