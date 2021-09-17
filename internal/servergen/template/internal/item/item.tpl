package item

import (
	"context"
	"fmt"
	"go-chi-rest/internal/db/redis"
	"strings"

	"github.com/google/uuid"
)

// User data model
type User struct {
	ID   int64  `json:"id"`
	Name string `json:"name"`
}

// Item data model. I suggest looking at https://upper.io for an easy
// and powerful data persistence adapter.
type Item struct {
	ID     string `json:"id"`
	UserID int64  `json:"user_id"` // the author
	Title  string `json:"title"`
	Slug   string `json:"slug"`
}

// Item fixture data
var items = []*Item{
	{ID: "1", UserID: 100, Title: "Hi", Slug: "hi"},
	{ID: "2", UserID: 200, Title: "sup", Slug: "sup"},
	{ID: "3", UserID: 300, Title: "alo", Slug: "alo"},
	{ID: "4", UserID: 400, Title: "bonjour", Slug: "bonjour"},
	{ID: "5", UserID: 500, Title: "whats up", Slug: "whats-up"},
}

func CreateItem(ctx context.Context, item *Item) (*Item, error) {
	id := generateUUID()
	item.ID = id
	err := redis.Put(ctx, buildRedisKey(id), item)
	if err != nil {
		return nil, err
	}
	return item, nil
}

// func GetAllItems(ctx context.Context) ([]*Item, error) {
// 	var item *[]*Item
// 	err := redis.Get(ctx, buildRedisKey(id), item)
// 	if err != nil {
// 		return nil, err
// 	}
// 	return items, nil
// }

func GetItem(ctx context.Context, id string) (*Item, error) {
	item := &Item{}
	err := redis.Get(ctx, buildRedisKey(id), item)
	if err != nil {
		return nil, err
	}
	return item, nil
}

func UpdateItem(ctx context.Context, item *Item) (*Item, error) {
	err := redis.Put(ctx, buildRedisKey(item.ID), item)
	if err != nil {
		return nil, err
	}
	return item, nil
}

// DeleteItem removes an existing Item from our persistent store.
func DeleteItem(ctx context.Context, id string) error {
	return redis.Delete(ctx, buildRedisKey(id))
}

func generateUUID() string {
	return strings.ReplaceAll(uuid.New().String(), "-", "")
}

func buildRedisKey(id string) string {
	return fmt.Sprintf("item_" + id)
}
