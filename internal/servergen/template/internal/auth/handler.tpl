package auth

import (
	"go-chi-rest/internal/config"
	"go-chi-rest/internal/problem"
	"go-chi-rest/internal/users"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/jwtauth"
	"github.com/go-chi/render"
)

var (
	tokenAuth *jwtauth.JWTAuth
)

func RegisterRoutes() chi.Router {
	tokenAuth = config.AppConfig.TokenAuth

	r := chi.NewRouter()
	r.Post("/login", Login)
	return r
}

func Login(w http.ResponseWriter, r *http.Request) {
	data := &LoginRequest{}
	if err := render.Bind(r, data); err != nil {
		render.Render(w, r, problem.ErrInvalidRequest(err))
		return
	}

	// username := data.Username
	// password := data.Password

	// TODO: change this to actually get a user by user_id
	user, err := users.GetUser(100)
	if err != nil {
		render.Render(w, r, problem.ErrNotFound(err))
	}

	claims := map[string]interface{}{
		"user_id": user.ID,
	}

	_, jwtJSON, err := tokenAuth.Encode(claims)
	if err != nil {
		render.Render(w, r, problem.ErrInternalServiceError(err))
	}

	cookie := &http.Cookie{
		Name:     "jwt",
		Value:    jwtJSON,
		Path:     "/",
		HttpOnly: true,
	}
	http.SetCookie(w, cookie)

	render.Status(r, http.StatusOK)
}
