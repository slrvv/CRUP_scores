cat celltypes.txt | while read line || [[ -n $line ]];
do
   mkdir $line 
done
