
class CheckValidGuessData {

  static bool isValidGuessBoyHeight(num month, double height) {
    bool check = false;
    var valid = month.floor().toInt();
    switch(valid) {
      case 0:
        check = (height >= 46.1 && height <= 53.7) ? true : false;
        break;
      case 1:
        check = (height >= 50.8 && height <= 58.6) ? true : false;
        break;
      case 2:
        check = (height >= 54.4 && height <= 62.4) ? true : false;
        break;
      case 3:
        check = (height >= 57.3 && height <= 65.5) ? true : false;
        break;
      case 4:
        check = (height >= 59.7 && height <= 68.0) ? true : false;
        break;
      case 5:
        check = (height >= 61.7 && height <= 70.1) ? true : false;
        break;
      case 6:
        check = (height >= 63.3 && height <= 71.9) ? true : false;
        break;
      case 7:
        check = (height >= 64.8 && height <= 73.5) ? true : false;
        break;
      case 8:
        check = (height >= 66.2 && height <= 75.0) ? true : false;
        break;
      case 9:
        check = (height >= 67.5 && height <= 76.5) ? true : false;
        break;
      case 10:
        check = (height >= 68.7 && height <= 77.9) ? true : false;
        break;
      case 11:
        check = (height >= 69.9 && height <= 79.2) ? true : false;
        break;
      case 12:
        check = (height >= 71.0 && height <= 80.5) ? true : false;
        break;
      case 13:
        check = (height >= 72.1 && height <= 81.8) ? true : false;
        break;
      case 14:
        check = (height >= 73.1 && height <= 83.0) ? true : false;
        break;
      case 15:
        check = (height >= 74.1 && height <= 84.2) ? true : false;
        break;
      case 16:
        check = (height >= 75.0 && height <= 85.4) ? true : false;
        break;
      case 17:
        check = (height >= 76.0 && height <= 86.5) ? true : false;
        break;
      case 18:
        check = (height >= 76.9 && height <= 87.7) ? true : false;
        break;
      case 19:
        check = (height >= 77.7 && height <= 88.8) ? true : false;
        break;
      case 20:
        check = (height >= 78.6 && height <= 89.8) ? true : false;
        break;
      case 21:
        check = (height >= 79.4 && height <= 90.9) ? true : false;
        break;
      case 22:
        check = (height >= 80.2 && height <= 91.9) ? true : false;
        break;
      case 23:
        check = (height >= 81.0 && height <= 92.9) ? true : false;
        break;
      case 24:
        check = (height >= 81.7 && height <= 93.9) ? true : false;
        break;
      case 30:
        check = (height >= 85.1 && height <= 98.7) ? true : false;
        break;
      case 36:
        check = (height >= 88.7 && height <= 103.5) ? true : false;
        break;
      case 42:
        check = (height >= 91.9 && height <= 107.8) ? true : false;
        break;
      case 48:
        check = (height >= 94.9 && height <= 111.7) ? true : false;
        break;
      case 54:
        check = (height >= 97.8 && height <= 115.5) ? true : false;
        break;
      case 60:
        check = (height >= 100.7 && height <= 119.2) ? true : false;
        break;
      default:
        check = false;
    }
    return check;
  }

  static bool isValidGuessBoyWeight(num month, double weight) {
    bool check = false;
    var valid = month.floor().toInt();
    switch(valid) {
      case 0:
        check = (weight >= 2.5 && weight <= 4.4) ? true : false;
        break;
      case 1:
        check = (weight >= 3.4 && weight <= 5.8) ? true : false;
        break;
      case 2:
        check = (weight >= 4.3 && weight <= 7.1) ? true : false;
        break;
      case 3:
        check = (weight >= 5.0 && weight <= 8.0) ? true : false;
        break;
      case 4:
        check = (weight >= 5.6 && weight <= 8.7) ? true : false;
        break;
      case 5:
        check = (weight >= 6.0 && weight <= 9.3) ? true : false;
        break;
      case 6:
        check = (weight >= 6.4 && weight <= 9.8) ? true : false;
        break;
      case 7:
        check = (weight >= 6.7 && weight <= 10.3) ? true : false;
        break;
      case 8:
        check = (weight >= 6.9 && weight <= 10.7) ? true : false;
        break;
      case 9:
        check = (weight >= 7.1 && weight <= 11.0) ? true : false;
        break;
      case 10:
        check = (weight >= 7.4 && weight <= 11.4) ? true : false;
        break;
      case 11:
        check = (weight >= 7.6 && weight <= 11.7) ? true : false;
        break;
      case 12:
        check = (weight >= 7.7 && weight <= 12.0) ? true : false;
        break;
      case 13:
        check = (weight >= 7.9 && weight <= 12.3) ? true : false;
        break;
      case 14:
        check = (weight >= 8.1 && weight <= 12.6) ? true : false;
        break;
      case 15:
        check = (weight >= 8.3 && weight <= 12.8) ? true : false;
        break;
      case 16:
        check = (weight >= 8.4 && weight <= 13.1) ? true : false;
        break;
      case 17:
        check = (weight >= 8.6 && weight <= 13.4) ? true : false;
        break;
      case 18:
        check = (weight >= 8.8 && weight <= 13.7) ? true : false;
        break;
      case 19:
        check = (weight >= 8.9 && weight <= 13.9) ? true : false;
        break;
      case 20:
        check = (weight >= 9.1 && weight <= 14.2) ? true : false;
        break;
      case 21:
        check = (weight >= 9.2 && weight <= 14.5) ? true : false;
        break;
      case 22:
        check = (weight >= 9.4 && weight <= 14.7) ? true : false;
        break;
      case 23:
        check = (weight >= 9.5 && weight <= 15.0) ? true : false;
        break;
      case 24:
        check = (weight >= 9.7 && weight <= 15.3) ? true : false;
        break;
      case 30:
        check = (weight >= 10.5 && weight <= 16.9) ? true : false;
        break;
      case 36:
        check = (weight >= 11.3 && weight <= 18.3) ? true : false;
        break;
      case 42:
        check = (weight >= 12.0 && weight <= 19.7) ? true : false;
        break;
      case 48:
        check = (weight >= 12.7 && weight <= 21.2) ? true : false;
        break;
      case 54:
        check = (weight >= 13.4 && weight <= 22.7) ? true : false;
        break;
      case 60:
        check = (weight >= 14.1 && weight <= 24.2) ? true : false;
        break;
      default:
        check = false;
    }
    return check;
  }

  static bool isValidGuessBoyPerimeter(num month, double perimeter) {
    bool check = false;
    var valid = month.floor().toInt();
    switch(valid) {
      case 0:
        check = (perimeter >= 31.9 && perimeter <= 37.0) ? true : false;
        break;
      case 1:
        check = (perimeter >= 34.9 && perimeter <= 39.8) ? true : false;
        break;
      case 2:
        check = (perimeter >= 36.8 && perimeter <= 41.5) ? true : false;
        break;
      case 3:
        check = (perimeter >= 38.1 && perimeter <= 42.9) ? true : false;
        break;
      case 4:
        check = (perimeter >= 39.2 && perimeter <= 44.0) ? true : false;
        break;
      case 5:
        check = (perimeter >= 40.1 && perimeter <= 45.0) ? true : false;
        break;
      case 6:
        check = (perimeter >= 40.9 && perimeter <= 45.8) ? true : false;
        break;
      case 7:
        check = (perimeter >= 41.5 && perimeter <= 46.4) ? true : false;
        break;
      case 8:
        check = (perimeter >= 42.0 && perimeter <= 47.0) ? true : false;
        break;
      case 9:
        check = (perimeter >= 42.5 && perimeter <= 47.5) ? true : false;
        break;
      case 10:
        check = (perimeter >= 42.9 && perimeter <= 47.9) ? true : false;
        break;
      case 11:
        check = (perimeter >= 43.2 && perimeter <= 48.3) ? true : false;
        break;
      case 12:
        check = (perimeter >= 43.5 && perimeter <= 48.6) ? true : false;
        break;
      case 13:
        check = (perimeter >= 43.8 && perimeter <= 48.9) ? true : false;
        break;
      case 14:
        check = (perimeter >= 44.0 && perimeter <= 49.2) ? true : false;
        break;
      case 15:
        check = (perimeter >= 44.2 && perimeter <= 49.4) ? true : false;
        break;
      case 16:
        check = (perimeter >= 44.4 && perimeter <= 49.6) ? true : false;
        break;
      case 17:
        check = (perimeter >= 44.6 && perimeter <= 49.8) ? true : false;
        break;
      case 18:
        check = (perimeter >= 44.7 && perimeter <= 50.0) ? true : false;
        break;
      case 19:
        check = (perimeter >= 44.9 && perimeter <= 50.2) ? true : false;
        break;
      case 20:
        check = (perimeter >= 45.0 && perimeter <= 50.4) ? true : false;
        break;
      case 21:
        check = (perimeter >= 45.2 && perimeter <= 50.5) ? true : false;
        break;
      case 22:
        check = (perimeter >= 45.3 && perimeter <= 50.7) ? true : false;
        break;
      case 23:
        check = (perimeter >= 45.4 && perimeter <= 50.8) ? true : false;
        break;
      case 24:
        check = (perimeter >= 45.5 && perimeter <= 51.0) ? true : false;
        break;
      case 30:
        check = (perimeter >= 46.1 && perimeter <= 51.7) ? true : false;
        break;
      case 36:
        check = (perimeter >= 46.6 && perimeter <= 52.3) ? true : false;
        break;
      case 42:
        check = (perimeter >= 47.0 && perimeter <= 52.8) ? true : false;
        break;
      case 48:
        check = (perimeter >= 47.3 && perimeter <= 53.1) ? true : false;
        break;
      case 54:
        check = (perimeter >= 47.5 && perimeter <= 53.5) ? true : false;
        break;
      case 60:
        check = (perimeter >= 47.7 && perimeter <= 53.7) ? true : false;
        break;
      default:
        check = false;
    }
    return check;
  }

}