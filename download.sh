#!/bin/bash
#
# These NER datasets are directly 
#reterived from BioBERT (https://github.com/dmis-lab/biobert) via this link (http://nlp.dmis.korea.edu/projects/biobert-2020-checkpoints/datasets.tar.gz) and
#BioRED dataset is publically available at https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/

set -e

# Configure download location
DOWNLOAD_PATH="$BIOBERT_DATA"
if [ "$BIOBERT_DATA" == "" ]; then
    echo "BIOBERT_DATA not set; downloading to the default path ('data')."
    DOWNLOAD_PATH="./data"
fi
DOWNLOAD_PATH_TAR="$DOWNLOAD_PATH.zip"

# Download datasets
wget 'https://drive.usercontent.google.com/download?id=1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0&export=download&authuser=1&confirm=t' -O "$DOWNLOAD_PATH_TAR" && rm -rf /tmp/cookies.txt
jar xvf "$DOWNLOAD_PATH_TAR"
rm "$DOWNLOAD_PATH_TAR"
echo "Bio dataset download done!"
