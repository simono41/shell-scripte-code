file=$1
ocrmypdf -l deu --force-ocr --jbig2-lossy ${file} ${file%.*}-ocr.pdf
