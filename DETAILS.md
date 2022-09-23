# TalentQL Cloud Assessment

## How it Works

The Code Scanner makes use of the Trivy Image Scanner by AquaSecuirty. Users can create issues containing a list of container images to be scrutinized, on the repository.
The repository scans the images in the list from the issue and reports which images are safe or unsafe as a comment to the issue. It has a workflow that is triggered automatically when an issue is created or opened. To make use of the image scanner, perform the follow steps:

- Go to the github repository and then click on the `Issues` tab of the repository. You can access it directly using this [link](https://github.com/amadinathaniel/cloud-starter/issues)

- Click the `New Issue` icon on the issues page and enter a descriptive name of your choice for your issue.

- In the comment section of the issue enter a list of container images of your choice in the following format:

~~~Markdown
[<"Image_1>",<"Image_2>"...,"<Image_N>"]
~~~

Replace the placeholder with any container image.

For example:
`["ruby:3.1-alpine3.15","node:18-alpine3.15"]`

- Submit the issue to trigger the image scan workflow.

- After a few seconds, you get an auto-response on the vulnerability results from the Github-Actions Bot.

## Implementation Details

The steps below, describe how the workflow was Built:

- Complete the Installation of the Trivy Image scanner from the apt repository, after adding and validating the repo sources list for trivy in the `Init` step.

- Define an empty array for entering values for each image defined in the list.

- Read the issue body by using the environmental variable `$ISSUE_BODY` which os defined by `{{ github.event.issue.body }}`.

- Use the translate (tr) command to trim the external brackets in the list and store that value in a variable as shown below:

~~~Bash
image_list=$(echo $input | tr -d "[]")
~~~

- Read the images into an array by removing the `,`

- Define a function that determines whether an image is "SAFE" or "UNSAFE". It checks the output value from running the Trivy image command

- Each image of the `IMAGES` array will be passed into the function to determine if they are "SAFE" or "UNSAFE".

- The "json_output" function consists of and if, elif and else statement that take the filtered text outputs of running the trivy command as shown below

- That value is a variable gotten by running the trivy image scan as shown below:

~~~Bash
trivy image --quiet $image | grep -i "Total" | awk '{print $2} > scan.txt

sed '1d' scan.txt > scan2.txt
~~~

- A for loop is used to iterate over each image saved in the array and running the trivy image scan.

- "Jq" - A linux utility that is use to both read and manipulate JSON data was used to parse the aray values into a JSON format.

- Using the Output required from the instruction document, manipulate the desired values for the JSOn body to be in the format below, so as to allow a POST to the Github    API:

~~~json
{
   "body":"[\n  {\n    \"image\": \"ruby:3.1-alpine3.15\",\n    \"status\": \"SAFE\"\n  },\n  {\n    \"image\": \"node:18-alpine3.15\",\n    \"status\": \"SAFE\"\n           },\n  {\n    \"image\": \"python:2.7-alpine\",\n    \"status\": \"UNSAFE\"\n  }\n]"
}
~~~

- Save the output into a file - result.json

- Enter the command below, specifying the authorization header and token

~~~Bash
curl -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/repos/amadinathaniel/cloud-starter/issues/${{        github.event.issue.number }}/comments -g -d @result.json
~~~

The command allows the github actions bot to reply the issue created with a comment for the vulnerability scan results.
