const http = require("http");
const express = require("express");

const app = express();
const server = http.createServer(app);

app.all("*", (req, res) => {
  const responseObject = {
    url: req.url,
    headers: req.headers,
  };

  const contentType = req.get("content-type");

  if (contentType && contentType == "application/json") {
    let buffer = "";
    req.setEncoding("utf-8");
    req
      .on("data", (data) => {
        buffer += data;
      })
      .on("end", () => {
        const json_body = JSON.parse(buffer);
        responseObject.body = json_body;
        console.info(responseObject);
        res.sendStatus(200);
      });
  } else {
    res.sendStatus(200);
    console.info(responseObject);
  }
});

server.listen(3000, () => {
  console.log("Server listening on port 3000");
});
