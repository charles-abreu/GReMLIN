# GReMLIN

GReMLIN is a scalable graph based strategy which models protein-ligand interfaces as graphs.

### 1. Prerequisites
  * Python 3x (requiriments.txt)
  * java 1.7.0
  * openbabel v2.3.1
  * Chemaxon
  
### 2. Run GReMLIN
 
GReMLIN uses PMapper, a Chemaxon program to percieve pharmacophoric properties of atoms of given ligands. 
You could include the Chemaxon software by moving the Chemaxon folder to GReMLIN/config/. 
 
The program is run by the python script called "gremlin.py". To use GReMLIN, simply
type "python3 gremlin.py", using the parameters -d followed by the name of a directory 
contaning many PDB valid files, and -o followed by thename of a output directory to save 
the results, as shown below

**python3 gemlin.py -d datesets/ricin -o outputDir/**

 
### 3. Results

Given the output directory, GReMLIN generates another directories containing the results, as shown below:

#### Output directories:
* receptor/
> directory containing .pdb files slpitted by chain 
* ligands/
> directory containing ligands files extracted from .pdb structures
* graphs/
> directory containing .graphs files in json format with interaction information
* groups/
> directory containing files in gspan format grouped by properties similarity.
* patterns/
> directory containing graph patterns found in each group in json format.
* supports/
> directory containing graphs grouped by support.
