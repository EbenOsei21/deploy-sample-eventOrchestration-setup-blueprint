package main

//TODO - You need to make sure provide instructions in the blueprint's index.md file with directions on how to compile this Lambda in case they need to provide this in here.
import (
	"bytes"
	"fmt"
	"log"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

var (
	s3session *s3.S3
)

const (
	REGION = "us-east-1"                        //TODO These should not be should be passed in as environment variables to the lambda.  By hardcoding them your Lambda is only going 
	BUCKET_NAME = "paymentdatabucket"           //to be able read from this bucket and us-east-1.  This will break anyone else.  Dont forget to set those environment variables when you 
	                                            //deploy the lambda using the AWS Terraform region.  The Terraform component should not have these values hard coded.
)

func init() {
	s3session = s3.New(session.Must(session.NewSession(&aws.Config{
		Region: aws.String(REGION),
	  })))
  }

type Request struct {
	PaymentId    string `json:"paymentId"`
	PhoneNumber string  `json:"phoneNumber"`
}

type Response struct {
	Message string `json:"message"`
	Ok      bool   `json:"ok"`
}

func Handler(request Request) (Response, error) {
	log.Printf("Processing request %s\n", request.PaymentId)

	_, err := s3session.PutObject(&s3.PutObjectInput{
		Body:bytes.NewReader([]byte("{paymentId: "+request.PaymentId +", phoneNumber: "+request.PhoneNumber+"}")),
		Bucket: aws.String(BUCKET_NAME),
		Key: aws.String(request.PaymentId),
	  })

	  if err != nil {
		return Response{
			Message: "an error occured",
			Ok:      false,
		}, err
	  }

	return Response{
		Message: fmt.Sprintf("Processed request ID %s", request.PhoneNumber),
		Ok:      true,
	}, nil
}

func main() {
    lambda.Start(Handler)
}

