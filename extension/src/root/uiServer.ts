const http = require('http');
const fs = require('fs');
const path = require('path');

export class UiServer {
    constructor(directory: string) {
        const server = http.createServer((req: { url: any; }, res: { writeHead: (arg0: number, arg1: { "Content-Type": string; }) => void; end: (arg0: string) => void; }) => {
            // Construct the file path from the request URL
            const filePath = path.join(directory, req.url);

            // Check if the file exists
            fs.stat(filePath, (err: { code: string; }, stat: any) => {
                if (err) {
                    if (err.code === 'ENOENT') {
                        // File not found
                        res.writeHead(404, { 'Content-Type': 'text/plain' });
                        res.end('404 Not Found');
                    } else {
                        // Other errors
                        res.writeHead(500, { 'Content-Type': 'text/plain' });
                        res.end('500 Internal Server Error');
                    }
                } else {
                    // File found, stream it to the response
                    res.writeHead(200, { 'Content-Type': 'text/html' }); // Adjust content type if necessary
                    fs.createReadStream(filePath).pipe(res);
                }
            });
        });

        server.listen(this.port, () => {
            console.log(`!!!! Server running at http://localhost:${this.port}/`);
        });
    }

    public port = "5000";
}
