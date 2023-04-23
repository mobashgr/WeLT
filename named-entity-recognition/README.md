## WELT usage example

This is an example for fine-tuning `BioRED-Chem` over `SciBERT` using `WELT` weight scheme 
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
    --weight_scheme WELT \
    --per_device_train_batch_size ${BATCH_SIZE} \
    --save_steps ${SAVE_STEPS} \
    --seed ${SEED} \
    --do_train \
    --do_eval \
    --do_predict \
    --overwrite_output_dir
  ```
