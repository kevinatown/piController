from gopigo import *
import os
from flask import Flask, send_from_directory, jsonify

app = Flask(__name__, static_folder='./build')

@app.route("/")
def root():
  return send_from_directory('./pi-frontend/build/','index.html')

@app.route("/static/<path:path>")
def static_files(path):
  return send_from_directory('./pi-frontend/build/static/', path)

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

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=8090)
  