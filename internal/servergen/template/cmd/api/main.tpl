package main

import (
	"flag"
	"go-chi-rest/internal/application"
	"go-chi-rest/internal/config"
)

func main() {
	configPath := flag.String("config", ".", "Configuration file path.")
	flag.Parse()

	config.ReadApplicationConfig(*configPath)
	application.Run()
}
