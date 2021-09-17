package item

import (
	"go-chi-rest/internal/users"
	"net/http"

	"github.com/go-chi/render"
)

type ItemRequest struct {
	*Item
	ProtectedID string `json:"id"` // override 'id' json to have more control
}

// Bind is called to normalize data upon receiving the request.
func (a *ItemRequest) Bind(r *http.Request) error {
	// Something like changing all to lower case or removing certain ascii values
	return nil
}

type ItemResponse struct {
	*Item

	User *users.UserPayload `json:"user,omitempty"`

	// We add an additional field to the response here.. such as this
	// elapsed computed property
	Elapsed int64 `json:"elapsed"`
}

func (rd *ItemResponse) Render(w http.ResponseWriter, r *http.Request) error {
	// Pre-processing before a response is marshalled and sent across the wire
	return nil
}

func NewItemResponse(item *Item) *ItemResponse {
	resp := &ItemResponse{Item: item}

	if resp.User == nil {
		if user, _ := users.GetUser(resp.UserID); user != nil {
			resp.User = users.NewUserPayloadResponse(user)
		}
	}

	return resp
}

func NewItemListResponse(items []*Item) []render.Renderer {
	list := []render.Renderer{}
	for _, item := range items {
		list = append(list, NewItemResponse(item))
	}
	return list
}
