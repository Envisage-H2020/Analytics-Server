current_dir=$PWD
cd /home/envisage/WindLabs3D
python3 update_data.py
Rscript combined_clustering_and_html_generation.R
Rscript chemistry_combined_clustering_and_html_generation.R
cp WindDashboard3D.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/WindDashboard3D.html
cp ChemistryDashboard.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/ChemistryDashboard.html
cp ChemistryToolDashboard.html /var/www/envisageanalytics/envisageanalytics/static/dashboardtest/ChemistryToolDashboard.html
cd $current_dir
