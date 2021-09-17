package admin

import (
	"fmt"
	"go-chi-rest/internal/auth"
	"go-chi-rest/internal/config"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/jwtauth"
)

var tokenAuth *jwtauth.JWTAuth

// A completely separate router for administrator routes
func RegisterRoutes() chi.Router {
	tokenAuth = config.AppConfig.TokenAuth

	r := chi.NewRouter()
	r.Use(jwtauth.Verifier(tokenAuth))
	r.Use(auth.AdminOnly)
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("admin: index"))
	})
	r.Get("/accounts", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("admin: list accounts.."))
	})
	r.Get("/users/{userId}", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(fmt.Sprintf("admin: view user id %v", chi.URLParam(r, "userId"))))
	})
	return r
}
