# Cloud Assessment

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c0f96f90d4c54566949088f5138ab065)](https://app.codacy.com/gh/amadinathaniel/cloud-starter?utm_source=github.com&utm_medium=referral&utm_content=amadinathaniel/cloud-starter&utm_campaign=Badge_Grade_Settings)

Build and deploy a very simple GitHub Action workflow that scans container images for vulnerabilities

1.  Users can create issues on your repo containing a list of container images to be scrutinized
2.  Your repo needs to take that list, scan the images for vulnerabilities and create a comment on the original issue with the outcome of the scan, stating which image(s) are safe or unsafe
3.  Close the issue to trigger evaluating your work/attempt on the challenge

See full details and instructions in this [Google Doc](https://docs.google.com/document/d/1evc9UWuBszCAaRaBbnmCxpGPoI2fotRhg6tQBvadCi8)