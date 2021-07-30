GOOS=linux go build && \
zip fleet.zip fleet && \
rm fleet && \
aws lambda update-function-code --function-name fleet --zip-file fileb://fleet.zip && \
rm fleet.zip