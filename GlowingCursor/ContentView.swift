import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State var isGlowEnabled = false
    @State var _textView: NSTextView?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            BetterTextView(text: $text) { nsTextView in
                DispatchQueue.main.async {
                    self._textView = nsTextView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            Button(isGlowEnabled ? "Disable Glow" : "Enable Glow") {
                if isGlowEnabled {
                    disableGlow()
                } else {
                    enableGlow()
                }
            }
            .padding()
        }
    }
    
    func enableGlow() {
        guard let textView = _textView else { return }
        isGlowEnabled = true
        let indicator = textView.perform(Selector(("_insertionIndicator"))).takeUnretainedValue()
        let notification = NSNotification(name: .init("_NSTextInputContextDictationDidStartNotification"), object: nil)
        _ = indicator.perform(Selector(("dictationStateDidChange:")), with: notification)
    }
    
    func disableGlow() {
        guard let textView = _textView else { return }
        isGlowEnabled = false
        let indicator = textView.perform(Selector(("_insertionIndicator"))).takeUnretainedValue()
        let notification = NSNotification(name: .init("_NSTextInputContextDictationDidEndNotification"), object: nil)
        _ = indicator.perform(Selector(("dictationStateDidChange:")), with: notification)
    }
}

#Preview {
    ContentView()
}
