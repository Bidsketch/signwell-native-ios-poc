//
// SignWell
// iOS Demo
// Andrey Butov, 2023
//


import Foundation
import UIKit


let APP_DELEGATE = ((UIApplication.shared.delegate as! AppDelegate));

let SERVER_BASE_URL = "https://www.signwell.com/api/v1"

let SIGNWELL_API_KEY = ""; // TODO: Specify your SignWell API key.

let COLOR_LIGHT_GRAY_1 = UIColor(hex: "#f2ebeb");
let COLOR_SIGNWELL_BLUE = UIColor(hex: "#6ab5c4");

let SCREEN_WIDTH = UIScreen.main.bounds.size.width;
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height;

let FONT_REGULAR = UIFont.systemFont(ofSize: 14);
let FONT_BOLD = UIFont.boldSystemFont(ofSize: 14);
