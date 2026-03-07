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
        case focusGoal
    }

    @AppStorage("showOnboarding") var showOnboarding = true
    @AppStorage("onboardingScreenTimeRange") var onboardingScreenTimeRange = ""
    @AppStorage("onboardingFocusGoal") var onboardingFocusGoal = ""
    @EnvironmentObject var launchScreenManager: LaunchScreenManager
    @State private var animatePhone = false
    @State private var step: OnboardingStep = .welcome
    @State private var selectedRange: String?
    @State private var selectedGoal: String?
    @State private var showTrackingPrompt = true

    private let ranges = [
        "Under 1 hour",
        "1-3 hours",
        "3-4 hours",
        "4-5 hours",
        "5-7 hours",
        "More than 7 hours"
    ]

    private let goals = [
        "Reduce social media scrolling",
        "Stay focused while working",
        "Be more present with family",
        "Improve sleep routine"
    ]
    
    var body: some View {
        GeometryReader { proxy in
            onboardingView(size: proxy.size)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.7)) {
                        animatePhone = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        launchScreenManager.dismiss()
                    }
                }
        }
    }

    func onboardingView(size: CGSize) -> some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack(spacing: 0) {
                statusBar(size: size)
                    .padding(.top, scaled(4, for: size, min: 2, max: 8))
                    .padding(.horizontal, scaled(28, for: size, min: 16, max: 34))

                progressDots(size: size)
                    .padding(.top, scaled(10, for: size, min: 6, max: 12))
                    .padding(.bottom, scaled(8, for: size, min: 4, max: 12))

                switch step {
                case .welcome:
                    welcomeStep(size: size)
                case .screenTime:
                    screenTimeStep(size: size)
                case .focusGoal:
                    focusGoalStep(size: size)
                }

                homeIndicator(size: size)
                    .padding(.bottom, scaled(8, for: size, min: 6, max: 12))
            }
        }
    }

    private func welcomeStep(size: CGSize) -> some View {
        ZStack {
            VStack(spacing: 0) {
                opalWordmark(size: size)
                    .padding(.top, scaled(20, for: size, min: 10, max: 26))
                    .padding(.bottom, scaled(24, for: size, min: 14, max: 32))

                phonePreview(size: size)
                    .scaleEffect(animatePhone ? 1 : 0.92)
                    .opacity(animatePhone ? 1 : 0.25)
                    .padding(.bottom, scaled(44, for: size, min: 20, max: 56))

                Text("Welcome to Opal")
                    .font(.custom("Inter SemiBold", size: scaled(48, for: size, min: 30, max: 52), relativeTo: .largeTitle))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.85)
                    .padding(.horizontal, scaled(30, for: size, min: 18, max: 34))

                Text("Starting today, let's focus better and\naccomplish your dreams.")
                    .font(.custom("Inter Regular", size: scaled(22, for: size, min: 16, max: 24), relativeTo: .body))
                    .foregroundStyle(Color.white.opacity(0.82))
                    .multilineTextAlignment(.center)
                    .lineSpacing(scaled(4, for: size, min: 2, max: 6))
                    .minimumScaleFactor(0.9)
                    .padding(.horizontal, scaled(30, for: size, min: 18, max: 34))
                    .padding(.top, scaled(14, for: size, min: 8, max: 18))

                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        step = .screenTime
                    }
                } label: {
                    Text("Get Started")
                        .font(.custom("Inter SemiBold", size: scaled(34, for: size, min: 24, max: 36), relativeTo: .title2))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: scaled(84, for: size, min: 60, max: 90))
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, scaled(34, for: size, min: 20, max: 40))
                .padding(.top, scaled(48, for: size, min: 22, max: 56))

                Text("Already have an account?")
                    .font(.custom("Inter SemiBold", size: scaled(18, for: size, min: 14, max: 20), relativeTo: .headline))
                    .foregroundStyle(Color.white.opacity(0.8))
                    .padding(.top, scaled(28, for: size, min: 14, max: 34))

                Spacer(minLength: scaled(24, for: size, min: 10, max: 30))
            }

            if showTrackingPrompt {
                Color.black.opacity(0.2)
                    .ignoresSafeArea()

                trackingPrompt(size: size)
                    .padding(.horizontal, scaled(18, for: size, min: 12, max: 24))
                    .transition(.opacity.combined(with: .scale(scale: 0.96)))
            }
        }
    }

    private func screenTimeStep(size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            opalWordmark(size: size)
                .frame(maxWidth: .infinity)
                .padding(.top, scaled(20, for: size, min: 10, max: 26))
                .padding(.bottom, scaled(28, for: size, min: 16, max: 34))

            Text("What is your daily average\nScreen Time?")
                .font(.custom("Inter SemiBold", size: scaled(50, for: size, min: 30, max: 52), relativeTo: .largeTitle))
                .foregroundStyle(.white)
                .lineSpacing(scaled(2, for: size, min: 1, max: 3))
                .minimumScaleFactor(0.8)
                .padding(.horizontal, scaled(28, for: size, min: 18, max: 32))

            Text("On your phone only. Your best guess is ok.")
                .font(.custom("Inter Regular", size: scaled(18, for: size, min: 14, max: 20), relativeTo: .body))
                .foregroundStyle(Color.white.opacity(0.86))
                .padding(.horizontal, scaled(28, for: size, min: 18, max: 32))
                .padding(.top, scaled(10, for: size, min: 6, max: 12))
                .padding(.bottom, scaled(26, for: size, min: 16, max: 30))

            VStack(spacing: scaled(16, for: size, min: 10, max: 18)) {
                ForEach(ranges, id: \.self) { range in
                    Button {
                        selectedRange = range
                        onboardingScreenTimeRange = range
                        withAnimation(.easeInOut(duration: 0.28)) {
                            step = .focusGoal
                        }
                    } label: {
                        Text(range)
                            .font(.custom("Inter SemiBold", size: scaled(18, for: size, min: 14, max: 20), relativeTo: .headline))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: scaled(56, for: size, min: 44, max: 60))
                            .background(
                                RoundedRectangle(cornerRadius: scaled(11, for: size, min: 8, max: 12), style: .continuous)
                                    .fill(selectedRange == range ? Color.white.opacity(0.24) : Color(red: 0.09, green: 0.09, blue: 0.13))
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, scaled(18, for: size, min: 12, max: 24))

            Spacer()
        }
    }

    private func focusGoalStep(size: CGSize) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            opalWordmark(size: size)
                .frame(maxWidth: .infinity)
                .padding(.top, scaled(20, for: size, min: 10, max: 26))
                .padding(.bottom, scaled(28, for: size, min: 16, max: 34))

            Text("What do you want to improve first?")
                .font(.custom("Inter SemiBold", size: scaled(42, for: size, min: 28, max: 46), relativeTo: .largeTitle))
                .foregroundStyle(.white)
                .lineSpacing(scaled(2, for: size, min: 1, max: 3))
                .minimumScaleFactor(0.8)
                .padding(.horizontal, scaled(28, for: size, min: 18, max: 32))

            Text("Choose your main focus. You can update this later.")
                .font(.custom("Inter Regular", size: scaled(18, for: size, min: 14, max: 20), relativeTo: .body))
                .foregroundStyle(Color.white.opacity(0.86))
                .padding(.horizontal, scaled(28, for: size, min: 18, max: 32))
                .padding(.top, scaled(10, for: size, min: 6, max: 12))
                .padding(.bottom, scaled(26, for: size, min: 16, max: 30))

            VStack(spacing: scaled(14, for: size, min: 10, max: 18)) {
                ForEach(goals, id: \.self) { goal in
                    Button {
                        selectedGoal = goal
                        onboardingFocusGoal = goal
                    } label: {
                        HStack(spacing: scaled(12, for: size, min: 8, max: 14)) {
                            Circle()
                                .stroke(Color.white.opacity(0.5), lineWidth: 1.8)
                                .overlay(
                                    Circle()
                                        .fill(Color.white)
                                        .padding(4)
                                        .opacity(selectedGoal == goal ? 1 : 0)
                                )
                                .frame(width: scaled(22, for: size, min: 18, max: 24), height: scaled(22, for: size, min: 18, max: 24))
                            Text(goal)
                                .font(.custom("Inter SemiBold", size: scaled(17, for: size, min: 14, max: 19), relativeTo: .headline))
                                .foregroundStyle(.white)
                            Spacer(minLength: 0)
                        }
                        .padding(.horizontal, scaled(16, for: size, min: 12, max: 18))
                        .frame(maxWidth: .infinity)
                        .frame(height: scaled(62, for: size, min: 48, max: 68))
                        .background(
                            RoundedRectangle(cornerRadius: scaled(14, for: size, min: 10, max: 16), style: .continuous)
                                .fill(selectedGoal == goal ? Color.white.opacity(0.20) : Color(red: 0.09, green: 0.09, blue: 0.13))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, scaled(18, for: size, min: 12, max: 24))

            Spacer(minLength: scaled(14, for: size, min: 10, max: 20))

            Button {
                guard let selectedGoal else { return }
                onboardingFocusGoal = selectedGoal
                showOnboarding = false
            } label: {
                Text("Start Focus Journey")
                    .font(.custom("Inter SemiBold", size: scaled(24, for: size, min: 18, max: 26), relativeTo: .title2))
                    .foregroundStyle(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: scaled(72, for: size, min: 56, max: 78))
                    .background(selectedGoal == nil ? Color.white.opacity(0.45) : Color.white)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .disabled(selectedGoal == nil)
            .padding(.horizontal, scaled(28, for: size, min: 16, max: 32))
            .padding(.bottom, scaled(18, for: size, min: 12, max: 20))
        }
    }

    private func opalWordmark(size: CGSize) -> some View {
        HStack(spacing: 8) {
            Circle()
                .stroke(Color.white, lineWidth: 2.4)
                .frame(width: scaled(18, for: size, min: 14, max: 20), height: scaled(18, for: size, min: 14, max: 20))

            Text("Opal")
                .font(.custom("Inter SemiBold", size: scaled(32, for: size, min: 24, max: 34), relativeTo: .title2))
                .foregroundStyle(.white)
        }
    }

    private func statusBar(size: CGSize) -> some View {
        HStack {
            Text("9:41")
                .font(.custom("Inter SemiBold", size: scaled(17, for: size, min: 13, max: 18), relativeTo: .caption))
                .foregroundStyle(.white)
            Spacer()
            HStack(spacing: 5) {
                Image(systemName: "cellularbars")
                Image(systemName: "wifi")
                Image(systemName: "battery.100")
            }
            .font(.system(size: scaled(13, for: size, min: 10, max: 14), weight: .semibold))
            .foregroundStyle(.white)
        }
    }

    private func homeIndicator(size: CGSize) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.8))
            .frame(width: scaled(140, for: size, min: 100, max: 150), height: scaled(5, for: size, min: 4, max: 6))
    }

    private func progressDots(size: CGSize) -> some View {
        HStack(spacing: scaled(8, for: size, min: 6, max: 10)) {
            progressDot(active: step == .welcome, size: size)
            progressDot(active: step == .screenTime, size: size)
            progressDot(active: step == .focusGoal, size: size)
        }
    }

    private func progressDot(active: Bool, size: CGSize) -> some View {
        Capsule()
            .fill(active ? Color.white : Color.white.opacity(0.28))
            .frame(width: active ? scaled(24, for: size, min: 16, max: 26) : scaled(8, for: size, min: 6, max: 10), height: scaled(8, for: size, min: 6, max: 10))
            .animation(.easeOut(duration: 0.2), value: active)
    }

    private func trackingPrompt(size: CGSize) -> some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text("Allow \"Opal\" to track your\nactivity across other\ncompanies' apps and\nwebsites?")
                    .font(.custom("Inter SemiBold", size: scaled(16, for: size, min: 14, max: 18), relativeTo: .headline))
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(1)

                Text("By allowing access to this data you enable Opal to measure and improve your focus support experience.")
                    .font(.custom("Inter Regular", size: scaled(11, for: size, min: 10, max: 12), relativeTo: .caption))
                    .foregroundStyle(Color.black.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, scaled(18, for: size, min: 12, max: 22))
            }
            .padding(.top, scaled(24, for: size, min: 14, max: 28))
            .padding(.bottom, scaled(18, for: size, min: 12, max: 22))
            .background(Color(red: 0.95, green: 0.95, blue: 0.97))

            Divider()

            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    showTrackingPrompt = false
                }
            } label: {
                Text("Ask App Not to Track")
                    .font(.custom("Inter Regular", size: scaled(16, for: size, min: 14, max: 18), relativeTo: .headline))
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: scaled(52, for: size, min: 42, max: 56))
            }

            Divider()

            Button {
                withAnimation(.easeOut(duration: 0.2)) {
                    showTrackingPrompt = false
                }
            } label: {
                Text("Allow")
                    .font(.custom("Inter Regular", size: scaled(16, for: size, min: 14, max: 18), relativeTo: .headline))
                    .foregroundStyle(Color.blue)
                    .frame(maxWidth: .infinity)
                    .frame(height: scaled(52, for: size, min: 42, max: 56))
            }
        }
        .background(.white)
        .frame(maxWidth: scaled(370, for: size, min: 290, max: 390))
        .clipShape(RoundedRectangle(cornerRadius: scaled(18, for: size, min: 14, max: 22), style: .continuous))
        .shadow(color: .black.opacity(0.26), radius: 20, y: 8)
    }

    private func phonePreview(size: CGSize) -> some View {
        let phoneWidth = scaled(288, for: size, min: 200, max: 300)
        let phoneHeight = scaled(590, for: size, min: 400, max: 610)

        return ZStack {
            RoundedRectangle(cornerRadius: scaled(52, for: size, min: 34, max: 56), style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.14, green: 0.13, blue: 0.18), Color(red: 0.04, green: 0.04, blue: 0.07)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: scaled(52, for: size, min: 34, max: 56), style: .continuous)
                        .stroke(Color.white.opacity(0.20), lineWidth: 3)
                )
                .frame(width: phoneWidth, height: phoneHeight)
                .shadow(color: .black.opacity(0.45), radius: 28, y: 10)

            VStack(spacing: scaled(20, for: size, min: 12, max: 22)) {
                Capsule()
                    .fill(Color.black.opacity(0.42))
                    .frame(width: scaled(132, for: size, min: 96, max: 138), height: scaled(34, for: size, min: 24, max: 36))
                    .padding(.top, scaled(20, for: size, min: 10, max: 22))

                RoundedRectangle(cornerRadius: scaled(14, for: size, min: 10, max: 16), style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue.opacity(0.35), Color.cyan.opacity(0.4)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: scaled(210, for: size, min: 150, max: 220), height: scaled(14, for: size, min: 8, max: 16))

                LazyVGrid(columns: Array(repeating: GridItem(.fixed(scaled(44, for: size, min: 30, max: 46)), spacing: scaled(12, for: size, min: 8, max: 13)), count: 4), spacing: scaled(14, for: size, min: 8, max: 15)) {
                    ForEach(0..<16, id: \.self) { index in
                        RoundedRectangle(cornerRadius: scaled(10, for: size, min: 7, max: 11), style: .continuous)
                            .fill(iconColor(at: index))
                            .frame(width: scaled(44, for: size, min: 30, max: 46), height: scaled(44, for: size, min: 30, max: 46))
                    }
                }
                .padding(.horizontal, scaled(18, for: size, min: 12, max: 20))

                Spacer()

                HStack(spacing: scaled(14, for: size, min: 9, max: 15)) {
                    ForEach(0..<4, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: scaled(11, for: size, min: 8, max: 12), style: .continuous)
                            .fill(Color.white.opacity(0.9))
                            .frame(width: scaled(45, for: size, min: 30, max: 46), height: scaled(45, for: size, min: 30, max: 46))
                    }
                }
                .padding(.bottom, scaled(28, for: size, min: 16, max: 30))
            }
            .frame(width: phoneWidth, height: phoneHeight)
        }
    }

    private func scaled(_ base: CGFloat, for size: CGSize, min minValue: CGFloat, max maxValue: CGFloat) -> CGFloat {
        let widthScale = size.width / 393
        let heightScale = size.height / 852
        let value = base * Swift.min(widthScale, heightScale)
        return Swift.max(minValue, Swift.min(maxValue, value))
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
