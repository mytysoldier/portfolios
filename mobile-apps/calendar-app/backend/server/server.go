package server

import (
	"backend/handler"
	"fmt"

	"github.com/gin-gonic/gin"
)

func Server() {
	r := gin.Default()
	r.GET("/calendar_events", handler.GetCalendarEvents)
	r.Run()
	fmt.Println("server started.")
}
