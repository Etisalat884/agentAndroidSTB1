import boto3
import sys

# AWS S3 credentials and bucket information


# file_key = 'EvQUAL/ICONS/RDK_Remote.png'  # The key of the file in the S3 bucket
# local_file_path = 'D:/SourceCodes/hi.png' # Local file path where you want to save the downloaded file

file_key = sys.argv[1]  # The key of the file in the S3 bucket
local_file_path = sys.argv[2]  # Local file path where you want to save the downloaded file

# Initialize a session using Amazon S3
session = boto3.Session(
    aws_access_key_id=aws_access_key_id,
    aws_secret_access_key=aws_secret_access_key
)
s3 = session.client('s3')


# Download the file from S3 to a local location

def copy_paste(path1, path2):
    with open(path1, 'r') as source_file:
        source_contents = source_file.read()
    with open(path2, 'a') as destination_file:
        destination_file.write(source_contents)


try:
    s3.download_file(bucket_name, file_key, local_file_path)
    print(f"Local path:{local_file_path}")
    print(f"File downloaded to {local_file_path}")
    example_path = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/TestSuite/STB"
    if example_path in local_file_path:
        dest_path = "/home/ltts2/Documents/evqual_automation/agentAndroidSTB1/workspace/TestSuite/STB/STB04_KSTB6080/STB04_KSTB6080.robot"
        copy_paste(local_file_path, dest_path)
except Exception as e:
    print(f"An error occurred: {str(e)}")
