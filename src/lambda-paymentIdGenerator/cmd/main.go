package main

import (
	"fmt"
	"math/rand"
	"strconv"

	"github.com/aws/aws-lambda-go/lambda"
)

type Request struct {
	CardNumber string `json:"cardNumber"`
}

type Response struct {
	PaymentId string `json:"paymentId"`
}

func Handler(request Request) (Response, error) {
	fmt.Printf("Processing request: %s", request.CardNumber)
	return Response{
		PaymentId: strconv.Itoa(rand.Int()),
	}, nil
}

func main() {
	lambda.Start(Handler)
}
