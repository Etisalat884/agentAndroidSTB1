import sys
sys.path.append('/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/Lib/Python/STB/Etisalat_Android_STB1/Signal')

from Etisalat import etisalat_tv_cmds

etisalat_tv_cmds("RIGHT")
def test_all_ports(button_name="RIGHT"):
    client = RedRatHub.Client()
    client.OpenSocket('192.168.1.24', 40000)

    for port in range(2, 10):  # ports 2 to 9
        cmd = f'ip="192.168.1.143" dataset="Linux_DWI259ETI" signal="{button_name}" output="1:100"'
        print(f"Testing port {port} → {cmd}")
        ret = client.SendMessage(cmd)
        print("Response:", ret)
        time.sleep(2)

    client.CloseSocket()