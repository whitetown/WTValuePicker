
Pod::Spec.new do |s|

  s.name         = "WTValuePicker"
  s.version      = "0.0.2"
  s.summary      = "Large Value Picker based on UITableView"
  s.description  = <<-DESC
  Large Value Picker based on UITableView

    let picker1 = WTValuePicker()

    self.picker1.fillColor = .yellow
    self.picker1.attributes = [
        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 32)
      ]

    self.picker1.frame = CGRect(x: 0, y: 0, width: 100, height: self.view.frame.size.height)
    self.view.addSubview(self.picker1)

    self.picker1.onSelect = { value in
        print(value)
    }
    self.picker1.onScrolling = { isScrolling in
        print(isScrolling)
    }
                   DESC
  s.homepage     = "https://github.com/whitetown/WTValuePicker"
  s.screenshots  = "https://raw.githubusercontent.com/whitetown/WTValuePicker/master/screenshot/WTValuePicker.png"
  s.license      = { :type => "MIT" }
  s.author       = { "WhiteTown" => "whitetownmail@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/whitetown/WTValuePicker.git", :tag => "v0.0.2" }
  s.source_files = "WTValuePicker", "WTValuePicker/**/*.{h,m,swift}"

end
