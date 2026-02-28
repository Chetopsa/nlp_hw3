#!/bin/bash

# ============================================================
#  run_experiments.sh
#  Runs all training & testing experiments for sentiment model
# ============================================================

# --- Config (edit these paths to match your setup) ----------
PYTHON="python3"                       # or "python3"
SCRIPT="main.py"                       # path to your Python file
FILE_FOLDER="./data"                       # folder containing the JSON data files
MODEL_NAME="distilbert-base-uncased"
BASE_MODEL_DIR="./models"
# ------------------------------------------------------------

# Exit immediately if any command fails
set -e

echo "========================================================"
echo "  Sentiment Analysis Experiments"
echo "========================================================"


# ============================================================
# EXPERIMENT 1 — Vary Epochs (for plot 1: per_epoch.png)
#   Fixed: train_size=800, learning_rate=2e-5
#   Varying: epochs 1..10
# ============================================================
echo ""
echo "--- Experiment 1: Varying Epochs ---"

EXP1_MODEL_DIR="${BASE_MODEL_DIR}/exp1_epochs"

for EPOCH in 1 2 3 4 5 6 7 8 9 10; do
    BEST_MODEL="epoch_${EPOCH}"
    echo "[Exp1] Training  epochs=${EPOCH}  -> model saved to ${BEST_MODEL}"
    $PYTHON $SCRIPT \
        --train \
        --model_name   $MODEL_NAME \
        --file_folder  $FILE_FOLDER \
        --epoch        $EPOCH \
        --train_size   800 \
        --learning_rate 2e-5 \
        --model_dir    $EXP1_MODEL_DIR \
        --best_model_name $BEST_MODEL
done

echo "[Exp1] Testing all epoch models..."
$PYTHON $SCRIPT \
    --test \
    --model_name  $MODEL_NAME \
    --file_folder $FILE_FOLDER \
    --model_dir   $EXP1_MODEL_DIR \
    --plot_name   per_epoch.png


# ============================================================
# EXPERIMENT 2 — Vary Training Data Size (for plot 2: per_size.png)
#   Fixed: epochs=3, learning_rate=2e-5
#   Varying: train sizes 50, 100, 200, 400, 600, 800
# ============================================================
echo ""
echo "--- Experiment 2: Varying Training Data Size ---"

EXP2_MODEL_DIR="${BASE_MODEL_DIR}/exp2_sizes"

for SIZE in 50 100 200 400 600 800; do
    BEST_MODEL="size_${SIZE}"
    echo "[Exp2] Training  train_size=${SIZE}  -> model saved to ${BEST_MODEL}"
    $PYTHON $SCRIPT \
        --train \
        --model_name   $MODEL_NAME \
        --file_folder  $FILE_FOLDER \
        --epoch        3 \
        --train_size   $SIZE \
        --learning_rate 2e-5 \
        --model_dir    $EXP2_MODEL_DIR \
        --best_model_name $BEST_MODEL
done

echo "[Exp2] Testing all size models..."
$PYTHON $SCRIPT \
    --test \
    --model_name  $MODEL_NAME \
    --file_folder $FILE_FOLDER \
    --model_dir   $EXP2_MODEL_DIR \
    --plot_name   per_size.png


# ============================================================
# EXPERIMENT 3 — Vary Learning Rate (for plot 3: per_learning_rate.png)
#   Fixed: epochs=3, train_size=800
#   Varying: learning rates 1e-5, 2e-5, 5e-5, 1e-4, 1e-3
# ============================================================
echo ""
echo "--- Experiment 3: Varying Learning Rate ---"

EXP3_MODEL_DIR="${BASE_MODEL_DIR}/exp3_lr"

for LR in 1e-5 2e-5 5e-5 1e-4 1e-3; do
    # Replace 'e' and '-' so the folder name is filesystem-safe
    SAFE_LR="${LR//\-/neg}"         # e.g. 1e-5 -> 1eneg5
    BEST_MODEL="lr_${SAFE_LR}"
    echo "[Exp3] Training  learning_rate=${LR}  -> model saved to ${BEST_MODEL}"
    $PYTHON $SCRIPT \
        --train \
        --model_name   $MODEL_NAME \
        --file_folder  $FILE_FOLDER \
        --epoch        3 \
        --train_size   800 \
        --learning_rate $LR \
        --model_dir    $EXP3_MODEL_DIR \
        --best_model_name $BEST_MODEL
done

echo "[Exp3] Testing all learning rate models..."
$PYTHON $SCRIPT \
    --test \
    --model_name  $MODEL_NAME \
    --file_folder $FILE_FOLDER \
    --model_dir   $EXP3_MODEL_DIR \
    --plot_name   per_learning_rate.png


echo ""
echo "========================================================"
echo "  All experiments complete!"
echo "  Plots saved: per_epoch.png | per_size.png | per_learning_rate.png"
echo "========================================================"