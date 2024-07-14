package db

import (
	"backend/internal/db/models"
	"context"
	"fmt"
	"log"
	"os"
	"sync"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

var (
	ClientInstance *firestore.Client
	clientOnce     sync.Once
	closeOnce      sync.Once
)

func InitializeFirestoreClient() {
	clientOnce.Do(func() {
		ctx := context.Background()
		sa := option.WithCredentialsFile(os.Getenv("GCLOUD_CREDENTIAL_FILE_PATH"))
		app, err := firebase.NewApp(ctx, nil, sa)
		if err != nil {
			log.Fatalf("error initilizing app: %v", err)
		}

		ClientInstance, err = app.Firestore(ctx)
		if err != nil {
			log.Fatalf("error initializing Firestoer client: %v", err)
		}
	})
}

func GetRecords() []models.Record {
	ctx := context.Background()
	iter := ClientInstance.Collection("records").Documents(ctx)
	var records []models.Record

	for {
		doc, err := iter.Next()
		if err == iterator.Done {
			break
		}

		var record models.Record
		if err := doc.DataTo(&record); err != nil {
			log.Fatalf("Failed to convert: %v", err)
		}
		records = append(records, record)
	}

	return records
}

func GetUser(docID string) models.User {
	ctx := context.Background()
	doc, err := ClientInstance.Collection("users").Doc(docID).Get(ctx)
	if err != nil {
		log.Fatalf("failed to get user: %v", err)
		return models.User{}
	}

	// ドキュメントのデータをコンソールに出力
	data := doc.Data()
	fmt.Printf("Document data: %#v\n", data)

	var user models.User
	if err := doc.DataTo(&user); err != nil {
		log.Fatalf("failed to convert: %v", err)
		return models.User{}
	}

	fmt.Printf("Document user data: %#v\n", user)

	return user
}

func UpdateUser(docID string, user models.User) error {
	ctx := context.Background()
	_, err := ClientInstance.Collection("users").Doc(docID).Set(ctx, user)
	if err != nil {
		log.Default().Printf("failed to update user: %v", err)
		return err
	}
	return nil
}

func RegisterRecord(record models.Record) error {
	ctx := context.Background()
	_, _, err := ClientInstance.Collection("records").Add(ctx, record)
	if err != nil {
		return err
	}
	return nil
}

func DeleteRecord(docID string) error {
	ctx := context.Background()
	_, err := ClientInstance.Collection("records").Doc(docID).Delete(ctx)
	if err != nil {
		return err
	}
	return nil
}

func CloseFirestoreClient() {
	closeOnce.Do(func() {
		err := ClientInstance.Close()
		if err != nil {
			log.Printf("error closing Firestore client: %v", err)
		}
	})
}

// テストデータ登録
func PrepareTestData() {
	records := []struct {
		Text string
		Num  int
	}{
		{Text: "text1", Num: 1},
	}
	ctx := context.Background()
	for _, record := range records {
		_, _, err := ClientInstance.Collection("records").Add(ctx, record)
		if err != nil {
			log.Printf("Failed to adding record: %v", err)
		} else {
			log.Printf("Successfully added record: %+v", record)
		}
	}
}
