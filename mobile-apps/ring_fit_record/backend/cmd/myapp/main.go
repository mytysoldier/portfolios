package main

import (
	"backend/configs"
	"backend/internal/db"
	"backend/internal/server"
)

func main() {
	err := configs.LoadEnv()
	if err != nil {
		panic("error loading env file")
	}
	db.InitializeFirestoreClient()
	defer db.CloseFirestoreClient()

	server.Server()

	// db.PrepareTestData()
}
