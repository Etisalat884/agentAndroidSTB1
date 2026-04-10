import os
import http.server
import threading
import json
import requests
import os
from datetime import datetime
import pathlib
import socketserver
import subprocess


class SendReport:
    def __init__(self, trigger_id, agent_id):
        self.trigger_id = trigger_id
        self.agent_id = agent_id
# /home/ltts/Documents/evqual_automation/agentLinuxSTB2/workspace/Etisalat_Linux_STB2/Report/log-20250605-154136.xml
    def syncReports(self):
        file_Path = '/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/STB07_DWI259S'
        path = file_Path + "/Report/"
        print("this path",path)
        files = [path + i for i in os.listdir(path) if os.path.isfile(os.path.join(path, i)) and i.endswith(".html")]

        print("this whole fles path ", files)
        max_file = max(files, key=os.path.getctime)
        latest_file = os.path.basename(max_file)

        # Removed link_addr and S3 upload section

        print(latest_file)
        self.latest_file = latest_file

    def syncLogs(self):
        file_Path = '/home/ltts2/Documents/evqual_automation/agentLinuxSTB2/workspace'
        project_dir = file_Path
        folder_name = os.path.basename(project_dir)
        path = file_Path + "/Logs/"
        files = [path + i for i in os.listdir(path) if os.path.isfile(os.path.join(path, i)) and i.endswith(".txt")]
        print(files)
        max_file = max(files, key=os.path.getctime)
        filename = "STB_Logs"
        latest_file = os.path.basename(max_file)

    def Post_Result(self, addr):
        print("JS,", addr)
        url = "http://192.168.1.58:5000/update_data_dashboard?key="
        data1 = json.dumps({"trigger_id": self.trigger_id, "agent_id": self.agent_id})
        print("this data1", data1)
        data2 = json.dumps(addr)
        print(type(data2))
        print("this data2", data2)
        x = requests.post(url + data1 + "&attribute=" + data2)
        print("this is data", url + data1 + "&attribute=" + data2)
        return x

    def Post_Logs(self, addr):
        print("JS,", addr)
        url = "http://192.168.1.58:5000/update_data_dashboard?key="
        data1 = json.dumps({"trigger_id": self.trigger_id, "agent_id": self.agent_id})
        data2 = json.dumps(addr)
        # print(type(data), "jsondata")
        x = requests.post(url + data1 + "&attribute=" + data2)
        print("this is url", url + data1 + "&attribute=" + data2)
        return x

    # def access_html_file(self, html_file_path):
    #     PORT = 8083  # Change port number if needed
    #     # Handler = http.server.SimpleHTTPRequestHandler
    #     # Function to access a specific HTML file
    #     # Change directory to where the HTML file is located
    #     os.chdir(os.path.dirname(os.path.abspath(html_file_path)))

    #     # Extract the file name from the path
    #     file_name = os.path.basename(html_file_path)
    #     # Print the HTTP link to access the HTML file

    #     http_link = f"http://192.168.1.46:{PORT}/workspace/STB07_DWI259S/Report/{file_name}"
    #     print(f"Access your HTML file at: {http_link}")
    #     return http_link


    def access_html_file(self, html_file_path):
        PORT = 8084

        # Extract file name only
        file_name = os.path.basename(html_file_path)
        print("file name",file_name)

        # Use your known IP
        http_link = f"http://192.168.1.46:8084/{file_name}"

        print(f"Access your HTML file at: {http_link}")
        return http_link

    def access_logs_file(self, file_log_url):
        PORT = 8083  # Change port number if needed
        # Handler = http.server.SimpleHTTPRequestHandler
        # Function to access a specific HTML file
        # Change directory to where the HTML file is located
        os.chdir(os.path.dirname(os.path.abspath(file_log_url)))

        # Extract the file name from the path
        file_logs_name = os.path.basename(file_log_url)

        # Print the HTTP link to access the HTML file    /home/ltts/Documents/evqual_automation/agentLinuxSTB2/workspace/Reports

        # http_log_link = f"http://192.168.1.46:{PORT}/workspace/Record/Linux_KSTB6080_STB1/OutputRecordings/{file_logs_name}"
        http_log_link = f"http://192.168.1.46:{PORT}/{file_logs_name}"
        print(f"Access your HTML file at: {http_log_link}")
        return http_log_link

    # Example usage:
    def SendRP(self):

        self.syncReports()
        file_name = self.latest_file
        directory_path = r'/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/STB07_DWI259S/Report'
        html_file_path = f"{directory_path}/{file_name}"
        print("report path",html_file_path)
        html_report_file_path = self.access_html_file(html_file_path)
        print("this is whole report",html_report_file_path)
        statusres = {"trigger_id": self.trigger_id, "agent_id": self.agent_id, "exec_reports": html_report_file_path}
        self.Post_Result(statusres)
        directory_log_path = r"/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Record/STB07_DWI259S/OutputRecordings"
        files = [os.path.join(directory_log_path, f) for f in os.listdir(directory_log_path) if
                 os.path.isfile(os.path.join(directory_log_path, f))]

        # Find the most re[]cently created file
        max_file = max(files, key=os.path.getctime)
        print("this max_file:", max_file)
        latest_file = os.path.basename(max_file)
        file_log_url = os.path.join(directory_log_path, latest_file)
        print("this log file path", file_log_url)
        print("line 120")
        http_log_link = self.access_logs_file(file_log_url)
        statuslogs = {"trigger_id": self.trigger_id, "agent_id": self.agent_id, "dev_logs": http_log_link}
        print("this is statuslogs:", statuslogs)
        self.Post_Logs(statuslogs)

        # self.syncLogs()
        # directory_log_path = r'/Users/azeemkhan/Documents/evqual_automation/agent15dut1/workspace/Logs/iPhone/iPhone_14'
        # files = [os.path.join(directory_log_path, f) for f in os.listdir(directory_log_path) if
        #          os.path.isfile(os.path.join(directory_log_path, f))]

        # Find the most recently created file
        # max_file = max(files, key=os.path.getctime)
        # print("this max_file:", max_file)
        # latest_file = os.path.basename(max_file)
        # file_log_url = os.path.join(directory_log_path, latest_file)
        # print("this log file path", file_log_url)
        # http_log_link = self.access_logs_file(file_log_url)
        # statuslogs = {"trsigger_id": self.trigger_id, "agent_id": self.agent_id, "dev_logs": http_log_link}
        # print("this is statuslogs:", statuslogs)
        # self.Post_Logs(statuslogs)
        return statusres

# O = SendReport('12345', 'agent15dut1')
# O.SendRP()

