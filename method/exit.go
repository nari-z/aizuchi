package method

import (
	"fmt"

	"github.com/labstack/echo"
)

func Exit(ctx echo.Context) error {
	fmt.Println("Call Exit")

	return ctx.Echo().Close()
}