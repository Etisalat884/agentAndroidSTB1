# import os
# import http.server
# import socketserver
# import threading

# def start_http_server():
#         PORT = 8083  # Change port number if needed
#         Handler = http.server.SimpleHTTPRequestHandler
#         # Function to start the HTTP server
#         with socketserver.TCPServer(("", PORT), Handler) as httpd:
#             print(f"HTTP server running at http://192.168.1.46:{PORT}/")
#             httpd.serve_forever()

# server_thread = threading.Thread(target=start_http_server)
# server_thread.start()


import os
import http.server
import socketserver
import threading
class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type')
        super().end_headers()
def start_http_server():
    PORT = 8083  # Change port number if needed
    Handler = CORSRequestHandler
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"HTTP server running at http://192.168.1.46:{PORT}/")
        httpd.serve_forever()
server_thread = threading.Thread(target=start_http_server)
server_thread.start()

# import http.server
# import socketserver
# import threading

# # Custom handler with CORS and fixed directory
# class CORSRequestHandler(http.server.SimpleHTTPRequestHandler):
#     def __init__(self, *args, directory=None, **kwargs):
#         super().__init__(*args, directory=directory, **kwargs)

#     def end_headers(self):
#         self.send_header("Access-Control-Allow-Origin", "*")
#         self.send_header("Access-Control-Allow-Methods", "GET, OPTIONS")
#         self.send_header("Access-Control-Allow-Headers", "X-Requested-With, Content-Type")
#         super().end_headers()

# def start_http_server():
#     PORT = 8083
#     DIRECTORY = "/home/user/workspace"   # 👈 change this to your actual workspace path

#     handler = lambda *args, **kwargs: CORSRequestHandler(*args, directory=DIRECTORY, **kwargs)

#     with socketserver.TCPServer(("", PORT), handler) as httpd:
#         print(f"HTTP server running at http://192.168.1.46:{PORT}/")
#         httpd.serve_forever()

# server_thread = threading.Thread(target=start_http_server)
# server_thread.start()
