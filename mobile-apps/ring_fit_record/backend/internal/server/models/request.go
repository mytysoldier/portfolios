package models

type RegisterRecord struct {
	Attachment string `json:"attachment"`
	Comfort    string `json:"comfort"`
	Memo       string `json:"memo"`
}

type UpdateUser struct {
	Name               string `json:"name"`
	RingShape          string `json:"ringShape"`
	Material           string `json:"name"`
	Size               string `json:"name"`
	Width              string `json:"name"`
	Thickness          string `json:"name"`
	DominantHand       string `json:"name"`
	RingFingerJoint    string `json:"name"`
	FrequencyOfRemoval string `json:"name"`
	Sake               string `json:"name"`
	FitPreference      string `json:"name"`
}
