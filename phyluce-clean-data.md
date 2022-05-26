## **Clean the read data**

The data you just downloaded are actual, raw, untrimmed fastq data. This means they contain adapter contamination and low quality bases. We need to remove these - which you can do several ways. We'll use another program that is ([illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/)) because it allows us to trim many different indexed adapters from individual-specific fastq files - something that is a pain to do by hand. That said, you can certainly trim your reads however you would like. See the [illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/) website for instructions on installing the program.

To use this program, we will create a configuration file that we will use to inform the program about which adapters are in which READ1 and READ2 files. We will set up the trimming file with specific parameters, but please see the [illumiprocessor](https://github.com/faircloth-lab/illumiprocessor/) documentation for other options. The following example comes from the [phyluce tutorial](https://phyluce.readthedocs.io/en/latest/tutorials/tutorial-1.html):

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
