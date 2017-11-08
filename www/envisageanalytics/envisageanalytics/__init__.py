import logging
from logging.handlers import RotatingFileHandler
from flask import Flask, request, redirect, url_for, send_from_directory

app = Flask(__name__, static_url_path='/var/www/envisageanalytics/envisageanalytics/')

@app.route("/")
def root():
    getParams = request.args
    app.logger.info('Got parameters from GET', getParams)
    print('Got parameters from GET', getParams)
    outputAddress = 'dashboardtest/WindDashboard.html'
    if 'lab' in getParams:
        labType = getParams['lab']
        if labType == 'energy':
            outputAddress = 'dashboardtest/WindDashboard.html'
        if labType == 'chemistry':
            outputAddress = 'dashboardtest/ChemistryDashboard.html'
        if labType == 'taskgenerator':
            outputAddress = 'dashboardtest/task_generator.html'
    return app.send_static_file(outputAddress)

@app.route('/<path:path>')
def static_proxy(path):
    getParams = request.args
    app.logger.info('Got parameters from GET', getParams)
  # send_static_file will guess the correct MIME type
    return app.send_static_file(path)

############### END WSGI WRAPPER ##############

if __name__ == "__main__":
    # handler = RotatingFileHandler('envisageFlask.log', maxBytes=10000, backupCount=1)
    # handler.setLevel(logging.INFO)
    # app.logger.addHandler(handler)
    app.run()
