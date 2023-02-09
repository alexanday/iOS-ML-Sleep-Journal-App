//
//  SleepModeView.swift
//  Sleep Time App
//
//  Created by Dayanna Calderon on 2/7/23.
//

import SwiftUI
import CoreML

struct SleepModeView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var stressAmount = 5
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    Text("When would you like to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time", selection:
                    $wakeUp,
                               displayedComponents: .hourAndMinute)
                    .labelsHidden()
                }
                Section{
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper("\(sleepAmount.formatted()) hours",
                            value: $sleepAmount, in: 4...12, step: 0.25)
                }
                Section{
                    Text("Today's stress level")
                        .font(.headline)
                    Stepper("\(stressAmount)",
                            value: $stressAmount, in: 0...10)
                }
                Section{
                    Text("Your optimal wind-down time is:")
                        .font(.headline)
                    Text(self.calculateBedTime())
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                }
            }
        
        }
    }
                            
    func calculateBedTime() -> String{
        let bedTime : String
        do {
            let config = MLModelConfiguration()
            let model = try
            SleepyTimeSleepMode(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, stress: Double(stressAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let dateOfSleepTime = sleepTime.formatted(date:.omitted, time:.shortened)
            bedTime = "\(dateOfSleepTime)"
            return bedTime
        } catch {
            bedTime = "Sorry! There was a problem calculating your bedtime!"
            return bedTime
        }
    }
}

struct SleepModeView_Previews: PreviewProvider {
    static var previews: some View {
        SleepModeView()
    }
}
