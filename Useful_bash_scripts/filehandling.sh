TYPERUN=$1
TYPESAMPLE=$2
DIRDATA=/project/CRUP_scores/CRUP_scores/ENCODE/Encode_data/$TYPERUN/$TYPESAMPLE
#DIRDATA=~/Documents/3.BDBI_Third_Course/2nd_trim/crup/ENCODE/Encode_data/$TYPERUN/$TYPESAMPLE/DATA
CELL=$3

for DIR in Controls H3K4me1 H3K4me3 H3K27ac
do
 mapfile -t my_array < <( ls $DIRDATA/$CELL/$DIR )
 echo $DIR
 if [ ${#my_array[@]} -eq 1 ]
 then
   if [ "$DIR" = "Controls" ]
   then
     cp $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/input.bam
   else
     cp $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/$DIR.bam
   fi
 elif [ ${#my_array[@]} -eq 3 ]
 then
   if [ "$DIR" = "Controls" ]
   then
     samtools merge $DIRDATA/$CELL/$DIR/input.bam $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/${my_array[1]} $DIRDATA/$CELL/$DIR/${my_array[2]}
   else
     samtools merge $DIRDATA/$CELL/$DIR/$DIR.bam $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/${my_array[1]} $DIRDATA/$CELL/$DIR/${my_array[2]}
   fi
 else
   if [ "$DIR" = "Controls" ]
   then
     samtools merge $DIRDATA/$CELL/$DIR/input.bam $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/${my_array[1]}
   else
     samtools merge $DIRDATA/$CELL/$DIR/$DIR.bam $DIRDATA/$CELL/$DIR/${my_array[0]} $DIRDATA/$CELL/$DIR/${my_array[1]}
   fi
 fi
done

echo "Merge done"
# mv $DIRDATA/$CELL/Controls/Controls.bam $DIRDATA/$CELL/Controls/input.bam

echo "Indexing files"
#loop for indexing alignments
for FILE in $DIRDATA/$CELL/H3K4me3/H3K4me3.bam $DIRDATA/$CELL/H3K27ac/H3K27ac.bam $DIRDATA/$CELL/H3K4me1/H3K4me1.bam $DIRDATA/$CELL/Controls/input.bam
do
  samtools index $FILE $FILE.bai
done

echo "Creating info.txt"
###create the info.txt for crup
INFOFILE=$DIRDATA/$CELL/info.txt

echo -e "feature\tbam_file\tbam_file_input" > $INFOFILE
for HM in H3K4me3 H3K27ac H3K4me1
do
  echo -e "$HM\t$DIRDATA/$CELL/$HM/$HM.bam\t$DIRDATA/$CELL/Controls/input.bam" >> $INFOFILE
done
