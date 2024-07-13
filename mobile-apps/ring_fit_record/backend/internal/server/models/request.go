package models

type RegisterRecord struct {
	Attachment string `json:"attachment"`
	Comfort    string `json:"comfort"`
	Memo       string `json:"memo"`
}

type UpdateUser struct {
	Name               string `json:"name"`
	RingShape          string `json:"ringShape"`
	Material           string `json:"material"`
	Size               string `json:"size"`
	Width              string `json:"width"`
	Thickness          string `json:"thickness"`
	DominantHand       string `json:"dominantHand"`
	RingFingerJoint    string `json:"ringFingerJoint"`
	FrequencyOfRemoval string `json:"frequencyOfRemoval"`
	Sake               string `json:"sake"`
	FitPreference      string `json:"fitPreference"`
}
