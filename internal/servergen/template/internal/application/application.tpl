package application

import (
	"go-chi-rest/internal/admin"
	"go-chi-rest/internal/auth"
	"go-chi-rest/internal/config"
	"go-chi-rest/internal/db/redis"
	"go-chi-rest/internal/item"
	"log"
	"net/http"

	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/go-chi/jwtauth"
	"github.com/go-chi/render"
)

func Run() {
	setupConfig()
	setupDB()

	r := chi.NewRouter()

	r.Use(middleware.RequestID)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.URLFormat)
	r.Use(render.SetContentType(render.ContentTypeJSON))

	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("Healthy"))
	})

	// Mount routes for authentication
	r.Mount("/auth", auth.RegisterRoutes())

	// Mount routes for each package
	r.Mount("/items", item.RegisterRoutes())

	// Mount the admin sub-router, which btw is the same as:
	r.Mount("/admin", admin.RegisterRoutes())

	log.Fatal(http.ListenAndServe(":3333", r))
}

func setupConfig() {
	config.AppConfig.TokenAuth = jwtauth.New("HS256", []byte(config.AppConfig.SecretKey), nil)
}

func setupDB() {
	err := redis.SetupRedisClient("localhost", 6379, "")
	if err != nil {
		log.Fatal(err)
	}
}
