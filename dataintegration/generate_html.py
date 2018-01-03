import subprocess


def GenerateHTML():
    rCall = "R CMD ../envisage_viz/combined_clustering_and_html_generation.R"
    rProcess = subprocess.Popen(rCall.split(), stdout=subprocess.PIPE)
    rOutput, rError = rProcess.communicate()

GenerateHTML()
