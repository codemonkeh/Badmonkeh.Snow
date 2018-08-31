aws s3 rm --recursive --exclude "*" --include "*.html" s3://badmonkeh.com/
aws s3 cp --recursive --exclude "*" --include "*.html"  . s3://badmonkeh.com/
aws s3 cp --recursive --exclude "*" --include "*.xml"  . s3://badmonkeh.com/