import 'dart:math';

class AbsValue{
  late double absAcceleration;
  late List<double>? userAcceleration;
  late String type;

  AbsValue({ required this.userAcceleration}){
    num squaresum = pow(userAcceleration![0],2) + pow(userAcceleration![1], 2) + pow(userAcceleration![2], 2);
    absAcceleration = sqrt(squaresum);
    type = '';
  }
  Future <bool> check() async {
    if(absAcceleration >= 39.2266 && absAcceleration < 196.13){
      type = 'Mild Accident';
    }
    else if(absAcceleration >= 196.13 && absAcceleration < 392.26){
      type = 'Medium Accident';
    }
    else if(absAcceleration >= 392.26){
      type = 'Heavy Accident';
    }
    if(absAcceleration >= 39.2266) {
      return true;
    } else {
      return false;
    }
    return false;
  }

}
