current_dir=$PWD
cd /home/ubuntu/WindLabs2D
python3 update_data.py
Rscript combined_clustering_and_html_generation.R
cp WindDashBoard.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/WindDashboard.html
cd $current_dir