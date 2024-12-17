from flask import Flask, request, redirect, url_for, send_from_directory, render_template
import os
import subprocess

app = Flask(__name__, template_folder='templates')
UPLOAD_FOLDER = '/usr/local/nginx/html/uploads'
HLS_FOLDER = '/usr/local/nginx/html/hls'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['HLS_FOLDER'] = HLS_FOLDER

if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

if not os.path.exists(HLS_FOLDER):
    os.makedirs(HLS_FOLDER)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return 'No file part'
    file = request.files['file']
    if file.filename == '':
        return 'No selected file'
    if file:
        filename = file.filename
        file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(file_path)
        # Generate HLS files using ffmpeg
        hls_file_path = os.path.join(app.config['HLS_FOLDER'], 'stream.m3u8')
        subprocess.Popen(['ffmpeg', '-i', file_path, '-codec', 'copy', '-start_number', '0', '-hls_time', '10', '-hls_list_size', '0', '-f', 'hls', hls_file_path])
        return redirect(url_for('index'))

@app.route('/uploads/<filename>')
def uploaded_file(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)

@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
