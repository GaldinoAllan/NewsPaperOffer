import Foundation

class NewsPaperHomeAPI {
    static let url = "https://api.jsonbin.io/v3/qs/66ab5607e41b4d34e41a2639"
    
    static let modelMock = """
    {
      "id": "",
      "record": {
        "header_logo": "https://cdn.us-corp-qg-3.vip.tngg.net//nativeapp.www.us-corp-ga-3.tnga.net//content//tncms//assets//v3//media//9//e0//9e0dae9e-240b-11ef-9068-000c299ccbc9 //6661be72a43be.image.png?resize=762%2C174",
        "subscription": {
          "offer_page_style": "square",
          "cover_image": "https://cdn.us-corp-qg-3.vip.tnga.net/nativeapp.www.us-corp-ga-3.tnga.net/content/tncms/assets/v3/media/8/18/818482c0-09d7-11ed-ad65-000c299ccbc9/62dac9c7602ba, image.jeg?resize=750%2C420",
          "subscribe_title": "Get Unlimited Access",
          "subscribe_subtitle": "STLToday.com is where your story lives. Stay in the loop with unlimited access to articles, podcasts, videos and the E-edition. Plus unlock breaking news and customized real-time alerts for sports, weather, and more.",
          "offers": {
            "id0": {
              "price": 35.99,
              "description": "Billed monthly. Renews on MM/DD/YY."
            },
            "id1": {
              "price": 25.99,
              "description": "Billed monthly. Renews on MM/DD/YY."
            }
          },
          "benefits": [
            "Benefit statement 1",
            "Benefit statement 2",
            "Benefit statement 3"
          ],
          "disclaimer": "* Does not extend to E-edition or 3rd party"
        }
      },
      "metadata": {
        "name": "",
        "readCountRemaining": 86,
        "timeToExpire": 53176,
        "createdAt": "2024-08-01T09:31:51.573Z"
      }
    }
""".data(using: .utf8)
}
