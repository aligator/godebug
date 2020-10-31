package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	log.Println("Starting up webserver on :8080")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, "Hello %v", os.Args[1])
	})

	log.Fatal(http.ListenAndServe(":8080", nil))
}
