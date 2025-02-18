const keys = require("./keys");

// Express Application setup
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express(); // Define the app before using it
app.use(cors());
app.use(bodyParser.json());

// Postgres client setup
const { Pool } = require("pg");
const pgClient = new Pool({
  user: keys.pgUser,
  host: keys.pgHost,
  database: keys.pgDatabase,
  password: keys.pgPassword,
  port: keys.pgPort
});

pgClient.on("connect", client => {
  client
    .query("CREATE TABLE IF NOT EXISTS values (number INT)")
    .catch(err => console.log("PG ERROR", err));
});

// Express route definitions
app.get("/", (req, res) => {
  res.send("Hi");
});

// get the values
app.get("/api/values/all", async (req, res) => {
  try {
    const values = await pgClient.query("SELECT * FROM values");
    res.send(values.rows); // Send only rows to match frontend expectations
  } catch (err) {
    console.error("Error fetching values:", err);
    res.status(500).send("Error fetching values");
  }
});

// POST to insert a value
app.post("/api/values", async (req, res) => {
  try {
    if (!req.body.value) {
      return res.status(400).send({ working: false });
    }

    await pgClient.query("INSERT INTO values(number) VALUES($1)", [req.body.value]);
    res.send({ working: true });
  } catch (err) {
    console.error("Error inserting value:", err);
    res.status(500).send("Error inserting value");
  }
});

// Start the server
app.listen(5000, () => {
  console.log("Listening on port 5000");
});

