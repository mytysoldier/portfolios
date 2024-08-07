package funcs

import (
	"backend/internal/db"
	dbmodels "backend/internal/db/models"
	"backend/internal/server/models"
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetUserHandler(ctx *gin.Context) {
	// TODO ログイン機能できたらこのハンドラー不要になる
	docID := ctx.Param("docId")
	user := db.GetUser(docID)
	ctx.JSON(http.StatusOK, gin.H{
		"user": user,
	})
}

func UpdateUserHandler(ctx *gin.Context) {
	var req models.UpdateUser
	docID := ctx.Param("docId")
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	user := dbmodels.User{Name: req.Name, RingShape: req.RingShape, Material: req.Material, Size: req.Size, Width: req.Width, Thickness: req.Thickness, DominantHand: req.DominantHand, RingFingerJoint: req.RingFingerJoint, FrequencyOfRemoval: req.FrequencyOfRemoval, Sake: req.Sake, FitPreference: req.FitPreference}
	err := db.UpdateUser(docID, user)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
	} else {
		ctx.JSON(http.StatusOK, gin.H{
			"user": user,
		})
	}
}
