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
	user := db.GetUser("nZDt9rrkrDpImT8rso0B")
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
	err := db.UpdateUser(docID, dbmodels.User{Name: req.Name, RingShape: req.RingShape, Material: req.Material, Size: req.Size, Width: req.Width, Thickness: req.Thickness, DominantHand: req.DominantHand, RingFingerJoint: req.RingFingerJoint, FrequencyOfRemoval: req.FrequencyOfRemoval, Sake: req.Sake, FitPreference: req.FitPreference})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
	} else {
		ctx.JSON(http.StatusOK, gin.H{})
	}
}
