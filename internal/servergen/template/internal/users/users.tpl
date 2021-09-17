package users

import (
	"errors"
)

var users = []*User{
	{ID: 100, Name: "Peter"},
	{ID: 200, Name: "Julia"},
}

// User data model
type User struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

func GetUser(id int64) (*User, error) {
	return dbGetUser(id)
}

func dbGetUser(id int64) (*User, error) {
	for _, u := range users {
		if u.ID == id {
			return u, nil
		}
	}
	return nil, errors.New("user not found.")
}
