# WTValuePicker

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
