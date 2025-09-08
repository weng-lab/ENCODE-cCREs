#!/bin/bash

###########################################################
# Script: klf_hal2maf
# Author: [Your Name]                                      #
# Date: [Your Date]                                        #
# Description:                                             #
#   Wrapper script to convert HAL to MAF using hal2maf.    #
#   Edit the header to include relevant details.           #
# Usage:                                                   #
#   ./klf_hal2maf                                          #
###########################################################

# Set variables (edit these values as needed)
REF_GENOME="Homo_sapiens"
REF_SEQUENCE="chr19"
START=12885923
LENGTH=3
NO_ANCESTORS="--noAncestors"
NO_DUPES="--noDupes"
HAL_FILE="/zata/zippy/andrewsg/data/zoonomia/Alignments/447-mammalian-2022v1.hal"
OUTPUT_FILE="klf.maf"

# Run the hal2maf command
hal2maf \
  --refGenome "$REF_GENOME" \
  --refSequence "$REF_SEQUENCE" \
  --start "$START" \
  --length "$LENGTH" \
  $NO_ANCESTORS \
  $NO_DUPES \
  "$HAL_FILE" "$OUTPUT_FILE"

# Check if the command was successful
if [ $? -eq 0 ]; then
  echo "hal2maf completed successfully. Output saved to $OUTPUT_FILE."
else
  echo "hal2maf failed. Please check the input parameters and try again."
fi