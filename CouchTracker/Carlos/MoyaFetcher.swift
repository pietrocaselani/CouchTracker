/*
 Copyright 2017 ArcTouch LLC.
 All rights reserved.

 This file, its contents, concepts, methods, behavior, and operation
 (collectively the "Software") are protected by trade secret, patent,
 and copyright laws. The use of the Software is governed by a license
 agreement. Disclosure of the Software to third parties, in any form,
 in whole or in part, is expressly prohibited except as authorized by
 the license agreement.
 */

import Carlos
import Moya
import PiedPiper

final class MoyaFetcher<Target: TargetType>: Fetcher {
  typealias KeyType = Target
  typealias OutputType = NSData

  private let lock: ReadWriteLock = PThreadReadWriteLock()
  private var pendingRequests: [Future<OutputType>] = []
  private let provider: MoyaProvider<Target>

  init(provider: MoyaProvider<Target>) {
    self.provider = provider
  }

  func get(_ key: Target) -> Future<OutputType> {
    let promise = startRequest(target: key)

    promise.onSuccess { _ in
      self.removePendingRequests(promise)
      }.onFailure { _ in
        self.removePendingRequests(promise)
      }.onCancel {
        self.removePendingRequests(promise)
    }

    self.addPendingRequest(promise)

    return promise.future
  }

  private func startRequest(target: Target) -> Future<OutputType> {
    let promise = Promise<OutputType>()

    let cancellable = provider.request(target) { result in
      DispatchQueue.main.async {
        if case .success(let data) = result {
          promise.succeed(data.data as NSData)
        } else if case .failure(let error) = result {
          promise.fail(error)
        }
      }
    }

    promise.onCancel {
      cancellable.cancel()
    }

    return promise.future
  }

  private func addPendingRequest(_ request: Future<OutputType>) {
    lock.withWriteLock {
      self.pendingRequests.append(request)
    }
  }

  private func removePendingRequests(_ request: Future<OutputType>) {
    if let idx = lock.withReadLock({ self.pendingRequests.index(where: { $0 === request }) }) {
      _ = lock.withWriteLock {
        self.pendingRequests.remove(at: idx)
      }
    }
  }
}
