const express = require('express');
const router = express.Router();

/**
 * app.js　の中の app.use('/', indexRouter); により、index.js　にアクセスされた。
 * そして以下の router.get('/') であるが、これは / 以下のパスを示すものである。
 */
router.get('/', function(req, res, next) {
    res.json({"message" : "OK"});
});

module.exports = router;
