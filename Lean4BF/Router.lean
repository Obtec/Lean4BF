import Lean4BF.Core

namespace Lean4BF

open Std Async
open Std.Http
open Std.Http.Server

/-- HTTP 라우트 정의 -/
structure Route where
  method  : Method
  path    : String
  handler : Handler

/-- 라우터 구조체 -/
structure Router where
  routes : List Route := []
deriving Inhabited

namespace Router

def empty : Router := { routes := [] }

/-- 라우트 등록 -/
def addRoute (router : Router) (method : Method) (path : String) (handler : Handler) : Router :=
  { router with routes := router.routes ++ [{ method, path, handler }] }

/-- 요청에서 경로(Path) 추출 -/
def extractPath (req : Request) : String :=
  toString (RequestTarget.pathOrRoot req.line.uri)

/-- 요청과 매칭되는 핸들러를 찾아 디스패치 -/
def dispatch (router : Router) (req : Request) : ContextAsync (Std.Http.Response Body.Any) := do
  let path := extractPath req
  let method := req.line.method
  
  match router.routes.find? (fun r => r.method == method && r.path == path) with
  | some route => route.handler req
  | none => notFoundResponse s!"404 Not Found: {method} {path}"

end Router

end Lean4BF
