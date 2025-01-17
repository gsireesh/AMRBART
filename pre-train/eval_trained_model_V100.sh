#!/bin/bash

set -euxo pipefail


export CUDA_VISIBLE_DEVICES=0
dataset=Giga
datapath="/home/sgururaj/src/auxiliary-structure/data/"
MODEL=$1
interval=1

lr=5e-5

model_size="large"


# the slashes in the model param expansion replace the forward slash with a dash, as gotten from https://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script
outpath=/home/sgururaj/src/auxiliary-structure/output/${dataset}-${MODEL//\//-}-Unifiedtextinf-JointDenoise-6task-AMREOS

mkdir -p $outpath
echo "OutputDir: $outpath"

/home/sgururaj/miniconda3/envs/amrbart/bin/python run_multitask_unified_pretraining.py \
  --train_file $datapath/val.jsonl \
  --val_file $datapath/val.jsonl \
  --test_file $datapath/test.jsonl \
  --output_dir $outpath \
  --mlm \
  --mlm_amr \
  --mlm_text \
  --mlm_amr_plus_text \
  --mlm_text_plus_amr \
  --mlm_joint_to_amr \
  --mlm_joint_to_text \
  --block_size 512 \
  --per_gpu_train_batch_size 2 \
  --model_type "$MODEL" \
  --model_name_or_path "$MODEL" \
  --save_total_limit 2 \
  --do_eval \
  --evaluate_during_training  \
  --fp16 \
  --eval_all_checkpoints \
  --overwrite_output_dir 2>&1 | tee $outpath/run.log

  #  --gradient_accumulation_steps 4 \
  #  --num_train_epochs 100  \
  #  --learning_rate $lr \
  #  --joint_train_interval $interval \
  #  --warmup_steps 2500 \
  #  --max_steps 100000 \
  #  --logging_steps 1000 \