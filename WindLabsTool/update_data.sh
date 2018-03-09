current_dir=$PWD
cd /home/ubuntu/WindLabsTool
Rscript training_data_generation.R
nodejs generate_ann.js
Rscript html_generation.R
cp WindDashboardTool.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/WindDashboardTool.html
cd $current_dir