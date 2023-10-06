mkdir fixed
for f in ./*.gz;
do
   zcat "$f" | sed -E "s/^((@|\+)SRR[^.]+\.[^.]+)\.(1|2)/\1/" > ./fixed/${f/.gz/}
   gzip ./fixed/*.fastq
done
 