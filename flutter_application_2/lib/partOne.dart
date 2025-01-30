void main(List<String> args) {
  List<int> numberList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  print("List of numbers: $numberList");

  for (var element in numberList) {
    if (element % 2 == 0) {
      print("$element is even");
    } else {
      print("$element is odd");
    }
  }
}
