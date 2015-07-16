var solution = [];

var randNum = function(){
  return Math.floor(Math.random()*4)
}
var setSolution = function(){
  for ( var i = 0; i < 4; i++ ){
    if (randNum() = 0) {
      solution.push('R')
    } else if (randNum() = 1) {
      solution.push('G')
    } else if (randNum() = 2) {
      solution.push('B')
    } else {
      solution.push('Y')
    }
  }
}