package modelgen

import (
	"bytes"
	"errors"
	"fmt"
	"html/template"
	"os"

	"github.com/manifoldco/promptui"
	"github.com/urfave/cli/v2"
)

var ModelGenCommand = &cli.Command{
	Name:    "model",
	Aliases: []string{"s"},
	Usage:   "generate a model",
	Action:  action,
	Flags: []cli.Flag{
		&cli.StringFlag{
			Name:     "outputDir",
			Aliases:  []string{"o"},
			Usage:    "Use a randomized port",
			Required: true,
		},
	},
}

type Model struct {
	Name   string
	Fields []*field
}

type field struct {
	Name string
	Type string
}

func action(c *cli.Context) error {
	model := &Model{}
	err := getModelName(model)
	if err != nil {
		return err
	}
	err = getAllFields(model)
	if err != nil {
		return err
	}
	res, err := generateModel(model)
	if err != nil {
		return err
	}

	outputDir := c.String("outputDir")
	os.Mkdir("./"+outputDir, os.FileMode(0777))

	// dto

	// handler

	// model

	fmt.Printf(res)
	return nil
}

func getModelName(m *Model) error {
	validate := func(input string) error {
		if input == "" {
			return errors.New("Please input a valid model name.")
		}
		return nil
	}

	prompt := promptui.Prompt{
		Label:    "Model Name",
		Validate: validate,
	}

	modelName, err := prompt.Run()
	if err != nil {
		fmt.Printf("Prompt failed: %v\n", err)
		return err
	}
	m.Name = modelName
	return nil
}

func getAllFields(m *Model) error {
	for {
		newField, err := getField()
		if err != nil {
			return err
		}

		if newField == nil {
			break
		}

		m.Fields = append(m.Fields, newField)
		if ok, _ := confirmFinished(); ok {
			break
		}
	}
	return nil
}

func getField() (*field, error) {
	validateFieldName := func(input string) error {
		if input == "" {
			return errors.New("Please input a valid field name.")
		}
		return nil
	}
	promptFieldName := promptui.Prompt{
		Label:    "Model Field Name",
		Validate: validateFieldName,
	}

	fieldName, err := promptFieldName.Run()
	if err != nil {
		fmt.Printf("Prompt failed: %v\n", err)
		return nil, err
	}

	validateFieldType := func(input string) error {
		if input == "" {
			return errors.New("Please input a valid field type.")
		}
		return nil
	}

	promptFieldType := promptui.Prompt{
		Label:    "Model Field Type",
		Validate: validateFieldType,
	}

	fieldType, err := promptFieldType.Run()
	if err != nil {
		fmt.Printf("Prompt failed: %v\n", err)
		return nil, err
	}

	return &field{
		Name: fieldName,
		Type: fieldType,
	}, nil
}

func confirmFinished() (bool, error) {
	prompt := promptui.Select{
		Label:        "Are you finished adding fields?",
		Items:        []string{"No", "Yes"},
		HideSelected: true,
	}

	_, isFinished, err := prompt.Run()
	if err != nil {
		fmt.Printf("Prompt failed: %v\n", err)
		return true, err
	}
	return isFinished == "Yes", nil
}

func generateModel(m *Model) (string, error) {
	tpl := `type {{.Name}} struct {{"{"}} {{range .Fields}}{{"\n"}}{{.Name}} {{.Type}}{{end}} {{"\n}"}}`
	t, err := template.New("test").Parse(tpl)
	if err != nil {
		return "", err
	}

	var filledTpl bytes.Buffer
	err = t.Execute(&filledTpl, m)
	if err != nil {
		return "", err
	}

	return filledTpl.String(), nil
}
