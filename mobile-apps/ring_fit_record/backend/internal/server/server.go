package server

import (
	"backend/internal/server/funcs"

	"github.com/gin-gonic/gin"
)

func Server() {
	r := gin.Default()

	// 記録履歴取得
	r.GET("/records", funcs.GetRecordsHandler)
	// 記録追加
	r.POST("/records", funcs.RegisterRecordHandler)
	// 記録削除
	r.DELETE("/records/:id", funcs.DeleteRecordHandler)

	r.Run()
}
