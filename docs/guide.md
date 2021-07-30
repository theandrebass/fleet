# Setting up AWS Lambda

## Basics

First, you need to have an AWS account, if not, first things first and sign up for one [here](https://aws.amazon.com/free)

### 1. Create your function

Find AWS Lambda in the list of services, then look for this shiny button:

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-01.png)

We’re going to author a function from scratch. Name your function, then under **Runtime** choose `Go 1.x`.

Under **Role** name write any name you like. It’s a required field but irrelevant for this use case.

Click **Create function**.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-02.png)

### 2. Configure your function

You’ll see a screen for configuring your new function. Under **Handler** enter the name of your Go program.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-03.png)

If you scroll down, you’ll see a spot to enter environment variables. This is a great place to enter the Twitter API tokens and secrets, using the variable names that your program expects. The AWS Lambda function will create the environment for you using the variables you provide here.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-04.png)

No further settings are necessary for this use case. Click **Save** at the top of the page.

### 3. Upload your code

You can upload your function code as a zip file on the configuration screen. Since we’re using Go, you’ll want to `go build`, then zip the resulting executable before uploading that to Lambda.

But in all fairness, you don't want to run that manually every time you want to tweak the function. That’s what `awscli` and this bash script is for!

```sh
update.sh
```

```sh
go build && \
zip fcc-tweet.zip fcc-tweet && \
rm fcc-tweet && \
aws lambda update-function-code --function-name fcc-tweet --zip-file fileb://fcc-tweet.zip && \
rm fcc-tweet.zip
```

Now, whenever you want to make a change, run `bash update.sh`

If you’re not already using [AWS Command Line Interface](https://aws.amazon.com/cli/), do pip install awscli and thank me later. Find instructions for getting set up and configured in a few minutes [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html) under **Quick Configuration**.

### 4. Test your function

Click “Configure test events” in the dropdown at the top.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-05.png)

Since you’ll use a time-based trigger for this function, you don’t need to enter any code to define test events in the popup window. Simply write any name under **Event name** and empty the JSON in the field below. Then click **Create**.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-06.png)

Click **Test** at the top of the page, and if everything is working correctly you should see the following:

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-07.png)

### 5. Set up CloudWatch Events

To run our function as we would a cron job - as a regularly scheduled time-based event - we’ll use CloudWatch. Click **CloudWatch Events** in the **Designer** sidebar.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-08.png)

Under **Configure triggers**, you’ll create a new rule. Choose a descriptive name for your rule without spaces or punctuation, and ensure **Schedule expression** is selected. Then input the time you want your program to run as a rate expression, or cron expression.

A cron expression looks like this:
```sh
cron(0 12 ** ? *)
```

| Minutes | Hours | Month | Day of week | Year | In English |
| :---: | :---: | :---: | :---: | :---: | :---: |
| 0 | 12 | `*` | ? | `*` | Run at noon (UTC) every day |

For more on how to write your cron expressions, read [this](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html).

See the [current time in UTC](https://victoria.dev/utc/).

If you want your program to run twice a day, say once at 10am and again at 3pm, you’ll need to set two separate CloudWatch Events triggers and cron expression rules.

Click **Add**.

![image](https://github.com/theandrebass/fleet/blob/main/docs/lambda-09.png)

### Watch it go

That’s all you need to get your Lambda function up and running!