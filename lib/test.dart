void main(List<String> args) {
  var timeIn = '10:00 PM';
  var timeOut = '11:00 PM';
  var dateIn = 'Thu, Dec 8';
  var dateOut = 'Thu, Dec 8';
  var iN = dateIn + timeIn;
  var ouT = dateOut + timeOut;
  DateTime dateTimeIn = DateTime.parse(iN);
  DateTime dateTimeOut = DateTime.parse(ouT);
  print(dateTimeIn);
  print(dateTimeOut);
}
