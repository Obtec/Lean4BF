import Lean4BF.Core
import Lean4BF.Router

namespace Lean4BF

open Std Async
open Std.Http
open Std.Http.Server

/-- Lean4BF 애플리케이션 구조체 -/
structure App where
  router : Router := Router.empty
deriving Inhabited

instance : Server.Handler App where
  onRequest self req := self.router.dispatch req

namespace App

/-- 빈 애플리케이션 생성 -/
def empty : App := { router := Router.empty }

/-- 라우트 등록 기본 함수 -/
def route (app : App) (method : Method) (path : String) (handler : Handler) : App :=
  { app with router := app.router.addRoute method path handler }

/-- GET 라우트 등록 -/
def get (app : App) (path : String) (handler : Handler) : App :=
  app.route .get path handler

/-- POST 라우트 등록 -/
def post (app : App) (path : String) (handler : Handler) : App :=
  app.route .post path handler

/-- PUT 라우트 등록 -/
def put (app : App) (path : String) (handler : Handler) : App :=
  app.route .put path handler

/-- DELETE 라우트 등록 -/
def delete (app : App) (path : String) (handler : Handler) : App :=
  app.route .delete path handler

/-- 서버 실행 (기본 포트 8080, 0.0.0.0 바인딩) -/
def run (app : App) (port : UInt16 := 8080) : IO Unit := Async.block do
  let addr : Net.SocketAddress := .v4 ⟨.ofParts 0 0 0 0, port⟩
  IO.println s!"[Lean4BF] Server starting on http://0.0.0.0:{port}"
  let server ← Server.serve addr app
  server.waitShutdown

end App

end Lean4BF
