# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin "@rails/request.js", to: "request.js"

pin_all_from "app/javascript/controllers", under: "controllers"

pin "date-utils", to: "date-utils.js"
pin "themes", to: "themes.js"
pin "github-canvas", to: "github-canvas.js"
pin "github-canvas-rating", to: "github-canvas-rating.js"
