# backup
for wort in $(ls -d */ | cut -f1 -d'/'); do echo $wort; tar --use-compress-program=pigz -pcf ${wort}.tar.gz ${wort}; done

# transfer data (SSH)
scp -P 1022 *tar.gz simono41@65.108.123.253:

# restore
for wort in *.tar.gz; do echo $wort; tar -pxzf $wort; done
