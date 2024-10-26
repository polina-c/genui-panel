const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require("url");

export class UiServer {
    constructor(directory: string) {
        http.createServer(function (request: { url: any; }, response: { writeHead: (arg0: number, arg1: { "Content-Type": string; } | undefined) => void; write: (arg0: string, arg1: string | undefined) => void; end: () => void; }) {

            var uri = url.parse(request.url).pathname
                , filename = path.join(process.cwd(), uri);

            path.exists(filename, function (exists: any) {
                if (!exists) {
                    response.writeHead(404, { "Content-Type": "text/plain" });
                    response.write("404 Not Found\n", undefined);
                    response.end();
                    return;
                }

                if (fs.statSync(filename).isDirectory()) filename += '/index.html';

                fs.readFile(filename, "binary", function (err: string, file: any) {
                    if (err) {
                        response.writeHead(500, { "Content-Type": "text/plain" });
                        response.write(err + "\n", undefined);
                        response.end();
                        return;
                    }

                    response.writeHead(200, undefined);
                    response.write(file, "binary");
                    response.end();
                });
            });
        }).listen(parseInt(this.port, 10));

        console.log("!!! Static file server running at\n  => http://localhost:" + this.port + "/\nCTRL + C to shutdown");
    }

    public port = "8888";
}
