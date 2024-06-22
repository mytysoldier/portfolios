package configs

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

func LoadEnv() error {
	err := godotenv.Load("./configs/.env")

	if err != nil {
		log.Fatalf("error loading env file: %v", err)
		return err
	}

	gcloud_file_path := os.Getenv("GCLOUD_CREDENTIAL_FILE_PATH")
	log.Printf("GCLOUD_CREDENTIAL_FILE_PATH: %v", gcloud_file_path)

	return nil
}
