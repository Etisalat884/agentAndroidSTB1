def send_zap_command(channel_id):
    import requests, time
    payload = {'command': 'zap', 'channel': channel_id}
    start = time.time()
    response = requests.post('http://192.168.1.57:3005/apple_tv_cmds_2', data=payload)
    end = time.time()
    return {
        'status': response.status_code,
        'elapsed': round(end - start, 3),
        'response': response.text
    }