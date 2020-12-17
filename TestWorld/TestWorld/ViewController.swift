//
//  ViewController.swift
//  TestWorld
//
//  Created by Marvin Hülsmann on 15.12.20.
//

import UIKit

class ViewController: UIViewController {
    
    //    UI stuff
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var finishBar: UIProgressView!
    @IBOutlet weak var timer: UILabel!
    @IBOutlet weak var lastBestTime: UILabel!
    @IBOutlet weak var lastStandTime: UILabel!
    @IBOutlet var background: UIView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var color: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    
    
    //    file
    let file = "data.txt" //this is the file. the app will write to and read from it
    var fileStats = ""
    
    //    Text
    var pressStart = "Klicke zum starten"
    var yourClickAmount = "Punkte: "
    var timerTime = "Noch: "
    var lastBestTimeAmount = "Letze Runde: "
    var lastStandTimeAmount = "In: "
    var colorText = "Farbe: "
    
    //    informations
    var isPlayingEnabled = true
    var isPlaying = false
    var hasAlreadyPlay = false
    
    //    old Levels & statistics
    var oldTimeAmount = 0
    
    //    Levels
    var allTimeAmount = 0
    var levelAmount = 0
    
    
    //    time
    var runGameTime = 20
    var resetTime = 20
    
    var hasStayInGameTime = 0
    
    //   current game
    var currentColor = UIColor.darkGray
    var currentColorName = ""
    var correctButtonNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.finishBar.isHidden = true
        self.color.isHidden = true
        
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.background.backgroundColor = UIColor.systemBackground
            
            if !self.isPlayingEnabled {
                self.toolbar.isHidden = false
                
                self.button1.isHidden = false
                self.button2.isHidden = false
                self.button3.isHidden = false
                self.button4.isHidden = false
                
                self.name.isHidden = false
                
                self.lastStandTime.isHidden = false
                self.lastBestTime.isHidden = false
                
                self.timer.isHidden = false
                
                self.isPlayingEnabled = true
            }
            
            if self.isPlaying {
                
                //check if player is not inactive
                let state = UIApplication.shared.applicationState
                if state == .background || state == .inactive {
                    self.saveGame(resetBool: true, screen: false)
                } else if state == .active {
                    
                    //update the time
                    self.hasStayInGameTime += 1
                    
                    self.runGameTime -= 1
                    
                    if self.runGameTime == 1 {
                        self.timer.text = self.timerTime + "einer Sekunde"
                    } else {
                        self.timer.text = self.timerTime + String(self.runGameTime) + " Sekunden"
                    }
                    
                    //end of the game
                    if self.runGameTime == 0 {
                        self.saveGame(resetBool : true, screen: true)
                    }
                }
            }
        }
    }
    
    
    /// ToolBar Trash Button
    /// - Parameter sender: sender description
    @IBAction func pToolBarTrash(_ sender: Any) {
        reset(UIreset : true, WhiteScreen: false)
    }
    
    //    new one
    
    @IBAction func pbutton1(_ sender: Any) {
        playGame(amount: 1, button: button1)
    }
    
    @IBAction func pbutton2(_ sender: Any) {
        playGame(amount: 2, button: button2)
    }
    
    @IBAction func pbutton3(_ sender: Any) {
        playGame(amount: 3, button: button3)
    }
    
    @IBAction func pbutton4(_ sender: Any) {
        playGame(amount: 4, button: button4)
    }
    
    
    /// Start for the game
    /// - Parameter amount: amount from the clicked button
    func playGame(amount : Int, button : UIButton) {
        if isPlayingEnabled {
            
            if amount != correctButtonNumber && name.text != pressStart {
                
                if allTimeAmount - 1 != -1 {
                    allTimeAmount -= 1
                    name.text = yourClickAmount + String(allTimeAmount)
                }
                button.backgroundColor = UIColor.systemBackground
            } else {
                
                let generator = UISelectionFeedbackGenerator()
                generator.selectionChanged()
                
                finishBar.isHidden = false
                
                setGameCanvas()
                
                if finishBar.progress < 1 {
                    interactButton(boolean: false)
                } else {
                    interactButton(boolean: true)
                }
            }
        }
    }
    
    func setGameCanvas() {
        randomCurrentColor()
        randomCorrectButton()
        randomPlaceHolderColor()
    }
    
    
    /// save the game and statistics
    func saveGame(resetBool : Bool, screen : Bool) {
        if allTimeAmount != 0 {
            lastBestTime.text = lastBestTimeAmount + String(allTimeAmount) + " Punkte"
            
            if hasStayInGameTime == 1 {
                lastStandTime.text = lastStandTimeAmount + "einer Sekunde"
            } else {
                lastStandTime.text = lastStandTimeAmount + String(hasStayInGameTime) + " Sekunden"
            }
            
            hasAlreadyPlay = true
        }
        
        
        reset(UIreset : resetBool, WhiteScreen: screen)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    /// Restart the game
    func reset(UIreset : Bool, WhiteScreen : Bool) {
        
        name.text = pressStart
        timer.text = ""
        
        isPlayingEnabled = false
        isPlaying = false
        
        finishBar.progress = 0
        allTimeAmount = 0
        levelAmount = 0
        runGameTime = resetTime
        
        hasStayInGameTime = 0
        
        if UIreset {
            //        waiting screen
            if WhiteScreen {
                background.backgroundColor = UIColor.white
                toolbar.isHidden = true
                            
            }
            
            lastStandTime.isHidden = true
            lastBestTime.isHidden = true
            
            name.isHidden = true
            timer.isHidden = true
            finishBar.isHidden = true
            
            button1.backgroundColor = UIColor.gray
            button2.backgroundColor = UIColor.gray
            button3.backgroundColor = UIColor.gray
            button4.backgroundColor = UIColor.gray
            
            button1.isHidden = true
            button2.isHidden = true
            button3.isHidden = true
            button4.isHidden = true
            
            color.isHidden = true
            
            
            
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
        
    }
    
    /// Update game
    /// - Parameter boolean: set progress view to null
    func interactButton(boolean : Bool) {
        //        set progress
        allTimeAmount+=1
        finishBar.progress+=0.1
        
        color.isHidden = false
        color.text = colorText + currentColorName
        
        if name.text == pressStart {
            
            isPlaying = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.warning)
            
            let estimesTime = Int.random(in: 10..<45)
            
            runGameTime = estimesTime
            resetTime = estimesTime
            
            if runGameTime == 1 {
                timer.text = timerTime + "eine Sekunde"
            } else {
                timer.text = timerTime + String(runGameTime) + " Sekunden"
            }
            
            name.text = yourClickAmount + String(allTimeAmount)
        } else {
            name.text = yourClickAmount + String(allTimeAmount)
        }
        
        if boolean {
            finishBar.progress = 0.1
            levelAmount+=1
        }
    }
    
    
    /// Set the correct button for the game
    func randomCorrectButton() {
        let buttonNumber = Int.random(in: 1..<4)
        correctButtonNumber = buttonNumber
        
        if correctButtonNumber == 1 {
            button1.backgroundColor = currentColor
        } else if correctButtonNumber == 2 {
            button2.backgroundColor = currentColor
        } else if correctButtonNumber == 3 {
            button3.backgroundColor = currentColor
        } else if correctButtonNumber == 4 {
            button4.backgroundColor = currentColor
        }
    }
    
    /// Set the color for the random placeholders
    func randomPlaceHolderColor() {
        
        for i in 1...4 {
            
            let random = Int.random(in: 0..<5)
            var tempHolder = UIColor.gray
            
            switch random {
            case 1:
                tempHolder = UIColor.magenta
                break
            case 2:
                tempHolder = UIColor.cyan
                break
            case 3:
                tempHolder = UIColor.systemBlue
                break
            case 4:
                tempHolder = UIColor.systemTeal
                break
            case 5:
                tempHolder = UIColor.systemBlue
                break
            default:
                tempHolder = UIColor.gray
            }
            
            if tempHolder != currentColor {
                if i == 1  {
                    if correctButtonNumber != 1 {
                        button1.backgroundColor = tempHolder
                    }
                    
                } else if i == 2 {
                    if correctButtonNumber != 2 {
                        button2.backgroundColor = tempHolder
                    }
                    
                } else if i == 3 {
                    if correctButtonNumber != 3 {
                        button3.backgroundColor = tempHolder
                    }
                    
                } else if i == 4 {
                    if correctButtonNumber != 4 {
                        button4.backgroundColor = tempHolder
                    }
                }
            } else {
                randomPlaceHolderColor()
            }
        }
    }
    
    
    /// Set the random current click color
    func randomCurrentColor() {
        let colorChanger = Int.random(in: 0..<10)
        
        switch colorChanger {
        case 1:
            currentColor = UIColor.red
            currentColorName = "Rot"
            break
        case 2:
            currentColor = UIColor.yellow
            currentColorName = "Gelb"
            break
        case 3:
            currentColor = UIColor.purple
            currentColorName = "Lila"
            break
        case 4:
            currentColor = UIColor.orange
            currentColorName = "Orange"
            break
        case 5:
            currentColor = UIColor.systemBlue
            currentColorName = "Dunkel Blau"
            break
        case 6:
            currentColor = UIColor.brown
            currentColorName = "Braun"
            break
        case 7:
            currentColor = UIColor.lightGray
            currentColorName = "Hell Grau"
            break
        case 8:
            currentColor = UIColor.green
            currentColorName = "Grün"
            break
        case 9:
            currentColor = UIColor.white
            currentColorName = "Weiß"
            break
        default:
            currentColor = UIColor.darkGray
            currentColorName = "Dunkel Grau"
        }
    }
}

