import Std.Http

namespace Lean4BF

open Std Async
open Std.Http
open Std.Http.Server

/-- Lean4BF 요청 타입 (Std.Http 기반) -/
abbrev Request := Std.Http.Request Body.Stream

/-- Lean4BF 비동기 핸들러 타입 -/
abbrev Handler := Request → ContextAsync (Std.Http.Response Body.Any)

/-- 텍스트 응답 생성 헬퍼 -/
def textResponse (text : String) (status : Status := .ok) : ContextAsync (Std.Http.Response Body.Any) := do
  let builder := Response.withStatus status
  builder.text text

/-- JSON 응답 생성 헬퍼 -/
def jsonResponse (json : String) (status : Status := .ok) : ContextAsync (Std.Http.Response Body.Any) := do
  let builder := Response.withStatus status
  builder.json json

/-- 404 Not Found 응답 생성 헬퍼 -/
def notFoundResponse (msg : String := "Not Found") : ContextAsync (Std.Http.Response Body.Any) := do
  let builder := Response.notFound
  builder.text msg

end Lean4BF
