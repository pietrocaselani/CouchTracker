import RxRelay

struct GoGo {
  func gogo() {
    let relay = PublishRelay<Int>() // Start with no value
    relay.accept(4) // Only emits values. No one will receive 4
    _ = relay.subscribe(onNext: { print($0) })

    
  }
}
