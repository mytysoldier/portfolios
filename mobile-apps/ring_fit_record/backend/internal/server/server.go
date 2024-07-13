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
	// ユーザー情報取得
	// TODO IDを受け取る
	r.GET("/user", funcs.GetUserHandler)
	// ユーザー情報更新
	r.POST("/user/:docId", funcs.UpdateUserHandler)

	r.Run()
}
