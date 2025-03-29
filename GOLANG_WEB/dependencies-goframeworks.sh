#!/bin/bash

# Define an array of Go web frameworks
frameworks=(
 "github.com/gin-gonic/gin"
 "github.com/labstack/echo/v4"
 "github.com/gofiber/fiber/v2"
 "github.com/go-chi/chi/v5"
 "github.com/beego/beego/v2"
 "github.com/gobuffalo/buffalo"
)
echo "Updating system packages..."
sudo apt update -y && sudo apt upgrade -y
echo "Checking if Go is installed..."
if ! command -v go &> /dev/null
then
 echo "Go is not installed. Installing Go..."
 sudo apt install -y golang
else
 echo "Go is already installed."
fi
echo "Setting up Go modules..."
export GO111MODULE=on
echo "Installing Go web frameworks..."
for framework in "${frameworks[@]}"; do
 echo "Installing $framework..."
 go get -u "$framework"
done
echo "Cleaning up Go modules..."
go mod tidy
echo "All Go web frameworks installed successfully!
