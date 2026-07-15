// 개발 미리보기용 정적 서버 (의존성 없음)
const http = require("http");
const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname, "www");
const PORT = 8123;
const MIME = {
  ".html": "text/html; charset=utf-8",
  ".js": "application/javascript; charset=utf-8",
  ".css": "text/css; charset=utf-8",
  ".png": "image/png",
  ".json": "application/json; charset=utf-8"
};

http.createServer((req, res) => {
  const urlPath = decodeURIComponent(req.url.split("?")[0]);
  let file = path.join(ROOT, urlPath === "/" ? "index.html" : urlPath);
  if (!file.startsWith(ROOT)) { res.writeHead(403); res.end(); return; }
  fs.readFile(file, (err, data) => {
    if (err) { res.writeHead(404); res.end("Not found"); return; }
    res.writeHead(200, { "Content-Type": MIME[path.extname(file)] || "application/octet-stream" });
    res.end(data);
  });
}).listen(PORT, () => console.log("serving www on http://localhost:" + PORT));
