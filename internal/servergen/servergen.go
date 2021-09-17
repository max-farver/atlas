package servergen

import (
	"github.com/urfave/cli/v2"
)

var ModelGenCommand = &cli.Command{
	Name:    "server",
	Aliases: []string{"s"},
	Usage:   "generate an http server",
	Action:  action,
}

func action(c *cli.Context) error {
	return nil
}
