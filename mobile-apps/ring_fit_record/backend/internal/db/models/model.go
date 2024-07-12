package models

import "time"

type Record struct {
	Attachment string
	Comfort    string
	Memo       string
	CreatedAt  time.Time
}

type User struct {
	Name               string
	RingShape          string
	Material           string
	Size               string
	Width              string
	Thickness          string
	DominantHand       string
	RingFingerJoint    string
	FrequencyOfRemoval string
	Sake               string
	FitPreference      string
}
