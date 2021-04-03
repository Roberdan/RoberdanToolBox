//
//  Onboarding.swift
//  core stuff for an onboarding experience
//
//  Created by Roberto D’Angelo on 22/12/20.
//

import Foundation
import SwiftUI

#if os(iOS)

@available(iOS 13.0, *)

public struct OnboardingView: View {
    public var onboardingCards: [OnboardingCard]
    public var startMsg: String
    public var cardBackGroundUIColor: UIColor
    
    public init(onboardingCards: [OnboardingCard], startMsg: String, cardBackGroundUIColor: UIColor) {
        self.onboardingCards = onboardingCards
        self.startMsg = startMsg
        self.cardBackGroundUIColor = cardBackGroundUIColor
    }

    public var body: some View {
        TabView {
            ForEach(onboardingCards) { item in
                OnboardingCardView(card: item, startMsg: startMsg, cardBackGroundUIColor: cardBackGroundUIColor)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .padding(.vertical, 15)
    }
}

public struct OnboardingCardView: View {
    public var card: OnboardingCard
    public var startMsg: String
    public var cardBackGroundUIColor: UIColor
    
    @State private var isAnimating: Bool = false

    // MARK: - BODY
    public var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // CARD: IMAGE
                if card.image != "" {
                    Image(card.image)
                        .resizable()
                        .scaledToFit()
                        .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 8, x: 6, y: 8)
                        .scaleEffect(isAnimating ? 1.0 : 0.6)
                }

                // CARD: TITLE
                Text(card.title)
                    .foregroundColor(Color.white)
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.center)
                    .padding()
                    .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 2, x: 2, y: 2)

                // CARD: HEADLINE
                Text(card.headline)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 480)
                    .lineLimit(nil)

                if card.description != "" {
                    Text(card.description)
                        .lineLimit(10)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }

                if card.form != nil {
                    card.form
                        .background(Color(cardBackGroundUIColor).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                        .padding()

                }
                // BUTTON: START
                if card.isLast {
                    StartButtonView(startMsg: startMsg)
                }
                if card.alignTop {
                    Spacer()
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAnimating = true
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(LinearGradient(gradient: Gradient(colors: card.gradientColors), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

public struct StartButtonView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    public var startMsg: String
    
    public var body: some View {
        let btnAction = {
            isOnboarding = false
        }
        Button(action: btnAction) {
            HStack(spacing: 8) {
                Text(startMsg)

                Image(systemName: "arrow.right.circle")
                    .imageScale(.large)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                Capsule().strokeBorder(Color.white, lineWidth: 1.25)
            )
        }
        .accentColor(Color.white)
    }
}

public struct OnboardingCard: Identifiable {
    public var id = UUID()
    public var title: String
    public var headline: String
    public var image: String
    public var gradientColors: [Color]
    public var description: String
    public var form: AnyView?
    public var isLast: Bool
    public var alignTop: Bool
    
    public init(title: String, headline: String, image: String, gradientColors: [Color], description: String, form: AnyView?, isLast: Bool, alignTop: Bool) {
        self.title = title
        self.alignTop = alignTop
        self.description = description
        self.headline = headline
        self.image = image
        self.gradientColors = gradientColors
        self.form = form
        self.isLast = isLast
    }
}

#endif
