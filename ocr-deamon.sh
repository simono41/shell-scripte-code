set -x

DOKUMENT_DIR=/home/simono41/data1/Dokumente

find ${DOKUMENT_DIR} -path ${DOKUMENT_DIR}/.stversions -prune -type f -o -name "*.pdf" ! -name '*-ocr.pdf' -print | while read file; do
  if ! [ -f "${file%.*}-ocr.pdf" ]; then
    timeout 60 ocrmypdf -l deu+eng -c "${file}" "${file%.*}-ocr.pdf"
    sleep 1
  else
    echo "Datei wurde bereits verarbeitet"
  fi
done
