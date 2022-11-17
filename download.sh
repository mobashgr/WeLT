#!/bin/bash
#
# These NER datasets are directly 
#reterived from BioBERT (https://github.com/dmis-lab/biobert) via this link (https://drive.google.com/file/d/1cGqvAm9IZ_86C4Mj7Zf-w9CFilYVDl8j/view) and
#BioRED dataset is publically avaliable in https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/

gdown https://drive.google.com/uc?id=1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0
unzip datasets.zip
rm -r datasets.zip

echo "Bio dataset download done!"
