# WeLT: Improving Biomedical Fine-tuned Pre-trained Language Models with Cost-sensitive Learning
Authors: Ghadeer Mobasher*, Olga Krebs, Wolfgang Müller, and Michael Gertz 

[For transperancy, all the :hugs: models are publicaly avaliable as a result of our expiremental work on HuggingFaceHub](https://huggingface.co/mobashgr)

Biomedical pre-trained language models (BioPLMs) have been achieving state-of-the-art results for various biomedical text mining tasks. However, prevailing fine-tuning approaches naively train BioPLMs on targeted datasets without considering the class distributions. This is problematic, especially with dealing with imbalanced biomedical gold-standard datasets for named entity recognition (NER). Regardless of the high-performing SOTA fine-tuned NER models, they are biased towards other (O) tags and misclassify biomedical entities. To fill the gap, we propose WELT, a cost-sensitive BERT that handles the class imbalance for the task of biomedical NER. We investigate the impact of WELT against the traditional fine-tuning approaches on mixed-domain and domain-specific BioPLMs. We evaluated WELT againest other weighting schemes such as Inverse of Number of Samples (INS), Inverse of Square Root of Number of Samples (ISNS) and Effective Number of Samples (ENS). Our results show the outperformance of WELT on 4 different types of Biomedical BERT models and BioELECTRA using 8 gold-standard datasets.

## Installation 
**Dependencies**
-	Python (>=3.6)
-	Pytorch (>=1.2.0) 
1.	Clone this GitHub repository: `git clone https://github.com/mobashgr/WELT.git`
2.	Navigate to the WELT folder and install all necessary dependencies: `python3 -m pip install -r requirements.txt` \
Note: To install appropriate torch, follow the [download instructions](https://pytorch.org/) based on your development environment.
## Data Preparation
**NER Datasets**
| Dataset 	| Source 	|
|---	|---	|
| <ul><li>NCBI-disease</li> <li>BC5CDR-disease</li>  <li>BC5CDR-chem</li>  <li>BC4CHEMD</li>  <li>JNLPBA</li>  <li>BC2GM</li> <li>linnaeus</li> <li>s800</li></ul> 	| NER datasets are directly reterived from [BioBERT](https://github.com/dmis-lab/biobert) via this [link](https://drive.google.com/file/d/1cGqvAm9IZ_86C4Mj7Zf-w9CFilYVDl8j/view) 	|
| <ul><li>BioRED-Dis</li>  <li>BioRED-Chem</li></ul> 	| We have extended the prementioned NER datastes to include [BioRED](https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/). To convert from  `BioC XML / JSON` to `conll`, we used [bconv](https://github.com/lfurrer/bconv) and filtered the chemical and disease entities. 	|

**Data Download** \
To directly download NER datasets, use `download.sh` or manually download them via this [link](https://drive.google.com/file/d/1nHH3UYpQImQhBTei5HiTcAAFBvsfaBw0/view) in `WELT` directory, `unzip datasets.zip` and `rm -r datasets.zip`

**Data Pre-processing** \
We adapted the `preprocessing.sh` from [BioBERT](https://github.com/dmis-lab/biobert) to include [BioRED](https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/)

## Fine-tuning with handling the class imbalance
We have conducted expirements on different BERT models using WELT weighting scheme. We have compared WELT againest other existing weighting schemes and the corresponding traditional fine-tuning approaches(i.e normal BioBERT fine-tuning)

**Fine-tuning BERT Models**
| Model 	| Used version in HF :hugs: |
|---	|---	|
|BioBERT| [model_name_or_path](https://huggingface.co/dmis-lab/biobert-v1.1)|
|BlueBERT| [model_name_or_path](https://huggingface.co/bionlp/bluebert_pubmed_uncased_L-12_H-768_A-12)|
|PubMedBERT| [model_name_or_path](https://huggingface.co/microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract)|
|SciBERT| [model_name_or_path](https://huggingface.co/allenai/scibert_scivocab_uncased)|
|BioELECTRA| [model_name_or_path](https://huggingface.co/kamalkraj/bioelectra-base-discriminator-pubmed)|

**Weighting Schemes** 
|Name 
|---	|
|Inverse of Number of Samples (INS)|
|Inverse of Square Root of Number of Samples (ISNS)|
|Effective Number of Samples (ENS)|
|Weighted Loss Trainer (WeLT) (Ours)|

**Cost-Sensitive Fine-Tuning**

We have adapted [BioBERT-run_ner.py](https://github.com/dmis-lab/biobert-pytorch/blob/master/named-entity-recognition/run_ner.py) to develop in [run_weight_scheme.py](https://github.com/mobashgr/WeLT/blob/main/named-entity-recognition/run_weight_scheme.py) that extends `Trainer` class to [`WeightedLossTrainer`](https://github.com/mobashgr/WeLT/blob/b1118057a0314ceeb3aa198a0fbf57e610fb9795/named-entity-recognition/run_weight_scheme.py#L93-L102) and override `compute_loss` function to include [`INS, ISNS, ENS and WELT`](https://github.com/mobashgr/WeLT/blob/b1118057a0314ceeb3aa198a0fbf57e610fb9795/named-entity-recognition/run_weight_scheme.py#L130-L167) in [`weighted Cross-Entropy loss` function].

**Evaluation** \
For fair comparison we have used the same NER evaluation approach of [BioBERT](https://github.com/dmis-lab/biobert)

**Usage Example** \
This is an example for fine-tuning `BioRED-Chem` over `SciBERT` using `ENS` weight scheme with $\beta$ of 0.3
```bash
cd named-entity-recognition
./preprocess.sh

export SAVE_DIR=./output
export DATA_DIR=../datasets/NER

export MAX_LENGTH=384
export BATCH_SIZE=5
export NUM_EPOCHS=20
export SAVE_STEPS=1000
export ENTITY=BioRED-Chem
export SEED=1

python run_weight_scheme.py \
    --data_dir ${DATA_DIR}/${ENTITY}/ \
    --labels ${DATA_DIR}/${ENTITY}/labels.txt \
    --model_name_or_path allenai/scibert_scivocab_uncased \
   --output_dir ${ENTITY}-WLT-${MAX_LENGTH}-SciBERT-ENS-4 \
    --max_seq_length ${MAX_LENGTH} \
    --num_train_epochs ${NUM_EPOCHS} \
    --weight_scheme ENS \
    --beta_factor 0.3  \
    --per_device_train_batch_size ${BATCH_SIZE} \
    --save_steps ${SAVE_STEPS} \
    --seed ${SEED} \
    --do_train \
    --do_eval \
    --do_predict \
    --overwrite_output_dir
  ```
## Quick Links  
  -[Usage of WeLT](https://github.com/mobashgr/WeLT/tree/main/named-entity-recognition#welt-usage-example)\
  -[Hyperparameters](https://github.com/mobashgr/WeLT/tree/main/named-entity-recognition#welt-usage-example)

 ## Citation
  (TBD)
## Acknowledgment
Ghadeer Mobasher is part of the [PoLiMeR-ITN](http://polimer-itn.eu/) and is supported by European Union’s Horizon 2020 research and innovation program under the Marie Skłodowska-Curie grant agreement PoLiMeR, No 81261
