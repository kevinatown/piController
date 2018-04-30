#!/usr/bin/env python

from gopigo import *
import os
import shutil
from flask import Flask, send_from_directory, jsonify

app = Flask(__name__, static_folder='/piController/piController/pi-frontend/build')

@app.route("/")
def root():
  return send_from_directory('/piController/piController/pi-frontend/build/','index.html')

@app.route("/static/<path:path>")
def static_files(path):
  return send_from_directory('/piController/piController/pi-frontend/build/static/', path)

@app.route('/move/<int:num>')
def show_post(num):
  try:
    if num == 1:
      fwd() # Move forward
    elif num == 2:
      left()  # Turn left
    elif num == 3:
      right() # Turn Right
    elif num == 4:
      bwd() # Move back
    elif num == 5:
      stop()  # Stop
    elif num == 6:
      increase_speed()  # Increase speed
    elif num == 7:
      decrease_speed()  # Decrease speed
    else:
      return jsonify(success=False)
    return jsonify(success=True)
  except:
    return jsonify(success=False)

@app.route('/config/', methods=['POST'])
def setConfigs():
  conftype = request.args.get('conf')
  if (conftype == 'wifi'):
    ssid = request.args.get('ssid')
    pw = request.args.get('pw')
    cmd = 'wpa_passphrase %s %s | sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null' % (ssid, pw)
    os.system(cmd)
    f = open('/continue.conf', 'w')
    f.write('wifi')
    f.close()
    shutil.copy('/piController/configs/interfaces.wifi', '/etc/network/interfaces')
  elif (conftype == 'hotspot'):
    f = open('/continue.conf', 'w')
    f.write('wifi')
    f.close()
    shutil.copy('/piController/configs/interfaces.hotspot', '/etc/network/interfaces')
  else:
    return jsonify(success=False)

@app.route('/halt/')
def haltPi():
  os.system('sudo shutdown -r now')
      

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=80)
  