#!/bin/bash
#
# These NER datasets are directly 
#reterived from BioBERT (https://github.com/dmis-lab/biobert) via this link (http://nlp.dmis.korea.edu/projects/biobert-2020-checkpoints/datasets.tar.gz) and
#BioRED dataset is publically available at https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/

gdown https://drive.google.com/uc?id=1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0
unzip datasets.zip
rm -r datasets.zip

echo "Bio dataset download done!"
