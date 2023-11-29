//
//  LoginView.swift
//  PresentationKit
//
//  Created by 고병학 on 9/30/23.
//  Copyright © 2023 kr.ddd.ozeon. All rights reserved.
//

import Alamofire
import AuthenticationServices
import ComposableArchitecture
import KakaoSDKAuth
import KakaoSDKCommon
import KeychainAccess
import SwiftJWT

import SwiftUI

fileprivate enum Constants {
    enum Sizes {
        static let logoWidth: CGFloat = 58.0
        static let logoHeight: CGFloat = 58.0
        static let snsLoginLogoSize: CGFloat = 18.0
        static let snsLoginHorizontalSpace: CGFloat = 10.0
        static let bottomPaddingOfLogo: CGFloat = 16.0
        static let textBottomPadding: CGFloat = 12.0
        static let signInLabelVerticalPadding: CGFloat = 16.0
        static let containerHorizontalPadding: CGFloat = 16.0
        static let loginButtonBottomPadding: CGFloat = 8.0
        static let buttonCornerRadius: CGFloat = 100.0
    }
    enum Colors {
        static let kakaoYellow: Color = Color(red: 1, green: 0.9, blue: 0)
        
    }
    enum Strings {
        static let appSubtitle: String = "오롯이 전하는 \n전통문화 큐레이션"
        static let kakaoLogin: String = "카카오로 로그인"
        static let appleLogin: String = "Apple로 로그인"
        static let lookAround: String = "둘러보기"
    }
}

public struct LoginView: View {
    
    let store: StoreOf<Login>
    
    public init(store: StoreOf<Login>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStackStore(
            self.store.scope(state: \.path, action: { .path($0) })
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ZStack {
                    VStack(spacing: 0) {
                        VStack {
                            Spacer()
                            HStack(alignment: .center, spacing: 4.45265) {
                                Image.DK.icOzeonLogo.swiftUIImage
                                    .resizable()
                                    .frame(
                                        width: Constants.Sizes.logoWidth,
                                        height: Constants.Sizes.logoHeight
                                    )
                                    .padding(.bottom, Constants.Sizes.bottomPaddingOfLogo)
                                DesignSystemKitAsset.ojeonTitleLogo.swiftUIImage
                                    .scaledToFill()
                                    .frame(width: 110, height: 58)
                                    .padding(.bottom, Constants.Sizes.textBottomPadding)
                            }
                            Text(Constants.Strings.appSubtitle)
                                .font(Font.Head2.semiBold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.orangeGray3)
                            Spacer()
                        }
                        
//                        SNSLoginButton(snsType: .KAKAO) {
//                            viewStore.send(.didTapKakaoLoginButton)
//                        }
//                        .padding(.horizontal, Constants.Sizes.containerHorizontalPadding)
//                        .padding(.bottom, Constants.Sizes.loginButtonBottomPadding)
                        
                        SignInWithAppleButton(.continue) { request in
                            request.requestedScopes = [.fullName, .email]
                        } onCompletion: { result in
                            self.handleAppleLoginResult(result: result) { (identityToken: String) in
                                viewStore.send(.successAppleLogin(identityToken, ""))
                            }
                        }
                        .frame(height: 50)
                        .padding(.horizontal, Constants.Sizes.containerHorizontalPadding)
                        .padding(.bottom, Constants.Sizes.loginButtonBottomPadding)
                        
                        Button(action: {
                            viewStore.send(
                                .didTapLookAround,
                                animation: .easeOut(duration: 0.2)
                            )
                        }, label: {
                            Text(Constants.Strings.lookAround)
                                .font(.Title2.regular)
                                .foregroundStyle(Color.orangeGray5)
                        })
                        .padding(.vertical, Constants.Sizes.loginButtonBottomPadding)
                    }
                    .background(.white)
                    .navigationBarBackButtonHidden()
                    
                    OZDialogView(
                        title: "회원가입하면\n나에게 맞춘 전통 콘텐츠를 만날 수 있어요!\n회원가입 하시겠어요?",
                        cancelString: "둘러볼게요",
                        confirmString: "가입할게요"
                    ) {
                        viewStore.send(.didTapDialogContinueButton)
                    } confirmAction: {
                        viewStore.send(.didTapDialogSignUpButton)
                    }
                    .opacity(viewStore.state.isSignUpDialogPresented ? 1 : 0)
                    .ignoresSafeArea()
                }
            }
        } destination: { (state: Login.Path.State) in
            switch state {
            case .privacyPolicy:
                CaseLet(
                    /Login.Path.State.privacyPolicy,
                     action: Login.Path.Action.privacyPolicy,
                     then: PrivacyPolicyView.init(store:)
                )
            case .onboardingEmail:
                CaseLet(
                    /Login.Path.State.onboardingEmail,
                     action: Login.Path.Action.onboardingEmail,
                     then: OnboardingEmailView.init(store:)
                )
            case .onboardingNickname:
                CaseLet(
                    /Login.Path.State.onboardingNickname,
                     action: Login.Path.Action.onboardingNickname,
                     then: OnboardingNicknameView.init(store:)
                )
            case .onboardingInterestedPlace:
                CaseLet(
                    /Login.Path.State.onboardingInterestedPlace,
                     action: Login.Path.Action.onboardingInterestedPlace,
                     then: OnboardingInterestedPlaceView.init(store:)
                )
            case .onboardingInterestedContents:
                CaseLet(
                    /Login.Path.State.onboardingInterestedContents,
                     action: Login.Path.Action.onboardingInterestedContents,
                     then: OnboardingInterestedContentsView.init(store:)
                )
            case .onboardingComplete:
                CaseLet(
                    /Login.Path.State.onboardingComplete,
                     action: Login.Path.Action.onboardingComplete,
                     then: OnboardingCompleteView.init(store:)
                )
            case .ozWeb:
                CaseLet(
                    /Login.Path.State.ozWeb,
                     action: Login.Path.Action.ozWeb,
                     then: OZWebView.init(store:)
                )
            }
        }
    }
    
    private func handleAppleLoginResult(
        result: Result<ASAuthorization, Error>,
        completion: @escaping (String) -> Void
    ) {
        switch result {
        case .success(let authResults):
            switch authResults.credential {
            case let appleIDCredential as ASAuthorizationAppleIDCredential:
                guard let tokenData = appleIDCredential.identityToken,
                      let identityToken = String(data: tokenData, encoding: .utf8) else {
                    return
                }
                let lastName = appleIDCredential.fullName?.familyName ?? ""
                let firstName = appleIDCredential.fullName?.givenName ?? ""
                let name = "\(lastName)\(firstName)"
                try? Keychain().set(appleIDCredential.email ?? "", key: "EMAIL")
                try? Keychain().set(name, key: "NAME")
                
                if let authorizationCode = appleIDCredential.authorizationCode {
                    let code = String(decoding: authorizationCode, as: UTF8.self)
                    print("Code - \(code)")
                    self.getAppleRefreshToken(code: code) { data in
                        print("🚧 \(data ?? "-")")
                        UserDefaults.standard.set(data, forKey: "AppleRefreshToken")
                    }
                } else {
                    print("🚧 authorizationCode is nil")
                }
                completion(identityToken)
            default:
                break
            }
        case .failure(let error):
            Logger.log(error.localizedDescription, "\(Self.self)", #function)
        }
    }
    
    func makeJWT() -> String {
        let myHeader = Header(kid: "SQLLWGJ48N")
        
        // MARK: - client_secret(JWT) 발급 응답 모델
        struct MyClaims: Claims {
            let iss: String
            let iat: Int
            let exp: Int
            let aud: String
            let sub: String
        }

        var dateComponent = DateComponents()
        dateComponent.month = 6
        let iat = Int(Date().timeIntervalSince1970)
        let exp = iat + 3600
        let myClaims = MyClaims(iss: "92NGUT4BRA",
                                iat: iat,
                                exp: exp,
                                aud: "https://appleid.apple.com",
                                sub: "kr.ddd.ozeon.OZeon")

        var myJWT = JWT(header: myHeader, claims: myClaims)

        guard let url = Bundle.main.url(forResource: "AuthKey_SQLLWGJ48N", withExtension: "p8"),
              let privateKey: Data = try? Data(contentsOf: url, options: .alwaysMapped),
              let signedJWT = try? myJWT.sign(using: JWTSigner.es256(privateKey: privateKey))
        else {
            return ""
        }
        
        UserDefaults.standard.set(signedJWT, forKey: "AppleClientSecret")
        print("🗝 singedJWT - \(signedJWT)")
        return signedJWT
    }
    
    func getAppleRefreshToken(code: String, completionHandler: @escaping (String?) -> Void) {
        let secret = makeJWT()
        let bundleID = "kr.ddd.ozeon.OZeon"
        let url = "https://appleid.apple.com/auth/token"
          let header: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]
          let parameters: Parameters = [
              "client_id": bundleID,
              "client_secret": secret,
              "code": code,
              "grant_type": "authorization_code"
          ]

        print("🗝 clientSecret - \(UserDefaults.standard.string(forKey: "AppleClientSecret") ?? "")")
        print("🗝 authCode - \(code)")
        
        _ = AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: header
        )
        .validate(statusCode: 200..<500)
        .responseData { response in
            print("🗝 response - \(response.description)")
            switch response.result {
            case .success(let output):
                let decoder = JSONDecoder()
                if let decodedData = try? decoder.decode(AppleTokenResponse.self, from: output) {
                    if decodedData.refresh_token == nil {
                        print("if decodedData.refresh_token == nil")
                    } else {
                        completionHandler(decodedData.refresh_token)
                    }
                }
            case .failure:
                print("애플 토큰 발급 실패 - \(response.error.debugDescription)")
            }
        }
    }
}

#if DEBUG
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(store: Store(initialState: Login.State()) {
            Login()
        })
    }
}
#endif
