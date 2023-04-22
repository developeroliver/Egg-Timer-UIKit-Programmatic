//
//  ViewController.swift
//  Egg Timer UIKit Programmatically
//
//  Created by olivier geiger on 22/04/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  
  // Création des images
  let imageView1  = UIImageView(image: UIImage(named: "soft"))
  let imageView2  = UIImageView(image: UIImage(named: "medium"))
  let imageView3  = UIImageView(image: UIImage(named: "hard"))
  let button1     = UIButton(type: .custom)
  let button2     = UIButton(type: .custom)
  let button3     = UIButton(type: .custom)
  var progressView: UIProgressView!
  
  // Création des variables
  
  var timer = Timer()
  var player: AVAudioPlayer!
  var totalTime = 0
  var secondsPassed = 0
  var onTap: (() -> Void)?
  var progressValue = 0.0
  
  
  // Création du label
  private let labelView: UILabel = {
    let label = UILabel()
    label.text = "How do you like your eggs?"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
    
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBlue
    
    configureUI()
  }
  
  func configureUI() {
    // Création de la stack horizontale
    let stackView = UIStackView(arrangedSubviews: [button1, button2, button3])
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .equalSpacing
    stackView.spacing = 10
    
    // Création de la stack vertical
    let mainStackView = UIStackView(arrangedSubviews: [labelView, stackView])
    mainStackView.axis = .vertical
    mainStackView.alignment = .center
    mainStackView.distribution = .equalSpacing
    mainStackView.spacing = 80
    
    // Ajout de la stack view à la controller view
    view.addSubview(mainStackView)
    
    // Ajout des images
    let image1 = imageView1.image
    button1.translatesAutoresizingMaskIntoConstraints = false
    button1.setImage(image1, for: .normal)
    button1.setTitle("soft", for: .normal)
    button1.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    
    let image2 = imageView2.image
    button2.translatesAutoresizingMaskIntoConstraints = false
    button2.setImage(image2, for: .normal)
    button2.setTitle("medium", for: .normal)
    button2.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    
    let image3 = imageView3.image
    button3.translatesAutoresizingMaskIntoConstraints = false
    button3.setImage(image3, for: .normal)
    button3.setTitle("hard", for: .normal)
    button3.addTarget(self, action: #selector(buttonClicked(sender:)), for: .touchUpInside)
    
    // Réglage des constraints
    mainStackView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      
      button1.widthAnchor.constraint(equalToConstant: 90),
      button1.heightAnchor.constraint(equalToConstant: 90),
      
      button2.widthAnchor.constraint(equalToConstant: 90),
      button2.heightAnchor.constraint(equalToConstant: 90),
      
      button3.widthAnchor.constraint(equalToConstant: 90),
      button3.heightAnchor.constraint(equalToConstant: 90),
      
    ])
    
  }
  
  // Action à effectuer lorsque le bouton est cliqué
  @objc func buttonClicked(sender: UIButton) {
    let eggTimes = ["soft": 3, "medium": 4, "hard": 7]
    let progressViewWidth: CGFloat = 200.0
    let progressViewHeight: CGFloat = 20.0
    
    progressView = UIProgressView(progressViewStyle: .default)
    progressView.frame = CGRect(x:(view.frame.size.width - progressViewWidth) / 2, y: UIScreen.main.bounds.height - 200, width: 200, height: 20)
    progressView.progress = 0.0
    progressView.progressTintColor = .orange
    view.addSubview(progressView)
    
    timer.invalidate()
    let hardness = sender.currentTitle!
    print(hardness)
    totalTime = eggTimes[hardness]!
    secondsPassed = 0
    
    labelView.text = hardness.uppercased()
    
    timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector: #selector(updateTimer), userInfo:nil, repeats: true)
    
    sender.alpha = 0.5
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
      //Bring's sender's opacity back up to fully opaque.
      sender.alpha = 1.0
    }
  }
  
  @objc func updateTimer() {
    if secondsPassed < totalTime {
      secondsPassed += 1
      progressView.setProgress(Float(secondsPassed) / Float(totalTime), animated: true)
    } else {
      timer.invalidate()
      labelView.text = "DONE!"
      
      let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3")
      player = try! AVAudioPlayer(contentsOf: url!)
      player.play()
      progressView.progress = 0.0
    }
  }
  
}


