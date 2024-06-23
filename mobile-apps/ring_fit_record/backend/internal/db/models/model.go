package models

import "time"

type Record struct {
	Attachment string
	Comfort    string
	Memo       string
	CreatedAt  time.Time
}
