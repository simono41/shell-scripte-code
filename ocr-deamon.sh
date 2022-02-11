set -x

DOKUMENT_DIR=/home/simono41/data1/Dokumente

for file in $(find ${DOKUMENT_DIR} -path ${DOKUMENT_DIR}/.stversions -prune -o -name "*.pdf" ! -name '*-ocr.pdf' -print); do
	ocrmypdf -l deu --force-ocr --jbig2-lossy ${file} ${file%.*}-ocr.pdf
done 
