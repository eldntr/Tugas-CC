Penjelasan Struktur Direktori:
app/: Direktori untuk aplikasi web Flask.

app.py: File utama aplikasi Flask.
templates/: Direktori untuk template HTML.
index.html: Template HTML untuk menampilkan data cuaca.
db/: Direktori untuk service database MySQL.

run_mysql.sh: Script untuk menjalankan container MySQL.
dbdata/: Direktori untuk menyimpan data MySQL (akan di-mount ke container).
scripts/: Direktori untuk script pengumpulan data cuaca.

getweather.sh: Script untuk mengambil data cuaca dari API Weatherbit dan menyimpannya ke database MySQL.
Dockerfile: Dockerfile untuk membangun image pengumpulan data cuaca.
web/: Direktori untuk service aplikasi web.

run_webapp.sh: Script untuk menjalankan aplikasi web Flask.
run_weather_collector.sh: Script untuk menjalankan service pengumpulan data cuaca.

README.md: File dokumentasi proyek.