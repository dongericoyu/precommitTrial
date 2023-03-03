#! /bin/bash

for file in $(find . -name "*.qmd"); do
  if ! grep -q -E "date:\s+\"(0[1-9]|1[0-2])\/(0[1-9]|[12][0-9]|3[01])\/(19|20)[0-9]{2}\"" "$file"; then
    echo "File $file does not have the correct date format." >&2; exit 1;
  fi;
done;
exit 0