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
  let pixelLines = deserializeCanvas(canvas)
  let width = Int(canvas.width)
  let height = Int(canvas.height)

  // Prepare top and bottom parts of the display frame:
  // +-----+
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

  // Add side frames: "|"
  var output: [String] = [top]
  var last: [String] = [bottom]
  for line in pixelLines {
    var newline = "|".concat(line).concat("|")
    var lineArr: [String] = [newline]
    output = output.concat(lineArr)
  }
  output = output.concat(last)

  // Display the frame and canvas.
  for line in output {
    log(line)
  }
  return output
}

pub fun createPicture(pixels: [String]): @Picture {
  let canvas = Canvas(
    width: UInt8(pixels[0].length),
    height: UInt8(pixels.length),
    pixels: serializePixels(pixels)
  )
  let picture <- create Picture(canvas: canvas)
  return <- picture
}

// W1Q2 challenge: Create a resource that prints `Picture`'s but only once for each unique 5x5 `Canvas`.
pub resource Printer {
  // Map to remember which Canvases have been printed.
  pub let printed: {String: Bool}

  // If the canvas pixels have not been printed, print it as a picture.
  // Otherwise log an error.
  pub fun print(canvas: Canvas): @Picture? {
    if self.printed[canvas.pixels] == nil {
      self.printed[canvas.pixels] = true
      display(canvas: canvas)
      return <- create Picture(canvas: canvas)
    } else {
      log("canvas has already been printed")
      return nil
    }
  }

  init() {
    self.printed = {}
  }
}

pub fun main() {
  // Create a Picture for each letter in: "FLOWX"
  
  // "F"
  let pixelsF = [
    "*****",
    "*    ",
    "*****",
    "*    ",
    "*    "
  ]
  let pictureF <- createPicture(pixels: pixelsF)
  
  // "L"
  let pixelsL = [
    "*    ",
    "*    ",
    "*    ",
    "*    ",
    "*****"
  ]
  let pictureL <- createPicture(pixels: pixelsL)

  
  // "O"
  let pixelsO = [
    "*****",
    "*   *",
    "*   *",
    "*   *",
    "*****"
  ]
  let pictureO <- createPicture(pixels: pixelsO)

  
  // "W"
  let pixelsW = [
    "*   *",
    "*   *",
    "* * *",
    " * * ",
    "     "
  ]
  let pictureW <- createPicture(pixels: pixelsW)


  // "X"
  let pixelsX = [
    "*   *",
    " * * ",
    "  *  ",
    " * * ",
    "*   *"
  ]
  let pictureX <- createPicture(pixels: pixelsX)

  log("=== W1Q2 ===")
  let canvasX = Canvas(
    width: 5,
    height: 5, 
    pixels: serializePixels(pixelsX),
  ) 

  let printer <- create Printer()
  let printX <- printer.print(canvas: canvasX)

  log("=== W1Q2 ===")
  destroy printer
  destroy printX
  destroy pictureF
  destroy pictureL
  destroy pictureO
  destroy pictureW
  destroy pictureX
}