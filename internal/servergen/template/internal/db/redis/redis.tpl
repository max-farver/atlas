package redis

import (
	"context"
	"encoding/json"
	"fmt"
	"go-chi-rest/internal/config"
	"go-chi-rest/internal/problem"

	"github.com/go-redis/redis/v8"
)

var (
	appConfig   *config.ApplicationConfig
	redisClient *redis.Client
)

func SetupRedisClient(host string, port int, password string) error {
	redisClient = redis.NewClient(&redis.Options{
		Addr:     fmt.Sprintf("%s:%d", host, port),
		Password: password, // no password set
		DB:       0,        // use default DB
	})

	_, err := redisClient.Ping(context.Background()).Result()
	return err
}

func Get(ctx context.Context, id string, data interface{}) error {
	val, err := redisClient.Get(ctx, id).Result()
	if err != nil {
		if err == redis.Nil {
			return problem.ErrDBNotFound{
				Id:  id,
				Err: err,
			}
		}
		return err
	}
	err = json.Unmarshal([]byte(val), data)
	if err != nil {
		return problem.ErrIncorrectType{Err: err}
	}
	return err
}

// func Scan(ctx context.Context, match string, offset uint64, count int64, data interface{}) error {
// 	keys, cursor, err := redisClient.Scan(ctx, offset, match, count).Result()
// 	if err != nil {
// 		if err == redis.Nil {
// 			return problem.ErrDBNotFound{
// 				Id:  "",
// 				Err: err,
// 			}
// 		}
// 		return err
// 	}
// 	for _, key := range keys {

// 	}
// 	return err
// }

func Put(ctx context.Context, id string, data interface{}) error {
	json, err := json.Marshal(data)
	err = redisClient.Set(ctx, id, json, 0).Err()
	if err != nil {
		if err == redis.Nil {
			return problem.ErrDBNotFound{
				Id:  id,
				Err: err,
			}
		}
		return err
	}
	return err
}

func Delete(ctx context.Context, id string) error {
	_, err := redisClient.Del(ctx, id).Result()
	if err != nil {
		if err == redis.Nil {
			return problem.ErrDBNotFound{
				Id:  id,
				Err: err,
			}
		}
		return err
	}
	return err
}
