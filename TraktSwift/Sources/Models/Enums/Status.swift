public enum Status: String, Codable {
  case ended
  case returning = "returning series"
  case canceled
  case inProduction = "in production"
  case inDevelopment = "planned"
  case pilot
}
