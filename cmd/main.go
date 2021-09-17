package main

import (
	"atlas/internal/modelgen"
	"log"
	"os"

	"github.com/urfave/cli/v2"
)

func main() {
	app := &cli.App{
		Name:     "server-scaffold",
		Usage:    "build a server for kicking off projects",
		Commands: []*cli.Command{modelgen.ModelGenCommand},
	}

	err := app.Run(os.Args)
	if err != nil {
		log.Fatal(err)
	}
}
