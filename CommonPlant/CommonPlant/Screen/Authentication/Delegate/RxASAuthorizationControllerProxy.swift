//
//  RxASAuthorizationControllerProxy.swift
//  CommonPlant
//
//  Created by 아라 on 2/27/24.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

class RxASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate> {
    
    fileprivate var presentationWindow: UIWindow = UIWindow()
    var didComplete = PublishSubject<ASAuthorization>()
    
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: RxASAuthorizationControllerProxy.self)
    }
    
    deinit {
        self.didComplete.onCompleted()
    }
}

extension RxASAuthorizationControllerProxy: DelegateProxyType {
    public static func registerKnownImplementations() {
        register { 
            return RxASAuthorizationControllerProxy(controller: $0) }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        return object.delegate = delegate
    }
}

extension RxASAuthorizationControllerProxy: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        didComplete.onCompleted()
    }
}

extension RxASAuthorizationControllerProxy: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return presentationWindow
    }
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    public func signInWithApple(scope: [ASAuthorization.Scope]? = nil, on window: UIWindow) -> Observable<ASAuthorization> {
        let request = base.createRequest()
        request.requestedScopes = scope

        let controller = ASAuthorizationController(authorizationRequests: [request])

        let proxy = RxASAuthorizationControllerProxy.proxy(for: controller)
        proxy.presentationWindow = window

        controller.presentationContextProvider = proxy
        controller.performRequests()

        return proxy.didComplete
    }
}
