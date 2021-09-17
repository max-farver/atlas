package auth

import (
	"errors"
	"net/http"
)

// LoginRequest is the request payload for logging a User in.
type LoginRequest struct {
	Username string `json:"username"`
	Password string `json:"password"`
}

func (lr *LoginRequest) Bind(r *http.Request) error {
	if lr.Username == "" || lr.Password == "" {
		return errors.New("Username or Password missing from login request.")
	}
	return nil
}
