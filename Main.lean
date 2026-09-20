import Lean4BF

open Lean4BF

def main : IO Unit := do
  let app := App.empty
    |>.get "/" (fun _ =>
      textResponse "Welcome to Lean4BF (Lean 4 Backend Framework)!")
    |>.get "/health" (fun _ =>
      jsonResponse "{\"status\":\"healthy\",\"framework\":\"Lean4BF\",\"engine\":\"Std.Http\"}")
    |>.get "/api/hello" (fun _ =>
      jsonResponse "{\"message\":\"Hello from Lean 4 Backend Framework!\"}")

  app.run (port := 8080)
