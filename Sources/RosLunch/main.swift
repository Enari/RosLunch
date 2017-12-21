import Foundation
import Just
import SlackKit
import SwiftSoup


func getLunch() -> String {
    let request = Just.get("http://www.hors.se/restaurang/restaurang-rosenhill")
    let html : String = request.text!
    var allLunches = String()
    
    do{
        let doc: Document = try! SwiftSoup.parse(html)
        let body: Element = doc.body()!
        
        let lunchdivs = try body.getElementsByClass("col-xs-10 text-left")
        
        for lunchdiv in lunchdivs {
            let lunch = try lunchdiv.html()
            allLunches += "\(lunch)\n"
            //print(lunch)
        }
    }
    catch Exception.Error(_, let message) {
        print(message)
        return "Failed to get todays lunches"
    }
    catch{
        print("error")
        return "Failed to get todays lunches"
    }
    return allLunches
}

let bot = SlackKit()
bot.addRTMBotWithAPIToken(slackToken)
bot.addWebAPIAccessWithToken(slackToken)

bot.notificationForEvent(.message){ (event, client) in
    let message = event.message
    if message?.text == "lunch?" {
        bot.webAPI?.sendMessage(channel: message!.channel!, text: getLunch(), success: nil, failure: nil)
    }
}

RunLoop.main.run()
