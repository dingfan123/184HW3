import SwiftUI
import Combine

struct WelcomeView: View {
    @State private var isAnimating: Bool = false

    var body: some View {
        ZStack {
            AnimatedBackground()
                .edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                Text("Expiration Reminder")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .padding(.bottom, 40)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isAnimating = true
                        }
                    }

                CustomButton(title: "Sign In", action: {})
                CustomButton(title: "Sign Up", action: {})

                Spacer()
            }
        }
    }
}

struct AnimatedBackground: View {
    @State private var start = UnitPoint(x: 0, y: -2)
    @State private var end = UnitPoint(x: 4, y: 0)

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color.black]), startPoint: start, endPoint: end)
                .edgesIgnoringSafeArea(.all)

            ClockView()
                .frame(width: 100, height: 100)
                .position(x: UIScreen.main.bounds.width / 2, y: 150) // Adjust position as needed
            
        }
    }
}

struct ClockView: View {
    @State private var currentTime = Time()
    @State private var currentDate = Date()
    @State private var progress = 0.0

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.3)
                .foregroundColor(.white)

            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
                .foregroundColor(.white)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)

            VStack {
                Text(currentTime.string)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(radius: 10)

                Text(dateFormatter.string(from: currentDate))
                    .font(.system(size: 12, weight: .light, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(0.8)
            }
            .transition(.scale)
        }
        .onReceive(timer) { _ in
            currentTime.update()
            currentDate = Date()
            progress = (Double(currentTime.second) + 1) / 60.0
        }
    }

    struct Time {
        var hour = 0
        var minute = 0
        var second = 0

        var string: String {
            String(format: "%02d:%02d:%02d", hour, minute, second)
        }

        mutating func update() {
            let now = Calendar.current.dateComponents([.hour, .minute, .second], from: Date())
            hour = now.hour ?? 0
            minute = now.minute ?? 0
            second = now.second ?? 0
        }
    }
}
struct CustomButton: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(40)
                .padding(.horizontal, 20)
        }
    }
}

// Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
