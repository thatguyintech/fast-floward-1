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

pub resource Picture {
  pub let canvas: Canvas

  init(canvas: Canvas) {
    self.canvas = canvas
  }
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
    destroy pictureX
}