current_dir=$PWD
cd /home/ubuntu/WindLabs3D
python3 update_data.py
Rscript combined_clustering_and_html_generation.R
cp WindDashboard3D.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/WindDashboard3D.html
cd $current_dir
