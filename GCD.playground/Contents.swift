import UIKit

// Queue

// Main Queue
//DispatchQueue.main.sync {
//    // UI update
//    let view = UIView()
//    view.backgroundColor = .white
//}

// global Queue
DispatchQueue.global(qos: .userInteractive).async {
    // 0.1 ~ 1초 사이의 빠른 작업

}

DispatchQueue.global(qos: .userInitiated).async {
    // 2 ~ 10초 사이의 작업
}

DispatchQueue.global(qos: .utility).async {
    // 5 ~ 10분 사이의 작업

}

DispatchQueue.global(qos: .background).async {
    // 30분 이상의 작업

}

// custom queue
let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial", qos: .background)

// Async

DispatchQueue.global(qos: .background).async {
    for i in 0...5 {
        print("😈\(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("😀\(i)")
    }
}

// Sync



DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("😀\(i)")
    }
}

DispatchQueue.global(qos: .background).sync {
    for i in 0...5 {
        print("😈\(i)")
    }
}

DispatchQueue.global(qos: .background).async {
    for i in 0...5 {
        print("👹\(i)")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("💀\(i)")
    }
}
