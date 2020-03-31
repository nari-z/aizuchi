package main

import (
	"github.com/labstack/echo"

	"github.com/nari-z/aizuchi/method"
)

func main() {
	e := echo.New()

	e.GET("/exit", method.Exit)

	e.Start(":8080")
}
