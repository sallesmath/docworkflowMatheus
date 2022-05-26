We are going to start by processing raw read data from UCE enrichments performed against some divergent taxa. For more general analysis notes, please visit: <https://phyluce.readthedocs.io/en/latest/tutorials/index.html>

Protocols based on the phyluce pipeline: Faircloth BC. 2016. PHYLUCE is a software package for the analysis of conserved genomic loci. Bioinformatics 32:786-788. [doi:[10.1093/bioinformatics/btv646](doi:%5B10.1093/bioinformatics/btv646){.uri}](http://doi.org/10.1093/bioinformatics/btv646).

## **First steps**

Starting from raw sequencing data, and if you want to use the command line, you can use something like:

```{bash}
# create a project directory
mkdir uce-tutorial

# change to that directory
cd uce-tutorial

# make a directory to hold the data
mkdir raw-fastq

# move the zip file into that directory
mv fastq.zip raw-fastq

# move into the directory we just created
cd raw-fastq

# unzip the fastq data
unzip fastq.zip

# delete the zip file
rm fastq.zip

# you should something like the following in this directory now
ls -l

total 5643996
-rwxr-xr-x 1 sallesmath sallesmath 243771396 Mar  2 15:40 CHUNB74137_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 292212818 Mar  2 15:40 CHUNB74137_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 190273914 Mar  2 15:41 CHUNB74145_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 228411548 Mar  2 15:41 CHUNB74145_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 212160650 Mar  2 15:40 CHUNB74146_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 255392164 Mar  2 15:40 CHUNB74146_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath  95138993 Mar  2 15:41 CHUNB74147_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 116223869 Mar  2 15:41 CHUNB74147_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 312703366 Mar  2 15:42 CHUNB74155_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 372020696 Mar  2 15:41 CHUNB74155_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 239417910 Mar  2 15:41 CHUNB74156_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 282782992 Mar  2 15:41 CHUNB74156_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 227597484 Mar  2 15:40 CHUNB74157_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 273037339 Mar  2 15:42 CHUNB74157_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 337325296 Mar  2 15:41 CHUNB74162_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 409804219 Mar  2 15:40 CHUNB74162_R2_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 769251191 Mar  2 15:40 CHUNB74163_R1_001.fastq.gz
-rwxr-xr-x 1 sallesmath sallesmath 921803276 Mar  2 15:42 CHUNB74163_R2_001.fastq.gz
```

## **Count the read data**

Usually, we want a count of the actual number of reads in a given sequence file for a given species. We can do this several ways, but here, we'll use tools from unix, because they are fast. The next line of code will count the lines in each R1 file (which should be equal to the reads in the R2 file) and divide that number by 4 to get the number of sequence reads.

```{bash}
for i in R1.fastq.gz; do echo $i; gunzip -c $i | wc -l | awk '{print $1/4}'; done
```

You should see something like the following (with the names of your own sequence files):

```{bash}
AMCC204364_R1_001.fastq.gz
1380457
AMCC204421_R1_001.fastq.gz
1791683
AMCC204453_R1_001.fastq.gz
1568584
AMCC204456_R1_001.fastq.gz
1551834
AMCC204481_R1_001.fastq.gz
3125303
AMCC204537_R1_001.fastq.gz
1286469
AMCC204553_R1_001.fastq.gz
1619173
CURIMPAMPAM946104_R1_001.fastq.gz
1880353
LJAMCNP12113_R1_001.fastq.gz
1909457
MTR29373_R1_001.fastq.gz
1413708
MTR29379_R1_001.fastq.gz
1453609
MTR29393_R1_001.fastq.gz
1287652
MTR29439_R1_001.fastq.gz
1436066
MTR29440_R1_001.fastq.gz
924942
```
