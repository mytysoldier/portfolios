package funcs

import (
	"backend/internal/db"
	dbmodels "backend/internal/db/models"
	"backend/internal/server/models"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func GetRecordsHandler(ctx *gin.Context) {
	records := db.GetRecords()
	ctx.JSON(http.StatusOK, gin.H{
		"records": records,
	})
}

func RegisterRecordHandler(ctx *gin.Context) {
	var req models.RegisterRecord
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	err := db.RegisterRecord(dbmodels.Record{Attachment: req.Attachment, Comfort: req.Comfort, Memo: req.Memo, CreatedAt: time.Now()})
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{
			"error": err,
		})
	} else {
		ctx.JSON(http.StatusOK, gin.H{})
	}
}

func DeleteRecordHandler(ctx *gin.Context) {
	docID := ctx.Param("id")
	if err := db.DeleteRecord(docID); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{})
}
