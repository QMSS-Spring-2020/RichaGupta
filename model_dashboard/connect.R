library(reticulate)
conda_list()
conda_install("r-reticulate", "scikit-learn")
conda_install("r-reticulate", "pandas")
use_condaenv("r-reticulate")

# setwd(getwd())
setwd("~/Desktop/Practicum/model_dashboard")


#reticulate::py_load_object('model-dir/model_svc_fit.pkl', pickle = "pickle")

#reticulate::py_run_string("import pickle; import sklearn; pickle.load( open('model-dir/model_svc_fit.pkl', 'rb'))")

reticulate::source_python('predict_narrative.ipynb')
predict_narrative("hey what's up with you")

py_run_file("LinearSVC_mortgage_narratives.py")


reticulate::source_python('sub.py')
sub(10, 2)

source_python('predict_narrative.py')
predict_narrative(new_narrative)

source_python('LinearSVC_mortgage_narratives.py')
LinearSVC_mortgage_narratives("hey what is up")


new_narrative <- "hey what is up"
LinearSVC_mortgage_narratives(new_narrative)
