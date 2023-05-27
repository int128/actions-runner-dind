package main

import (
	"log"
	"os"
)

func main() {
	log.Printf("pid %d", os.Getpid())
}
