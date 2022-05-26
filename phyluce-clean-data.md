## **Clean the read data**

The data you just downloaded are actual, raw, untrimmed fastq data. This means they contain adapter contamination and low quality bases. We need to remove these - which you can do several ways. We'll use another program that is ([illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/)) because it allows us to trim many different indexed adapters from individual-specific fastq files - something that is a pain to do by hand. That said, you can certainly trim your reads however you would like. See the [illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/) website for instructions on installing the program.

To use this program, we will create a configuration file (usually named "illumiprocessor.conf") that we will use to inform the program about which adapters are in which READ1 and READ2 files. We will set up the trimming file with specific parameters, but please see the [illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/) documentation for other options. This file gives details of your reads, how you want them processed, and what renaming options to use. There are several variations in formatting required depending on the library preparation method that you used. The following example comes from the [phyluce tutorial](https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html):

    # this is the section where you list the adapters you used. the asterisk
    # will be replaced with the appropriate index for the sample.

    [adapters]
    i7:AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC*ATCTCGTATGCCGTCTTCTGCTTG
    i5:AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT

    # this is the list of indexes we used

    [tag sequences]
    BFIDT-166:GGAGCTATGG
    BFIDT-016:GGCGAAGGTT
    BFIDT-045:TTCTCCTTCA
    BFIDT-011:CTACAACGGC

    # this is how each index maps to each set of reads

    [tag map]
    Alligator_mississippiensis_GGAGCTATGG:BFIDT-166
    Anolis_carolinensis_GGCGAAGGTT:BFIDT-016
    Gallus_gallus_TTCTCCTTCA:BFIDT-045
    Mus_musculus_CTACAACGGC:BFIDT-011

    # we want to rename our read files something a bit more nice - so we will
    # rename Alligator_mississippiensis_GGAGCTATGG to alligator_mississippiensis

    [names]
    Alligator_mississippiensis_GGAGCTATGG:alligator_mississippiensis
    Anolis_carolinensis_GGCGAAGGTT:anolis_carolinensis
    Gallus_gallus_TTCTCCTTCA:gallus_gallus
    Mus_musculus_CTACAACGGC:mus_musculus

In our analyses, the program was run in a Python 2.7 environment, outside of phyluce. The requirements for the operation of illumiprocessor, as well its additional command options, are available at: <https://github.com/faircloth-lab/illumiprocessor>

Illumiprocessor automates adapter and quality trimming processes over hundred of files and produces output in the format we want downstream. If you do not have a multicore machine, you may want to run with --cores = 1. Additionally, multicore operations require a fair amount of RAM, so if you're low on RAM, run with fewer cores:

```{bash}
# go to the directory containing our config file and data
cd uce-tutorial

# run illumiprocessor
illumiprocessor \
    --input raw_amcc \
    --output clean-fastq \
    --config illumiprocessor_matheus_2.conf \
    --cores 4 \
    --r1-pattern "{}_R1_\d+.fastq.gz" \
    --r2-pattern "{}_R2_\d+.fastq.gz"
```

The output should look like the following:

    2022-05-09 11:56:09,008 - illumiprocessor - INFO - ==================== Starting illumiprocessor ===================
    2022-05-09 11:56:09,008 - illumiprocessor - INFO - Version: 2.0.9
    2022-05-09 11:56:09,008 - illumiprocessor - INFO - Argument --config: illumiprocessor_matheus_mtr.conf
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --cores: 4
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --input: /home/sallesmath/dados_uce/phyluce_dados_uce_tropidurus/dados_andre/raw_mtr
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --log_path: None
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --min_len: 40
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --no_merge: False
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --output: /home/sallesmath/dados_uce/phyluce_dados_uce_tropidurus/dados_andre/clean-fastq
    2022-05-09 11:56:09,009 - illumiprocessor - INFO - Argument --phred: phred33
    2022-05-09 11:56:09,010 - illumiprocessor - INFO - Argument --r1_pattern: {}_R1_\d+.fastq.gz
    2022-05-09 11:56:09,010 - illumiprocessor - INFO - Argument --r2_pattern: {}_R2_\d+.fastq.gz
    2022-05-09 11:56:09,010 - illumiprocessor - INFO - Argument --se: False
    2022-05-09 11:56:09,010 - illumiprocessor - INFO - Argument --trimmomatic: /home/sallesmath/anaconda2/bin/trimmomatic
    2022-05-09 11:56:09,010 - illumiprocessor - INFO - Argument --verbosity: INFO
    2022-05-09 11:56:09,043 - illumiprocessor - INFO - Trimming samples with Trimmomatic
    2022-05-09 12:05:23,685 - illumiprocessor - INFO - =================== Completed illumiprocessor ===================

The really important information is in the split-adapter-quality-trimmed directory - which now holds our reads that have had adapter-contamination and low-quality bases removed. Within this split-adapter-quality-trimmed directory, the READ1 and READ2 files hold reads that remain in a pair (the reads are in the same consecutive order in each file). The READ-singleton file holds READ1 reads **OR** READ2 reads that lost their "mate" or "paired-read" because of trimming or removal.

## **Quality control**

You might want to get some idea of what effect the trimming has on read counts and overall read lengths. There are certainly other (better) tools out there to do this (like [FastQC](http://www.bioinformatics.babraham.ac.uk/projects/fastqc/)), but you can get a reasonable idea of how good your reads are by running the following, which will output a CSV listing of read stats by sample:

```{bash}
# move to the directory holding our cleaned reads
cd clean-fastq/

# run this script against all directories of reads

for i in *;
do
    phyluce_assembly_get_fastq_lengths --input $i/split-adapter-quality-trimmed/ --csv;
done
```

The output you see should look like this:

    sample                                                      reads       total bp        mean length             95 CI length            min     max     median
    Tropidurus_guarani_AMCC204453-READ2.fastq.gz                3049264     439692070       144.19613060725473      0.010745828205731861    40      150     150.0
    Tropidurus_lagunablanca_AMCC204456-READ2.fastq.gz           3014316     435556544       144.49597985081857      0.010536428156580744    40      150     150.0
    Tropidurus_melanopleurus_AMCC204553-READ2.fastq.gz          3136383     450463124       143.62503686571443      0.011142362674969167    40      150     150.0
    Tropidurus_tarara_AMCC204421-READ-singleton.fastq.gz        3428896     491965519       143.47636061286198      0.010730813022356636    40      150     150.0
    Tropidurus_teyumirim_AMCC204364-READ1.fastq.gz              2667913     383853425       143.87778949313565      0.011806031561148612    40      150     150.0
    Tropidurus_xanthochilus_AMCC204537-READ-singleton.fastq.gz  2510125     362947684       144.59347004631243      0.011403934648204684    40      150     150.0
    Tropidurus_callathelys_MTR29440-READ1.fastq.gz              1800854     259782538       144.25519114819969      0.013871031436742015    40      150     150.0
    Tropidurus_cfguarani_MTR29373-READ1.fastq.gz                2756032     398402891       144.5566999947751       0.010955551654613928    40      150     150.0
    Tropidurus_cfguarani_MTR29379-READ-singleton.fastq.gz       2826922     407939296       144.3051120618114       0.011057119272219721    40      150     150.0
    Tropidurus_cfguarani_MTR29393-READ-singleton.fastq.gz       2513882     363193165       144.4750250807317       0.011572667266856925    40      150     150.0
    Tropidurus_cftarara_MTR29566-READ2.fastq.gz                 2862799     413760265       144.52997398699665      0.010787932431841618    40      150     150.0
    Tropidurus_cftarara_MTR29570-READ-singleton.fastq.gz        2908159     420650652       144.6449977459967       0.010584848839830107    40      150     150.0
    Tropidurus_cftarara_MTR29586-READ-singleton.fastq.gz        3120913     452078128       144.85444740048825      0.010001043977677175    40      150     150.0
    Tropidurus_cftarara_MTR29588-READ1.fastq.gz                 1676243     239271890       142.74296149186006      0.016225932906319483    40      150     150.0
    Tropidurus_cftarara_MTR29611-READ-singleton.fastq.gz        1799022     259111209       144.02892738387857      0.014182472115866566    40      150     150.0
    Tropidurus_cftarara_MTR29619-READ-singleton.fastq.gz        2839612     410890096       144.69938005614853      0.010666459635961476    40      150     150.0
    Tropidurus_cftarara_MTR29623-READ-singleton.fastq.gz        2982873     431851814       144.7771373437622       0.01032000025534235     40      150     150.0
    Tropidurus_cfxanthochilus_MTR29439-READ1.fastq.gz           2787901     401271731       143.93327847724865      0.011496119381719886    40      150     150.0
    Tropidurus_cfxanthochilus_MTR29466-READ1.fastq.gz           3067255     442177749       144.1607394885655       0.010762075736230831    40      150     150.0
    Tropidurus_cfxanthochilus_MTR29499-READ1.fastq.gz           3968033     575068206       144.92525793006257      0.008801093903678362    40      150     150.0
    Tropidurus_cfxanthochilus_MTR29508-READ1.fastq.gz           2399064     346858050       144.5805739238303       0.011730784602433276    40      150     150.0
    Tropidurus_cfxanthochilus_MTR29554-READ-singleton.fastq.gz  3007008     435671834       144.88549215698794      0.010157667120217762    40      150     150.0
    Tropidurus_curimpampam_MTR29521-READ1.fastq.gz              2220589     317487002       142.974229810199        0.013848331319261487    40      150     150.0
    Tropidurus_cfcurimpampam_946104-READ-singleton.fastq.gz     3575643     510440722       142.75494561397767      0.01103157958983751     40      150     150.0
    Tropidurus_spinulosus_LJAMCNP12113-READ-singleton.fastq.gz  3576025     505555877       141.3736976111744       0.012000718063661306    40      150     150.0
