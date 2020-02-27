package main

import (
    "net/http"

    "github.com/go-playground/validator/v10"
    "github.com/julienschmidt/httprouter"

    "api/config"
    "api/infrastructure/api/router"
    "api/infrastructure/datastore"
    "api/registry"
    "fmt"
	"strconv"
)

func main() {
    i1, _ := strconv.Atoi(str1)
    fmt.Println(i1)
		
    config.LoadConfig()

    db := datastore.NewMySQL()
    ps := datastore.NewPostgreSQL()
    r := httprouter.New()
    v := validator.New()

    rg := registry.NewInteractor(db, ps, v)
    h := rg.NewAppHandler()

    router.NewRouter(r, h)

    defer db.Close()

    http.ListenAndServe(":8080", r)
    
                    
    
}

//werkweujhr kj jmhnbnk   
 
