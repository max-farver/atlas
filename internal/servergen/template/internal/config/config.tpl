package config

import (
	"log"
	"os"
	"path"

	"github.com/go-chi/jwtauth"
	"github.com/spf13/viper"
)

var AppConfig *ApplicationConfig

type ApplicationConfig struct {
	SecretKey string `mapstructure:"secret_key"`
	TokenAuth *jwtauth.JWTAuth
	// Extend as needed
}

func ReadApplicationConfig(configPath string) error {
	viper.SetEnvPrefix("GO_REST_")

	if configPath == "." {
		cwd, _ := os.Getwd()
		configPath = path.Join(cwd, "..", "..", "internal", "config")
	}

	log.Print(configPath)

	viper.SetConfigFile(path.Join(configPath, "config.yml"))
	err := viper.ReadInConfig()
	if _, ok := err.(viper.ConfigFileNotFoundError); ok {
		log.Println("Config file not found")
	}

	err = viper.Unmarshal(&AppConfig)
	if err != nil {
		log.Fatal("Unable to decode config into struct:", err)
		return err
	}

	return nil
}
