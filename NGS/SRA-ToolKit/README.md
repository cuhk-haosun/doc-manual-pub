# Installing and using SRA ToolKit in Linux

The SRA Toolkit is a tool for ncbi to download .SRA files and convert .fastQ files.

## Download the package

### Download from https://www.ncbi.nlm.nih.gov/ website

Open NCBI, click `Download` on the icon.

![sample image](/NGS/SRA-ToolKit/pic/1.png)

Then click `Download Tools` on the new page

![sample image](/NGS/SRA-ToolKit/pic/2.png)

And you will see the download of `SRA Toolkit`. Click in and you will go to the download interface of the corresponding system

![sample image](/NGS/SRA-ToolKit/pic/3.png)

### Download by Linux code

Directly download the latest version of the toolkit from NCBI's website. You can usually use the `wget` commands to download and then extract

```
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-centos_linux64.tar.gz
tar -xzf sratoolkit.current-centos_linux64.tar.gz
```

Add the bin directory to your PATH environment variable

```
nano ~/.bashrc
export PATH=$PATH: / share/home/grp-sunhao/liyixiao/sratoolkit.3.1.0-centos_linux64/bin
source ~/.bashrc
```

Try to use SRA ToolKit to download a fastq files as example. 
GSE71378's raw file id is SRR061633, use commands will split two original paired-end reads (paired sequencing sequences) into two files, with the first and second sequences of each paired reads stored separately.

```
fastq-dump --split-files SRR061633
```
![sample image](/NGS/SRA-ToolKit/pic/4.png)
