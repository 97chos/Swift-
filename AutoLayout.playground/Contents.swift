import Foundation
import UIKit

let containerView = UIView(frame: CGRect(x:0, y:0, width: 300, height: 400))
containerView.backgroundColor = UIColor.white

//: 뷰 세 개를 만들고 오토레이아웃을 적용할 준비를 한다.

let redView = UIView()
redView.backgroundColor = UIColor.red
redView.translatesAutoresizingMaskIntoConstraints = false
containerView.addSubview(redView)

let blueView = UIView()
blueView.backgroundColor = UIColor.blue
blueView.translatesAutoresizingMaskIntoConstraints = false
containerView.addSubview(blueView)

let greenView = UIView()
greenView.backgroundColor = UIColor.green
greenView.translatesAutoresizingMaskIntoConstraints = false
containerView.addSubview(greenView)

//: 컨테이너뷰로부터 표준 마진을 사용한다.
let margins = containerView.layoutMarginsGuide

//: `redView`의 위치는 위, 왼쪽, 폭, 높이를 결정해준다.
redView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
redView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
redView.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.5, constant: -4.0).isActive = true
redView.heightAnchor.constraint(equalTo: margins.heightAnchor, multiplier: 0.5, constant: -4.0).isActive = true

//: `blueView`는 좀 더 쉬운데 `redView`를 따라가기만 하면 된다.
blueView.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
blueView.widthAnchor.constraint(equalTo: redView.widthAnchor).isActive = true
blueView.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true
blueView.leadingAnchor.constraint(equalTo: redView.trailingAnchor, constant: 0).isActive = true

//: `greenView`는 `redView`의 아래쪽으로 전체 폭을 사용한다.
greenView.topAnchor.constraint(equalTo: redView.bottomAnchor, constant: 8).isActive = true
greenView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
greenView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
greenView.widthAnchor.constraint(equalTo: margins.widthAnchor).isActive = true
greenView.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true

containerView

