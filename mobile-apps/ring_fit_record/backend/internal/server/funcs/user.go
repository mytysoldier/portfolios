package funcs

import (
	"backend/internal/db"
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
