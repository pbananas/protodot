#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
from argparse import ArgumentParser
from functools import partial
import os

parser = ArgumentParser(description='Serve a web game (godot, gdevelop, etc)')
parser.add_argument('-d','--dir', default=".", help='the directory with the build in it')
parser.add_argument('-p','--port', type=int, default=8888, help='the port to serve on')
args = parser.parse_args()

args.dir = os.path.abspath(os.path.expanduser(args.dir))


class RequestHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, directory=".", **kwargs):
        super().__init__(*args, directory=directory, **kwargs)

    def end_headers(self):
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET,OPTIONS')
        self.send_header('Cache-Control', 'no-store, no-cache, must-revalidate')
        return super(RequestHandler, self).end_headers()

handler = partial(RequestHandler, directory=args.dir)
httpd = HTTPServer(('localhost', args.port), handler)
print(f"Serving {args.dir} at http://localhost:{args.port} ...")
httpd.serve_forever()
