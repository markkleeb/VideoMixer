void scatter(Capture videoCamera) {
  
    int scatterAmount = int(map(projBox.knobs[0], 0, 1023, 0, maxScatter));
  videoCamera.loadPixels();
  for (int i = scatterAmount; i < videoCamera.pixels.length-scatterAmount; i++) {
    float r = red(videoCamera.pixels[i]);
    float g = green(videoCamera.pixels[i]);
    float b = blue(videoCamera.pixels[i]);

    int newIndex = i+int(random(scatterAmount*-1, scatterAmount));
    newImg.pixels[newIndex] = color(r, g, b);
  }
  newImg.updatePixels();
 
}
