package method

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo"
)

type infomation struct {
	Name    string `json:"name"`
	Version string `json:"version"`
}

func Infomation(ctx echo.Context) error {
	fmt.Println("Call Infomation")

	// TODO: 一元管理。ファイル等から取得できる良い。
	info := &infomation{
		Name:    "aizuchi",
		Version: "1.0.0",
	}

	return ctx.JSON(http.StatusOK, info)
}
