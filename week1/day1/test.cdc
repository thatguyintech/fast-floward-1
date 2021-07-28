pub fun sayHi(to name: String) {
    log("Hi, ".concat(name))
}

pub struct Canvas {

  pub let width: UInt8
  pub let height: UInt8
  pub let pixels: String

  init(width: UInt8, height: UInt8, pixels: String) {
    self.width = width
    self.height = height
    // The following pixels
    // 123
    // 456
    // 789
    // should be serialized as
    // 123456789
    self.pixels = pixels
  }
}


pub fun serializePixels(_ lines: [String]): String {
  var output = ""
  for line in lines {
    output = output.concat(line)
  }
  return output
}

pub fun deserializeCanvas(_ canvas: Canvas): [String] {
  var width = canvas.width
  var height = canvas.height
  var output: [String] = []
  var rowsDone: UInt8 = 0

  while rowsDone < height {
    let from = Int(rowsDone * width)
    let to = Int((rowsDone+1) * width)
    output.append(canvas.pixels.slice(from: from, upTo: to))
    rowsDone = rowsDone + 1
  }
  return output
}

pub resource Picture {
  pub let canvas: Canvas

  init(canvas: Canvas) {
    self.canvas = canvas
  }
}

pub fun display(canvas: Canvas): [String] {

  // *   * * *   *   * * *   *
  // +-----+
  let pixelLines = deserializeCanvas(canvas)
  let width = Int(canvas.width)
  let height = Int(canvas.height)

  var top = "+"
  var bottom = "+"
  var t = 0
  while t < width {
    top = top.concat("-")
    bottom = bottom.concat("-")
    t = t + 1
  }
  top = top.concat("+") 
  bottom = bottom.concat("+")

  var output: [String] = [top]
  var last: [String] = [bottom]
  for line in pixelLines {
    var newline = "|".concat(line).concat("|")
    var lineArr: [String] = [newline]
    output = output.concat(lineArr)
  }
  output = output.concat(last)
  for line in output {
    log(line)
  }
  return output
}

pub fun main() {
    sayHi(to: "FastFloward")
    let pixelsX = [
      "*   *",
      " * * ",
      "  *  ",
      " * * ",
      "*   *"
    ]
    sayHi(to: serializePixels(pixelsX))

    let canvasX = Canvas(
      width: 5,
      height: 5,
      pixels: serializePixels(pixelsX)
    )
    let pictureX <- create Picture(canvas: canvasX)
    log(pictureX.canvas)
    log(deserializeCanvas(canvasX))

    log("=== W1Q1 ===")
    display(canvas: canvasX)
    destroy pictureX
}