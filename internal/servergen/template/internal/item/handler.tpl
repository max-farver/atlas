package item

import (
	"go-chi-rest/internal/problem"
	"go-chi-rest/internal/server"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/render"
)

func RegisterRoutes() chi.Router {
	r := chi.NewRouter()
	r.With(server.Paginate).Get("/", listItems)
	r.Post("/", createItem)

	r.Route("/{itemId}", func(r chi.Router) {
		r.Get("/", getItem)
		r.Put("/", updateItem)
		r.Delete("/", deleteItem)
	})
	return r
}

func listItems(w http.ResponseWriter, r *http.Request) {
	if err := render.RenderList(w, r, NewItemListResponse(items)); err != nil {
		render.Render(w, r, problem.ErrRender(err))
		return
	}
}

// GetItem returns the specific Item.
func getItem(w http.ResponseWriter, r *http.Request) {
	itemId := chi.URLParam(r, "itemId")
	item, err := GetItem(r.Context(), itemId)
	if err != nil {
		render.Render(w, r, problem.GetErrorRenderer(err))
		return
	}
	if err := render.Render(w, r, NewItemResponse(item)); err != nil {
		render.Render(w, r, problem.GetErrorRenderer(err))
		return
	}
}

func createItem(w http.ResponseWriter, r *http.Request) {
	data := &ItemRequest{}
	if err := render.Bind(r, data); err != nil {
		render.Render(w, r, problem.ErrInvalidRequest(err))
		return
	}

	item := data.Item
	CreateItem(r.Context(), item)

	render.Status(r, http.StatusCreated)
	render.Render(w, r, NewItemResponse(item))
}

func updateItem(w http.ResponseWriter, r *http.Request) {
	itemId := chi.URLParam(r, "itemId")
	item, err := GetItem(r.Context(), itemId)
	if err != nil {
		return
	}

	data := &ItemRequest{Item: item}
	if err := render.Bind(r, data); err != nil {
		render.Render(w, r, problem.ErrInvalidRequest(err))
		return
	}
	item = data.Item
	UpdateItem(r.Context(), item)

	render.Render(w, r, NewItemResponse(item))
}

func deleteItem(w http.ResponseWriter, r *http.Request) {
	itemId := chi.URLParam(r, "itemId")
	item, err := GetItem(r.Context(), itemId)
	if err != nil {
		return
	}

	err = DeleteItem(r.Context(), item.ID)
	if err != nil {
		render.Render(w, r, problem.GetErrorRenderer(err))
		return
	}

	render.Render(w, r, NewItemResponse(item))
}
