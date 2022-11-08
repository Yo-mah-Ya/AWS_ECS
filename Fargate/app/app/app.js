const express = require("express");

const indexRouter = require("./routes/index");
const healthcheckRouter = require("./routes/healthcheck");

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/", indexRouter);
app.use("/healthcheck", healthcheckRouter);

app.use(function (req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header(
        "Access-Control-Allow-Headers",
        "Origin, X-Requested-With, Content-Type, Accept"
    );
    next();
});

app.listen(3000);
module.exports = app;
