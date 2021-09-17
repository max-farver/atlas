package users

import "net/http"

type UserPayload struct {
	*User
	Role string `json:"role"`
}

// Bind on UserPayload will run after the unmarshalling is complete, its
// a good time to focus some post-processing after a decoding.
func (u *UserPayload) Bind(r *http.Request) error {
	return nil
}

func NewUserPayloadResponse(user *User) *UserPayload {
	return &UserPayload{User: user}
}

func (u *UserPayload) Render(w http.ResponseWriter, r *http.Request) error {
	u.Role = "collaborator"
	return nil
}
