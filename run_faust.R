# install.packages("ggdendro")
# install.packages("knitr")

# Load required libraries
suppressPackageStartupMessages({
    library(configr)            # NOT Required for Faust - Helps with user configurations
    library(flowWorkspaceData)  # Required for Faust
    library(flowWorkspace)      # Required for Faust
    # library(ggdendro)         # NOT Required for Faust
    library(scamp)              # Required for FAUST
    library(ggplot2)            # Required for FAUST
    library(cowplot)            # Required for FAUST
    # library(knitr)            # NOT Required for FAUST
    library(dplyr)              # Required for FAUST
    library(tidyr)              # Required for FAUST
    library(faust)              # Required for FAUST
})

# Install and load user configurations
user_configurations_file_path <- file.path("/opt", "faust", "faust_configurations.yaml")
user_configurations <- read.config(file=user_configurations_file_path)

if ((!"annotations_approved" %in% names(user_configurations))
    || user_configurations$annotations_approved == "PLEASE_CHANGE_ME") {
    stop("The user MUST provide an explicit value in `faust_configurations.yaml` for the setting `annotations_approved`")
}
if ((!"depth_score_threshold" %in% names(user_configurations))
    || user_configurations$depth_score_threshold == "PLEASE_CHANGE_ME") {
    stop("The user MUST provide an explicit value in `faust_configurations.yaml` for the setting `depth_score_threshold`")
}
if ((!"experimental_unit" %in% names(user_configurations))
    || user_configurations$experimental_unit == "PLEASE_CHANGE_ME") {
    stop("The user MUST provide an explicit value in `faust_configurations.yaml` for the setting `experimental_unit`")
}
if ((!"selection_quantile" %in% names(user_configurations))
    || user_configurations$selection_quantile == "PLEASE_CHANGE_ME") {
    stop("The user MUST provide an explicit value in `faust_configurations.yaml` for the setting `selection_quantile`")
}
if ((!"starting_node" %in% names(user_configurations))
    || user_configurations$starting_node == "PLEASE_CHANGE_ME") {
    stop("The user MUST provide an explicit value in `faust_configurations.yaml` for the setting `starting_node`")
}

# Load data sets into gating set
directories <- list.dirs(path=file.path("/opt", "faust", "input_files"), full.names=TRUE, recursive=FALSE)
if (lengths(directories) != 1) {
    stop("Only one workspace can be provided for FAUST execution. Please make sure that the `input_files` directory contains only one workspace directory and try running FAUST again.")
}
dataset_file_path <- directories[1]

gating_set <- load_gs(dataset_file_path)

# ???
active_channels_in <- markernames(gating_set)[-1L]

# Select the channel boundaries
channel_bounds_in <- matrix(0, nrow=2, ncol=length(active_channels_in))
colnames(channel_bounds_in) <- active_channels_in
rownames(channel_bounds_in) <- c("Low","High")
channel_bounds_in["High",] <- 3500

# Set the FAUST project path for execution
faust_processing_directory <- file.path("/opt", "faust", "output_files")
dir.create(faust_processing_directory, recursive = TRUE)

print("=======================================================================")
print("Beginning FAUST execution - This may take awhile!")
print("=======================================================================")
# Perform FAUST Analysis with a revised depth score
faust(
    gatingSet = gating_set,
    experimentalUnit = user_configurations$experimental_unit,
    activeChannels = active_channels_in,
    channelBounds = channel_bounds_in,
    startingCellPop = user_configurations$starting_node,
    projectPath = faust_processing_directory,
    depthScoreThreshold = user_configurations$depth_score_threshold,
    selectionQuantile = user_configurations$selection_quantile,
    debugFlag = FALSE,
    #set this to the number of threads you want to use on your system
    threadNum = parallel::detectCores() / 2 - 1,
    seedValue = 271828,
    annotationsApproved = user_configurations$annotations_approved
)
