const express = require("express");
const dotenv = require("dotenv");
const path = require("path");
const connectDB = require("../auth-api/config/db");

dotenv.config({ path: path.resolve(__dirname, "../.env") });

console.log("MONGO_URI:", process.env.MONGO_URI);

const app = express();

connectDB();

app.use(express.json());
app.use("/api/auth", require("../auth-api/routes/auth"));

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log("Server running on port " + PORT));