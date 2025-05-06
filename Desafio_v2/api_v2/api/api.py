from http.server import BaseHTTPRequestHandler, HTTPServer
import json, os

DATA_PATH = "/mnt/data"

class SimpleAPI(BaseHTTPRequestHandler):
    def _send_response(self, status=200, body=None):
        self.send_response(status)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        if body is not None:
            self.wfile.write(json.dumps(body).encode())

    def do_GET(self):
        if self.path == "/": return self._send_response(200, {"status": "ok"})
        if self.path.startswith("/json/"):
            obj_id = self.path.split("/")[-1]
            file_path = os.path.join(DATA_PATH, f"{obj_id}.json")
            if os.path.exists(file_path):
                with open(file_path) as f:
                    return self._send_response(200, json.load(f))
                return self._send_response(404, {"error": "Not found"})
            return self._send_response(404, {"error": "Not found"})

    def do_POST(self):
        if self.path == "/json":
            length = int(self.headers.get("Content-Length", 0))
            data = json.loads(self.rfile.read(length))
            if "id" not in data:
                return self._send_response(400, {"error": "Missing id"})
            with open(os.path.join(DATA_PATH, f"{data['id']}.json"), "w") as f:
                json.dump(data, f)
            return self._send_response(201, {"message": "Created"})
        return self._send_response(404, {"error": "Invalid endpoint"})

    def do_PUT(self):
        if self.path.startswith("/json/"):
            obj_id = self.path.split("/")[-1]
            file_path = os.path.join(DATA_PATH, f"{obj_id}.json")
            length = int(self.headers.get("Content-Length", 0))
            data = json.loads(self.rfile.read(length))
            if os.path.exists(file_path):
                with open(file_path, "w") as f:
                    json.dump(data, f)
                return self._send_response(200, {"message": "Updated"})
            return self._send_response(404, {"error": "Not found"})
        return self._send_response(404, {"error": "Invalid endpoint"})

    def do_DELETE(self):
        if self.path.startswith("/json/"):
            obj_id = self.path.split("/")[-1]
            file_path = os.path.join(DATA_PATH, f"{obj_id}.json")
            if os.path.exists(file_path):
                os.remove(file_path)
                return self._send_response(200, {"message": "Deleted"})
            return self._send_response(404, {"error": "Not found"})
        return self._send_response(404, {"error": "Invalid endpoint"})

if __name__ == "__main__":
    HTTPServer(("0.0.0.0", 5000), SimpleAPI).serve_forever()