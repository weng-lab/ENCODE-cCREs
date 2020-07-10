# ENCODE cCRE analysis

---

## Supplementary Figure 8 | Overlap of cCREs with ChromHMM states

**Overlap of cCREs with ChromHMM states. a,** Percentages of various groups of GM12878 cCREs that overlap ChromHMM states. **b,** Percentage of GM12878 cCREs-pELS that overlap ChromHMM states ranked by distance from the nearest TSS. Due to ChromHMM's lower spatial resolution, cCREs-PLS that are closest to TSSs overlap promoter ChromHMM states while those farther away overlap enhancer states. **c,** Percentages of mouse cCREs that overlap ChromHMM states in the corresponding tissue. All combinations of tissues and timepoints with both DNase and histone modification data were included and the overlap was computed for data in the same tissue at the same time point.

### Panel A

```
./Supplementary-Figure-8a.Human-ChromHMM-Overlap.sh
```

Requires: 
* `choose-majority-chromhmm-state.py`
* GM12878 cCREs
* GM12878 ChromHMM states: [ENCFF001TDH](https://www.encodeproject.org/files/ENCFF001TDH/)


### Panel B

```
./Supplementary-Figure-8b.pELS-ChromHMM-TSS-Distance.sh
```

Requires:
* `choose-majority-chromhmm-state.py`
* GM12878 cCREs
* GM12878 ChromHMM states: [ENCFF001TDH](https://www.encodeproject.org/files/ENCFF001TDH/)
* [GENCODE24 TSSs](https://github.com/weng-lab/ENCODE-cCREs/blob/master/Version-2/cCRE-Pipeline/Input-Data/hg38/GENCODE24/TSS.Basic.bed.gz)


### Panel C

```
./Supplementary-Figure-8c.Mouse-ChromHMM-Overlap.sh
```

Requires:
* `choose-majority-chromhmm-state.py`
* Mouse cCREs
* [DAC Mouse ChromHMM states](https://github.com/weng-lab/ENCODE-cCREs/tree/master/Version-2/cCRE-Analysis/Input-Data/mm10/DAC-Mouse-ChromHMM)
