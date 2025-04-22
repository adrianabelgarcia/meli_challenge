# server.py
from http.server import BaseHTTPRequestHandler, HTTPServer
import json, os

EFS_PATH = '/mnt/efs'

class SimpleAPI(BaseHTTPRequestHandler):
    def _send_response(self, status=200, body=None):
        self.send_response(status)
        self.send_header('Content-type', 'application/json')
        self.end_headers()
        if body:
            self.wfile.write(json.dumps(body).encode())

    def do_POST(self):
        if self.path == '/json':
            content_len = int(self.headers.get('Content-Length'))
            post_data = self.rfile.read(content_len)
            data = json.loads(post_data)

            if 'id' not in data:
                return self._send_response(400, {'error': 'Missing id'})

            file_path = os.path.join(EFS_PATH, f"{data['id']}.json")
            with open(file_path, 'w') as f:
                json.dump(data, f)
            return self._send_response(201, {'message': 'Created'})

        self._send_response(404)

    def do_GET(self):
        if self.path.startswith('/json/'):
            json_id = self.path.split('/')[-1]
            file_path = os.path.join(EFS_PATH, f"{json_id}.json")
            if os.path.exists(file_path):
                with open(file_path, 'r') as f:
                    content = json.load(f)
                return self._send_response(200, content)
            return self._send_response(404, {'error': 'Not found'})
        self._send_response(404)

    def do_PUT(self):
        if self.path.startswith('/json/'):
            json_id = self.path.split('/')[-1]
            file_path = os.path.join(EFS_PATH, f"{json_id}.json")

            if not os.path.exists(file_path):
                return self._send_response(404, {'error': 'Not found'})

            content_len = int(self.headers.get('Content-Length'))
            put_data = self.rfile.read(content_len)
            with open(file_path, 'w') as f:
                f.write(put_data.decode())
            return self._send_response(200, {'message': 'Updated'})

        self._send_response(404)

    def do_DELETE(self):
        if self.path.startswith('/json/'):
            json_id = self.path.split('/')[-1]
            file_path = os.path.join(EFS_PATH, f"{json_id}.json")

            if os.path.exists(file_path):
                os.remove(file_path)
                return self._send_response(200, {'message': 'Deleted'})
            return self._send_response(404, {'error': 'Not found'})
        self._send_response(404)

if __name__ == '__main__':
    os.makedirs(EFS_PATH, exist_ok=True)
    server = HTTPServer(('0.0.0.0', 5000), SimpleAPI)
    print("API corriendo en puerto 5000")
    server.serve_forever()
