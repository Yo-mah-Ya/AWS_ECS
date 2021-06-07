const express = require('express');
const router = express.Router();

router.get('/', function(req, res, next) {
    res.json({"message" : "Health Check OK"});
});

module.exports = router;
