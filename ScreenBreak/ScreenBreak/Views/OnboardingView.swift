//
//  OnboardingView.swift
//  ScreenBreak
//
//  Created by Christian Pichardo on 4/13/23.
//

import SwiftUI

struct OnboardingView: View {
    private enum OnboardingStep {
        case welcome
        case screenTime
    }

    @AppStorage("showOnboarding") var showOnboarding = true
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var animatePhone = false
    @State private var step: OnboardingStep = .welcome
    @State private var selectedRange: String?

    private let ranges = [
        "Under 1 hour",
        "1-3 hours",
        "3-4 hours",
        "4-5 hours",
        "5-7 hours",
        "More than 7 hours"
    ]
    
    var body: some View {
        onboardingView
            .onAppear {
                withAnimation(.easeOut(duration: 0.7)) {
                    animatePhone = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    launchScreenManager.dismiss()
                }
            }
    }

    var onboardingView: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 0) {
                statusBar
                    .padding(.top, 4)
                    .padding(.horizontal, 28)

                switch step {
                case .welcome:
                    welcomeStep
                case .screenTime:
                    screenTimeStep
                }

                homeIndicator
                    .padding(.bottom, 8)
            }
        }
    }

    private var welcomeStep: some View {
        VStack(spacing: 0) {
            opalWordmark
                .padding(.top, 20)
                .padding(.bottom, 24)

            phonePreview
                .scaleEffect(animatePhone ? 1 : 0.92)
                .opacity(animatePhone ? 1 : 0.25)
                .padding(.bottom, 44)

            Text("Welcome to Opal")
                .font(.custom("Inter SemiBold", size: 48, relativeTo: .largeTitle))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Text("Starting today, let's focus better and\naccomplish your dreams.")
                .font(.custom("Inter Regular", size: 22, relativeTo: .body))
                .foregroundStyle(Color.white.opacity(0.82))
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 30)
                .padding(.top, 14)

            Button {
                withAnimation(.easeInOut(duration: 0.3)) {
                    step = .screenTime
                }
            } label: {
                Text("Get Started")
                    .font(.custom("Inter SemiBold", size: 34, relativeTo: .title2))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 84)
                    .background(Color.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 34)
            .padding(.top, 48)

            Text("Already have an account?")
                .font(.custom("Inter SemiBold", size: 18, relativeTo: .headline))
                .foregroundStyle(Color.white.opacity(0.8))
                .padding(.top, 28)

            Spacer(minLength: 24)
        }
    }

    private var screenTimeStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            opalWordmark
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                .padding(.bottom, 28)

            Text("What is your daily average\nScreen Time?")
                .font(.custom("Inter SemiBold", size: 50, relativeTo: .largeTitle))
                .foregroundStyle(.white)
                .lineSpacing(2)
                .padding(.horizontal, 28)

            Text("On your phone only. Your best guess is ok.")
                .font(.custom("Inter Regular", size: 18, relativeTo: .body))
                .foregroundStyle(Color.white.opacity(0.86))
                .padding(.horizontal, 28)
                .padding(.top, 10)
                .padding(.bottom, 26)

            VStack(spacing: 16) {
                ForEach(ranges, id: \.self) { range in
                    Button {
                        selectedRange = range
                        showOnboarding = false
                    } label: {
                        Text(range)
                            .font(.custom("Inter SemiBold", size: 18, relativeTo: .headline))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(
                                RoundedRectangle(cornerRadius: 11, style: .continuous)
                                    .fill(selectedRange == range ? Color.white.opacity(0.24) : Color(red: 0.09, green: 0.09, blue: 0.13))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 18)

            Spacer()
        }
    }

    private var opalWordmark: some View {
        HStack(spacing: 8) {
            Circle()
                .stroke(Color.white, lineWidth: 2.4)
                .frame(width: 18, height: 18)

            Text("Opal")
                .font(.custom("Inter SemiBold", size: 32, relativeTo: .title2))
                .foregroundStyle(.white)
        }
    }

    private var statusBar: some View {
        HStack {
            Text("9:41")
                .font(.custom("Inter SemiBold", size: 17, relativeTo: .caption))
                .foregroundStyle(.white)
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "cellularbars")
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(.white)
        }
    }

    private var homeIndicator: some View {
        Capsule()
            .fill(Color.white.opacity(0.8))
            .frame(width: 140, height: 5)
    }

    private var phonePreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 52, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.14, green: 0.13, blue: 0.18), Color(red: 0.04, green: 0.04, blue: 0.07)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 52, style: .continuous)
                        .stroke(Color.white.opacity(0.20), lineWidth: 3)
                )
                .frame(width: 288, height: 590)
                .shadow(color: .black.opacity(0.45), radius: 28, y: 10)

            VStack(spacing: 20) {
                Capsule()
                    .fill(Color.black.opacity(0.42))
                    .frame(width: 132, height: 34)
                    .padding(.top, 20)

                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.35), Color.cyan.opacity(0.4)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 210, height: 14)

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(44), spacing: 12), count: 4), spacing: 14) {
                    ForEach(0..<16, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(iconColor(at: index))
                            .frame(width: 44, height: 44)
                    }
                }
                .padding(.horizontal, 18)

                Spacer()

                HStack(spacing: 14) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: 45, height: 45)
                    }
                }
                .padding(.bottom, 28)
            }
            .frame(width: 288, height: 590)
        }
    }

    private func iconColor(at index: Int) -> Color {
        let colors: [Color] = [
            Color(red: 0.21, green: 0.54, blue: 0.97),
            Color(red: 0.93, green: 0.29, blue: 0.28),
            Color(red: 0.95, green: 0.59, blue: 0.11),
            Color(red: 0.31, green: 0.39, blue: 0.95),
            Color(red: 0.76, green: 0.25, blue: 0.52),
            Color(red: 0.21, green: 0.67, blue: 0.38),
            Color(red: 0.16, green: 0.57, blue: 0.84),
            Color(red: 0.29, green: 0.60, blue: 0.88)
        ]
        return colors[index % colors.count]
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
