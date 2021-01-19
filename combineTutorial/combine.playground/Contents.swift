import UIKit
import Combine

var myIntArrayPublisher : Publishers.Sequence<[Int], Never> = [1,2,3].publisher


myIntArrayPublisher.sink(receiveCompletion: {
    completion in
    switch completion {
    case .finished:
        print("완료")
    case .failure(let error):
          print("실패 : error : \(error)")
    }
    
}) { receivedValue in
    print("값을 받았다. : \(receivedValue)")
}

var mySubscription : AnyCancellable? //rx의 disposable

var mySubscriptionSet = Set<AnyCancellable>()

var myNotification = Notification.Name("com.dustin.customNotification")

var myDefaultPublisher : NotificationCenter.Publisher  = NotificationCenter.default.publisher(for: myNotification)


//구독 하는 행위 sink
mySubscription = myDefaultPublisher.sink(receiveCompletion: {
    completion in
    
    switch completion {
    case .finished:
        print("완료")
    case .failure(let error):
        print("실패 : error : \(error)")
    }
    
    
}, receiveValue: { receivedValue in
    print("받은 값 : \(receivedValue)")
})

// & : 매개 변수 자체를 변경 할 수 없지만 in/out을 통해 변경 함.
mySubscription?.store(in: &mySubscriptionSet)

//메모리에 계속 남아 있다. Notification
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))
NotificationCenter.default.post(Notification(name: myNotification))

//메모리를 해제 하기 위해서는 -> 메모리에서 삭제
mySubscription?.cancel()


//KVO - key value observing

class MyFriend {
    var name = "철수" {
        didSet {
            print("name - didSet() : ", name)
        }
    }
    
}


//assign 구독 행위를 함.

//영수로 구독하면서 영수로 바뀜
var myFriend = MyFriend()

let myFriendSubscription : AnyCancellable = ["영수"].publisher.assign(to: \.name, on: myFriend)
