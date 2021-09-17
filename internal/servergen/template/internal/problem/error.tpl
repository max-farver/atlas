package problem

import (
	"fmt"

	"github.com/go-chi/render"
)

type ErrDBNotFound struct {
	Id  string
	Err error
}

type ErrIncorrectType struct {
	Err error
}

func (e ErrDBNotFound) Error() string {
	return fmt.Sprintf("Record not found: %s", e.Id)
}
func (e ErrDBNotFound) ErrorResponse() render.Renderer {
	return ErrNotFound(e)
}

func (e ErrIncorrectType) Error() string {
	return fmt.Sprintf("Could not parse JSON: %v", e.Err)
}

func (e ErrIncorrectType) ErrorResponse() render.Renderer {
	return ErrInvalidRequest(e)
}

func GetErrorRenderer(err error) render.Renderer {
	if enf, ok := err.(ErrDBNotFound); ok {
		return enf.ErrorResponse()
	}
	if eit, ok := err.(ErrIncorrectType); ok {
		return eit.ErrorResponse()
	}
	return ErrInternalServiceError(err)
}
