#!/bin/bash
#
# These NER datasets are directly 
#reterived from BioBERT (https://github.com/dmis-lab/biobert) via this link (http://nlp.dmis.korea.edu/projects/biobert-2020-checkpoints/datasets.tar.gz) and
#BioRED dataset is publically available at https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/

set -e

# Configure download location
DOWNLOAD_PATH="$BIOBERT_DATA"
if [ "$BIOBERT_DATA" == "" ]; then
    echo "BIOBERT_DATA not set; downloading to default path ('data')."
    DOWNLOAD_PATH="./data"
fi
DOWNLOAD_PATH_TAR="$DOWNLOAD_PATH.zip"

# Download datasets
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0" -O "$DOWNLOAD_PATH_TAR" && rm -rf /tmp/cookies.txt
jar xvf "$DOWNLOAD_PATH_TAR"
rm "$DOWNLOAD_PATH_TAR"
echo "Bio dataset download done!"
