package main

import (
	"bytes"
	"fmt"
	"log"
	"os"

	"github.com/aws/aws-lambda-go/lambda"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

var (
	s3session *s3.S3
)

var (
	REGION      = os.Getenv("REGION")
	BUCKET_NAME = os.Getenv("BUCKET_NAME")
)

func init() {
	s3session = s3.New(session.Must(session.NewSession(&aws.Config{
		Region: aws.String(REGION),
	})))
}

type Request struct {
	PaymentId   string `json:"paymentId"`
	PhoneNumber string `json:"phoneNumber"`
}

type Response struct {
	Message string `json:"message"`
	Ok      bool   `json:"ok"`
}

func Handler(request Request) (Response, error) {
	log.Printf("Processing request %s\n", request.PaymentId)

	_, err := s3session.PutObject(&s3.PutObjectInput{
		Body:   bytes.NewReader([]byte("{paymentId: " + request.PaymentId + ", phoneNumber: " + request.PhoneNumber + "}")),
		Bucket: aws.String(BUCKET_NAME),
		Key:    aws.String(request.PaymentId),
	})

	if err != nil {
		return Response{
			Message: "an error occured",
			Ok:      false,
		}, err
	}

	return Response{
		Message: fmt.Sprintf("Processed request ID %s", request.PaymentId),
		Ok:      true,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
