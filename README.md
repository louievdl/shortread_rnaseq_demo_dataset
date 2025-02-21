# shortread_rnaseq_demo_dataset
Use short-read RNA sequencing data from P Mews et al, Sci Adv, 2024 (PMID: 39365860) addressing effect of patterns of cocaine administration on two types of medium spiny neurons in mice (NCBI GEO accession: GSE272823). Only a subset of the dataset is used.

Multiple factors are present in this dataset, making the dataset useful for training in RNA-seq differential gene expression analysis from simple to advanced levels.
1. Outlier samples may be detected by more than one method
2. Two main effects are present in the data: cell type, with two levels (D1 or D2), and experimental protocol with three levels (chronic saline - SS, chronic saline and single cocaine - SC, chronic cocaine - CC), which have been incorporated into a single group variable. These variables make the dataset amenable to analysis at various levels of statistical complexity, from the very simple 2-factor/1-comparison design to single-factor-multiple-level or multiple-factor designs.
3. A batch effect (experimenter) has been added to the metadata for training purposes, although not present in the original dataset, increasing the complexity of the design if desired.

The scripts were generated on a compute cluster running a SLURM scheduler with hisat2/2.2.1, samtools/1.14 and trimgalore/0.6.6 modules. For non-HPC environments, hisat2, samtools and trim_galore executables should be present in your PATH.
