#!/bin/bash

for file in ./*
do
  infile=`echo "${file:2}"|sed  \
         -e 's|"\"|"\\"|g' \
         -e 's| |\ |g' -e 's|!|\!|g' \
         -e 's|@|\@|g' -e 's|*|\*|g' \
         -e 's|&|\&|g' -e 's|]|\]|g' \
         -e 's|}|\}|g' -e 's|"|\"|g' \
         -e 's|,|\,|g' -e 's|?|\?|g' \
         -e 's|=|\=|g'  `
  outfileNOSPECIALS=`echo "${file:2}"|sed -e 's|[^A-Za-z0-9._-]|_|g'`
  outfileNOoe=`echo $outfileNOSPECIALS| sed -e 's|ö|oe|g'`
  outfileNOae=`echo $outfileNOoe| sed -e 's|ä|ae|g'`
  outfileNOue=`echo $outfileNOae| sed -e 's|ü|ue|g'`
  outfileNOOE=`echo $outfileNOue| sed -e 's|Ö|OE|g'`
  outfileNOAE=`echo $outfileNOOE| sed -e 's|Ä|AE|g'`
  outfileNOUE=`echo $outfileNOAE| sed -e 's|Ü|UE|g'`
  outfileNOss=`echo $outfileNOUE| sed -e 's|ß|ss|g'`
  outfile=${outfileNOss}
  if [ "$infile" != "${outfile}" ]
  then
        echo "filename changed for " $infile " in " $outfile
        mv "$infile" ${outfile}
  fi
done

exit
