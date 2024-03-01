# Harnessing the Microbiome: From Microbial Genes in the Gut to Intestinal Function and Drug Absorption

List of participants and affiliations:

- Abhinav Bhushan, Illinois Institute of Technology (Team Leader)
- Abhinav Sur, NICHD
- Christopher Tang (Tech Lead)
- David Cooper
- Gayathri Jahan Mohan
- Gobikrishnan Subramaniam, Queen's University
- Jooho Lee, D4CG, University of Chicago
- Karan Jogi, Discovery Partners Institute
- Soham Shirolkar, University of South Florida
- Viktoriia Liu

## Project Goals

The scientific goal of the project is to build AI/ML model to predict the impact of a bacterial species on human intestinal function in inflammatory bowel diseases (IBD), specifying, drug absorption & metabolism.

## Initial Approach

1. Find changes in genes of interest (drug absorption, metabolism) due to IBD
    1. Find pharmacokinetic response of IBD patients to drugs, or
    2. Find dataset on patient response to drugs relevant in IBD
2. Find relative abundance of bacterial species relevant in IBD
    1. Identify and obtain microbial features that will be used for AI/ML
3. Develop an AI/ML model to predict effect of bacteria on genes/pathways
    1. Find host-microbiome interactions relevant to IBD
    2. Create training set and identify AI/ML models
    3. Classify bacterial species that similarly affect (similar) genes/pathways
    4. Predict drug absorption/metabolism based upon this

## Modified Approach

- Add principal component analysis (PCA) to identify significant components (bacteria)

## Collected data

Data is collected from Priya, S. et al. paper listed on reference section. [Supplementary Tables](https://static-content.springer.com/esm/art%3A10.1038%2Fs41564-022-01121-z/MediaObjects/41564_2022_1121_MOESM2_ESM.zip)

- Paired data
  - RNAseq of colon (~16k genes)
  - Abundance (~700) of gut bacterial species `Supplementary Table 13`

## Results

## Future Work

- pharmacoketic profile (PK) of drug

## References

Priya, S., Burns, M.B., Ward, T. et al. Identification of shared and disease-specific host gene–microbiome associations across human diseases using multi-omic integration. Nat Microbiol 7, 780–795 (2022). https://doi.org/10.1038/s41564-022-01121-z

Zhou, H., Beltrán, J.F. & Brito, I.L. Host-microbiome protein-protein interactions capture disease-relevant pathways. Genome Biol 23, 72 (2022). https://doi.org/10.1186/s13059-022-02643-9

## NCBI Codeathon Disclaimer
This software was created as part of an NCBI codeathon, a hackathon-style event focused on rapid innovation. While we encourage you to explore and adapt this code, please be aware that NCBI does not provide ongoing support for it.

For general questions about NCBI software and tools, please visit: [NCBI Contact Page](https://www.ncbi.nlm.nih.gov/home/about/contact/)

